function __BROADCAST_class_broadcast(_block = function() {  }, _scope) : __Struct__() constructor  {
	static __num_id = 0; __num_id++;
	static __recursive_stack_limit = 0xFFFF;
	__pool__ = undefined;
	
	__id = __num_id;
	__Type__.add( __BROADCAST_class_broadcast );
	__Type__.add( __BROADCAST_class_hook__ );
	
	static watch = function( _broadcast ) {
		if  not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.TYPECHECK) &&
			not struct_type(_broadcast, __BROADCAST_class_broadcast) {
			throw new InvalidArgumentType("watch", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		__watch( _broadcast );
		
		if not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.RECURSIVE_WATCH) {
			return self;
		}
		if (_broadcast == self) {
			throw new RecursiveBroadcastWatch(self, self);
		}
		__recursive_stack_limit = 0xFFFF;
		if (_broadcast.__contains(self)) {
			throw new RecursiveBroadcastWatch(self, _broadcast);
		}
		return self;
	}
	
	static dispatch = function(args) {
		__recursive_stack_limit = 0xFFFF;
		__dispatch(args);	
	}
	
	static destroy = function() {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
			__pool__.put( self );
			if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID) {
				__id = undefined;	
			}
		}
		__hooks.clear();
	}
	
	static toString = function() {
		
	}
	
	static __watch = function( _broadcast ) {
		_broadcast.__hooks.push( self );	
	}
	
	static __dispatch = function(args) {
		if (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.DISPATCH) {
			if (--__recursive_stack_limit <= 0) {
				throw new RecursiveDispatchError(self);	
			}
		}
		__block(args);
		var _i = 0; repeat( __hooks.size()) {
            if (struct_type(__hooks.index(_i), __BROADCAST_class_viewer)) {
				var viewer = __hooks.pop(_i);
				viewer.__dispatch(args);
				viewer.destroy();
			}
            else
                __hooks.index(_i++).__dispatch(args);
        }
	}
	
	static __contains = function( _broadcast ) {
		if (--__recursive_stack_limit <= 0) {
			return true;
		}
	
		var el;
		var _i = 0; repeat( __hooks.size()) {
			el = __hooks.index(_i++);
			if (struct_type(el, __BROADCAST_class_broadcast)) {
				if (el.__hooks.contains( _broadcast )) {
					return true;	
				}
				if (el.__contains( _broadcast )) {
					return true;	
				}
			}
		}
		return false;
	}
	
	static __init__ = function(_block, _scope) {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID && __id = undefined) {
			__num_id++;
			__id = __num_id;
		}
		__scope = _scope ?? method_get_self(_block);
		__block = method(__scope, _block);
		__hooks = new ArrayList();
	}
}