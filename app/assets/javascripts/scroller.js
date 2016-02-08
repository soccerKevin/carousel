// Generated by CoffeeScript 1.9.3
var Scroller;

Scroller = (function() {
  function Scroller(scrollerSelector, trackSelector, options) {
    this.scroller = $(scrollerSelector);
    this.track = $(trackSelector);
    this.options = options;
  }

  Scroller.prototype.getElements = function() {
    return this.track.find(this.options.slideSelector);
  };

  Scroller.prototype.goto = function(index) {
    var diff;
    if (!this.track.find(".carousel-slide[data-carousel-index=" + index + "]").get(0)) {
      return false;
    }
    diff = this.slideStageDiff(index);
    this.moveTrack(diff);
    return this.setCurrent(index);
  };

  Scroller.prototype.slideStageDiff = function(index) {
    var $slide, method;
    $slide = this.track.find(".carousel-slide[data-carousel-index=" + index + "]");
    method = this.options.alignment.capitalize();
    return this["diff" + method]($slide);
  };

  Scroller.prototype.diffLeft = function(slide) {
    return this.scroller.offset().left - slide.offset().left;
  };

  Scroller.prototype.diffRight = function(slide) {
    return (this.scroller.offset().left + this.scroller.width()) - (slide.offset().left + slide.width());
  };

  Scroller.prototype.diffCenter = function(slide) {
    var scrollerCenter, slideCenter;
    scrollerCenter = this.scroller.offset().left + this.scroller.width() / 2;
    slideCenter = slide.offset().left + slide.width() / 2;
    return scrollerCenter - slideCenter;
  };

  Scroller.prototype.moveTrack = function(difference) {
    var start;
    start = this.track.offset().left;
    return this.track.css('left', start + difference);
  };

  Scroller.prototype.setCurrent = function(index) {
    var $elements;
    $elements = this.getElements();
    return $elements.removeClass('carousel-current').eq(index).addClass('carousel-current');
  };

  Scroller.prototype.next = function() {
    var index;
    index = this.track.find('.carousel-current').data('carousel-index') + this.options.slidesToScroll;
    return this.goto(index);
  };

  Scroller.prototype.prev = function() {
    var index;
    index = this.track.find('.carousel-current').data('carousel-index') - this.options.slidesToScroll;
    return this.goto(index);
  };

  return Scroller;

})();

$(function() {
  return window.Scroller = Scroller;
});
