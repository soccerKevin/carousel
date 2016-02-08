$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center'
    initialSlide: 0
    ltr: true
    # slidesToScroll: 1
    # slidesToShow: 1
    # adaptiveHeight: true
    # autoplay: false
    # arrows: true
    # containWidth: false
    # containHeight: true
    # cssEase: 'ease-out'
    # draggable: true
    # edgeFriction: 0
    # effect: 'fade'
    # focusOnClick: false
    # infinite: false
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'
    # pagination: false
    # respondTo: window
    # slideSelector: '>*'
    # speed: 1000
    # touchThreshold: 5

  window.carousel = new window.Carousel '#carousel', options


