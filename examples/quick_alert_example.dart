import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const FinalView(),
    );
  }
}

class FinalView extends StatefulWidget {
  const FinalView({super.key});

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Alert"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Success
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: 'Transaction Completed Successfully!',
                );
              },
              color: Colors.green[600],
              child: const Text(
                "Success",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Error
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Oops...',
                  text: 'Sorry, something went wrong',
                );
              },
              color: Colors.red[600],
              child: const Text(
                "Error",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Warning
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'You just broke protocol',
                );
              },
              color: Colors.teal[700],
              child: const Text(
                "Warning",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Info
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  text: 'Buy two, get one free',
                );
              },
              color: Colors.yellow[600],
              child: const Text(
                "Info",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Confirm
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Do you want to logout',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                );
              },
              color: Colors.teal[200],
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Loading
            MaterialButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.loading,
                  title: 'Loading',
                  text: 'Fetching your data',
                );
              },
              color: Colors.blue[300],
              child: const Text(
                "Loading",
                style: TextStyle(color: Colors.white),
              ),
            ),

            /// Custom
            MaterialButton(
              onPressed: () {
                var message;
                QuickAlert.show(
                  title: 'Custom',
                  text: 'Custom Widget Alert',
                  context: context,
                  type: QuickAlertType.custom,
                  barrierDismissible: true,
                  confirmBtnText: 'Save',
                  widget: TextFormField(
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Enter Phone Number',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => message = value,
                  ),
                  onConfirmBtnTap: () async {
                    if (message.length < 5) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Please input something',
                      );
                      return;
                    }
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 1000));
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "Phone number '$message' has been saved!.",
                    );
                  },
                );
              },
              color: Colors.deepPurpleAccent,
              child: const Text(
                "Custom",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
