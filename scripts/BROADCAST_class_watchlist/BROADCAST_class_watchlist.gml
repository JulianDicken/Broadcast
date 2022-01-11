function __BROADCAST_class_watchlist() : __Struct__() constructor  {
	static __num_id = 0; __num_id++;
	static __pool__ = undefined;
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
		var i = -1; repeat ( __registry.size() ) { i++;
			if not weak_ref_alive( __registry.index(i)) {
				__registry.pop(i);	
				if  (__registry.size() == 0) {
					onFinished.dispatch();	
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
	
	static __init__ = function() {
		__registry	= new ArrayList();
		onFinished	= Broadcast();
	}
	
	__init__();
}