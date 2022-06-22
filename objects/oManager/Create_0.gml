//n = timeit(1000, function() {
    hello = Broadcast( function() {
 	    str = "hello"
    });

    world = Subscriber( function() {
     	str = "world"
    }).watch(hello);

    hello.dispatch();
    
    hello.destroy();
    world.destroy();
//});
//show_message(string_format((n.average) / 1000000, 16, 16));
