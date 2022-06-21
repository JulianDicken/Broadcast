o = timeit(1000, function() {
    hello = Broadcast_old( function() {
 	    str = "hello"
    });

    world = Subscriber_old( function() {
     	str = "world"
    }).watch(hello);

    hello.dispatch();
    
    hello.destroy();
    world.destroy();
});

n = timeit(1000, function() {
    hello = Broadcast( function() {
 	    str = "hello"
    });

    world = Subscriber( function() {
     	str = "world"
    }).watch(hello);

    hello.dispatch();
    
    hello.destroy();
    world.destroy();
});
show_message(string_format((n.average / o.average) * 100, 16, 16));
