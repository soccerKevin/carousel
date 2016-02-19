###
  A Carousel Scroller.  Controls the track
###

class Scroller
  constructor: (scrollerSelector, trackSelector, @options)->
    @Util = window.Util
    @uid = @Util.guid()
    @scroller = $ scrollerSelector
    @scroller.attr 'data-uid', @uid
    @track = $ trackSelector
    @TRACK_TRANSITION = 'carousel-track-transition'
    @setTrackTransition()
    @initilizeSlides()
    @setCurrent @options.initialSlide
    @handlers()
    setTimeout (=>
      @applyOptions()
    ), 50

  ###
    #use to apply the initial options
    @params [hash] options
    #only set these options
    #will set all options otherwise
    @private
  ###
  applyOptions: (options=null)->
    options = if options? then options else @options
    @setSlideWidth() if @Util.present options.slideWidth
    @setInfiniteSlides() if @Util.present options.infinite
    @gotoCurrent false

  addSlides: (slides)->
    @removeInfiniteSlides() if @options.infinite
    @track.append $(slides)
    @unsetSlides()
    @initilizeSlides()
    @applyOptions()

  removeSlides: (startIndex, count=1)->
    @removeInfiniteSlides if @options.infinite
    $remove = @getSlides().filter ->
      startIndex <= $(@).data('carousel-index') < startIndex + count
    $remove.remove()
    @unsetSlides()
    @indexSlides()
    @applyOptions()
    $remove

  initilizeSlides: ->
    @getSlides().addClass 'carousel-slide'
    @indexSlides()

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
    parseInt @currentSlide().data('carousel-index')

  indexSlides: ->
    for index, elem of @getSlides().get()
      #just set both to avoid errors.  stupid data attribute
      $(elem).attr('data-carousel-index', index)
        .data 'carousel-index', index

  ###
    @return [array]
    #array of jquery slide objects
  ###
  getSlides: ->
    @slides = if @slides? then @slides else @track.find(@options.slideSelector).not('.clone')

  unsetSlides: ->
    @slides = null

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
    @track.addClass @TRACK_TRANSITION if animated
    [$slide, index] = @nextSlideAndIndex index
    diff = @slideStageDiff $slide
    @moveTrack diff
    @setCurrent index

  ###
    @private
  ###
  nextSlideAndIndex: (index)->
    console.log index
    console.log @slideCount()
    if @options.infinite?
      if index < 0
        $slide = @getClone @slideCount() + index, 'front'
        index += @slideCount()
      else if index >= @slideCount()
        $slide = @getClone index - @slideCount(), 'rear'
        index -= @slideCount()
      else
        $slide = @getSlide index
    else
      if index < 0
        index = 0
      else if index >= @slideCount()
        index = @slideCount() - 1
      $slide = @getSlide index

    console.log $slide
    [$slide, index]

  gotoCurrent: (animated = true)->
    @goto @currentSlideIndex(), animated

  getSlide: (index)->
    @getSlides().filter("[data-carousel-index=#{index}]")

  getClone: (index, end)->
    @track.find(@options.slideSelector).filter(".clone.#{end}[data-carousel-index=#{index}]")

  slideCount: ->
    @getSlides().length

  # delta(x) of slide[index] to stage
  # uses diff[method]
  slideStageDiff: (slide)->
    method = @options.alignment.capitalize()
    @["diff#{method}"](slide)

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
    if @options.slideWidth == 'auto'
      $slides.css 'width', 'auto'
      return
    scrollerWidth = @scroller[0].getBoundingClientRect().width
    width = Math.ceil scrollerWidth * @options.slideWidth
    $slides.css 'width', width

  setInfiniteSlides: ()->
    if @options.infinite && @track.find('.clone').length < 1
      @addInfiniteSlides()
    else
      @removeInfiniteSlides()

  addInfiniteSlides: ->
    @track.prepend @cloneSlides().addClass 'front'
    @track.append @cloneSlides().addClass 'rear'

  cloneSlides: ->
    @getSlides().clone().removeClass('carousel-current').addClass 'clone'

  removeInfiniteSlides: ->
    @track.find('.clone').remove()

  next: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    @goto @currentSlideIndex() + slides

  prev: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    @goto @currentSlideIndex() - slides


  # slideWidth: '1'
  # alignment: 'left'
  # initialSlide: 0
  # ltr: true
  # slidesToScroll: 1
  # slideSelector: '>*'
  # infinite: true
  # cssEase: 'ease-out'

  # draggable: true
  # effect: 'scroll'
  # speed: 1000
  # edgeFriction: 0
  # touchThreshold: 5
  # lazyLoad: false
  # lazyLoadRate: 0
  # lazyLoadAttribute: 'data-lazy'
  # titleSlide: false

  ###
    @params [hash] new options
    #a set of only the options you wish to change
  ###
  updateOptions: (options)->
    @options = @Util.combineHash @options, options
    @applyOptions options

  handlers: ->
    @transitionEndHandler()

  transitionEndHandler: ->
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd'
    $(document).on transitionEnd, =>
      @track.removeClass @TRACK_TRANSITION
      # needs to be done when moveTrack is finished
      @gotoCurrent false if @options.infinite

$ ->
  window.Scroller = Scroller
