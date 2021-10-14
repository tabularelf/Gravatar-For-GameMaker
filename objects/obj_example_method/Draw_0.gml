/// @description We'll render the results.
// We can technically render all of the images out this way.
if (avatar.hasImages) {
	var _length = array_length(avatar.spriteList);
	var _i = 0;
	repeat(_length) {
		draw_sprite(avatar.spriteList[_i][0], 0, 32 + (_i * 80), 32);		
		++_i;
	}
}