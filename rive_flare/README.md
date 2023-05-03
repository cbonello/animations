# Teddy

<img align="right" src="https://i.imgur.com/hJU9Obt.gif" height="250">

An example built using JCToon's Flare File as a custom UI component. <br/>
Teddy will follow the cursor as you type or move it around.

## Overview

The basic idea is to use the `ctrl_face` node in JCToon's file to change the direction of Teddy's gaze, as it's shown here in the gif to the right.

This is done by using [custom `FlareControls`](lib/teddy_controller.dart), available in `/lib/teddy_controller.dart`.

```
abstract class FlareController {
  void initialize(FlutterActorArtboard artboard);
  void setViewTransform(Mat2D viewTransform);
  bool advance(FlutterActorArtboard artboard, double elapsed);
}
```

<img align="right" src="https://i.imgur.com/WdjurVo.gif" width="300" />

An instance of `TeddyController` is passed to the `FlareActor` in [`/lib/main.dart`](lib/main.dart#L78). This ties the controller to this widget, and allows it to use the three overrides to perform custom actions:

```
FlareActor(
    "assets/Teddy.flr",
    controller: _teddyController,
    [...]
)
```

In this example, `initialize()` will grab the reference to the `ctrl_face` node through the library call `artboard.getNode("ctrl_face")`. 
