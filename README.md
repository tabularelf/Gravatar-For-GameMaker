# Gravatar-For-GameMaker V1.0.0

Adds Gravatar implementation into GameMaker Studio 2.
https://en.gravatar.com/site/implement/images/

Implementation:
```gml
// Create Event

// Init loading in images
avatar = new gravatar("email@domain.tld");

// Async Image Loaded
gravatar_async();

// Draw Event (or elsewhere)
var _image = gravatar_image_get("email@domain.tld");

if (_image != -1) {
	draw_sprite(_image, 0, 32, 32);	
}
```
