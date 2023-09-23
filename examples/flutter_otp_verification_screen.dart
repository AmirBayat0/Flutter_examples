import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OTP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.ubuntu(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          headline2: GoogleFonts.ubuntu(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          headline3: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          headline4: GoogleFonts.ubuntu(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          headline5: GoogleFonts.ubuntu(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurpleAccent,
          ),
          subtitle1: GoogleFonts.ubuntu(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurpleAccent,
          ),
        ),
      ),
      home: FinalView(),
    );
  }
}

class FinalView extends StatelessWidget {
  FinalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(
          CupertinoIcons.back,
          color: Colors.deepPurpleAccent,
          size: 30,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            const TopTexts(),
            Otp(),
            const ResendCode(),
            Expanded(child: Container()),
            BottomButton(size: size)
          ],
        ),
      ),
    ));
  }
}

/// Two Bottom Button
class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: size.width,
      height: size.height * 0.07,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        MaterialButton(
          onPressed: () {},
          minWidth: size.width / 2.2,
          height: size.height * 0.06,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.deepPurpleAccent, width: 2)),
          child: Text("Resend", style: textTheme.subtitle1),
        ),
        MaterialButton(
          onPressed: () {},
          color: Colors.deepPurpleAccent,
          minWidth: size.width / 2.2,
          height: size.height * 0.06,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text("Confirm",
              style: textTheme.subtitle1?.copyWith(color: Colors.white)),
        ),
      ]),
    );
  }
}

/// Resend Code Text
class ResendCode extends StatelessWidget {
  const ResendCode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
          text: "Resend code after ",
          style: textTheme.headline3,
          children: [
            TextSpan(
                text: "1:20",
                style: textTheme.headline5?.copyWith(fontSize: 16))
          ]),
    );
  }
}

/// Otp
class Otp extends StatelessWidget {
  Otp({
    Key? key,
  }) : super(key: key);

  var textFormFieldDecoration = InputDecoration(
    hintText: "2",
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        width: 2,
        color: Color.fromARGB(255, 190, 168, 250),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        width: 3,
        color: Colors.deepPurpleAccent,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: Form(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              decoration: textFormFieldDecoration,
              cursorColor: Colors.deepPurpleAccent,
              textAlign: TextAlign.center,
              cursorHeight: 30.0,
              maxLines: 1,
              style: textTheme.headline1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              decoration: textFormFieldDecoration,
              cursorColor: Colors.deepPurpleAccent,
              textAlign: TextAlign.center,
              cursorHeight: 30.0,
              maxLines: 1,
              style: textTheme.headline1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              },
              decoration: textFormFieldDecoration,
              cursorColor: Colors.deepPurpleAccent,
              textAlign: TextAlign.center,
              cursorHeight: 30.0,
              maxLines: 1,
              style: textTheme.headline1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 1) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              decoration: textFormFieldDecoration,
              cursorColor: Colors.deepPurpleAccent,
              textAlign: TextAlign.center,
              cursorHeight: 30.0,
              maxLines: 1,
              style: textTheme.headline1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
        ],
      )),
    );
  }
}

/// Top Texts
class TopTexts extends StatelessWidget {
  const TopTexts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: size.width,
      height: size.height * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verification code", style: textTheme.headline2),
          const SizedBox(
            height: 2,
          ),
          Text("We have sent the verification code to",
              style: textTheme.headline3),
          const SizedBox(
            height: 5,
          ),
          RichText(
            text: TextSpan(
                text: "+98********56  ",
                style: textTheme.headline4,
                children: [
                  TextSpan(
                      text: "Change Phone number?", style: textTheme.headline5)
                ]),
          ),
        ],
      ),
    );
  }
}
