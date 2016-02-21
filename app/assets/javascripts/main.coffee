$ ->
  options =
    next: '#next .arrow'
    prev: '#prev .arrow'
    alignment: 'center' #left, center, right
    initialSlide: 13 #indexed from 0
    ltr: true #left to right / right to left
    slidesToScroll: 3 #per action to move
    slideWidth: .33333
    speed: 800 #mili-seconds
    # cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    cssEase: 'ease-out'
    slideSelector: '.card'
    infinite: true
    lazyLoad: true
    lazyLoadRate: 4
    lazyLoadAttribute: 'data-lazy'
    hideUnclickableArrows: true
    # arrows: true

    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # titleSlide: false

  window.carousel = new window.Carousel '#carousel', options


  options2 =
    slideWidth: 1
    # next: '#prev .arrow'
    # prev: '#next .arrow'
    # alignment: 'left'
    # initialSlide: 3 # should not be able to change
    # slideSelector: '.card' # should not be able to change
    # ltr: true
    slidesToScroll: 3
    # speed: 800 #mili-seconds
    # cssEase: 'ease'
    infinite: true
    # lazyLoad: false
    # lazyLoadRate: 0
    # lazyLoadAttribute: 'data-lazy'

    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # arrows: true
    # hideUnclickableArrows: false
    # titleSlide: false

  $('#change-options').on 'click', ->
    # $slides = $('#extras').children()
    # window.carousel.addSlides $slides
    window.carousel.removeSlides 4, 5
    window.carousel.updateOptions options2


