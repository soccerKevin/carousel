// Generated by CoffeeScript 1.9.3

/*
   * A Carousel Scroller.  Controls the track
  ## Basic Concept
  #find the difference between the carousel.offset().left and the next slide.offset().left.  then move that distance

   * REMEMBER TO UNSET SLIDES IF YOU CHANGE WHAT THEY ARE
  #ie, add/remove
 */
var Scroller;

Scroller = (function() {
  function Scroller(scrollerSelector, trackSelector, options1) {
    this.options = options1;
    this.TRACK_TRANSITION = 'carousel-track-transition';
    this.Util = window.Util;
    this.uid = this.Util.guid();
    this.scroller = $(scrollerSelector);
    this.scroller.attr('data-uid', this.uid);
    this.track = $(trackSelector);
    this.initilizeSlides();
    this.setTrackTransition();
    this.handlers();
    $(window).load((function(_this) {
      return function() {
        _this.applyOptions();
        return _this.dispatchEvent('karouselLoad');
      };
    })(this));
  }


  /*
    #use to apply the initial options
    @params [hash] options
    #only set these options
    #will set all options otherwise
    @private
   */

  Scroller.prototype.applyOptions = function(options) {
    var index;
    if (options == null) {
      options = this.options;
    }
    if (this.Util.present(options.slideWidth)) {
      this.setSlideWidth();
    }
    if (this.Util.present(options.infinite)) {
      this.setInfiniteSlides();
    }
    index = this.gotoCurrent(false);
    this.dispatchEvent('karouselOptionsChanged');
    return index;
  };

  Scroller.prototype.addSlides = function(slides) {
    if (this.options.infinite) {
      this.removeInfiniteSlides();
    }
    this.track.append($(slides));
    this.unsetSlides();
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
    this.unsetSlides();
    this.indexSlides();
    if (!this.currentSlideIndex()) {
      this.setCurrent(startIndex);
    }
    this.applyOptions();
    return $remove;
  };

  Scroller.prototype.initilizeSlides = function() {
    this.getSlides().addClass('carousel-slide');
    this.indexSlides();
    this.setCurrent(this.options.initialSlide);
    if (this.options.lazyLoad) {
      return this.lazyLoad();
    }
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
    return parseInt(this.currentSlide().data('carousel-index'));
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

  Scroller.prototype.unsetSlides = function() {
    return this.slides = null;
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

  Scroller.prototype.readyToMove = function(animated) {
    return !(this.atClone && animated);
  };


  /*
    @param [int] index
     * index of the slide to goto
     * may first go to clone, then to slide ("instantly") if infinite
    @return [int] index of the new slide
    #-1 if didn't move
   */

  Scroller.prototype.goto = function(index, animated) {
    var $slideClone, diff, ref;
    if (animated == null) {
      animated = true;
    }
    if (!this.readyToMove(animated)) {
      return -1;
    }
    if (this.options.lazyLoad) {
      this.lazyLoad();
    }
    if (animated) {
      this.track.addClass(this.TRACK_TRANSITION);
      this.transitionEndHandler();
    }
    ref = this.nextSlideCloneAndIndex(index), $slideClone = ref[0], index = ref[1];
    diff = this.slideCloneStageDiff($slideClone);
    if (this.scroller.offset().left === diff) {
      return -1;
    }
    this.removeSelected();
    this.moveTrack(diff);
    this.setCurrent(index);
    this.slideSelected = index;
    this.atClone = $slideClone.hasClass('clone');
    if (!animated) {
      this.afterSlideChange();
      this.dispatchEvent('slideChanged');
    }
    return index;
  };

  Scroller.prototype.afterSlideChange = function() {
    this.track.removeClass(this.TRACK_TRANSITION);
    return this.setSelected(this.slideSelected);
  };

  Scroller.prototype.dispatchEvent = function(eventType) {
    return this.scroller.trigger(eventType);
  };


  /*
    @private
    @param [slideClone]
    @return slideClone and index of newCurrent (after a move) slide
   */

  Scroller.prototype.nextSlideCloneAndIndex = function(index) {
    var $slideClone;
    if (this.options.infinite) {
      if (index < 0) {
        $slideClone = this.getClone(this.slideCount() + index, 'front');
        index += this.slideCount();
      } else if (index >= this.slideCount()) {
        $slideClone = this.getClone(index - this.slideCount(), 'rear');
        index -= this.slideCount();
      } else {
        $slideClone = this.getSlide(index);
      }
    } else {
      index = Math.max(index, 0);
      index = Math.min(index, this.slideCount() - 1);
      $slideClone = this.getSlide(index);
    }
    return [$slideClone, index];
  };

  Scroller.prototype.gotoCurrent = function(animated) {
    if (animated == null) {
      animated = true;
    }
    return this.goto(this.currentSlideIndex(), animated);
  };


  /*
    @private
    @return jquery slide with the given index
   */

  Scroller.prototype.getSlide = function(index) {
    return this.getSlides().filter("[data-carousel-index=" + index + "]");
  };


  /*
    @return [array] jquery slide objects
   */

  Scroller.prototype.getSlides = function() {
    return this.slides = this.slides != null ? this.slides : this.track.find(this.options.slideSelector).not('.clone');
  };

  Scroller.prototype.getClone = function(index, end) {
    return this.track.find(this.options.slideSelector).filter(".clone." + end + "[data-carousel-index=" + index + "]");
  };

  Scroller.prototype.getClones = function(index) {
    if (index == null) {
      index = null;
    }
    if (index == null) {
      return this.track.find('.clone');
    }
    return this.track.find(".clone[data-carousel-index=" + index + "]");
  };


  /*
    @private
    @return all slides and all clones in order, front-clones + slides + rear-clones
   */

  Scroller.prototype.getAll = function() {
    return this.track.find(this.options.slideSelector);
  };


  /* @private */

  Scroller.prototype.slideCount = function() {
    return this.getSlides().length;
  };

  Scroller.prototype.slideCloneStageDiff = function(slideClone) {
    var method;
    method = this.options.alignment.capitalize();
    return this["diff" + method](slideClone);
  };

  Scroller.prototype.diffLeft = function(slide) {
    return slide.offset().left * -1;
  };

  Scroller.prototype.diffRight = function(slide) {
    return Math.ceil(this.scroller.width() - (slide.offset().left + slide.width()));
  };

  Scroller.prototype.diffCenter = function(slide) {
    var scrollerCenter, slideCenter;
    scrollerCenter = this.scroller.width() / 2;
    slideCenter = slide.offset().left + slide.width() / 2;
    return scrollerCenter - slideCenter;
  };

  Scroller.prototype.moveTrack = function(difference) {
    return this.track.css('left', this.track.offset().left + difference);
  };

  Scroller.prototype.setCurrent = function(index) {
    this.getSlides().removeClass('carousel-current');
    return this.getSlide(index).addClass('carousel-current');
  };

  Scroller.prototype.setSelected = function(index) {
    this.removeSelected();
    return this.getSlide(index).addClass('carousel-selected');
  };

  Scroller.prototype.removeSelected = function() {
    return this.getSlides().removeClass('carousel-selected');
  };

  Scroller.prototype.setSlideWidth = function() {
    var scrollerWidth, w, width;
    scrollerWidth = this.scroller[0].getBoundingClientRect().width;
    w = this.options.slideWidth;
    width = isNaN(parseFloat(w)) ? w : parseFloat(w) * scrollerWidth;
    return this.getSlides().css('width', width);
  };

  Scroller.prototype.setInfiniteSlides = function() {
    if (this.options.infinite && this.track.find('.clone').length < 1) {
      return this.addInfiniteSlides();
    } else if (!this.options.infinite) {
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


  /*
    @return [int] index of the new slide
    #-1 if didn't move
   */

  Scroller.prototype.next = function() {
    var slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    return this.goto(this.currentSlideIndex() + slides);
  };


  /*
    @return [int] index of the new slide
    #-1 if didn't move
   */

  Scroller.prototype.prev = function() {
    var slides;
    slides = this.options.ltr ? this.options.slidesToScroll : this.options.slidesToScroll * -1;
    return this.goto(this.currentSlideIndex() - slides);
  };

  Scroller.prototype.lazyLoad = function() {
    var current, end, start;
    current = this.getAll().index(this.currentSlide());
    start = current - this.options.lazyLoadRate;
    end = start + this.options.lazyLoadRate * 2 + 1;
    return this.loadImages(start, end);
  };


  /*
    @private
    @param [int] start
    #index of first slide/clone to load
    @param [int] end
    #index of las slide/clone to load
   */

  Scroller.prototype.loadImages = function(start, end) {
    var $imgs, elem, index, ref, results;
    start = Math.max(start, 0);
    ref = this.getAll().get().slice(start, end);
    results = [];
    for (index in ref) {
      elem = ref[index];
      $imgs = $(elem).find('img');
      if ($imgs.attr('src') !== $imgs.attr(this.options.lazyLoadAttribute)) {
        results.push($imgs.attr('src', $imgs.attr(this.options.lazyLoadAttribute)));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Scroller.prototype.resize = function() {
    return this.setSlideWidth();
  };


  /*
    @params [hash] new options
    #a set of only the options you wish to change
   */

  Scroller.prototype.updateOptions = function(options) {
    this.options = this.Util.combineHash(this.options, options);
    return this.applyOptions(options);
  };

  Scroller.prototype.handlers = function() {};

  Scroller.prototype.transitionEndHandler = function() {
    var transitionEnd;
    transitionEnd = 'transitionend webkitTransitionEnd msTransitionEnd oTransitionEnd transitionEnd';
    return $(document).one(transitionEnd, (function(_this) {
      return function() {
        _this.afterSlideChange();
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
