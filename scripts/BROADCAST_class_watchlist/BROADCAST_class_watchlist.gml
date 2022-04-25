function __BROADCAST_class_watchlist() : __Struct__() constructor  {
	static __num_id = 0; __num_id++;
	__pool__ = undefined;
	static __recursive_stack_limit = 0xFFFF;
	__id = __num_id;
	
	static add = function( _broadcast ) {
		if  not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.TYPECHECK) &&
			not struct_type(_broadcast, __BROADCAST_class_broadcast) {
			throw new InvalidArgumentType("add", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		__registry.push( weak_ref_create(
				Viewer().watch( _broadcast )
			)
		);
	}
	
	static update = function() {
		var el;
		var i = __registry.size(); repeat ( __registry.size() ) { i--;
			el = __registry.index(i);
			if (!weak_ref_alive( el ) || el.ref.__expired) {
				__registry.pop(i);	
				if  (__registry.size() == 0) {
					dispatch();	
				}
			} 
		}
	}
	
	static destroy = function() {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.USE_OBJECT_POOL) {
			__pool__.put( self );
			if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID) {
				__id = undefined;	
			}
		}
	}
	
	static dispatch = function(args) {
		__recursive_stack_limit = 0xFFFF;
		__dispatch(args);	
	}
	
	static __dispatch = function() {
		if (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY.DISPATCH) {
			if (--__recursive_stack_limit <= 0) {
				throw new RecursiveDispatchError(self);	
			}
		}
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
	
	static __init__ = function() {
		if (BROADCAST_BEHAVIOUR_FLAGS & BROADCAST_BEHAVIOUR.REASSIGN_INSTANCE_ID && __id = undefined) {
			__num_id++;
			__id = __num_id;
		}
		__registry = new ArrayList();
		__hooks	= new ArrayList();
	}
}