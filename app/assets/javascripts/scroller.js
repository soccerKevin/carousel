// Generated by CoffeeScript 1.9.3

/*
  A Carousel Scroller.  Controls the track
 */
var Scroller;

Scroller = (function() {
  function Scroller(scrollerSelector, trackSelector, options) {
    this.uid = window.Util.guid();
    this.scroller = $(scrollerSelector);
    this.scroller.attr('data-uid', this.uid);
    this.track = $(trackSelector);
    this.TRACK_TRANSITION = 'carousel-track-transition';
    this.options = options;
    this.setTrackTransition();
    this.indexSlides();
    this.setCurrent(this.options.initialSlide);
    this.handlers();
  }


  /*
    @return [object]
    #JQuery object of the current slide for this scroller
   */

  Scroller.prototype.currentSlide = function() {
    return this.track.find('.carousel-current');
  };


  /*
    @return [int]
    #the index of the current slide
   */

  Scroller.prototype.currentSlideIndex = function() {
    return this.currentSlide().data('carousel-index');
  };

  Scroller.prototype.indexSlides = function() {
    var $slides, elem, index, ref, results;
    $slides = this.getSlides();
    ref = $slides.get();
    results = [];
    for (index in ref) {
      elem = ref[index];
      results.push($(elem).attr('data-carousel-index', index));
    }
    return results;
  };


  /*
    @return [array]
    #array of jquery slide objects
   */

  Scroller.prototype.getSlides = function() {
    return this.track.find(this.options.slideSelector);
  };

  Scroller.prototype.setTrackTransition = function() {
    var $elem, $trackTransition;
    $trackTransition = $("<style id='" + this.TRACK_TRANSITION + "-" + this.uid + "'></style>").prop("type", "text/css").html(this.scroller.selector + "[data-uid='" + this.uid + "'] ." + this.TRACK_TRANSITION + " {transition: left " + (this.options.speed / 1000) + "s " + this.options.cssEase + " !important;}");
    $elem = $('head').find($trackTransition.selector);
    if ($elem.get(0)) {
      return $elem.replaceWith($trackTransition);
    } else {
      return $('head').append($trackTransition);
    }
  };

  Scroller.prototype.goto = function(index, animated) {
    var diff;
    if (animated == null) {
      animated = true;
    }
    if (!this.track.find(".carousel-slide[data-carousel-index=" + index + "]").get(0)) {
      return false;
    }
    if (animated) {
      this.track.addClass(this.TRACK_TRANSITION);
    }
    diff = this.slideStageDiff(index);
    this.moveTrack(diff);
    return this.setCurrent(index);
  };

  Scroller.prototype.gotoCurrent = function(animated) {
    if (animated == null) {
      animated = true;
    }
    return this.goto(this.currentSlideIndex(), animated);
  };

  Scroller.prototype.slideStageDiff = function(index) {
    var $slide, method;
    $slide = this.track.find(".carousel-slide[data-carousel-index=" + index + "]");
    method = this.options.alignment.capitalize();
    return this["diff" + method]($slide);
  };

  Scroller.prototype.diffLeft = function(slide) {
    return slide.offset().left * -1;
  };

  Scroller.prototype.diffRight = function(slide) {
    return this.scroller.width() - (slide.offset().left + slide.width());
  };

  Scroller.prototype.diffCenter = function(slide) {
    var scrollerCenter, slideCenter;
    scrollerCenter = this.scroller.width() / 2;
    slideCenter = slide.offset().left + slide.width() / 2;
    return scrollerCenter - slideCenter;
  };

  Scroller.prototype.moveTrack = function(difference) {
    var start;
    start = this.track.offset().left;
    return this.track.css('left', start + difference);
  };

  Scroller.prototype.setCurrent = function(index) {
    var $slides;
    $slides = this.getSlides();
    return $slides.removeClass('carousel-current').eq(index).addClass('carousel-current');
  };

  Scroller.prototype.setSlideWidth = function() {
    var $slides;
    $slides = this.getSlides();
    return $slides.css('width', this.scroller.width() * this.options.slideWidth);
  };

  Scroller.prototype.next = function() {
    var index, slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    index = this.track.find('.carousel-current').data('carousel-index') + slides;
    return this.goto(index);
  };

  Scroller.prototype.prev = function() {
    var index, slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    index = this.track.find('.carousel-current').data('carousel-index') - slides;
    return this.goto(index);
  };

  Scroller.prototype.updateOptions = function(options) {
    this.options = options;
    this.setSlideWidth();
    return this.gotoCurrent(false);
  };

  Scroller.prototype.handlers = function() {
    return this.transitionEndHandler();
  };

  Scroller.prototype.transitionEndHandler = function() {
    var transitionEnd;
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd';
    return $(document).on(transitionEnd, (function(_this) {
      return function() {
        return _this.track.removeClass(_this.TRACK_TRANSITION);
      };
    })(this));
  };

  return Scroller;

})();

$(function() {
  return window.Scroller = Scroller;
});
