$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center'
    initialSlide: 0
    ltr: true
    slideWidth: '.8'
    speed: 800 #mili-seconds
    # cssEase: 'ease-out'
    # infinite: false
    # slideSelector: '>*'
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


