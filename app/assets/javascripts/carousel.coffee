class Carousel
  constructor: (selector, options)->
    throw new Error 'Missing Parameters Error' unless selector?

    @carousel = $ selector
    throw new Error 'Invalid Carousel Selector' unless @carousel[0]

    @options = @mergeOptions options

    @carousel.wrapInner "<div class='carousel-track'></div>"
    @carousel.wrapInner "<div class='carousel-scroller'></div>"
    @carousel.wrapInner "<div class='carousel-container'></div>"
    @scroller = new window.Scroller('.carousel-scroller', '.carousel-track', @options)

    @indexElements()
    $elements = @getElements()
    $elements.addClass 'carousel-slide'
    $($elements.get(@options.initialSlide)).addClass 'carousel-current'
    @prevBtn = $ "#{@options.prev}"
    @nextBtn = $ "#{@options.next}"

    @handlers()
    # @setPosition()

  getElements: ->
    @scroller.getElements()

  indexElements: ->
    $elements = @getElements()
    for index, elem of $elements.get()
      $(elem).attr 'data-carousel-index', index

  defaults: ->
    defaults =
      adaptiveHeight: true
      autoplay: false
      arrows: true
      alignment: 'left'
      containWidth: false
      containHeight: true
      cssEase: 'ease-out'
      draggable: true
      edgeFriction: 0
      effect: 'fade'
      focusOnClick: false
      initialSlide: 0
      infinite: false
      lazyLoad: false
      lazyLoadRate: 0
      lazyLoadAttribute: 'data-lazy'
      pagination: false
      respondTo: window
      ltr: true
      slideSelector: '>*'
      slidesToScroll: 1
      slidesToShow: 1
      speed: 1000
      touchThreshold: 5

  mergeOptions: (options)->
    defaults = @defaults()
    combined = {}
    for attribute of defaults
      combined[attribute] = defaults[attribute]
    for attribute of options
      combined[attribute] = options[attribute]
    combined

  handlers: ->
    @arrowHandlers()

  moveDirection: (direction)->
    return false if @moving
    @moving = true
    @scroller[direction]()
    @moving = false

  arrowHandlers: ->
    @prevBtn.on 'click', (e)=>
      @moveDirection 'prev'

    @nextBtn.on 'click', (e)=>
      @moveDirection 'next'

$ ->
  window.Carousel = Carousel
