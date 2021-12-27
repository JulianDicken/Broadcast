function __BROADCAST_class_watchlist() : __Struct__() constructor  {
	__registry = new ArrayList();
	
	onFinished	= Broadcast();
	
	static add = function( _broadcast ) {
		if  not (BROADCAST_SAFETY_FLAGS & BROADCAST_SAFETY_LEVEL.TYPECHECK) &&
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
}