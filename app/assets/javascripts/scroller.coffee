class Scroller
  constructor: (scrollerSelector, trackSelector, options)->
    @scroller = $ scrollerSelector
    @track = $ trackSelector
    @options = options

  getSlides: ->
    @track.find @options.slideSelector

  goto: (index)->
    return false unless @track.find(".carousel-slide[data-carousel-index=#{index}]").get(0)
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

$ ->
  window.Scroller = Scroller
