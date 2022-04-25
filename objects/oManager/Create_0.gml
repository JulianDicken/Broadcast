broadcast = Broadcast();
sub = Subscriber( function() {
	show_message(msgA + msgB);	
}).watch( broadcast );

broadcast.dispatch({msgA :"Hello, ", msgB: "World!"} )
