// Generated by CoffeeScript 1.9.3

/*
  Responsive Carousel that just works

  You should contain your carousel in a containing div.
  try not to mess with the element that you tell carousel to use
 */

/*
   * defaults =
   * @param next [string]
  #default: none
  #next button selector (required)

   * @param prev [string]
  #default: none
  #prev button selector (required)

   * @option alignment [string]
  #default: 'left'
  #values: left, right, center

   * @option initialSlide [int]
  #default: 0
  #must be positive

   * @option ltr [boolean]
  #default: true
  #left to right (true or false)

   * @option slidesToScroll [int]
  #default: 1
  #shift this many slides

   * @option [float] slideWidth
  #default: 1
  #width of slides compared to carousel as a decimal
  #example:
  #show 2 slides at once, set to .5
  #show 4 slides at once, set to .25

   * @option [boolean] infinite
  #default: false
  #fake the infinite slides

   * @option [string] slideSelector
  #default: '>*'
  #Carousel uses to get elements to use as slides
  #incase direct children are not what you want to be referenced as slides

   * @option [boolean] draggable
  #default: true
  #allow the user to move the carousel using their mouse

   * @option [string] effect
  #default: 'scroll'
  #possible: scroll, fade
  #the effect to use when changing slides

   * @option [string] cssEase
  #default: 'ease-out'
  #method of transition

   * @option [int] speed
  #default: 1000
  #speed of transition in ms

  #edgeFriction: 0
  #touchThreshold: 5

   * @option [boolean] lazyLoad
  #default: false
  #load images as you need them vs all at once

   * @option [int] lazyLoadRate
  #default: 0
  #load this many images past the current image

   * @option [string] lazyLoadAttribute
  #default: 'data-lazy'
  #attribute on img tag to get the source of the image for lazy loading

   * @option [boolean] hideUnclickableArrows
  #default: false
  #hide left arrow if no more slides to the left
  #hide right arrow if no more slides to the right
  #only available in non-infinite mode

   * @option [boolean] titleSlide
  #default: false
  #marks the first slide as a title slide

   * Event Types
  #karouselLoad
  #karouselOptionsChanged
  #slideChanged
 */
var Carousel;

Carousel = (function() {

  /*
    @param [string] selector
    #main Carousel Container
  
    @param [hash] options
    #overrides for defaults
  
    @return [object] carousel instance
   */
  function Carousel(selector, options) {
    if (selector == null) {
      throw new Error('Missing Parameters Error');
    }
    this.carousel = $(selector);
    if (!this.carousel[0]) {
      throw new Error('Invalid Carousel Selector');
    }
    this.Util = window.Util;
    this.options = this.Util.combineHash(this.defaults(), options);
    this.assertDefaults();
    this.carousel.wrapInner("<div class='carousel-track'></div>");
    this.carousel.wrapInner("<div class='carousel-scroller'></div>");
    this.carousel.wrapInner("<div class='carousel-container'></div>");
    this.carouselContainer = this.carousel.find('.carousel-container');
    this.scroller = new window.Scroller(this.carousel.selector + " .carousel-scroller", this.carousel.selector + " .carousel-track", this.options);
    this.initialHandlers();
    this.applyOptions(this.options);
    this.saveSize();
  }

  Carousel.prototype.assertDefaults = function() {
    var img, index, option1, option2, option3, ref, results;
    if (this.options.slidesToScroll < 1) {
      this.options.slidesToScroll = 1;
    }
    if (this.options.lazyLoad != null) {
      option1 = this.options.lazyLoadRate;
      option2 = this.options.slidesToScroll;
      option3 = isNaN(this.options.slideWidth) ? 0 : this.options.slidesToScroll + Math.ceil(1.0 / this.options.slideWidth);
      this.options.lazyLoadRate = Math.max(option1, option2, option3);
    }
    ref = this.carousel.find('img').get();
    results = [];
    for (index in ref) {
      img = ref[index];
      if ($(img).attr('src') == null) {
        results.push($(img).attr('src', ''));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };


  /*
    Apply options used to set new and override existing options
    @private
   */

  Carousel.prototype.applyOptions = function() {
    this.setArrows();
    return this.keyEventsHandler();
  };


  /*
    @return JQuery object of the current slide
   */

  Carousel.prototype.currentSlide = function() {
    return this.scroller.currentSlide();
  };


  /*
    @return index of the current slide
   */

  Carousel.prototype.currentSlideIndex = function() {
    return this.scroller.currentSlideIndex();
  };


  /*
    @return [hash] defaults
    @private
   */

  Carousel.prototype.defaults = function() {
    var defaults;
    return defaults = {
      next: '#next .arrow',
      prev: '#prev .arrow',
      alignment: 'left',
      initialSlide: 0,
      ltr: true,
      slidesToScroll: 1,
      slideWidth: 'auto',
      infinite: false,
      slideSelector: '>*',
      speed: 1000,
      lazyLoad: false,
      lazyLoadRate: 0,
      lazyLoadAttribute: 'data-lazy',
      cssEase: 'ease-out',
      hideUnclickableArrows: false,
      keyEvents: false
    };
  };


  /*
    @param [array] slides
    #an array of slides to add
   */

  Carousel.prototype.addSlides = function(slides) {
    return this.scroller.addSlides(slides);
  };


  /*
    @param [int] startIndex
    #where to start removing slides from
    @param [int] count
    #how many slides to remove
   */

  Carousel.prototype.removeSlides = function(startIndex, count) {
    if (count == null) {
      count = 1;
    }
    return this.scroller.removeSlides(startIndex, count);
  };


  /*
    @return [array] slides
    #JQuery array of the slides of this carousel's scroller
   */

  Carousel.prototype.getSlides = function() {
    return this.scroller.getSlides();
  };


  /*
    @param [string] direction
    #'next'/'prev'
   */

  Carousel.prototype.moveDirection = function(direction) {
    var index;
    if (this.moving) {
      return false;
    }
    this.moving = true;
    index = this.scroller[direction]();
    this.moving = false;
    return index;
  };


  /*
    resize this carousel
    #make sure everything is how it should be
   */

  Carousel.prototype.resize = function() {
    this.applyOptions();
    this.scroller.resize();
    return this.scroller.gotoCurrent(false);
  };


  /*
    Update options after instance construction
    @param [hash] options
    #any set of options you wish to change
   */

  Carousel.prototype.updateOptions = function(options) {
    options = Carousel.deleteNonResetables(options);
    this.options = this.Util.combineHash(this.options, options);
    this.assertDefaults();
    this.applyOptions();
    return this.scroller.updateOptions(options);
  };


  /* @private */

  Carousel.deleteNonResetables = function(options) {
    delete options.slideSelector;
    delete options.initialSlide;
    return options;
  };


  /* @private */

  Carousel.prototype.setArrows = function() {
    this.arrowHandlersOff();
    this.setNext();
    return this.setPrev();
  };


  /* @private */

  Carousel.prototype.setNext = function() {
    this.nextBtn = $(this.options.next);
    return this.nextHandler();
  };


  /* @private */

  Carousel.prototype.setPrev = function() {
    this.prevBtn = $(this.options.prev);
    return this.prevHandler();
  };


  /* @private */

  Carousel.prototype.saveSize = function() {
    this.width = this.carousel.width();
    return this.height = this.carousel.height();
  };


  /* @private */

  Carousel.prototype.didResize = function() {
    if (this.width !== this.carousel.width() || this.height !== this.carousel.height()) {
      this.saveSize();
      return true;
    }
    return false;
  };

  Carousel.prototype.showBtn = function(btn) {
    return this[btn + "Btn"].show();
  };

  Carousel.prototype.hideBtn = function(btn) {
    return this[btn + "Btn"].hide();
  };


  /* @private */

  Carousel.prototype.initialHandlers = function() {
    return this.resizeHandler();
  };


  /* @private */

  Carousel.prototype.resizeHandler = function() {
    return $(window).resize((function(_this) {
      return function() {
        if (_this.didResize()) {
          return _this.resize();
        }
      };
    })(this));
  };


  /* @private */

  Carousel.prototype.nextHandler = function() {
    return this.nextBtn.on('click', (function(_this) {
      return function(e) {
        return _this.nextBtnClick();
      };
    })(this));
  };


  /* @private */

  Carousel.prototype.prevHandler = function() {
    return this.prevBtn.on('click', (function(_this) {
      return function(e) {
        return _this.prevBtnClick();
      };
    })(this));
  };

  Carousel.prototype.nextBtnClick = function() {
    var index;
    index = this.moveDirection('next');
    this.showBtn('prev');
    if (!this.options.infinite && this.options.hideUnclickableArrows) {
      if (this.options.ltr) {
        if (index >= this.scroller.slideCount() - 1) {
          return this.hideBtn('next');
        }
      } else {
        if (index <= 0) {
          return this.hideBtn('next');
        }
      }
    }
    return this.showBtn('next');
  };

  Carousel.prototype.prevBtnClick = function() {
    var index;
    index = this.moveDirection('prev');
    this.showBtn('next');
    if (!this.options.infinite && this.options.hideUnclickableArrows) {
      if (!this.options.ltr) {
        if (index >= this.sroller.slideCount() - 1) {
          return this.hideBtn('prev');
        }
      } else {
        if (index <= 0) {
          return this.hideBtn('prev');
        }
      }
    }
    return this.showBtn('prev');
  };

  Carousel.prototype.arrowHandlersOff = function() {
    if (this.nextBtn != null) {
      this.nextBtn.off();
    }
    if (this.prevBtn != null) {
      return this.prevBtn.off();
    }
  };

  Carousel.prototype.keyEvents = function(e) {
    if (!this.options.keyEvents) {
      return false;
    }
    if (e.keyCode === 37) {
      return this.prevBtnClick();
    } else if (e.keyCode === 39) {
      return this.nextBtnClick();
    }
  };

  Carousel.prototype.keyEventsHandler = function() {
    if (this.options.keyEvents) {
      $(document).on('keypress', (function(_this) {
        return function(e) {
          return _this.keyEvents(e);
        };
      })(this));
    }
    if (this.options.wheelEvents) {
      return document.addEventListener('onscroll', function(e) {
        return console.log(e.wheelDelta);
      });
    }
  };

  return Carousel;

})();

$(function() {
  return window.Carousel = Carousel;
});
