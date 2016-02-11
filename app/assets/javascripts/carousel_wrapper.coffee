###
  #A simple class to handle responsive aspects of Carousel
  #determines if the Carousel needs to resize
###
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
