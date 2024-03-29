 define ["marionette"], (Marionette) ->

  class Thing extends Backbone.Model

    defaults:
      text: ""
      translation: ""
      accept: []

    # extract what we need from the api - the text, translation and
    # anything else we're meant to accept. Now has to use hard coded columns
    parse: (thinguser) ->
      {thing} = thinguser
      col_a = thing.columns[thinguser.column_a]
      col_b = thing.columns[thinguser.column_b]
      accept = col_a.accepted
      for alt in col_a.alts
        accept.push alt.val
      accept.push col_a.val
      end = _.extend thing,
        text: col_a.val
        translation: col_b.val
        accept: accept
      return end

    initialize: ->
      @on "loaded", -> @set "loaded", true

    # this code has been copied from the memrise js, but doesn't use XRegExp
    # memoize caches output results
    sanitizeInput: _.memoize (text) ->
      # Remove parenthetical expressions e.g. dog (male)
      text = text.replace(/\([^\)]*\)/g, "")

      # Remove all punctuation
      text = text.replace(/['";:,.\/?\\-]/g, "")

      # Replace all whitespace with one space
      text = text.replace(/\s+/g, " ")

      # could add this in again later, unnecessary for now
      # Remove all ignorable characters
      # text = text.replace(untypeable_re, '', 'all')
      # text = text.replace(arabic_ignorable_re, '', 'all')

      # Lower case
      text = text.toLowerCase()

      # simple trim shim, probably unnecessary
      if not String::trim then String::trim -> @replace /^\s+|\s+$/g, ''

      text = text.trim()

      return text

    checkAnswer: (text) ->
      safeText = @sanitizeInput(text)
      for answer in @get("accept")
        if safeText is @sanitizeInput(answer)
          return true
      return false

    checkPartialAnswer: (text) ->
      safeText = @sanitizeInput(text)
      for answer in @get("accept")
        if safeText is @sanitizeInput(answer).substring(0, safeText.length)
          # console.log "match for " + safeText + ", and:" + @sanitizeInput(answer)
          # console.log "substring was " + @sanitizeInput(answer).substring(0, safeText.length)
          return true
        else
          # console.log "substring was " + @sanitizeInput(answer).substring(0, safeText.length)
          # console.log "no match for " + safeText + ", and:" + @sanitizeInput(answer)
      return false

    getTiming: ->
      text = @get("text")
      words = text.split(" ").length
      return 2000 + Math.max(5000, words*3000, text.length*300)
