$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center'
    initialSlide: 0
    ltr: true
    slideWidth: '.8'
    speed: 800 #mili-seconds
    cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    slideSelector: '.card'
    # infinite: false
    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'
    # arrows: true
    # hideUnclickableArrows: false

  window.carousel = new window.Carousel '#carousel', options


