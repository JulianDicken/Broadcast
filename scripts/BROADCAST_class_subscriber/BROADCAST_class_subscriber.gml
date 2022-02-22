function __BROADCAST_class_subscriber(_block = function() {  }, _scope) : __Struct__() constructor {
	static __num_id = 0; __num_id++;
	__id = __num_id;
	
	__Type__.add( __BROADCAST_class_subscriber );
	__Type__.add( __BROADCAST_class_hook__ );

	static watch = function( _broadcast ) {
		if  not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.TYPECHECK) &&
			not struct_type(_broadcast, __BROADCAST_class_broadcast) {
			throw new InvalidArgumentType("watch", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		
		_broadcast.__hooks.push( self );
		return self;
	}
	
	static toString = function() {
		
	}
	
	static destroy = function() {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
			__pool__.put( self );
			if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID) {
				__id = undefined;	
			}
		}
	}
	
	static __dispatch = function() {
		__block();	
	}
	
	static __init__ = function(_block, _scope) {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID && __id = undefined) {
			__num_id++;
			__id = __num_id;
		}
		__scope = _scope ?? method_get_self(_block);
		__block = method(__scope, _block);
	}
}