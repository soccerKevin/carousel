// Generated by CoffeeScript 1.9.3

/*
  A Carousel Scroller.  Controls the track
 */
var Scroller;

Scroller = (function() {
  function Scroller(scrollerSelector, trackSelector, options1) {
    this.options = options1;
    this.Util = window.Util;
    this.uid = this.Util.guid();
    this.scroller = $(scrollerSelector);
    this.scroller.attr('data-uid', this.uid);
    this.track = $(trackSelector);
    this.TRACK_TRANSITION = 'carousel-track-transition';
    this.setTrackTransition();
    this.initilizeSlides();
    this.setCurrent(this.options.initialSlide);
    this.handlers();
    setTimeout(((function(_this) {
      return function() {
        return _this.applyOptions();
      };
    })(this)), 50);
  }


  /*
    #use to apply the initial options
    @params [hash] options
    #only set these options
    #will set all options otherwise
    @private
   */

  Scroller.prototype.applyOptions = function(options) {
    if (options == null) {
      options = null;
    }
    options = options != null ? options : this.options;
    if (this.Util.present(options.slideWidth)) {
      this.setSlideWidth();
    }
    if (this.Util.present(options.infinite)) {
      this.setInfiniteSlides();
    }
    return this.gotoCurrent(false);
  };

  Scroller.prototype.addSlides = function(slides) {
    if (this.options.infinite) {
      this.removeInfiniteSlides();
    }
    this.track.append($(slides));
    this.initilizeSlides();
    return this.applyOptions();
  };

  Scroller.prototype.removeSlides = function(startIndex, count) {
    var $remove;
    if (count == null) {
      count = 1;
    }
    if (this.options.infinite) {
      this.removeInfiniteSlides;
    }
    $remove = this.getSlides().filter(function() {
      var ref;
      return (startIndex <= (ref = $(this).data('carousel-index')) && ref < startIndex + count);
    });
    $remove.remove();
    this.indexSlides();
    this.applyOptions();
    return $remove;
  };

  Scroller.prototype.initilizeSlides = function() {
    this.getSlides().addClass('carousel-slide');
    return this.indexSlides();
  };


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
    var elem, index, ref, results;
    ref = this.getSlides().get();
    results = [];
    for (index in ref) {
      elem = ref[index];
      results.push($(elem).attr('data-carousel-index', index).data('carousel-index', index));
    }
    return results;
  };


  /*
    @return [array]
    #array of jquery slide objects
   */

  Scroller.prototype.getSlides = function() {
    return this.track.find(this.options.slideSelector).not('.clone');
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
    var $slide, diff, ref;
    if (animated == null) {
      animated = true;
    }
    if (animated) {
      this.track.addClass(this.TRACK_TRANSITION);
    }
    ref = this.nextSlideAndIndex(index), $slide = ref[0], index = ref[1];
    diff = this.slideStageDiff($slide);
    this.moveTrack(diff);
    return this.setCurrent(index);
  };


  /*
    @private
   */

  Scroller.prototype.nextSlideAndIndex = function(index) {
    var $slide;
    if (this.options.infinite) {
      if (index < 0) {
        $slide = this.getClone(this.slideCount() + index, 'front');
        index += this.slideCount();
      } else if (index >= this.slideCount() - 1) {
        $slide = this.getClone(index - this.slideCount(), 'rear');
        index -= this.slideCount();
      } else {
        $slide = this.getSlide(index);
      }
    } else {
      if (index < 0) {
        index = 0;
      } else if (index >= this.slideCount() - 1) {
        index = this.slideCount() - 1;
      }
      $slide = this.getSlide(index);
    }
    return [$slide, index];
  };

  Scroller.prototype.gotoCurrent = function(animated) {
    if (animated == null) {
      animated = true;
    }
    return this.goto(this.currentSlideIndex(), animated);
  };

  Scroller.prototype.getSlide = function(index) {
    return this.getSlides().filter("[data-carousel-index=" + index + "]");
  };

  Scroller.prototype.getClone = function(index, end) {
    return this.track.find(this.options.slideSelector).filter(".clone." + end + "[data-carousel-index=" + index + "]");
  };

  Scroller.prototype.slideCount = function() {
    return this.getSlides().length;
  };

  Scroller.prototype.slideStageDiff = function(slide) {
    var method;
    method = this.options.alignment.capitalize();
    return this["diff" + method](slide);
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
    var $slides, scrollerWidth, width;
    $slides = this.getSlides();
    if (this.options.slideWidth === 'auto') {
      $slides.css('width', 'auto');
      return;
    }
    scrollerWidth = this.scroller[0].getBoundingClientRect().width;
    width = Math.ceil(scrollerWidth * this.options.slideWidth);
    return $slides.css('width', width);
  };

  Scroller.prototype.setInfiniteSlides = function() {
    if (this.options.infinite && this.track.find('.clone').length < 1) {
      return this.addInfiniteSlides();
    } else {
      return this.removeInfiniteSlides();
    }
  };

  Scroller.prototype.addInfiniteSlides = function() {
    this.track.prepend(this.cloneSlides().addClass('front'));
    return this.track.append(this.cloneSlides().addClass('rear'));
  };

  Scroller.prototype.cloneSlides = function() {
    return this.getSlides().clone().removeClass('carousel-current').addClass('clone');
  };

  Scroller.prototype.removeInfiniteSlides = function() {
    return this.track.find('.clone').remove();
  };

  Scroller.prototype.next = function() {
    var slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    return this.goto(this.currentSlideIndex() + slides);
  };

  Scroller.prototype.prev = function() {
    var slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    return this.goto(this.currentSlideIndex() - slides);
  };


  /*
    @params [hash] new options
    #a set of only the options you wish to change
   */

  Scroller.prototype.updateOptions = function(options) {
    this.options = this.Util.combineHash(this.options, options);
    return this.applyOptions(options);
  };

  Scroller.prototype.handlers = function() {
    return this.transitionEndHandler();
  };

  Scroller.prototype.transitionEndHandler = function() {
    var transitionEnd;
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd';
    return $(document).on(transitionEnd, (function(_this) {
      return function() {
        _this.track.removeClass(_this.TRACK_TRANSITION);
        if (_this.options.infinite) {
          return _this.gotoCurrent(false);
        }
      };
    })(this));
  };

  return Scroller;

})();

$(function() {
  return window.Scroller = Scroller;
});
