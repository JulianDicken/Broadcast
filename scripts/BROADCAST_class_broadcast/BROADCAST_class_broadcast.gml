function __BROADCAST_class_broadcast(_block = function() {  }, _scope) : __Struct__() constructor  {
	static __num_id = 0; __num_id++;
	static __recursive_stack_limit = 0xFFFF;
	__id = __num_id;
	
	__scope = _scope ?? method_get_self(_block);
	syslog(__scope);
	__block = method(__scope, _block);
	__subscribers = new ArrayList();
	
	__Type__.add( __BROADCAST_class_broadcast );
	__Type__.add( __BROADCAST_class_hook__ );
	
	static watch = function( _broadcast ) {
		__watch( _broadcast );
		
		if not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.WATCH) {
			return self;
		}
		if (!struct_type(_broadcast, __BROADCAST_class_broadcast)) {
			throw new InvalidArgumentType("watch", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		if (_broadcast == self) {
			throw new RecursiveBroadcastSubscription(self, self);
		}
		__recursive_stack_limit = 0xFFFF;
		if (_broadcast.__contains(self)) {
			throw new RecursiveBroadcastSubscription(self, _broadcast);
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
		_broadcast.__subscribers.push( self );	
	}
	
	static __dispatch = function() {
		if (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.DISPATCH) {
			if (--__recursive_stack_limit <= 0) {
				throw new RecursiveDispatchError(self);	
			}
		}
		__block();
		
		var _i = 0; repeat( __subscribers.size()) {
            if (struct_type(__subscribers.index(_i), __BROADCAST_class_viewer))
                __subscribers.pop(_i).__dispatch();
            else
                __subscribers.index(_i++).__dispatch();
        }
	}
	
	static __contains = function( _broadcast ) {
		if (--__recursive_stack_limit <= 0) {
			return true;
		}
	
		var el;
		var _i = 0; repeat( __subscribers.size()) {
			el = __subscribers.index(_i++);
			if (struct_type(el, __BROADCAST_class_broadcast)) {
				if (el.__subscribers.contains( _broadcast )) {
					return true;	
				}
				if (el.__contains( _broadcast )) {
					return true;	
				}
			}
		}
		return false;
	}
	
}