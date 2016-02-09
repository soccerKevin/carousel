// Generated by CoffeeScript 1.9.3

/*
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use
 */
var Carousel;

Carousel = (function() {

  /*
    selector = main Carousel Container
    options = overrides for defaults
   */
  function Carousel(selector, options) {
    var $slides;
    if (selector == null) {
      throw new Error('Missing Parameters Error');
    }
    this.carousel = $(selector);
    this.carouselWrapper = new window.CarouselWrapper(selector);
    if (!this.carousel[0]) {
      throw new Error('Invalid Carousel Selector');
    }
    this.options = this.mergeOptions(options);
    this.carousel.wrapInner("<div class='carousel-track'></div>");
    this.carousel.wrapInner("<div class='carousel-scroller'></div>");
    this.carousel.wrapInner("<div class='carousel-container'></div>");
    this.carouselContainer = this.carousel.find('.carousel-container');
    this.scroller = new window.Scroller('.carousel-scroller', '.carousel-track', this.options);
    $slides = this.getSlides();
    $slides.addClass('carousel-slide');
    this.prevBtn = $("" + this.options.prev);
    this.nextBtn = $("" + this.options.next);
    this.handlers();
    this.applyOptions(this.options);
    setTimeout(((function(_this) {
      return function() {
        return _this.scroller.goto(_this.options.initialSlide);
      };
    })(this)), 50);
  }

  Carousel.prototype.applyOptions = function(options) {
    return this.scroller.setSlideWidth();
  };

  Carousel.prototype.getSlides = function() {
    return this.scroller.getSlides();
  };

  Carousel.prototype.defaults = function() {
    var defaults;
    return defaults = {

      /* selector of the next arrow */
      next: '#next .arrow',

      /* selector of the prev arrow */
      prev: '#prev .arrow',

      /*
        left aligned, right aligned or centered
        values: left, right, center
       */
      alignment: 'left',

      /* must be positive */
      initialSlide: 0,

      /* left to right (true or false) */
      ltr: true,

      /* shift this many slides */
      slidesToScroll: 1,

      /*
        width of slides compared to carousel
        show 2 slides at once, set to .5
        show 4 slides at once, set to .25
       */
      slideWidth: '1',

      /* fake the infinite slides */
      infinite: false,
      slideSelector: '>*',
      adaptiveHeight: true,
      draggable: true,
      effect: 'fade',
      cssEase: 'ease-out',
      edgeFriction: 0,
      speed: 1000,
      touchThreshold: 5,
      lazyLoad: false,
      lazyLoadRate: 0,
      lazyLoadAttribute: 'data-lazy',
      arrows: true,
      hideUnclickableArrows: false
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

  Carousel.prototype.moveDirection = function(direction) {
    if (this.moving) {
      return false;
    }
    this.moving = true;
    this.scroller[direction]();
    return this.moving = false;
  };

  Carousel.prototype.resize = function() {
    this.applyOptions();
    return this.scroller.gotoCurrent();
  };

  Carousel.prototype.handlers = function() {
    this.arrowHandlers();
    return this.resizeHandler();
  };

  Carousel.prototype.resizeHandler = function() {
    return $(window).resize((function(_this) {
      return function() {
        if (_this.carouselWrapper.didResize()) {
          return _this.resize();
        }
      };
    })(this));
  };

  Carousel.prototype.arrowHandlers = function() {
    this.prevBtn.on('click', (function(_this) {
      return function(e) {
        return _this.moveDirection('prev');
      };
    })(this));
    return this.nextBtn.on('click', (function(_this) {
      return function(e) {
        return _this.moveDirection('next');
      };
    })(this));
  };

  return Carousel;

})();

$(function() {
  return window.Carousel = Carousel;
});
