
function __gravatar_struct_create(_email) constructor {
	email = md5_string_utf8(_email);
	ref = "";
	size = "";
	rating = "";
	force_ref = false;
	
	loaded = -1;
	image = -1;
	has_extracted = false;
	
	load = function(_x, _y) {
		if (force_ref) {
			loaded = sprite_add("https://www.gravatar.com/avatar/" + email + ref + rating + size + "&f=y", 0, false, false, _x, _y);
		} else {
			loaded = sprite_add("https://www.gravatar.com/avatar/" + email + ref + rating + size, 0, false, false, _x, _y);	
		}
	}
	
	static free = function() {
		if (sprite_exists(image)) sprite_delete(image);	
		image = -1;
	}
	
	static as_load = function(_map) {
		if _map[? "id"] == loaded {
			if _map[? "status"] >= 0 {
				image = loaded;
			}
		}
	}
}

/// @func gravatar_create
/// @arg email
/// @arg [autoload(bool)]
/// @arg [size]
/// @arg [rate]
/// @arg [referral]
/// @arg [force_referral]
function gravatar_create(_email) {
	var _grav = new __gravatar_struct_create(_email);
	
	#argsvar _autoload = argument_count > 1 ? argument[1] : true;
	
	switch(argument_count) {
		case 6: _grav.force_ref = argument[5];
		case 5: _grav.ref = "?d=" + string(argument[4]); _grav.rating = "&r=" + string(argument[3]); _grav.size = "&s=" + string(argument[2]); break;
		case 4: _grav.rating = "?r=" + string(argument[3]); _grav.size = "&s=" + string(argument[2]); break;
		case 3: _grav.size = "?s=" + string(argument[2]); break;
	}
	
	if (_autoload) {
		gravatar_load(_grav, 0,0);
	}
	return _grav;
}

/// @func gravatar_load
/// @arg Gravatar_Struct
/// @arg XOrigin
/// @arg YOrigin
function gravatar_load(_grav, _x, _y) {
	_grav.load(_x, _y);	
}

/// @func gravatar_free
/// @arg Gravatar_Struct
function gravatar_free(_grav) {
	_grav.free();
	delete _grav;
}

/// @func gravatar_async
/// @arg Gravatar_Struct
function gravatar_async(_grav) {
	var _map = ds_map_create();
	ds_map_copy(_map,async_load);
	_grav.as_load(_map);
	ds_map_destroy(_map);
}

/// @func gravatar_get_image
/// @arg Gravatar_Struct
function gravatar_get_image(_grav) {
	return _grav.image;	
}

/// @func gravatar_extract_image
function gravatar_extract_image(_grav) {
	if (gravatar_is_ready(_grav)) {
		_grav.has_extracted = true;
		return _grav.image;
	}
}

/// @func gravatar_is_ready
/// @arg Gravatar_Struct
function gravatar_is_ready(_grav) {
	return _grav.image != -1;	
}

/// @func gravatar_reset
/// @arg Gravatar_Struct
function gravatar_reset(_grav) {
	if !(_grav.has_extracted) {
		_grav.image = -1;
		has_extracted = false;
	} else _grav.free();
	loaded = -1;
}

/// @func gravatar_set_email
/// @func Gravatar_Struct
/// @func Email(String)
function gravatar_set_email(_grav, _email) {
	_grav.email = md5_string_utf8(_email);
}

/// @func gravatar_set_ref
/// @func Gravatar_Struct
/// @func Referral(String)
function gravatar_set_ref(_grav, _ref) {
	_grav.ref = _ref;
}

/// @func gravatar_set_rating
/// @func Gravatar_Struct
/// @func Rating(String)
function gravatar_set_rating(_grav, _rate) {
	_grav.rating = _rate;
}