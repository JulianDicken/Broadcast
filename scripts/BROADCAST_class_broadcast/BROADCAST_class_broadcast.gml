function __BROADCAST_class_broadcast(_block = function() {  }, _scope) : __Struct__() constructor  {
	static __num_id = 0; __num_id++;
	static __recursive_stack_limit = 0xFFFF;
	__id = __num_id;
	
	__scope = _scope ?? method_get_self(_block);
	__block = method(__scope, _block);
	__hooks = new ArrayList();
	
	__Type__.add( __BROADCAST_class_broadcast );
	__Type__.add( __BROADCAST_class_hook__ );
	
	static watch = function( _broadcast ) {
		if  not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.TYPECHECK) &&
			not struct_type(_broadcast, __BROADCAST_class_broadcast) {
			throw new InvalidArgumentType("watch", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		__watch( _broadcast );
		
		if not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.RECURSIVE_WATCH) {
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
	
	static dispatch = function() {
		__recursive_stack_limit = 0xFFFF;
		__dispatch();	
	}
	
	static toString = function() {
		
	}
	
	static __watch = function( _broadcast ) {
		_broadcast.__hooks.push( self );	
	}
	
	static __dispatch = function() {
		if (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.DISPATCH) {
			if (--__recursive_stack_limit <= 0) {
				throw new RecursiveDispatchError(self);	
			}
		}
		__block();
		
		var _i = 0; repeat( __hooks.size()) {
            if (struct_type(__hooks.index(_i), __BROADCAST_class_viewer))
                __hooks.pop(_i).__dispatch();
            else
                __hooks.index(_i++).__dispatch();
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
				if (el.__hooks( _broadcast )) {
					return true;	
				}
			}
		}
		return false;
	}
	
}