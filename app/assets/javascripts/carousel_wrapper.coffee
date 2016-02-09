

class CarouselWrapper
  constructor: (selector)->
    @carousel = $ selector
    @saveSize()

  saveSize: ->
    @width = @carousel.width()
    @height = @carousel.height()

  didResize: ->
    if @width != @carousel.width() || @height != @carousel.height()
      @saveSize()
      return true
    false

$ ->
  window.CarouselWrapper = CarouselWrapper
