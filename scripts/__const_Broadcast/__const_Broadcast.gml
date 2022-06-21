#macro BROADCAST_BROADCAST_MAX_POOL_SIZE 64
#macro BROADCAST_SUBSCRIBER_MAX_POOL_SIZE 64
#macro BROADCAST_VIEWER_MAX_POOL_SIZE 64

#macro BROADCAST_RECURSION_MAX_DEPTH 0xFFFF

#macro BROADCAST_ERROR_LOGGER show_message
#macro BROADCAST_WARN_LOGGER show_message
#macro BROADCAST_ERROR_RECURSIVE_DISPATCH __broadcast_error_generic("Recursive dispatch at ", __broadcast_try_find_instance_name(self));
#macro BROADCAST_WARNING_RECURSIVE_WATCH __broadcast_warn_generic("Recursive watch at ", __broadcast_try_find_instance_name(self), " with ", __broadcast_try_find_instance_name(broadcast));

function __broadcast_error_generic() {
    var _out = "[ERROR] Broadcast\n";
    var i = -1; repeat(argument_count) { i++;
    	_out += string(argument[i]);	
    }
    BROADCAST_ERROR_LOGGER(_out);
}
function __broadcast_warn_generic() {
    var _out = "[WARNING] Broadcast\n";
    var i = -1; repeat(argument_count) { i++;
    	_out += string(argument[i]);	
    }
    BROADCAST_WARN_LOGGER(_out);
}
function __broadcast_try_find_instance_name(inst) {
    var _name = "unknown or anonymous, broadcast identity:" + string(inst.__num_id);
	if (inst.__scope != inst) {
		var _ary = variable_struct_get_names(inst.__scope);
		var i = -1; 
		var n = array_length(_ary);
		repeat(n) { i++;
			var element = inst.__scope[$ _ary[i]];
			if (element == inst)
				_name = _ary[i];
		}
	} 

	var _scopeName;
	if (is_struct(inst.__scope)) {
		_scopeName = instanceof(inst.__scope);	
	} 
	else if (object_exists(inst)) {
		_scopeName = object_get_name(inst.__scope.object_index);
	} 
	else {
	    _scopeName = "unknown or anonymous";
	}
	return "<" + _name + "> in: <" + _scopeName + ">";
}


enum __broadcastType {
    Broadcast = 0x01,
    Subscriber = 0x02,
    Volatile = 0x04
}

