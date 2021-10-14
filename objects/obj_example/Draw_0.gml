/// @description We'll render the results.
var _image = gravatar_image_get("tabularelf@gmail.com");

if (_image != -1) {
	draw_sprite(_image, 0, 32, 32);	
}

var _image = gravatar_image_get("test@example.com");
if (_image != -1) {
	// Offsetting by 80 because that's the default size for gravatars.
	draw_sprite(_image, 0, 32+80, 32);	
}

draw_text(8, 128, "Press Space to remove image!");