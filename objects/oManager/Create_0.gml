buttonWatchlist = Watchlist();
a = Subscriber( function() {
	show_message("All buttons have been pressed!");	
}).watch( buttonWatchlist );