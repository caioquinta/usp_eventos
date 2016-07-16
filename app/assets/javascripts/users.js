$(function() {
	// Ajax function to upload event list after a filter checkbox is selected
	$('#filters input').on('click', function(e) {
		var arr = $( "#filters input:checked");
		var tags = [];
		console.log('tags');
		$.each( arr, function(_,element) { tags.push(element.value); });
		tags_data = {"tag": tags};
		$.ajax({
		url: '/home.js',
		type: 'PUT',
		data: tags_data
		});
	});
	// Function to set auto-scrolling for new event button
	$(window).scroll(function() {
		var winScrollTop = $(window).scrollTop();
		var winHeight = $(window).height();
		var floaterHeight = $('.event-floater-btn').outerHeight(true);
		var fromBottom = 5*($(window).height())/100;
		var top = winScrollTop + winHeight - floaterHeight - fromBottom;
		$('.event-floater-btn').css({'top': top + 'px'});
	});

	// Initialize Slidebars (filters menu)
	var controller = new slidebars();
	controller.init();

	$( '.toogle-sliderbar-1' ).on( 'click', function ( event ) {
		// Stop default action and bubbling
		event.stopPropagation();
		event.preventDefault();

		// Toggle the Slidebar with id 'sliderbar-1'
		controller.toggle( 'sliderbar-1' );
	});
});

