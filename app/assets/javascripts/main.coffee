$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center'
    initialSlide: 0
    ltr: true
    slidesToScroll: 1
    slideWidth: 0.4
    speed: 800 #mili-seconds
    cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    slideSelector: '.card'
    infinite: false
    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'
    # arrows: true
    # hideUnclickableArrows: false
    # titleSlide: false

    # quicker move through slides (hold down button/similar)
    # title slide?
    # click and drag (snap into place)

  window.carousel = new window.Carousel '#carousel', options


  options2 =
    slideWidth: 1
    # next: '#prev .arrow'
    # prev: '#next .arrow'
    # alignment: 'left'
    # initialSlide: 3 # should not be able to change
    # slideSelector: '.card' # should not be able to change
    # ltr: true
    # slidesToScroll: 3
    # speed: 800 #mili-seconds
    # cssEase: 'ease'
    infinite: true
    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'
    # arrows: true
    # hideUnclickableArrows: false
    # titleSlide: false

  $('#change-options').on 'click', ->
    window.carousel.updateOptions options2


