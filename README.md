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
 **Broadcast Hooks**. **Broadcasts** *can* be **Broadcast Hooks**.

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
### Viewers
```js
update = Broadcast( function() {
 	syslog("Update");
});
Viewer( function() {
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
 This creates a **Viewer**. A **Viewer** is a type of **Broadcast Hook**.
 A **Viewer** can only watch **Broadcasts** and cannot cascade **dispatches** downwards.
 A **Viewer** will only be **dispatched** once.

 ---

 A **Viewer** may need to be disposed manually or defined using the `var` keyboard :
 ```js
foo = Broadcast( function() {
    //your code here
});
manual_dispose = Viewer( function() {
    //your code here
    manual_dispose = undefined;
 }).watch(foo);

 //automatic disposal
 Viewer( function() {
   //your code here
}).watch(foo);
 update.dispatch();
 ```
 In this context both **Viewers** will be garbage collected after they are called.
 I recommend either not assigning **Viewers** or using `var` when using **Viewers**.

 ---

 Combined **Subscribers** and **Viewers** can be used as following:
 ```js
 update = Broadcast( function() {
  	syslog("Update");
 });
 Viewer( function() {
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

---
### Safety
As previously mentioned **Broadcasts** can be **Broadcast Hooks** too :
```js
hello = Broadcast( function() {
 	syslog("Hello, ");
});

world = Broadcast( function() {
 	syslog("World!");
}).watch(hello);

hello.dispatch();
 ```
 prints:
 ```
"Hello, "
"World!"
 ```

---

This introduces potential problems due to recursion but BROADCAST tries to warn the User of Recursive Subscriptions.

```js
 recursive_fiend = Broadcast(function() {
 	syslog("I called myself!");
 }, id);
 recursive_fiend.watch(recursive_fiend);
 recursive_fiend.dispatch();
 ```
Crashes with RecursiveSubscriptionError or RecursiveDispatchError, depending on the set **Safety Flags**.
```js
recursive_fiend_one = Broadcast(function() {
 	syslog("I watch two!");
}, id);
recursive_fiend_two = Broadcast(function() {
 	syslog("I watch one!");
}, id);
recursive_fiend_one.watch(recursive_fiend_two);
recursive_fiend_two.watch(recursive_fiend_one);
recursive_fiend_one.dispatch();
```
Crashes with RecursiveSubscriptionError or RecursiveDispatchError, depending on the set **Safety Flags**.

---

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

---

To circumvent them globally you can modify the **Safety Flags** in BROADCAST_util :
```js
#macro BROADCAST_SAFETY_FLAGS BROADCAST_SAFETY_LEVEL.WATCH | BROADCAST_SAFETY_LEVEL.DISPATCH

enum BROADCAST_SAFETY_LEVEL {
	WATCH = 0x01,
	DISPATCH = 0x02
}
```
This is the default configuration.
To disable a flag simply remove it from the macro :
```js
#macro BROADCAST_SAFETY_FLAGS BROADCAST_SAFETY_LEVEL.DISPATCH

enum BROADCAST_SAFETY_LEVEL {
	WATCH = 0x01,
	DISPATCH = 0x02
}
```

```js
recursive_fiend = Broadcast(function() {
 	syslog("I called myself!");
}, id);
recursive_fiend.watch(recursive_fiend);
recursive_fiend.dispatch();
```
Crashes with RecursiveDispatchError.
