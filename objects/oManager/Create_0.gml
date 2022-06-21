#macro syslog show_debug_message

watchlist = Watchlist(function() {

});
broadcastA = Broadcast( function() {
  syslog("Dispatched broadcastA.");
});
broadcastB = Broadcast( function() {
  syslog("Dispatched broadcastB.");
});
watchlist.watch( broadcastA );
watchlist.watch( broadcastB );

broadcastA.dispatch();
broadcastB.dispatch();