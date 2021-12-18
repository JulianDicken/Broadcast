function __BROADCAST_class_viewer(_block = function() {  }, _scope) : __Struct__() constructor {
	static __num_id = 0; __num_id++;
	__id = __num_id;
	
	__scope = _scope ?? self;
	__block = method(__scope, _block);
	
	__Type__.add( __BROADCAST_class_viewer );
	__Type__.add( __BROADCAST_class_hook__ );
	
	static watch = function( _broadcast ) {
		if (!struct_type(_broadcast, __BROADCAST_class_broadcast)) {
			throw new InvalidArgumentType("watch", 0, _broadcast, "__BROADCAST_class_broadcast"); 
		}
		
		_broadcast.__subscribers.push( self );
		return self;
	}
	
	static __dispatch = function() {		
		__block();	
	}
	
	static toString = function() {
		
	}
}