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

  # Event Types
  #karouselLoad
  #karouselOptionsChanged
  #slideChanged
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
    throw new Error 'Invalid Carousel Selector' unless @carousel[0]

    @Util = window.Util
    @options = @Util.combineHash @defaults(), options
    @assertDefaults()

    @carousel.wrapInner "<div class='carousel-track'></div>"
    @carousel.wrapInner "<div class='carousel-scroller'></div>"
    @carousel.wrapInner "<div class='carousel-container'></div>"
    @carouselContainer = @carousel.find '.carousel-container'
    @scroller = new window.Scroller "#{@carousel.selector} .carousel-scroller", "#{@carousel.selector} .carousel-track", @options
    @initialHandlers()
    @applyOptions @options
    @saveSize()

  assertDefaults: ->
    #assert slidesToScroll < 1
    @options.slidesToScroll = 1 if @options.slidesToScroll < 1

    #assert lazyLoadRate
    if @options.lazyLoad?
      option1 = @options.lazyLoadRate
      option2 = @options.slidesToScroll
      option3 = if isNaN @options.slideWidth
          0
        else
          @options.slidesToScroll + Math.ceil 1.0 / @options.slideWidth
      @options.lazyLoadRate = Math.max option1, option2, option3

    #assert img's have src
    for index, img of @carousel.find('img').get()
      $(img).attr 'src', '' unless $(img).attr('src')?

  ###
    Apply options used to set new and override existing options
    @private
  ###
  applyOptions: ()->
    @setArrows()
    @keyEventsHandler()

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
      # left, center, right
      alignment: 'left'
      # indexed from 0
      initialSlide: 0
      # left to right / right to left
      ltr: true
      # per action to move
      slidesToScroll: 1
      # auto or % of carousel width (as decimal)
      # auto does not set size
      # want to show 3 slides? set to .3333.  4 slides? .25
      slideWidth: 'auto'
      # is it infinite?
      infinite: false
      # in case your slides have a container or anchor around them
      slideSelector: '>*'
      # scroll speed (ms)
      speed: 1000
      # lazy load images in slides? (will load all images in a slide)
      lazyLoad: false
      # how many slides to lazy load before and after the current slide
      lazyLoadRate: 0
      # will sub in this attributes value to a slides img.src when lazy loading
      lazyLoadAttribute: 'data-lazy'
      # what easing style to use when sliding (or fading)
      cssEase: 'ease-out'
      # scroll or fade
      # effect: 'scroll'
      # hide prev arrow if can't move previous
      # hide next arrow if can't move next
      hideUnclickableArrows: false
      keyEvents: false
      # wheelEvents: false
      # widthHeightRatio: 'auto'

      # draggable: true
      # edgeFriction: 0
      # touchThreshold: 5
      # arrows: true
      # is there a title slide?
      # if true, treats the first slide as the title slide
      # titleSlide: false

  ###
    @param [array] slides
    #an array of slides to add
  ###
  addSlides: (slides)->
    @scroller.addSlides slides

  ###
    @param [int] startIndex
    #where to start removing slides from
    @param [int] count
    #how many slides to remove
  ###
  removeSlides: (startIndex, count = 1)->
    @scroller.removeSlides startIndex, count

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
    index = @scroller[direction]()
    @moving = false
    index

  ###
    resize this carousel
    #make sure everything is how it should be
  ###
  resize: ->
    @applyOptions()
    @scroller.resize()
    @scroller.gotoCurrent false

  ###
    Update options after instance construction
    @param [hash] options
    #any set of options you wish to change
  ###
  updateOptions: (options)->
    options = Carousel.deleteNonResetables options
    @options = @Util.combineHash @options, options
    @assertDefaults()
    @applyOptions()
    @scroller.updateOptions options

  ### @private ###
  @deleteNonResetables: (options)->
    delete options.slideSelector
    delete options.initialSlide
    options

  ### @private ###
  setArrows: ->
    @arrowHandlersOff()
    @setNext()
    @setPrev()

  ### @private ###
  setNext: ->
    @nextBtn = $(@options.next)
    @nextHandler()

  ### @private ###
  setPrev: ->
    @prevBtn = $(@options.prev)
    @prevHandler()

  ### @private ###
  saveSize: ->
    @width = @carousel.width()
    @height = @carousel.height()

  ### @private ###
  didResize: ->
    if @width != @carousel.width() || @height != @carousel.height()
      @saveSize()
      return true
    false

  showBtn: (btn)->
    @["#{btn}Btn"].show()

  hideBtn: (btn)->
    @["#{btn}Btn"].hide()

  ### @private ###
  initialHandlers: ->
    @resizeHandler()

  ### @private ###
  resizeHandler: ->
    $(window).resize =>
      @resize() if @didResize()

  ### @private ###
  nextHandler: ->
    @nextBtn.on 'click', (e)=>
      @nextBtnClick()

  ### @private ###
  prevHandler: ->
    @prevBtn.on 'click', (e)=>
      @prevBtnClick()

  nextBtnClick: ->
    index = @moveDirection 'next'
    @showBtn 'prev'
    if !@options.infinite && @options.hideUnclickableArrows
      if @options.ltr
        if index >= @scroller.slideCount() - 1
          return @hideBtn 'next'
      else
        if index <= 0
          return @hideBtn 'next'
    @showBtn 'next'

  prevBtnClick: ->
    index = @moveDirection 'prev'
    @showBtn 'next'
    if !@options.infinite && @options.hideUnclickableArrows
      if !@options.ltr
        if index >= @sroller.slideCount() - 1
          return @hideBtn 'prev'
      else
        if index <= 0
          return @hideBtn 'prev'
    @showBtn 'prev'

  arrowHandlersOff: ->
    @nextBtn.off() if @nextBtn?
    @prevBtn.off() if @prevBtn?

  keyEvents: (e)->
    return false unless @options.keyEvents
    if e.keyCode == 37
      @prevBtnClick()
    else if e.keyCode == 39
      @nextBtnClick()

  keyEventsHandler: ->
    if @options.keyEvents
      $(document).on 'keypress', (e)=>
        @keyEvents e

    if @options.wheelEvents
      document.addEventListener 'onscroll', (e)->
        # console.log(e.wheelDelta);



$ ->
  window.Carousel = Carousel
