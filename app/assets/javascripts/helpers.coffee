String.prototype.capitalize = ->
  @.charAt(0).toUpperCase() + @.slice 1
