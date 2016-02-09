###
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use

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

    @options = @mergeOptions options

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

  getSlides: ->
    @scroller.getSlides()

  defaults: ->
    defaults =
      ### selector of the next arrow ###
      next: '#next .arrow'
      ### selector of the prev arrow ###
      prev: '#prev .arrow'
      ###
        left aligned, right aligned or centered
        values: left, right, center
      ###
      alignment: 'left'
      ### must be positive ###
      initialSlide: 0
      ### left to right (true or false) ###
      ltr: true
      ### shift this many slides###
      slidesToScroll: 1

      ###
        width of slides compared to carousel
        show 2 slides at once, set to .5
        show 4 slides at once, set to .25
      ###
      slideWidth: '1'

      ### fake the infinite slides ###
      infinite: false
      slideSelector: '>*'
      adaptiveHeight: true
      draggable: true
      effect: 'fade'
      cssEase: 'ease-out'
      edgeFriction: 0
      speed: 1000
      touchThreshold: 5
      lazyLoad: false
      lazyLoadRate: 0
      lazyLoadAttribute: 'data-lazy'
      arrows: true
      hideUnclickableArrows: false

  mergeOptions: (options)->
    defaults = @defaults()
    combined = {}
    for attribute of defaults
      combined[attribute] = defaults[attribute]
    for attribute of options
      combined[attribute] = options[attribute]
    combined

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
