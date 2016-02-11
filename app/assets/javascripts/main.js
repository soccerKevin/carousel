// Generated by CoffeeScript 1.9.3
$(function() {
  var options, options2;
  options = {
    next: '#next .arrow',
    prev: '#prev .arrow',
    alignment: 'center',
    initialSlide: 2,
    ltr: true,
    slidesToScroll: 1,
    slideWidth: '.4',
    speed: 800,
    cssEase: 'cubic-bezier(0.950, 0.050, 0.795, 0.035)',
    slideSelector: '.card'
  };
  window.carousel = new window.Carousel('#carousel', options);
  options2 = {
    slideWidth: '1'
  };
  return $('#change-options').on('click', function() {
    return window.carousel.updateOptions(options2);
  });
});
