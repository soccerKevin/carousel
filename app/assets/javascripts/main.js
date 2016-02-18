// Generated by CoffeeScript 1.9.3
$(function() {
  var options, options2;
  options = {
    next: '#next .arrow',
    prev: '#prev .arrow',
    alignment: 'center',
    initialSlide: 0,
    ltr: true,
    slidesToScroll: 1,
    slideWidth: 0.4,
    speed: 800,
    cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)',
    slideSelector: '.card',
    infinite: false
  };
  window.carousel = new window.Carousel('#carousel', options);
  options2 = {
    slideWidth: 1,
    infinite: true
  };
  return $('#change-options').on('click', function() {
    return window.carousel.updateOptions(options2);
  });
});
