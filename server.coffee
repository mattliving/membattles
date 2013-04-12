socket = require 'socket.io'
express = require 'express'
http = require 'http'

app = express()
app.use(express.static(__dirname + "/app"))
server = http.createServer(app)

clients = {}
clientCount = 0

# ids of clients that have requested another user to connect to
looking = []

# this is for dealing with the way grunt watch moves compiled files
app.get "/scripts/*", (req, res) -> res.sendfile ".tmp"+req.url
app.get "/styles/*", (req, res) -> res.sendfile ".tmp"+req.url

io = socket.listen(server.listen(9000))

io.sockets.on 'connection', (socket) ->

  # register the user into the clients array
  socket.on 'register', ({user}) ->
    console.log "registering " + socket.id
    socket.set 'user', user
    socket.set 'ready', false
    socket.set 'cached', []
    clients[socket.id] = socket
    console.log "#{++clientCount} clients connected"
    socket.emit 'registered', {}

  # assign this user another player and send them the username
  socket.on 'getid', ->
    if looking.length > 0
      console.log 'assigning otherid to socket'
      otherid = looking.shift()
      other   = clients[otherid]

      # tell the request that a match has been found
      other.get 'user', (err, user) ->
        if err
          console.log err
          return
        socket.set 'otherid', otherid
        socket.emit 'otherid', id: otherid, user: user, first: false

      # tell the match that a match has been found
      socket.get 'user', (err, user) ->
        if err
          console.log err
          return
        other.set 'otherid', socket.id
        other.emit 'otherid', id: socket.id, user: user, first: true

        # if other is ready, send over the cached events
        other.get 'ready', (err, ready) ->
          if ready isnt false
            other.get 'cached', (err, cached) ->
              for cachedEvent in cached
                console.log "emiting cached event #{cachedEvent}"
                other.get cachedEvent, (err, data) ->
                  socket.emit cachedEvent, data

    else
      console.log "waiting for another connection"
      looking.push(socket.id)

  # emit an event to the other user
  socket.toOther = (eventName, data) ->
    console.log "sending event #{eventName} to other user"
    @get 'otherid', (err, otherid) =>
      unless err or not clients[otherid]?
        clients[otherid].emit eventName, data
      else
        @emit 'error', msg: "invalid client id #{otherid} or client disconnected"

  # emit an event to the other user, but cache the data if they're not connected
  socket.toOtherCached = (eventName, data)->
    console.log "caching or sending event #{eventName} to other user"
    @get 'otherid', (err, otherid) =>
      if err
        @emit 'error', msg: "an error has occured: #{err}"
      if clients[otherid]?
        clients[otherid].emit eventName, data
      else if otherid is null
        @get 'cached', (err, cached) =>
          cached.push eventName
          @set 'cached', cached
          @set eventName, data

  socket.on 'ready', (selectedCourse) -> @toOtherCached 'ready', selectedCourse

  socket.on 'things', (things) -> @toOtherCached 'things', things

  socket.on 'guess', (guess) -> @toOther 'guess', guess

  socket.on 'keypress', (input) -> @toOther 'keypress', input

  socket.on 'disconnect', ->
    socket.get 'otherid', (err, otherid) ->
      unless err
        if socket.id in looking
          looking.splice looking.indexOf(socket.id), 1
        if clients[otherid]?
          clients[otherid].emit 'disconnect'
      else
        console.log "ERROR: #{err}"
    if socket.id of clients
      delete clients[socket.id]
      console.log "#{--clientCount} clients connected"
