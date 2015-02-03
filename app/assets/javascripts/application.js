// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

(function() {
	var container = document.getElementById( 'container'),
		trigger = container.querySelector( 'button.trigger' );

	function toggleContent() {
		if( classie.has( container, 'container--open')) {
			classie.remove( container, 'container--open' );
			classie.remove( trigger, 'trigger--active');
			window.addEventListener('scroll', noscroll);
		} else {
			classie.add( container, 'container--open');
			classie.add(trigger, 'trigger--active');
			window.removeEventListener('scroll', noscroll);
		}
	}

	function noscroll() {
		window.scrollTo( 0, 0 );
  }

  // reset scrolling position
  document.body.scrollTop = document.documentElement.scrollTop = 0;

  // disable scrolling
  window.addEventListener( 'scroll', noscroll );

  trigger.addEventListener( 'click', toggleContent );

})();

