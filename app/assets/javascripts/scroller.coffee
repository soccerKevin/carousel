###
  A Carousel Scroller.  Controls the track
###

class Scroller
  constructor: (scrollerSelector, trackSelector, options)->
    @uid = window.Util.guid()
    @scroller = $ scrollerSelector
    @scroller.attr 'data-uid', @uid
    @track = $ trackSelector
    @TRACK_TRANSITION = 'carousel-track-transition'
    @options = options
    @setTrackTransition()
    @indexSlides()
    @setCurrent @options.initialSlide
    @handlers()

  ###
    @return [object]
    #JQuery object of the current slide for this scroller
  ###
  currentSlide: ->
    @track.find('.carousel-current')

  ###
    @return [int]
    #the index of the current slide
  ###
  currentSlideIndex: ->
    @currentSlide().data('carousel-index')

  indexSlides: ->
    $slides = @getSlides()
    for index, elem of $slides.get()
      $(elem).attr 'data-carousel-index', index

  ###
    @return [array]
    #array of jquery slide objects
  ###
  getSlides: ->
    @track.find @options.slideSelector

  setTrackTransition: ->
    $trackTransition = $("<style id='#{@TRACK_TRANSITION}-#{@uid}'></style>")
      .prop("type", "text/css")
      .html "
        #{@scroller.selector}[data-uid='#{@uid}'] .#{@TRACK_TRANSITION} {\
          transition: left #{@options.speed / 1000}s #{@options.cssEase} !important;\
        }"
    $elem = $('head').find $trackTransition.selector
    if $elem.get 0
      $elem.replaceWith $trackTransition
    else
      $('head').append $trackTransition

  goto: (index, animated = true)->
    return false unless @track.find(".carousel-slide[data-carousel-index=#{index}]").get(0)
    @track.addClass @TRACK_TRANSITION if animated
    diff = @slideStageDiff index
    @moveTrack diff
    @setCurrent index

  gotoCurrent: (animated = true)->
    @goto @currentSlideIndex(), animated

  # delta(x) of slide[index] to stage
  # uses diff[method]
  slideStageDiff: (index)->
    $slide = @track.find ".carousel-slide[data-carousel-index=#{index}]"
    method = @options.alignment.capitalize()
    @["diff#{method}"]($slide)

  diffLeft: (slide)->
    slide.offset().left * -1

  diffRight: (slide)->
    @scroller.width() - (slide.offset().left + slide.width())

  diffCenter: (slide)->
    scrollerCenter = @scroller.width() / 2
    slideCenter = slide.offset().left + slide.width() / 2
    scrollerCenter - slideCenter

  moveTrack: (difference)->
    start = @track.offset().left
    @track.css 'left', start + difference

  setCurrent: (index)->
    $slides = @getSlides()
    $slides.removeClass('carousel-current').eq(index).addClass 'carousel-current'

  setSlideWidth: ()->
    $slides = @getSlides()
    $slides.css 'width', @scroller.width() * @options.slideWidth

  next: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    index = @track.find('.carousel-current').data('carousel-index') + slides
    @goto index

  prev: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    index = @track.find('.carousel-current').data('carousel-index') - slides
    @goto index


  # slideWidth: '1'

  # alignment: 'left'
  # initialSlide: 0
  # ltr: true
  # slidesToScroll: 1
  # infinite: false
  # slideSelector: '>*'
  # draggable: true
  # effect: 'scroll'
  # cssEase: 'ease-out'
  # speed: 1000
  # edgeFriction: 0
  # touchThreshold: 5
  # lazyLoad: false
  # lazyLoadRate: 0
  # lazyLoadAttribute: 'data-lazy'
  # titleSlide: false
  updateOptions: (options)->
    @options = options
    for index, option of @resetableOptions()
      @["set#{option.capitalize()}"]()
    @gotoCurrent false

  ###
    @return [array] resetable options
    @private
  ###
  resetableOptions: ->
    [
      'slideWidth'
    ]

  handlers: ->
    @transitionEndHandler()

  transitionEndHandler: ->
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd'
    $(document).on transitionEnd, =>
      @track.removeClass @TRACK_TRANSITION

$ ->
  window.Scroller = Scroller
