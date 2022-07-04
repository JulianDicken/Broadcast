
/// @function Consumer(callback, scope)
/// @param {Function} callback
/// @param {Instance.Id, Struct} scope
/// @return {Struct.__class_Consumer} consumer reference
function Consumer(callback = undefined, scope = undefined) {
    /*static __pool = function() {
        global.__consumer_pool = ds_stack_create();
        return global.__consumer_pool;
    }();
    if (ds_stack_size(__pool) == 0) {
        ds_stack_push(__pool, new __class_Consumer());
    }
    while (ds_stack_size(__pool) > 1 && ds_stack_size(__pool) > BROADCAST_CONSUMER_MAX_POOL_SIZE - 1) {
        ds_stack_pop(__pool);
    }*/
    return new __class_Consumer().__init(
        callback, scope
    );
}

function __class_Consumer() constructor {
    static __base_type = __broadcastType.Hook | __broadcastType.Volatile;
    static __num_id = 0;
    __id    = undefined;
    __type = undefined;

    __callback = function() /*=>*/ {return undefined};
    __scope = undefined;
    
    static __init = function(callback, scope) {
        __id = ++__num_id;
        __type = __base_type;

	    __callback  = callback  ?? function() /*=>*/ {return undefined};
	    __scope     = scope     ?? method_get_self(__callback);

	    return self;
    }
    
    static destroy = function() {
    	//ds_stack_push(global.__consumer_pool, self);
    	__type |= __broadcastType.Zombie;
    }
    
    static watch = function(broadcast) {
        if !(is_struct(broadcast) && (broadcast[$ "__type"] ?? 0x00) & __broadcastType.Broadcast) {
            // Feather ignore GM1013 once
        	BROADCAST_ERROR_NOT_A_BROADCAST
		    return;
		}
		return __watch(broadcast);
    }
    
    static __watch = function(broadcast) {
        ds_list_add(broadcast.__hooks, self);
        return self;
    }
    
    static __dispatch = function() {
    	// Feather disable GM1019
        switch (argument_count) {
			case  0: __callback();
				break;
			case  1: __callback(argument[0]);
				break;
			case  2: __callback(argument[0], argument[1]);
				break;
			case  3: __callback(argument[0], argument[1], argument[2]);
				break;
			case  4: __callback(argument[0], argument[1], argument[2], argument[3]);
				break;
			case  5: __callback(argument[0], argument[1], argument[2], argument[3], argument[4]);
				break;
			case  6: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5]);
				break;
			case  7: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]);
				break;
			case  8: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
				break;
			case  9: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);
				break;
			case 10: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);
				break;
			case 11: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);
				break;
			case 12: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]);
				break;
			case 13: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]);
				break;
			case 14: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]);
				break;
			case 15: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]);
				break;
			case 16: __callback(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]);
				break;
			//default: __broadcast_warning("Can't use more than 16 arguments."); break;
		}
        // Feather enable GM1019
    }
}