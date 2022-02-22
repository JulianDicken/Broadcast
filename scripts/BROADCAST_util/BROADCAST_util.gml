#macro BROADCAST_SAFETY_FLAGS \
	BROADCAST_SAFETY.RECURSIVE_WATCH |\
	BROADCAST_SAFETY.DISPATCH |\
	BROADCAST_SAFETY.TYPECHECK
	
#macro BROADCAST_BEHAVIOUR_FLAGS \
	BROADCAST_BEHAVIOUR.USE_OBJECT_POOL |\
	BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID

enum BROADCAST_SAFETY {
	RECURSIVE_WATCH = 0x01,
	DISPATCH = 0x02,
	TYPECHECK = 0x04
}
enum BROADCAST_BEHAVIOUR {
	USE_OBJECT_POOL = 0x01,
	REASSIGN_INSTANCE_ID = 0x02,
}

//namespace shenanigans
function Broadcast(_block = function() { }, _scope = undefined) {
	var __inst;
	if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
		static __pool__ = new ObjectPool( function() {
			return new __BROADCAST_class_broadcast();
		});
		__inst = __pool__.get();
		__inst.__pool__ = __pool__;
	} else {
		__inst =  new __BROADCAST_class_broadcast();
	}
	__inst.__init__(_block, _scope);
	return __inst;
}
function Subscriber(_block = function() { }, _scope = undefined) {
	var __inst;
	if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
		static __pool__ = new ObjectPool( function() {
			return new __BROADCAST_class_subscriber();
		});
		__inst = __pool__.get();
		__inst.__pool__ = __pool__;
	} else {
		__inst =  new __BROADCAST_class_subscriber();
	}
	__inst.__init__(_block, _scope);
	return __inst;
}
function Viewer(_block = function() { }, _scope = undefined) {
	var __inst;
	if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
		static __pool__ = new ObjectPool( function() {
			return new __BROADCAST_class_viewer();
		});
		__inst = __pool__.get();
		__inst.__pool__ = __pool__;
	} else {
		__inst =  new __BROADCAST_class_viewer();
	}
	__inst.__init__(_block, _scope);
	return __inst;
}
function Watchlist() {
	var __inst;
	if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
		static __pool__ = new ObjectPool( function() {
			return new __BROADCAST_class_watchlist();
		});
		__inst = __pool__.get();
		__inst.__pool__ = __pool__;
	} else {
		__inst = new __BROADCAST_class_watchlist();
	}
	__inst.__init__();
	return __inst;
}

/// @func RecursiveBroadcastWatch
/// @desc	Thrown when a subscription would lead tos an infinite loop
/// @wiki Core-Index Errors
function RecursiveBroadcastWatch( _watcher, _broadcast ) : __Error__() constructor {
	var _watcherName = "unknown"
	if (_watcher.__scope != _watcher) {
		_watcherName = "anonymous";	
		var ary = variable_struct_get_names(_watcher.__scope);
		for (var i = 0, n = array_length(ary); i < n; i++) {
			var el = _watcher.__scope[$ ary[i]];
			if (is_struct(el) == true && struct_type(el, __BROADCAST_class_broadcast) &&
				el == _watcher) {
				_watcherName = ary[i];
			}
		}
	} 
	var _broadcastName = "unknown"
	if (_broadcast.__scope != _broadcast) {
		_broadcastName = "anonymous";	
		var ary = variable_struct_get_names(_broadcast.__scope);
		for (var i = 0, n = array_length(ary); i < n; i++) {
			var el = _broadcast.__scope[$ ary[i]];
			if (is_struct(el) == true && struct_type(el, __BROADCAST_class_broadcast) &&
				el == _broadcast) {
				_broadcastName = ary[i];
			}
		}
	} 
	var _watcherScope;
	if (is_struct(_watcher.__scope)) {
		_watcherScope = instanceof(_watcher.__scope);	
	} else {
		_watcherScope = object_get_name(_watcher.__scope.object_index)
	}
	var _broadcastScope;
	if (is_struct(_broadcast.__scope)) {
		_broadcastScope = instanceof(_broadcast.__scope);	
	} else {
		_broadcastScope = object_get_name(_broadcast.__scope.object_index)	
	}
	
	message	= f( "Broadcast {}::{} in {} caused a recursion error with Broadcast {}::{} in {}.",
		_watcherName, _watcher.__id, _watcherScope,
		_broadcastName, _broadcast.__id, _broadcastScope
	);
}

/// @func RecursiveBroadcastWatch
/// @desc	Thrown when a dispatch lead to an infinite loop
/// @wiki Core-Index Errors
function RecursiveDispatchError( _broadcast ) : __Error__() constructor {
	var _broadcastName = "unknown"
	if (_broadcast.__scope != _broadcast) {
		_broadcastName = "anonymous";	
		var ary = variable_struct_get_names(_broadcast.__scope);
		for (var i = 0, n = array_length(ary); i < n; i++) {
			var el = _broadcast.__scope[$ ary[i]];
			if (is_struct(el) == true && struct_type(el, __BROADCAST_class_broadcast) &&
				el == _broadcast) {
				_broadcastName = ary[i];
			}
		}
	} 
	
	var _broadcastScope;
	if (is_struct(_broadcast.__scope)) {
		_broadcastScope = instanceof(_broadcast.__scope);	
	} else {
		_broadcastScope = object_get_name(_broadcast.__scope.object_index)	
	}
	
	message	= f( "Broadcast {}::{} in {} caused a recursion error during dispatch.",
		_broadcastName, _broadcast.__id, _broadcastScope
	);
}

//type flag
function __BROADCAST_class_hook__() : __Struct__() constructor {
	__Type__.add( __BROADCAST_class_hook__ );
}
