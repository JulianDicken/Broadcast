#macro syslog show_debug_message

var recursive_fiend_one = Broadcast(function() {
 	syslog("I watch two!");
}, id);
recursive_fiend_two = Broadcast(function() {
 	syslog("I watch one!");
}, id);
recursive_fiend_one.watch(recursive_fiend_two);
recursive_fiend_two.watch(recursive_fiend_one);
recursive_fiend_one.dispatch();