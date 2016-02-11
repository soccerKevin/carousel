###
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use
###

### defaults =
  # @param next [string]
  ## next button selector (required)
  # @param prev [string]
  ## prev button selector (required)
  # @option alignment [string]
  ## values: left, right, center.  default = 'left'
  # @option initialSlide [int]
  ## must be positive. default = 0
  # @option ltr [boolean]
  ## left to right (true or false). default = true
  # @option slidesToScroll [int]
  ## shift this many slides. default = 1

  # @option [float] width of slides compared to carousel as a decimal
  # show 2 slides at once, set to .5
  # show 4 slides at once, set to .25
  slideWidth: '1'

  # @option [boolean] fake the infinite slides
  infinite: false

  # @option [string] slide selector, what Carousel uses to get slides
  slideSelector: '>*'

  #
  # adaptiveHeight: true

  # @option is the user allowed to move the carousel using their mouse?
  draggable: true

  # @option values, scroll, fade
  effect: 'scroll'

  # @option the method of transition
  cssEase: 'ease-out'

  # @option the speed of transition
  speed: 1000

  edgeFriction: 0
  touchThreshold: 5

  # @option are you loading images after page carousel load?
  lazyLoad: false

  # @option how many images ahead to load
  lazyLoadRate: 0

  # @option attribute on img tag to get the source of the image for lazy loading
  lazyLoadAttribute: 'data-lazy'

  # @option show arrows?
  arrows: true

  # @option hide left arrow if no more slides to the left
  # @option hide right arrow if no more slides to the right
  # @option only available in non-infinite mode
  hideUnclickableArrows: false
###

class Carousel
  ###
    selector = main Carousel Container
    options = overrides for defaults
  ###
  constructor: (selector, options)->
    throw new Error 'Missing Parameters Error' unless selector?

    @carousel = $ selector
    @carouselWrapper = new window.CarouselWrapper selector
    throw new Error 'Invalid Carousel Selector' unless @carousel[0]

    @options = window.Util.combineHash @defaults(), options

    @carousel.wrapInner "<div class='carousel-track'></div>"
    @carousel.wrapInner "<div class='carousel-scroller'></div>"
    @carousel.wrapInner "<div class='carousel-container'></div>"
    @carouselContainer = @carousel.find '.carousel-container'
    @scroller = new window.Scroller '.carousel-scroller', '.carousel-track', @options

    $slides = @getSlides()
    $slides.addClass 'carousel-slide'
    @prevBtn = $ "#{@options.prev}"
    @nextBtn = $ "#{@options.next}"

    @handlers()
    @applyOptions @options
    setTimeout (=>
      @scroller.gotoCurrent false
    ), 50

  applyOptions: (options)->
    @scroller.setSlideWidth()

  updateOptions: (options)->
    @options = window.Util.combineHash @options, options
    @applyOptions()

  getSlides: ->
    @scroller.getSlides()

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

  moveDirection: (direction)->
    return false if @moving
    @moving = true
    @scroller[direction]()
    @moving = false

  resize: ->
    @applyOptions()
    @scroller.gotoCurrent()

  handlers: ->
    @arrowHandlers()
    @resizeHandler()

  resizeHandler: ->
    $(window).resize =>
      @resize() if @carouselWrapper.didResize()

  arrowHandlers: ->
    @prevBtn.on 'click', (e)=>
      @moveDirection 'prev'

    @nextBtn.on 'click', (e)=>
      @moveDirection 'next'

$ ->
  window.Carousel = Carousel
