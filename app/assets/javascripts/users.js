$(window).scroll(function() {
    var winScrollTop = $(window).scrollTop();
    var winHeight = $(window).height();
    var floaterHeight = $('.event-floater-btn').outerHeight(true);
    var fromBottom = 20;
    var top = winScrollTop + winHeight - floaterHeight - fromBottom;
	$('.event-floater-btn').css({'top': top + 'px'});
});
