$ ->
  options =
    next: '#carousel1-container .next-btn .arrow'
    prev: '#carousel1-container .prev-btn .arrow'
    alignment: 'center' #left, center, right
    initialSlide: 13 #indexed from 0
    ltr: true #left to right / right to left
    slidesToScroll: 1 #per action to move
    slideWidth: .25
    speed: 800 #mili-seconds
    # cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    cssEase: 'ease-out'
    slideSelector: '.card'
    infinite: true
    lazyLoad: true
    lazyLoadRate: 4
    lazyLoadAttribute: 'data-lazy'
    hideUnclickableArrows: true
    keyEvents: true
    wheelEvents: true
    # arrows: true

    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # titleSlide: false

  window.carousel1 = new window.Carousel '#carousel1', options


  options1a = {}
    # next: '#carousel1-container .next-btn .arrow'
    # prev: '#carousel1-container .prev-btn .arrow'
    # alignment: 'center' #left, center, right
    # initialSlide: 13 #indexed from 0
    # ltr: true #left to right / right to left
    # slidesToScroll: 4 #per action to move
    # slideWidth: .25
    # speed: 800 #mili-seconds
    # # cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    # cssEase: 'ease-out'
    # slideSelector: '.card'
    # infinite: true
    # lazyLoad: true
    # lazyLoadRate: 4
    # lazyLoadAttribute: 'data-lazy'
    # hideUnclickableArrows: true
    # keyEvents: false
    # arrows: true

    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # titleSlide: false


  options2 =
    slideWidth: 1
    next: '#carousel2-container .next-btn .arrow'
    prev: '#carousel2-container .prev-btn .arrow'
    alignment: 'right' #left, center, right
    initialSlide: 2 #indexed from 0
    ltr: false #left to right / right to left
    slidesToScroll: 1 #per action to move
    slideWidth: 'auto'
    speed: 800 #mili-seconds
    # cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)'
    cssEase: 'ease-out'
    slideSelector: '.card'
    infinite: true
    lazyLoad: true
    lazyLoadRate: 4
    lazyLoadAttribute: 'data-lazy'
    hideUnclickableArrows: true
    keyEvents: true
    # arrows: true

    # draggable: true
    # effect: 'fade'
    # edgeFriction: 0
    # touchThreshold: 5
    # titleSlide: false

  window.carousel2 = new window.Carousel '#carousel2', options2

  $(document).on 'slideChanged', (e)=>
    console.log 'SLIDE CHANGED'

  $('#change-options').on 'click', ->
    # $slides = $('#extras').children()
    # window.carousel.addSlides $slides
    # window.carousel1.removeSlides 4, 5
    window.carousel1.updateOptions options1a


