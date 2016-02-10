###
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use

###

###
  ## defaults =
    ## selector for next arrow
    next: '#next .arrow'

    ## selector for prev arrow
    prev: '#prev .arrow'

    ## values: left, right, center
    alignment: 'left'

    ## must be positive
    initialSlide: 0

    ## left to right (true or false)
    ltr: true

    ## shift this many slides
    slidesToScroll: 1

    ## width of slides compared to carousel as a decimal
    ## show 2 slides at once, set to .5
    ## show 4 slides at once, set to .25
    slideWidth: '1'

    ## fake the infinite slides
    infinite: false

    ## slide selector, what Carousel uses to get slides
    slideSelector: '>*'

    ## adaptiveHeight: true

    ## is the user allowed to move the carousel using their mouse?
    draggable: true

    ## values, scroll, fade
    effect: 'scroll'

    ## the method of transition
    cssEase: 'ease-out'

    ## the speed of transition
    speed: 1000

    edgeFriction: 0
    touchThreshold: 5

    ## are you loading images after page carousel load?
    lazyLoad: false

    ## how many images ahead to load
    lazyLoadRate: 0

    ## attribute on img tag to get the source of the image for lazy loading
    lazyLoadAttribute: 'data-lazy'

    ## show arrows?
    arrows: true

    ## hide left arrow if no more slides to the left
    ## hide right arrow if no more slides to the right
    ## only available in non-infinite mode
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
      # selector for next arrow
      next: '#next .arrow'

      # selector for prev arrow
      prev: '#prev .arrow'

      # values: left, right, center
      alignment: 'left'

      # must be positive
      initialSlide: 0

      # left to right (true or false)
      ltr: true

      # shift this many slides
      slidesToScroll: 1

      # width of slides compared to carousel as a decimal
      # show 2 slides at once, set to .5
      # show 4 slides at once, set to .25
      slideWidth: '1'

      # fake the infinite slides
      infinite: false

      # slide selector, what Carousel uses to get slides
      slideSelector: '>*'

      # adaptiveHeight: true

      # is the user allowed to move the carousel with their mouse?
      draggable: true

      # values, scroll, fade
      effect: 'scroll'

      # the method of transition
      cssEase: 'ease-out'

      # the speed of transition
      speed: 1000

      edgeFriction: 0
      touchThreshold: 5

      # are you loading images after page carousel load?
      lazyLoad: false

      # how many images ahead to load
      lazyLoadRate: 0

      # attribute on img tag to get the source of the image for lazy loading
      lazyLoadAttribute: 'data-lazy'

      # show arrows?
      arrows: true

      # hide left arrow if no more slides to the left
      # hide right arrow if no more slides to the right
      # only available in non-infinite mode
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
