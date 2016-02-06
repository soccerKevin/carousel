// Generated by CoffeeScript 1.9.3
var Carousel;

Carousel = (function() {
  function Carousel(selector, options) {
    if (selector == null) {
      throw new Error('Missing Parameters Error');
    }
    this.carousel = $(selector);
    if (!this.carousel[0]) {
      throw new Error('Invalid Carousel Selector');
    }
    this.options = this.mergeOptions(options);
    this.carousel.wrapInner("<div class='carousel-track'></div>");
    this.carousel.wrapInner("<div class='carousel-scroller'></div>");
    this.carousel.wrapInner("<div class='carousel-container'></div>");
    this.track = this.carousel.find('.carousel-track');
    this.scroller = this.carousel.find('.carousel-scroller');
    this.elements = this.getElements();
    this.elements.addClass('carousel-slide');
    this.prevBtn = $("" + this.options.prev);
    this.nextBtn = $("" + this.options.next);
    this.handlers();
  }

  Carousel.prototype.getElements = function() {
    return this.track.find(this.options.slideSelector);
  };

  Carousel.prototype.defaults = function() {
    var defaults;
    return defaults = {
      adaptiveHeight: true,
      autoplay: false,
      arrows: true,
      alignment: 'left',
      containWidth: false,
      containHeight: true,
      cssEase: 'ease-out',
      draggable: true,
      edgeFriction: 0,
      effect: 'fade',
      focusOnClick: false,
      initialSlide: 0,
      infinite: false,
      lazyLoad: false,
      lazyLoadRate: 0,
      lazyLoadAttribute: 'data-lazy',
      pagination: false,
      respondTo: window,
      ltr: true,
      slideSelector: '>*',
      slidesToScroll: 1,
      slidesToShow: 1,
      speed: 1000,
      touchThreshold: 5
    };
  };

  Carousel.prototype.mergeOptions = function(options) {
    var attribute, combined, defaults;
    defaults = this.defaults();
    combined = {};
    for (attribute in defaults) {
      combined[attribute] = defaults[attribute];
    }
    for (attribute in options) {
      combined[attribute] = options[attribute];
    }
    return combined;
  };

  Carousel.prototype.slideStageDiff = function(index) {
    var $slide, method, op;
    op = this.options;
    $slide = this.track.find(".carousel-slide[data-carousel-index=" + index + "]");
    console.log(".carousel-slide[data-carousel-index=" + index + "]");
    console.log($slide);
    method = op.alignment.capitalize();
    return this["diff" + method]($slide);
  };

  Carousel.prototype.diffLeft = function(slide) {
    return this.scroller.offset().left - slide.offset().left;
  };

  Carousel.prototype.diffRight = function(slide) {
    return this.scroller.offset().right - slide.offset().right - this.scroller.width();
  };

  Carousel.prototype.diffCenter = function(slide) {
    var scrollerCenter, slideCenter;
    scrollerCenter = this.scroller.offset().left + this.scroller.width() / 2;
    slideCenter = slide.offset().left + slide.width() / 2;
    return scrollerCenter - slideCenter;
  };

  Carousel.prototype.next = function() {
    var diff, index;
    console.log(this.track.find('.carousel-slide').data);
    index = this.track.find('.carousel-slide').data('carousel-index' + this.options.slidesToScroll);
    diff = this.slideStageDiff(index);
    return this.moveTrack(diff);
  };

  Carousel.prototype.prev = function() {
    var diff, index;
    index = this.track.find('.carousel-slide').data('carousel-index' - this.options.slidesToScroll);
    diff = this.slideStageDiff(index);
    return this.moveTrack(diff);
  };

  Carousel.prototype.moveTrack = function(difference) {
    return this.track.css('left', difference);
  };

  Carousel.prototype.handlers = function() {
    return this.arrowHandlers();
  };

  Carousel.prototype.arrowHandlers = function() {
    this.prevBtn.on('click', (function(_this) {
      return function(e) {
        return _this.prev();
      };
    })(this));
    return this.nextBtn.on('click', (function(_this) {
      return function(e) {
        return _this.next();
      };
    })(this));
  };

  return Carousel;

})();

$(function() {
  return window.Carousel = Carousel;
});
