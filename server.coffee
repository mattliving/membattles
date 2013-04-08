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

app.get "/scripts/*", (req, res) -> res.sendfile ".tmp/"+req.url
app.get "/styles/*", (req, res) -> res.sendfile ".tmp/"+req.url

io = socket.listen(server.listen(9000))

io.sockets.on 'connection', (socket) ->

  socket.on 'register', ({user}) ->
    console.log "registering " + socket.id
    socket.set 'user', user
    clients[socket.id] = socket
    console.log "#{++clientCount} clients connected"
    socket.emit 'registered', {}

  socket.on 'getid', ->
    if looking.length > 0
      console.log 'assigning otherid to socket'
      otherid = looking.shift()
      other = clients[otherid]

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
    else
      console.log "waiting for another connection"
      looking.push socket.id

  socket.on 'guess', ({guess}) ->
    socket.get 'otherid', (err, otherid) ->
      unless err
        clients[otherid].emit 'event', event: event
      else
        socket.emit 'error', msg: "invalid client id #{otherid}"

  socket.on 'disconnect', ->
    socket.get 'otherid', (err, otherid) ->
      unless err
        if socket.id in looking
          i = 0
          while looking[i] isnt socket.id then i++
          looking.splice i, 1
        if clients[otherid]?
          clients[otherid].emit 'disconnect'
      else
        console.log "ERROR: #{err}"
    delete clients[socket.id]
    console.log "#{--clientCount} clients connected"
