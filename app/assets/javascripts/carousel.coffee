class Carousel
  constructor: (selector, options)->
    throw new Error 'Missing Parameters Error' unless selector?

    @carousel = $ selector
    throw new Error 'Invalid Carousel Selector' unless @carousel[0]

    @options = @mergeOptions options

    @carousel.wrapInner "<div class='carousel-track'></div>"
    @carousel.wrapInner "<div class='carousel-scroller'></div>"
    @carousel.wrapInner "<div class='carousel-container'></div>"
    @track = @carousel.find '.carousel-track'
    @scroller = @carousel.find '.carousel-scroller'
    @elements = @getElements()
    @elements.addClass 'carousel-slide'

    @prevBtn = $ "#{@options.prev}"
    @nextBtn = $ "#{@options.next}"

    @handlers()
    # @setPosition()

  getElements: ->
    @track.find @options.slideSelector

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

  slideStageDiff: (index)->
    # deltaX of index slide to stage
    op = @options
    $slide = @track.find ".carousel-slide[data-carousel-index=#{index}]"
    console.log ".carousel-slide[data-carousel-index=#{index}]"
    console.log $slide
    method = op.alignment.capitalize()
    @["diff#{method}"]($slide)

  diffLeft: (slide)->
    @scroller.offset().left - slide.offset().left

  diffRight: (slide)->
    @scroller.offset().right - slide.offset().right - @scroller.width()

  diffCenter: (slide)->
    scrollerCenter = @scroller.offset().left + @scroller.width() / 2
    slideCenter = slide.offset().left + slide.width() / 2
    scrollerCenter - slideCenter

  next: ->
    console.log @track.find('.carousel-slide').data
    index = @track.find('.carousel-slide').data 'carousel-index' + @options.slidesToScroll
    diff = @slideStageDiff index
    @moveTrack diff

  prev: ->
    index = @track.find('.carousel-slide').data 'carousel-index' - @options.slidesToScroll
    diff = @slideStageDiff index
    @moveTrack diff

  # positive difference moves right
  # negative difference moves left
  moveTrack: (difference)->
    @track.css 'left', difference

  handlers: ->
    @arrowHandlers()

  arrowHandlers: ->
    @prevBtn.on 'click', (e)=>
      @prev()

    @nextBtn.on 'click', (e)=>
      @next()

$ ->
  window.Carousel = Carousel
