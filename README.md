# Gravatar-For-GameMaker v1.0.0

Adds Gravatar implementation into GameMaker Studio 2.
https://en.gravatar.com/site/implement/images/

Example: https://tabularelf.com/examples/gravatar-example/

## Basic implementation:
```gml
// gravatar(email [autoload], [size], [rating], [default_image], [function], [force_default_image])

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

## Functions
```gml
gravatar_image_get(email) - Gets image from email.

gravatar_image_delete(email) - Removes image and email from the Global Gravatar Database, but not the Gravatar Constructor Database. (Debugging intended)'

gravatar_async() - Handles Gravatar loading. Should be in the Async Event Image Loaded.
```

## Methods

```
.setEmail(email) - sets email to load future Gravatars with.

.setSize(size) - Default 80: Sets the size to load future Gravatars with.

.setRating(rating) - Default g: Sets the rating to load future Gravatars with.

.setDefImage(default) - Default undefined: Sets the default image to load future Gravatars with.

.setForceDef(boolean) - Default false: Sets whether to forcefully load the default image or not for future Gravatars.

.setFunc(function) - Default undefined: Sets the function to use when loading in Gravatars. gravatar_async will pass through the following arguments in order: [image, email].
Note: You should append __addImage(image, email) if you wish to add them to the databases. (See below)

.load() - attempts to load image.

.extract() - Extracts the image from the Gravatar Constructor, removing the pointers from the Global & Constructor Gravatar Database.

.free() - Frees memory, removing all of the images loaded but not extracted.

.__addImage(image, email) - Used internally to add image to the Gravatar Database.
