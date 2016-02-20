// Generated by CoffeeScript 1.9.3
$(function() {
  var options, options2;
  options = {
    next: '#next .arrow',
    prev: '#prev .arrow',
    alignment: 'center',
    initialSlide: 15,
    ltr: true,
    slidesToScroll: 1,
    slideWidth: .33333,
    speed: 800,
    cssEase: 'ease-out',
    slideSelector: '.card',
    infinite: true
  };
  window.carousel = new window.Carousel('#carousel', options);
  options2 = {
    slideWidth: 1,
    slidesToScroll: 3,
    infinite: true
  };
  return $('#change-options').on('click', function() {
    return window.carousel.removeSlides(4, 5);
  });
});
