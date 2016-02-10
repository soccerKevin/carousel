String.prototype.capitalize = ->
  @.charAt(0).toUpperCase() + @.slice 1

class Util
  @combineHash = (object1, object2)->
    combined = {}
    for attribute of object1
      combined[attribute] = object1[attribute]
    for attribute of object2
      combined[attribute] = object2[attribute]
    combined

  @guid = ->
    s4 = ->
      Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
    s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

$ ->
  window.Util = Util
