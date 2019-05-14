# flutter_chromecast_example

Example of an implementation of your iOS or Android device as a ChromeCast sender. Uses [flutter_mdns_plugin](https://github.com/terrabythia/flutter_mdns_plugin) for discovering the ChromeCast devices (because this cannot be done purely in Dart) and uses [dart_chromecast](https://github.com/terrabythia/dart_chromecast) to communicate with a connected ChromeCast (purely in Dart).

The [dart_chromecast](https://github.com/terrabythia/dart_chromecast) project is still under development and that's mainly why this example is also still very simple, but as the dart_chromecast project grows, so will this example implementation of it.

**Usage**

Make sure you have the latest version of Dart and Flutter installed. 
Clone this project, get pub dependencies and just run! 
Works both in the simulator and on a real device.