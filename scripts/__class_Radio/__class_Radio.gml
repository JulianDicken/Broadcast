function Radio(callback = undefined, frequency = 1, unit = 1, scope = undefined) {
    static __pool = function() {
        global.__radio_pool = ds_stack_create();
        return global.__radio_pool;
    }();
    if (ds_stack_size(__pool) == 0) {
        ds_stack_push(__pool, new __class_Radio());
    }
    while (ds_stack_size(__pool) > 1 && ds_stack_size(__pool) > BROADCAST_RADIO_MAX_POOL_SIZE) {
        ds_stack_pop(__pool);
    }
    return ds_stack_pop(__pool).__init(
        callback, scope, frequency, unit
    );
}

function __class_Radio() constructor {
    static __base_type = __broadcastType.Broadcast;
    static __recursion_depth = 0;
    static __num_id = 0;
    __id    = undefined;
    __type = undefined;
    
    __hooks = undefined;
    
    __callback = function() /*=>*/ {return undefined};
    __scope = undefined;
    
    __frequency = undefined;
    __unit      = undefined;
    __timesource = undefined;
    
    __counter = undefined;
    __steps   = undefined;

    static __init = function(callback, scope, frequency = 1, unit = 1) {
        __id = ++__num_id;
        __type = __base_type;
        
	    __hooks ??= ds_list_create();
	    
	    __callback  = callback  ?? function() /*=>*/ {return undefined};
	    __scope     = scope     ?? method_get_self(__callback);
	    
	    __frequency = frequency;
	    __unit      = unit;
	    //Attempt to set up a time source for slick automatic input handling
	    if (__timesource == undefined) {
            try {
                //GMS2022.500.58 runtime
                __timesource = time_source_create(time_source_game, __frequency, __unit, function() {
                    dispatch();
                }, [], -1);
                time_source_start(__timesource);
            } catch(_error) {
                try {
                    //Early GMS2022.500.xx runtimes
                    __timesource = time_source_create(time_source_game, __frequency, __unit, function() {
                        dispatch();
                    }, -1);
                    time_source_start(__timesource);
                } catch(_error) {
                    BROADCAST_WARNING_v20225
                    __timesource = undefined;
                }
            }
    	    return self;
        }
    }
    
    static update = function() {
        switch __unit {
            case 0:
                __counter	+= min(BROADCAST_RADIO_FLOOR_FRAMES, delta_time*0.000001);
                __steps 	= floor(__frequency * __counter);
                __counter	-= __steps / __frequency;
                
                repeat( __steps ) {
                    dispatch();
                }
            break;
            case 1:
                __counter++;
                __counter %= __frequency;
                if (__counter == 0) {
                    dispatch();
                }
            break;
        }
    }
    
    static dispatch = function() {
        __recursion_depth = 0;
        
        switch (argument_count) {
			case  0: __dispatch();
				break;
			case  1: __dispatch(argument[0]);
				break;
			case  2: __dispatch(argument[0], argument[1]);
				break;
			case  3: __dispatch(argument[0], argument[1], argument[2]);
				break;
			case  4: __dispatch(argument[0], argument[1], argument[2], argument[3]);
				break;
			case  5: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4]);
				break;
			case  6: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5]);
				break;
			case  7: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]);
				break;
			case  8: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
				break;
			case  9: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);
				break;
			case 10: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);
				break;
			case 11: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);
				break;
			case 12: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]);
				break;
			case 13: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]);
				break;
			case 14: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]);
				break;
			case 15: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]);
				break;
			case 16: __dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]);
				break;
			//default: __broadcast_warning("Can't use more than 16 arguments."); break;
		}
    }
    
    static __dispatch = function() {
        if (++__recursion_depth > BROADCAST_RECURSION_MAX_DEPTH) {
        	BROADCAST_ERROR_RECURSIVE_DISPATCH
            return;
        }
        
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
		
		var i = -1; 
		var n = ds_list_size(__hooks); 
		repeat(n) {  i++;
		    switch (argument_count) {
    			case  0: __hooks[| i].__dispatch();
					break;
    			case  1: __hooks[| i].__dispatch(argument[0]);
					break;
    			case  2: __hooks[| i].__dispatch(argument[0], argument[1]);
					break;
    			case  3: __hooks[| i].__dispatch(argument[0], argument[1], argument[2]);
					break;
    			case  4: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3]);
					break;
    			case  5: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4]);
					break;
    			case  6: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5]);
					break;
    			case  7: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]);
					break;
    			case  8: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
					break;
    			case  9: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);
					break;
    			case 10: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);
					break;
    			case 11: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);
					break;
    			case 12: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]);
					break;
    			case 13: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]);
					break;
    			case 14: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]);
					break;
    			case 15: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]);
					break;
    			case 16: __hooks[| i].__dispatch(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]);
					break;
			    //default: __broadcast_warning("Can't use more than 16 arguments."); break;
		    }
		    
		    if ((__hooks[| i][$ "__type"] ?? 0x00) & (__broadcastType.Volatile | __broadcastType.Zombie)) {
		        ds_list_delete(__hooks, i--);
		    }
		}
    }
}