 define ["marionette"], (Marionette) ->

  class Thing extends Backbone.Model

    defaults:
      text: ""
      translation: ""
      accept: []

    # extract what we need from the api - the text, translation and
    # anything else we're meant to accept
    parse: (thing) ->
      accept = thing.columns[thing.a].accepted
      for alt in thing.columns[thing.a].alts
        accept.push alt.val
      accept.push thing.columns[thing.a].val
      _.extend thing,
        text: thing.columns[thing.a].val
        translation: thing.columns[thing.b].val
        accept: accept

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

    checkAnswer: (text) -> @sanitizeInput(text) in @get("accept")
