$(document).ready(function() {
	var pingAfter = 30000;
	var refreshId = setInterval(function() {
		$(".current-time").reload();
	}, pingAfter);
});