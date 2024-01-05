// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const FinalView(),
    );
  }
}

class QuestionField extends StatelessWidget {
  final String question;
  final TextEditingController controller;

  const QuestionField({
    Key? key,
    required this.question,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: question),
      controller: controller,
      validator: (val) => val?.isNotEmpty ?? false ? null : 'Required answer',
    );
  }
}

enum Type {
  CAT,
  DOG,
  ECHIDNA,
}

class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  State<FinalView> createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  final _fbKey = GlobalKey<FormBuilderState>();
  Type? _petType;

  final String firstName = 'FirstName';
  final String lastName = 'LastName';
  final String phoneNumber = 'PhoneNumber';
  final String petChoice = 'PetChoice';
  final String q1 = 'QuestionAnswer1';
  final String q2 = 'QuestionAnswer2';
  final String q3 = 'QuestionAnswer3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        title: Text(
          'Welcome Back! Dear User:)',
          style: GoogleFonts.firaSans(),
        ),
      ),

      /// <Main App Body>
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Colors.lightBlueAccent,
          ]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    /// Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PET HOTEL',
                          style: GoogleFonts.firaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.pets,
                        )
                      ],
                    ),

                    /// Sub Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: Text(
                        'Welcome to Pet Hotel! Please give some details about your furry or spikey friend below, and we\'ll be able to check you in.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.firaSans(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilder(
                          key: _fbKey,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                style: GoogleFonts.firaSans(),
                                name: firstName,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                ),
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FormBuilderTextField(
                                style: GoogleFonts.firaSans(),
                                name: lastName,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                ),
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FormBuilderTextField(
                                name: phoneNumber,
                                style: GoogleFonts.firaSans(),
                                validator: FormBuilderValidators.numeric(),
                                decoration: const InputDecoration(
                                  labelText: 'Phone number',
                                ),
                                autovalidateMode: AutovalidateMode.always,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 17),
                                child: Text(
                                  'What kind of pet do you have?',
                                  style: GoogleFonts.firaSans(fontSize: 18),
                                ),
                              ),
                              FormBuilderRadioGroup<Type>(
                                onChanged: (val) {
                                  print(val);
                                  setState(() {
                                    _fbKey.currentState?.patchValue({
                                      q1: '',
                                      q2: '',
                                      q3: '',
                                    });
                                    _petType = val;
                                  });
                                },
                                name: petChoice,
                                validator: FormBuilderValidators.required(),
                                orientation: OptionsOrientation.vertical,
                                options: [
                                  ...Type.values.map(
                                    (e) => FormBuilderFieldOption(
                                      value: e,
                                      child: Text(
                                        describeEnum(e).replaceFirst(
                                          describeEnum(e)[0],
                                          describeEnum(e)[0].toUpperCase(),
                                        ),
                                        style: GoogleFonts.firaSans(),
                                      ),
                                    ),
                                  ),
                                ],
                                wrapDirection: Axis.vertical,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Builder(
                                builder: (context) {
                                  switch (_petType) {
                                    case Type.CAT:
                                      return Column(
                                        children: [
                                          const Text("Aw, it's a cat!"),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q1,
                                            decoration: const InputDecoration(
                                              labelText: 'Can we pat the cat?',
                                            ),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q2,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Can we put a little outfit on it?',
                                            ),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q3,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Does it like to jump in boxes?',
                                            ),
                                          ),
                                        ],
                                      );

                                    case Type.DOG:
                                      return Column(
                                        children: [
                                          const Text(
                                              textAlign: TextAlign.center,
                                              "Yay, a puppy! What's its details?"),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q1,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Can we wash your dog?'),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q2,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'What is your dog\'s favorite treat?'),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q3,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Is your dog okay with other dog\'s?'),
                                          ),
                                        ],
                                      );

                                    case Type.ECHIDNA:
                                      return Column(
                                        children: [
                                          const Text(
                                              textAlign: TextAlign.center,
                                              "It's a small spiky boi. Can you fill us in on some of the details?"),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q1,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'How spikey is the echidna?'),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q2,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Can we read the echidna a story?'),
                                          ),
                                          FormBuilderTextField(
                                            style: GoogleFonts.firaSans(),
                                            name: q3,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    'Does it like leafy greens?'),
                                          ),
                                        ],
                                      );
                                    case null:
                                      {
                                        return Text(
                                            'Please choose your pet type from above',
                                            style: GoogleFonts.firaSans());
                                      }
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    final valid = _fbKey.currentState
                                            ?.saveAndValidate() ??
                                        false;
                                    if (!valid) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                          contentPadding:
                                              const EdgeInsets.all(20),
                                          title: Text('Please check the form',
                                              style: GoogleFonts.firaSans()),
                                          children: [
                                            Text(
                                                'Some details are missing or incorrect. Please check the details and try again.',
                                                style: GoogleFonts.firaSans())
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                          alignment: Alignment.center,
                                          contentPadding:
                                              const EdgeInsets.all(20),
                                          title: Text("All done!",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.firaSans(
                                                fontSize: 22,
                                              )),
                                          children: [
                                            Text(
                                                "Thanks for all the details! We're going to check your pet in with the following details.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.firaSans()),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    'First name: ${_fbKey.currentState!.value[firstName]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Last name: ${_fbKey.currentState!.value[lastName]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Number: ${_fbKey.currentState!.value[phoneNumber]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Pet type: ${_fbKey.currentState!.value[petChoice]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Response 1: ${_fbKey.currentState!.value[q1]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Response 2: ${_fbKey.currentState!.value[q2]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                                Text(
                                                    'Response 3: ${_fbKey.currentState!.value[q3]}',
                                                    style:
                                                        GoogleFonts.firaSans()),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('REGISTER'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
