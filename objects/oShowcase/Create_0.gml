#region how-to
//this creates a broadcaster
//it is good practice to provide the scope of the instance you are creating the broadcaster in
//this way error messages can be more accurate
hello = Broadcast( function() {
	syslog("Hello, ");	
}, id);

world = Subscriber( function() {
	syslog("World!");
}, id).watch(hello);
//a subscribers callback is called every time a watched broadcast is being dispatched
//this happens in order of addition

hello.dispatch();
//prints out 
//Hello, 
//World!

name = "User";
nameViewer = Viewer( function() {
	syslog(name + "!");
}, id).watch(hello);
//a viewers callback is only invoked the first time a broadcast is being dispatched
//there is no priority difference between a subscriber and a viewer

hello.dispatch();
//prints out
//Hello,
//World!
//User!

hello.dispatch();
//prints out 
//Hello, 
//World!

//a viewer may need to be disposed manually or defined using the var keyboard, e.g
nameViewer = undefined;
//or
var example = Viewer( function() {
	syslog("Example!");
}, id).watch(hello);
hello.dispatch();
//prints out
//Hello,
//World!
//Example!

//example will now be gced. 
#endregion
#region recursive operations
//broadcasts can subscribe to other broadcasts : 
A = Broadcast(function() {
	syslog("A");	
}, id);
B = Broadcast(function() {
	syslog("B");	
}, id).watch(A);
A.dispatch();
//prints 
//A
//B

//BROADCAST tries to prevent recursive operations as best as possible
C = Broadcast(function() {
	syslog("C");	
}, id);
C.watch(C);
//crashes with RecursiveSubscriptionError
D = Broadcast(function() {
	syslog("D");	
}, id).watch(A);
A.watch(D);
//crashes with RecursiveSubscriptionError

//for performance gains you can toggle off the safety locally.
E = Broadcast(function() {
	syslog("E");	
}, id);
E.watch(E, true);
//for a global unsafe toggle check BROADCAST_util.

#endregion