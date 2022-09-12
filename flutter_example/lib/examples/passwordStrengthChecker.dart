import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FinalView(),
    );
  }
}

//? CodeWithFlexz on Instagram

//* AmirBayat0 on Github
//! Programming with Flexz on Youtube

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  late String password;
  bool isObscure = false;
  double strength = 0;
  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  // 1: Great

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String displayText = 'Please enter a password';

  void checkPassword(String value) {
    password = value.trim();

    if (password.isEmpty) {
      setState(() {
        strength = 0;
        displayText = 'Please enter you password';
      });
    } else if (password.length < 6) {
      setState(() {
        strength = 1 / 4;
        displayText = 'Your password is too short';
      });
    } else if (password.length < 8) {
      setState(() {
        strength = 2 / 4;
        displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
        setState(() {
          strength = 3 / 4;
          displayText = 'Your password is strong';
        });
      } else {
        setState(() {
          strength = 1;
          displayText = 'Your password is great';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: strength <= 1 / 4
                ? Colors.red
                : strength == 2 / 4
                    ? Colors.yellow
                    : strength == 3 / 4
                        ? Colors.blue
                        : Colors.green,
            title: const Text('CodeWithFlexz'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => checkPassword(value),
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: strength <= 1 / 4
                                  ? Colors.red
                                  : strength == 2 / 4
                                      ? Colors.yellow
                                      : strength == 3 / 4
                                          ? Colors.blue
                                          : Colors.green,
                              width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Password'),
                ),
                const SizedBox(
                  height: 30,
                ),
                LinearProgressIndicator(
                  value: strength,
                  backgroundColor: Colors.grey[300],
                  color: strength <= 1 / 4
                      ? Colors.red
                      : strength == 2 / 4
                          ? Colors.yellow
                          : strength == 3 / 4
                              ? Colors.blue
                              : Colors.green,
                  minHeight: 15,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  displayText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: strength <= 1 / 4
                          ? Colors.red
                          : strength == 2 / 4
                              ? Colors.yellow
                              : strength == 3 / 4
                                  ? Colors.blue
                                  : Colors.green),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: strength < 1 / 2 ? null : () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        strength <= 1 / 4
                            ? Colors.red
                            : strength == 2 / 4
                                ? Colors.yellow
                                : strength == 3 / 4
                                    ? Colors.blue
                                    : Colors.green,
                      ),
                    ),
                    child: const Text('Continue'))
              ],
            ),
          )),
    );
  }
}
