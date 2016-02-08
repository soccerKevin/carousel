class Scroller
  constructor: (scrollerSelector, trackSelector, options)->
    @scroller = $ scrollerSelector
    @track = $ trackSelector
    @options = options

  getElements: ->
    @track.find @options.slideSelector

  # delta(x) of slide[index] to stage
  # uses the already set method
  slideStageDiff: (index)->
    $slide = @track.find ".carousel-slide[data-carousel-index=#{index}]"
    method = @options.alignment.capitalize()
    @["diff#{method}"]($slide)

  diffLeft: (slide)->
    @scroller.offset().left - slide.offset().left

  diffRight: (slide)->
    (@scroller.offset().left + @scroller.width()) - (slide.offset().left + slide.width())

  diffCenter: (slide)->
    scrollerCenter = @scroller.offset().left + @scroller.width() / 2
    slideCenter = slide.offset().left + slide.width() / 2
    scrollerCenter - slideCenter

  # positive difference moves right
  # negative difference moves left
  moveTrack: (difference)->
    start = @track.offset().left
    @track.css 'left', start + difference

  setCurrent: (index)->
    $elements = @getElements()
    $elements.removeClass('carousel-current').eq(index).addClass 'carousel-current'

  next: ->
    index = @track.find('.carousel-current').data('carousel-index') + @options.slidesToScroll
    return false unless @track.find(".carousel-slide[data-carousel-index=#{index}]").get(0)
    diff = @slideStageDiff index
    @moveTrack diff
    @setCurrent index

  prev: ->
    index = @track.find('.carousel-current').data('carousel-index') - @options.slidesToScroll
    return false unless @track.find(".carousel-slide[data-carousel-index=#{index}]").get(0)
    diff = @slideStageDiff index
    @moveTrack diff
    @setCurrent index

$ ->
  window.Scroller = Scroller
