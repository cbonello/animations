import 'package:animation_rive/signin_button.dart';
import 'package:animation_rive/teddy_controller.dart';
import 'package:animation_rive/tracking_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late TeddyController _teddyController;

  @override
  initState() {
    super.initState();
    _teddyController = TeddyController();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(93, 142, 155, 1.0),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 1.0],
                  colors: [
                    Color.fromRGBO(170, 207, 211, 1.0),
                    Color.fromRGBO(93, 142, 155, 1.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 200,
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: FlareActor(
                        'assets/Teddy.flr',
                        shouldClip: false,
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.contain,
                        controller: _teddyController,
                      )),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TrackingTextInput(
                                label: 'Email',
                                hint: "What's your email address?",
                                onCaretMoved: (Offset? caret) {
                                  _teddyController.coverEyes(false);
                                  _teddyController.lookAt(caret);
                                }),
                            TrackingTextInput(
                              label: 'Password',
                              hint: "Try 'bears'...",
                              isObscured: true,
                              onCaretMoved: (Offset? caret) {
                                _teddyController.coverEyes(caret != null);
                                _teddyController.lookAt(null);
                              },
                              onTextChanged: (String value) {
                                _teddyController.setPassword(value);
                              },
                            ),
                            SigninButton(
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'RobotoMedium',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () => _teddyController.submitPassword(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
