$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center'
    initialSlide: 0
    ltr: true
    slideWidth: 100
    slideHeight: false
    # infinite: false
    # slideSelector: '>*'
    # respondTo: window
    # adaptiveHeight: true
    # draggable: true
    # effect: 'fade'
    # cssEase: 'ease-out'
    # edgeFriction: 0
    # speed: 1000
    # touchThreshold: 5
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'
    # arrows: true
    # hideUnclickableArrows: false

  window.carousel = new window.Carousel '#carousel', options


