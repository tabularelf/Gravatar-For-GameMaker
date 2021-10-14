#macro GRAVATAR_VERSION "v1.0.0"
#macro GRAVATAR_AUTHOR "TabularElf - https://tabularelf.com/"

function __gravatar_init() {
	static _init = false;
	if (_init == false) {
		global.__gravatarAsync = [];
		global.__gravatarMap = {};
		_init = true;
		__gravatar_trace("Gravatar " + GRAVATAR_VERSION + " initialized! Author: " + GRAVATAR_AUTHOR);
	}
}

__gravatar_init();

function __gravatar_trace(_string) {
	show_debug_message("Gravatar: " + _string);	
}

/// @func gravatar_image_get(email)
/// @param email
function gravatar_image_get(_email) {
	var _image = global.__gravatarMap[$ _email];
	
	if (_image != undefined && sprite_exists(_image)) {
		return _image;	
	}
	
	return -1;
}

/// @func gravatar_image_delete(email)
/// @param email
function gravatar_image_delete(_email) {
	if (variable_struct_exists(global.__gravatarMap, _email)) {
		sprite_delete(global.__gravatarMap[$ _email]);
		variable_struct_remove(global.__gravatarMap, _email);
	} else {
		__gravatar_trace("Email " + _email + " doesn't exist!");
	}
}

/// @func gravatar_async
function gravatar_async() {
	var _id = async_load[? "id"];
	var _status = async_load[? "status"];
	//var _fileName = async_load[? "filename"];
	var _len = array_length(global.__gravatarAsync);
	var _i = 0;
	repeat(_len) {
		if  global.__gravatarAsync[_i][1] == _id {
			if (_status) >= 0 {
				var _email = global.__gravatarAsync[_i][2];
				var _spriteID = global.__gravatarAsync[_i][1];
				var _weakRef = global.__gravatarAsync[_i][0];
				if weak_ref_alive(_weakRef) {
					var _struct = _weakRef.ref;
					var _image = _struct.spriteMap[$ _email];
					
					if (_image != undefined && sprite_exists(_image)) {
						__gravatar_trace("Gravatar at " + string(_email) + " with sprite ID " + string(_image) + " loaded! Dumping sprite " + string(_spriteID));
						sprite_delete(_spriteID);
						return _spriteID;
					}
					
					if (_struct.func == undefined) {
						_struct.__addImage(_spriteID, _email);
					} else {
						_struct.func(_spriteID, _email);	
					}
					
				} else {
					// Remove it to prevent memory leaks
					sprite_delete(_spriteID);
				}	
			}
			
			array_delete(global.__gravatarAsync, _i, 1);
			
			// Exit out of loop
			break;
		}
		++_i;
	}
}

/// @func gravatar(email [autoload], [size], [rating], [default_image], [function], [force_default_image])
/// @param email
/// @param [autoload]
/// @param [size]
/// @param [rating]
/// @param [default_image]
/// @param [function]
/// @param [force_default_image]
function gravatar(_email, _autoload = true, _size = 80, _rating = "g", _ref = undefined, _func = undefined, _forceRef = false) constructor {
	email = _email;
	emailHash = md5_string_utf8(_email);
	ref = _ref;
	size = string(_size);
	rating = _rating;
	forceRef = _forceRef;
	func = _func;
	spriteList = [];
	spriteMap = {};
	hasImages = false;
	
	static load = function(_x = 0, _y = 0) {
		var _image = spriteMap[$ email];
		if (_image != undefined) {
			__gravatar_trace("Gravatar already exists for this email! Returning with Sprite ID: " + string(_image));
			return _image;
		}
		var _forceRef = forceRef == false ? "" : "&f=y";
		var _ref = is_undefined(ref) ? "" :  "&d=" + ref;
		var _string = "https://www.gravatar.com/avatar/" + emailHash + "?s=" + size + "&r=" + rating + _ref + _forceRef;
		var _imageID = sprite_add(_string, 0, false, false, _x, _y);
		
		// Init just in case
		__gravatar_init();
		
		// Store information
		array_push(global.__gravatarAsync, [weak_ref_create(self), _imageID, email]);
		return self;
	}
	
	static extract = function() {
		if (hasImages) {
			var _image = spriteList[0][0];
			var _email = spriteList[0][1];
			array_delete(spriteList, 0, 1);
			
			if (array_length(spriteList) == 0) {
				hasImages = false;	
			}
			
			variable_struct_remove(global.__gravatarMap, _email);
			variable_struct_remove(spriteMap, _email);
			
			return _image;
		}
	}
	
	static setEmail = function(_email) {
		email = _email;
		emailHash = md5_string_utf8(_email);
		return self;
	}
	
	static setDefImage = function(_ref = "default") {
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
	
	static setForceDef = function(_forceRef = false) {
		forceRef = _forceRef;
		return self;
	}
	
	static setFunc = function(_func = undefined) {
		func = _func;
		return self;
	}
	
	static __addImage = function(_image, _email) {
		if variable_struct_exists(global.__gravatarMap, _email) {
			__gravatar_trace("Email " + _email + " already exists!");
			return _image;
		}
		array_push(spriteList, [_image, _email]);
		
		global.__gravatarMap[$ _email] = _image;
		spriteMap[$ _email] = _image;
		
		hasImages = true;
		return _image;	
	}
	
	static free = function() {
		var _len = array_length(spriteList);
		var _i = 0;
		repeat(_len) {
			if (sprite_exists(spriteList[_i][0])) {
				sprite_delete(spriteList[_i][0]);	
			}
			++_i;
		}
		
		spriteList = [];
		
		// Do keys now
		var _keys = variable_struct_get_names(spriteMap);
		var _len = array_length(_keys);
		var _i = 0;
		
		repeat(_len) {
			variable_struct_remove(spriteMap, _keys[_i]);	
			variable_struct_remove(global.__gravatarMap, _keys[_i]);
			++_i;
		}
		
		hasImages = false;
	}
	
	if (_autoload) {
		load();	
	}
}