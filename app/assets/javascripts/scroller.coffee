###
  # A Carousel Scroller.  Controls the track
  ## Basic Concept
  #find the difference between the carousel.offset().left and the next slide.offset().left.  then move that distance

  # REMEMBER TO UNSET SLIDES IF YOU CHANGE WHAT THEY ARE
  #ie, add/remove
###

class Scroller
  constructor: (scrollerSelector, trackSelector, @options)->
    @TRACK_TRANSITION = 'carousel-track-transition'
    @Util = window.Util
    @uid = @Util.guid()
    @scroller = $ scrollerSelector
    @scroller.attr 'data-uid', @uid
    @track = $ trackSelector
    @initilizeSlides()
    @setTrackTransition()
    @handlers()

    # wait for dom to layout and css to paint
    $(window).load =>
      @applyOptions()

  ###
    #use to apply the initial options
    @params [hash] options
    #only set these options
    #will set all options otherwise
    @private
  ###
  applyOptions: (options = @options)->
    @setSlideWidth() if @Util.present options.slideWidth
    @setInfiniteSlides() if @Util.present options.infinite
    @gotoCurrent false

  addSlides: (slides)->
    @removeInfiniteSlides() if @options.infinite
    @track.append $(slides)
    @unsetSlides()
    @initilizeSlides()
    @applyOptions()

  removeSlides: (startIndex, count = 1)->
    @removeInfiniteSlides if @options.infinite
    $remove = @getSlides().filter ->
      startIndex <= $(@).data('carousel-index') < startIndex + count
    $remove.remove()
    @unsetSlides()
    @indexSlides()
    @setCurrent startIndex unless @currentSlideIndex()
    @applyOptions()
    $remove

  initilizeSlides: ->
    @getSlides().addClass 'carousel-slide'
    @indexSlides()
    @setCurrent @options.initialSlide
    @lazyLoad() if @options.lazyLoad

  ###
    @return [object]
    #JQuery object of the current slide for this scroller
  ###
  currentSlide: ->
    @track.find '.carousel-current'

  ###
    @return [int]
    #the index of the current slide
  ###
  currentSlideIndex: ->
    parseInt @currentSlide().data 'carousel-index'

  indexSlides: ->
    for index, elem of @getSlides().get()
      #just set both to avoid errors.  stupid data attribute
      $(elem).attr('data-carousel-index', index)
        .data 'carousel-index', index

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

  readyToMove: (animated)->
    !(@atClone && animated)

  ###
    @param [int] index
    # index of the slide to goto
    # may first go to clone, then to slide ("instantly") if infinite
    @return [int] index of the new slide
    #-1 if didn't move
  ###
  goto: (index, animated = true)->
    return -1 unless @readyToMove animated

    @lazyLoad() if @options.lazyLoad
    @track.addClass @TRACK_TRANSITION if animated
    [$slideClone, index] = @nextSlideCloneAndIndex index
    diff = @slideCloneStageDiff $slideClone

    return -1 if @scroller.offset().left == diff
    @moveTrack diff # to a slideClone
    @setCurrent index # set current to index of slide
    ###### ALERT ######
    # current slide could be flagged from '@setCurrent index', but not be in position
    # in this case, assume that transitionEnd handler will run "gotoCurrent false"
    @atClone = $slideClone.hasClass 'clone'
    index

  ###
    @private
    @param [slideClone]
    @return slideClone and index of newCurrent (after a move) slide
  ###
  nextSlideCloneAndIndex: (index)->
    if @options.infinite
      if index < 0
        $slideClone = @getClone @slideCount() + index, 'front'
        index += @slideCount()
      else if index >= @slideCount()
        $slideClone = @getClone index - @slideCount(), 'rear'
        index -= @slideCount()
      else
        $slideClone = @getSlide index
    else
      index = Math.max index, 0
      index = Math.min index, @slideCount() - 1
      $slideClone = @getSlide index

    [$slideClone, index]

  gotoCurrent: (animated = true)->
    @goto @currentSlideIndex(), animated

  ###
    @private
    @return jquery slide with the given index
  ###
  getSlide: (index)->
    @getSlides().filter "[data-carousel-index=#{index}]"

  ###
    @return [array] jquery slide objects
  ###
  getSlides: ->
    @slides = if @slides? then @slides else @track.find(@options.slideSelector).not '.clone'

  getClone: (index, end)->
    #probably don't need to find by selector then filter
    #could probably just find by .clone...
    @track.find(@options.slideSelector).filter ".clone.#{end}[data-carousel-index=#{index}]"

  getClones: (index=null)->
    return @track.find '.clone' unless index?
    @track.find ".clone[data-carousel-index=#{index}]"

  ###
    @private
    @return all slides and all clones in order, front-clones + slides + rear-clones
  ###
  getAll: ()->
    @track.find @options.slideSelector

  ### @private ###
  slideCount: ->
    @getSlides().length

  # delta(x) of slide[index] to stage
  # uses diff[method]
  slideCloneStageDiff: (slideClone)->
    method = @options.alignment.capitalize()
    @["diff#{method}"](slideClone)

  diffLeft: (slide)->
    slide.offset().left * -1

  diffRight: (slide)->
    Math.ceil @scroller.width() - (slide.offset().left + slide.width())

  diffCenter: (slide)->
    scrollerCenter = @scroller.width() / 2
    slideCenter = slide.offset().left + slide.width() / 2
    scrollerCenter - slideCenter

  moveTrack: (difference)->
    @track.css 'left', @track.offset().left + difference

  setCurrent: (index)->
    @getSlides().removeClass 'carousel-current'
    @getSlide(index).addClass 'carousel-current'

  setSlideWidth: ()->
    scrollerWidth = this.scroller[0].getBoundingClientRect().width;
    w = @options.slideWidth
    width = if isNaN parseFloat w then w else parseFloat(w) * scrollerWidth
    @getSlides().css 'width', width

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

  ###
    @return [int] index of the new slide
    #-1 if didn't move
  ###
  next: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    @goto @currentSlideIndex() + slides

  ###
    @return [int] index of the new slide
    #-1 if didn't move
  ###
  prev: ->
    slides = if @options.ltr then @options.slidesToScroll else @options.slidesToScroll * -1
    @goto @currentSlideIndex() - slides

  lazyLoad: ->
    current = @getAll().index @currentSlide()
    start = current - @options.lazyLoadRate
    end = start + @options.lazyLoadRate * 2 + 1
    @loadImages start, end

  ###
    @private
    @param [int] start
    #index of first slide/clone to load
    @param [int] end
    #index of las slide/clone to load
  ###
  loadImages: (start, end) ->
    start = Math.max start, 0
    for index, elem of @getAll().get().slice start, end
      $imgs = $(elem).find 'img'
      if $imgs.attr('src') != $imgs.attr @options.lazyLoadAttribute
        $imgs.attr 'src', $imgs.attr @options.lazyLoadAttribute

  resize: ->
    @setSlideWidth()

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
      # @gotoCurrent false if @options.infinite

$ ->
  window.Scroller = Scroller
