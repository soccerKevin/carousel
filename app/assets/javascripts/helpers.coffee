String.prototype.capitalize = ->
  @.charAt(0).toUpperCase() + @.slice 1

class Util
  @override = (object1, object2)->
    combined = {}
    for obj of [object1, object2]
      for attribute of obj
        combined[attribute] = obj[attribute]
    combined

  @guid = ->
    s4 = ->
      Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
    s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

$ ->
  window.Util = Util
