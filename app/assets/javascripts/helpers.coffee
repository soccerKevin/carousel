String.prototype.capitalize = ->
  @.charAt(0).toUpperCase() + @.slice 1

class Util
  @combineHash = (hash1, hash2)->
    combined = {}
    for attribute of hash1
      combined[attribute] = hash1[attribute]
    for attribute of hash2
      combined[attribute] = hash2[attribute]
    combined

  @guid = ->
    s4 = ->
      Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
    s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

  @present = (variable)->
    return true if variable != 'undefined' && variable != null
    false

$ ->
  window.Util = Util
