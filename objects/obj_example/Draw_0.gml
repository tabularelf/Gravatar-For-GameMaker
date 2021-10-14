/// @description Cat Judges your code
if (avatar.hasImages) {
	var _sprite = floor(current_time / 1000) %  array_length(avatar.spriteList);
	draw_sprite(_sprite, 0, 32, 32);	
}