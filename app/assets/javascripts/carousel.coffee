###
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use
###

###
  # defaults =
  # @param next [string]
  #default: none
  #next button selector (required)

  # @param prev [string]
  #default: none
  #prev button selector (required)

  # @option alignment [string]
  #default: 'left'
  #values: left, right, center

  # @option initialSlide [int]
  #default: 0
  #must be positive

  # @option ltr [boolean]
  #default: true
  #left to right (true or false)

  # @option slidesToScroll [int]
  #default: 1
  #shift this many slides

  # @option [float] slideWidth
  #default: 1
  #width of slides compared to carousel as a decimal
  #example:
  #show 2 slides at once, set to .5
  #show 4 slides at once, set to .25

  # @option [boolean] infinite
  #default: false
  #fake the infinite slides

  # @option [string] slideSelector
  #default: '>*'
  #Carousel uses to get elements to use as slides
  #incase direct children are not what you want to be referenced as slides

  # @option [boolean] draggable
  #default: true
  #allow the user to move the carousel using their mouse

  # @option [string] effect
  #default: 'scroll'
  #possible: scroll, fade
  #the effect to use when changing slides

  # @option [string] cssEase
  #default: 'ease-out'
  #method of transition

  # @option [int] speed
  #default: 1000
  #speed of transition in ms

  #edgeFriction: 0
  #touchThreshold: 5

  # @option [boolean] lazyLoad
  #default: false
  #load images as you need them vs all at once

  # @option [int] lazyLoadRate
  #default: 0
  #load this many images past the current image

  # @option [string] lazyLoadAttribute
  #default: 'data-lazy'
  #attribute on img tag to get the source of the image for lazy loading

  # @option [boolean] hideUnclickableArrows
  #default: false
  #hide left arrow if no more slides to the left
  #hide right arrow if no more slides to the right
  #only available in non-infinite mode

  # @option [boolean] titleSlide
  #default: false
  #marks the first slide as a title slide
###

class Carousel
  ###
    @param [string] selector
    #main Carousel Container

    @param [hash] options
    #overrides for defaults

    @return [object] carousel instance
  ###
  constructor: (selector, options)->
    throw new Error 'Missing Parameters Error' unless selector?

    @carousel = $ selector
    @carouselWrapper = new window.CarouselWrapper selector
    throw new Error 'Invalid Carousel Selector' unless @carousel[0]

    @Util = window.Util
    @options = @Util.combineHash @defaults(), options

    @carousel.wrapInner "<div class='carousel-track'></div>"
    @carousel.wrapInner "<div class='carousel-scroller'></div>"
    @carousel.wrapInner "<div class='carousel-container'></div>"
    @carouselContainer = @carousel.find '.carousel-container'
    @scroller = new window.Scroller '.carousel-scroller', '.carousel-track', @options

    @getSlides().addClass 'carousel-slide'
    @initialHandlers()

    @applyOptions @options
    setTimeout (=>
      @scroller.gotoCurrent false
    ), 50

  ###
    Apply options used to set new and override existing options
    @private
  ###
  applyOptions: ()->
    @setArrows()

  ###
    @return JQuery object of the current slide
  ###
  currentSlide: ()->
    @scroller.currentSlide()

  ###
    @return index of the current slide
  ###
  currentSlideIndex: ()->
    @scroller.currentSlideIndex()

  ###
    @return [hash] defaults
    @private
  ###
  defaults: ->
    defaults =
      next: '#next .arrow'
      prev: '#prev .arrow'
      alignment: 'left'
      initialSlide: 0
      ltr: true
      slidesToScroll: 1
      slideWidth: '1'
      infinite: false
      slideSelector: '>*'
      draggable: true
      effect: 'scroll'
      cssEase: 'ease-out'
      speed: 1000
      edgeFriction: 0
      touchThreshold: 5
      lazyLoad: false
      lazyLoadRate: 0
      lazyLoadAttribute: 'data-lazy'
      arrows: true
      hideUnclickableArrows: false
      titleSlide: false

  ###
    @return [array] slides
    #JQuery array of the slides of this carousel's scroller
  ###
  getSlides: ->
    @scroller.getSlides()

  ###
    @param [string] direction
    #'next'/'prev'
  ###
  moveDirection: (direction)->
    return false if @moving
    @moving = true
    @scroller[direction]()
    @moving = false

  ###
    resize this carousel
  ###
  resize: ->
    @applyOptions()
    @scroller.gotoCurrent false

  ###
    Update options after instance construction
    @param [hash] options
    #any set of options you wish to change
  ###
  updateOptions: (options)->
    options = Carousel.deleteNonResetables options
    @options = @Util.combineHash @options, options
    @applyOptions()
    @scroller.updateOptions options

  ### @private ###
  @deleteNonResetables: (options)->
    delete options.slideSelector
    delete options.initialSlide
    options

  setArrows: ->
    @nextBtn.off() if @nextBtn?
    @prevBtn.off() if @prevBtn?
    @setNext()
    @setPrev()

  setNext: ->
    @nextBtn = $(@options.next)
    @nextHandler()

  setPrev: ->
    @prevBtn = $(@options.prev)
    @prevHandler()

  ### @private ###
  initialHandlers: ->
    @resizeHandler()

  ### @private ###
  resizeHandler: ->
    $(window).resize =>
      @resize() if @carouselWrapper.didResize()

  ### @private ###
  nextHandler: ->
    @nextBtn.on 'click', (e)=>
      @moveDirection 'next'

  prevHandler: ->
    @prevBtn.on 'click', (e)=>
      @moveDirection 'prev'

$ ->
  window.Carousel = Carousel
