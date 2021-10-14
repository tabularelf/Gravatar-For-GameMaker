function __gravatar_init() {
	static _init = false;
	if (_init == false) {
		global.__gravatar_async = [];
		_init = true;
	}
}

function gravatar_async() {
	var _id = async_load[? "id"];
	var _status = async_load[? "status"];
	//var _fileName = async_load[? "filename"];
	var _len = array_length(global.__gravatar_async);
	var _i = 0;
	repeat(_len) {
		if  global.__gravatar_async[_i][1] == _id {
			if (_status) >= 0 {
				if weak_ref_alive(global.__gravatar_async[_i][0]) {
					var _struct = global.__gravatar_async[_i][0].ref;
					if (_struct.func == undefined) {
						_struct.__addImage(global.__gravatar_async[_i][1]);
					} else {
						_struct.func(global.__gravatar_async[_i][1]);	
					}
				} else {
					// Remove it to prevent memory leaks
					sprite_delete(global.__gravatar_async[_i][1]);
				}	
			}
			
			array_delete(global.__gravatar_async, _i, 1);
			
			// Exit out of loop
			break;
		}
		++_i;
	}
}

function gravatar(_email, _autoload = true, _size = 80, _rating = "g", _ref = undefined, _func = undefined, _forceRef = false) constructor {
	email = md5_string_utf8(_email);
	ref = _ref;
	size = string(_size);
	rating = _rating;
	forceRef = _forceRef;
	func = _func;
	spriteList = [];
	hasImages = false;
	
	static load = function(_x = 0, _y = 0) {
		var _forceRef = forceRef == false ? "" : "&f=y";
		var _ref = is_undefined(ref) ? "" :  "&d=" + ref;
		var _string = "https://www.gravatar.com/avatar/" + email + "?s=" + size + "&r=" + rating + _ref + _forceRef;
		var _imageID = sprite_add(_string, 0, false, false, _x, _y)
		
		// Init just in case
		__gravatar_init();
		
		// Store value
		array_push(global.__gravatar_async, [weak_ref_create(self), _imageID]);
		return self;
	}
	
	static extract = function() {
		if (hasImages) {
			var _image = spriteList[0];
			array_delete(spriteList, 0, 1);
			
			if (array_length(spriteList) == 0) {
				hasImages = false;	
			}
			
			return _image;
		}
	}
	
	static setEmail = function(_email) {
		email = md5_string_utf8(_email);
		return self;
	}
	
	static setRef = function(_ref = "default") {
		ref = _ref;
		return self;
	}
	
	static setSize = function(_size =80) {
		size = string(_size);
		return self;
	}
	
	static setRating = function(_rating = "g") {
		rating = _rating;
		return self;
	}
	
	static setForceRef = function(_forceRef = false) {
		forceRef = _forceRef;
		return self;
	}
	
	static setFunc = function(_func) {
		func = _func;
		return self;
	}
	
	static __addImage = function(_image) {
		array_push(spriteList, _image);
		hasImages = true;
		return _image;	
	}
	
	static free = function() {
		var _len = array_length(spriteList);
		var _i = 0;
		repeat(_len) {
			if (sprite_exists(spriteList[_i])) {
				sprite_delete(spriteList);	
			}
			++_i;
		}
	}
	
	if (_autoload) {
		load();	
	}
}

/*
function __gravatar_struct_create(_email) constructor {
	email = md5_string_utf8(_email);
	ref = "";
	size = "";
	rating = "";
	force_ref = false;
	
	imageID = -1;
	isLoaded = false;
	image = -1;
	has_extracted = false;
	
	load = function(_x, _y) {
		if (force_ref) {
			imageID = sprite_add("https://www.gravatar.com/avatar/" + email + ref + rating + size + "&f=y", 0, false, false, _x, _y);
		} else {
			imageID = sprite_add("https://www.gravatar.com/avatar/" + email + ref + rating + size, 0, false, false, _x, _y);	
		}
		
		__gravatar_init();
		global.gravatar_async.list[array_length(global.gravatar_async.list)] = self;
	}
	
	static free = function() {
		if (sprite_exists(image)) sprite_delete(image);	
		image = -1;
	}
	
	static as_load = function(_map) {
		if _map[? "id"] == imageID {
			if _map[? "status"] >= 0 {
				image = imageID;
				isLoaded = true;
			}
		}
	}
}

/// @func gravatar_create
/// @arg email
/// @arg [autoload]
/// @arg [size]
/// @arg [rate]
/// @arg [referral]
/// @arg [force_referral]
function gravatar_create(_email) {
	var _grav = new __gravatar_struct_create(_email);
	
	var _autoload = argument_count > 1 ? argument[1] : true;
	
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
function gravatar_async() {
	var _len = array_length(global.gravatar_async.list);
	var _i = 0;
	repeat(_len) {
		global.gravatar_async.list[_i++].as_load(async_load);	
	}
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
	imageID = -1;
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