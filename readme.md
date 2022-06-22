# Broadcast
 An Event Handling library written in gml.

 ---
### Broadcasts
```js
hello = Broadcast( function() {
 	syslog("Hello, ");
});

hello.dispatch();
```
prints:
```
"Hello, "
```

 This creates a **Broadcast** and then **dispatches** it.
 **Broadcasts** are event sources and **dispatching** them cascades event invocation down to
 **Broadcast Hooks**. **Broadcasts** *can* be **Broadcast Hooks** too.

 ---
### Subscribers
```js
hello = Broadcast( function() {
 	syslog("Hello, ");
});

world = Subscriber( function() {
 	syslog("World!");
}).watch(hello);

hello.dispatch();
 ```
 prints:
 ```
"Hello, "
"World!"
 ```
This creates a **Subscriber**. A **Subscriber** is a type of **Broadcast Hook**.
A **Subscriber** can only watch **Broadcasts** and cannot cascade **dispatches** downwards.

---
### Consumers
```js
update = Broadcast( function() {
 	syslog("Update");
});
Consumer( function() {
 	syslog("First Frame!");
}).watch(update);

update.dispatch();
update.dispatch();
```
prints:
```
"Update"
"First Frame!"
"Update"
```
 This creates a **Consumer**. A **Consumer** is a type of **Broadcast Hook**.
 A **Consumer** can only watch **Broadcasts** and cannot cascade **dispatches** downwards.
 A **Consumer** is *volatile* and will only be **dispatched** once.

 ---

 Combined **Subscribers** and **Consumers** can be used as following:
 ```js
 update = Broadcast( function() {
  	syslog("Update");
 });
 Consumer( function() {
  	syslog("First Frame!");
 }).watch(update);
 other_frames = Subscriber( function() {
  	syslog("Other Frame!");
 }).watch(update);

update.dispatch();
update.dispatch();
```
prints:
```
"Update"
"First Frame!"
"Other Frame!"
"Update"
"Other Frame!"
```
The order for Hook dispatch is **FIFO**.

---
### Watchlists
**Watchlists** serve as **Broadcast queues** and are a type of **Broadcast**.
```js
watchlist = Watchlist( function() {
  syslog("Watchlist Finished!")
});
broadcastA = Broadcast( function() {
  syslog("Dispatched broadcastA.")
});
broadcastB = Broadcast( function() {
  syslog("Dispatched broadcastB.")
});
watchlist.add( broadcastA );
watchlist.add( broadcastB );

```
Once all registered **Broadcasts** have been dispatched the watchlist will dispatch.

---
### Radios
**Radios** are a type of **Broadcast** and serve as repeating broadcast sources.
```js
radio = Radio( function() {
  syslog("Radio cycle!")
}, false, 1);
IHappenEverySecond = Broadcast( function() {
  syslog("Cycle call")
});
```
A radio will call infinitely with the set frequency.
Radios are not a type of Hook.

**Warning**: If you are using a pre 2022.5 runtime you will need to call radio.update() in a step event somewhere.

---
### Safety
As previously mentioned **Broadcasts** can be **Hooks** too :
```js
hello = Broadcast( function() {
 	syslog("Hello, ");
});

world = Broadcast( function() {
 	syslog("World!");
}).watch(hello);

hello.dispatch();
 ```
This introduces potential problems due to recursion but BROADCAST tries to warn the user of Recursive Subscriptions.
Unfortunately these safety checks are quite expensive.
To circumvent them locally you can call the private version of either `watch` or `dispatch` :
```js
recursive_fiend = Broadcast(function() {
  syslog("I called myself!");
}, id);
recursive_fiend.__watch(recursive_fiend);
recursive_fiend.__dispatch();
 ```
prints:
```
"I called myself!"
"I called myself!"
"I called myself!"
"I called myself!"
"I called myself!"
...
"I called myself!"
```
This will eventually crash due to a Recursion Depth error. Max recursion depth is set via the `BROADCAST_RECURSION_MAX_DEPTH` macro (default: 0xFFFF)
