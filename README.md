# go_app

A Go board in Flutter, that works on Desktop.

# Building and Running

Get setup for [flutter development](https://github.com/flutter/flutter) and [flutter desktop development](https://github.com/google/flutter-desktop-embedding) then run the command: `flutter run`. 

Setup steps are roughly: 
* download and install the Flutter command line tools
* download Visual Studio with the C++ development module for needed dependencies
* set ENABLE_FLUTTER_DESKTOP=true as an environment variable
* ensure flutter is working with `flutter`, `flutter doctor`, and `flutter upgrade`.
* ensure desktop embedding is enabled by seeing Windows showup as a device with `flutter devices`.
* build and run the app with `flutter run`. This will create needed DLLS (except for ones from visual studio...) and an exe in /build.

# Chess for James

There's a branch of this project at chess-game, that turns it in to a chess practice tool! Highlight squares on the board and try to mentally name them, before revealing the answer to check your guess.

![chess-for-james](https://user-images.githubusercontent.com/3268245/58774863-72cb3300-8578-11e9-8c15-628710a4ebb5.png)
