onPressed = Broadcast();
Subscriber( function() {
	image_blend = c_red;	
}).watch( onPressed );
Subscriber( function() {
	show_message("A button has been pressed");	
}).watch( onPressed );
oManager.buttonWatchlist.add( onPressed );