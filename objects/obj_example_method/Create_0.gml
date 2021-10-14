/// @description Cat Judges your code
avatar = new gravatar("tabularelf@gmail.com", false).setFunc(method(undefined, function(_sprite) {
	show_debug_message("The sprite ID is: " + string(_sprite));
	__addImage(_sprite);
})).load().setEmail("test@email.com").load();