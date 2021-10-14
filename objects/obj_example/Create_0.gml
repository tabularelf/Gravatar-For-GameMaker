/// @description Init Gravatar
avatar = new gravatar("tabularelf@gmail.com");

// We'll load in a second email, which will fail obviously!
avatar.setEmail("test@example.com");
avatar.load();