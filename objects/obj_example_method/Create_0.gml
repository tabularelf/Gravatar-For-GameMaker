/// @description Cat Judges your code
avatar = new gravatar("tabularelf@gmail.com", false).setFunc(method(undefined, function(_sprite, _email) {
	show_debug_message("The sprite ID is: " + string(_sprite));
	__addImage(_sprite, _email);
})).load().setEmail("test@email.com").load();