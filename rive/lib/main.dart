import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginForm(),
      );
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  Artboard? _teddyArtboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isCheckingEmail;
  SMINumber? numLook;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  late FocusNode _emailFocusNode;
  final TextEditingController _passwordController = TextEditingController();
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    final animationURL = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/teddy.riv'
        : 'teddy.riv';
    rootBundle.load(animationURL).then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        stateMachineController = StateMachineController.fromArtboard(artboard, 'Login Machine');
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);

          // for (var e in stateMachineController!.inputs) {
          //   debugPrint(e.runtimeType.toString());
          //   debugPrint('name${e.name}End');
          // }

          for (var element in stateMachineController!.inputs) {
            if (element.name == 'trigSuccess') {
              successTrigger = element as SMITrigger;
            } else if (element.name == 'trigFail') {
              failTrigger = element as SMITrigger;
            } else if (element.name == 'isHandsUp') {
              isHandsUp = element as SMIBool;
            } else if (element.name == 'isChecking') {
              isCheckingEmail = element as SMIBool;
            } else if (element.name == 'numLook') {
              numLook = element as SMINumber;
            }
          }
        }

        setState(() => _teddyArtboard = artboard);
      },
    );

    _emailFocusNode = FocusNode();
    _emailFocusNode.addListener(
      () {
        if (_emailFocusNode.hasFocus) {
          isCheckingEmail?.change(true);
          moveEyeBalls(_emailController.text);
        } else {
          isCheckingEmail?.change(false);
        }
      },
    );

    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(
      () => isHandsUp?.change(_passwordFocusNode.hasFocus),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void moveEyeBalls(val) => numLook?.change(val.length.toDouble());

  void login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == 'admin' && _passwordController.text == 'admin') {
        successTrigger?.fire();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You're in!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please try again!')),
        );
        failTrigger?.fire();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xffd6e2ea),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_teddyArtboard != null)
                SizedBox(
                  width: 400,
                  height: 300,
                  child: Rive(artboard: _teddyArtboard!, fit: BoxFit.fitWidth),
                ),
              Container(
                alignment: Alignment.center,
                width: 400,
                padding: const EdgeInsets.only(bottom: 16),
                margin: const EdgeInsets.only(bottom: 16 * 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 16 * 2),
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              onChanged: moveEyeBalls,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  return null;
                                }
                                return 'Please enter some text';
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 14),
                              cursorColor: const Color(0xffb04863),
                              decoration: const InputDecoration(
                                hintText: "Email/Username",
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusColor: Color(0xffb04863),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffb04863),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  return null;
                                }
                                return 'Please enter password';
                              },
                              style: const TextStyle(fontSize: 14),
                              cursorColor: const Color(0xffb04863),
                              decoration: const InputDecoration(
                                hintText: "Password",
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusColor: Color(0xffb04863),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffb04863),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const RememberMe(),
                                ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffb04863),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  late bool shouldRemember;

  @override
  void initState() {
    super.initState();
    shouldRemember = false;
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: shouldRemember,
            onChanged: (value) => setState(() => shouldRemember = value ?? false),
          ),
          const Text('Remember me'),
        ],
      );
}
