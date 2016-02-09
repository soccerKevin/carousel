class Scroller
  constructor: (scrollerSelector, trackSelector, options)->
    @scroller = $ scrollerSelector
    @track = $ trackSelector
    @TRACK_TRANSITION = 'carousel-track-transition'
    @options = options
    @setTrackTransition()
    @indexSlides()
    @handlers()

  indexSlides: ->
    $slides = @getSlides()
    for index, elem of $slides.get()
      $(elem).attr 'data-carousel-index', index

  getSlides: ->
    @track.find @options.slideSelector

  setTrackTransition: ->
    trackTransition = $("<style id='carousel-track-transition'></style>")
      .prop("type", "text/css")
      .html(
        ".#{@TRACK_TRANSITION} {\
          transition: left #{@options.speed / 1000}s #{@options.cssEase} !important;\
        }
        "
        "#my-window {\
        position: fixed;\
        z-index: 102;\
        display:none;\
        top:50%;\
        left:50%;\
        }"
      )
    $elem = $('head').find @TRACK_TRANSITION
    if $elem.get 0
      $elem.replaceWith trackTransition
    else
      $('head').append trackTransition

  goto: (index)->
    return false unless @track.find(".carousel-slide[data-carousel-index=#{index}]").get(0)
    @track.addClass @TRACK_TRANSITION
    diff = @slideStageDiff index
    @moveTrack diff
    @setCurrent index

  gotoCurrent: ->
    index = @track.find('.carousel-current').data('carousel-index')
    @goto index

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

  handlers: ->
    @animationEndHandler()

  animationEndHandler: ->
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd'
    $(document).on transitionEnd, =>
      @track.removeClass @TRACK_TRANSITION

$ ->
  window.Scroller = Scroller