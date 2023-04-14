import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace/constants/style_constants.dart';
import 'package:contact_trace/screens/client.dart';
import 'package:contact_trace/screens/establishment.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

class RegisterEstablishmentScreen extends StatefulWidget {
  const RegisterEstablishmentScreen({super.key});

  @override
  State<RegisterEstablishmentScreen> createState() =>
      _RegisterEstablishmentScreenState();
}

class _RegisterEstablishmentScreenState
    extends State<RegisterEstablishmentScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();
  final establishmentNameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final establishmentAddressController = TextEditingController();

  var obscurePassword = true;
  final _formkey = GlobalKey<FormState>();
  final collectionPath = 'user';

  void registerClient() async {
    try {
      EasyLoading.show(
        status: 'Processing...',
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      //created user account -> UID
      String uid = userCredential.user!.uid;
      FirebaseFirestore.instance.collection(collectionPath).doc(uid).set({
        'establishmentName': establishmentNameController.text,
        'contactPersonName': contactPersonController.text,
        'establishmentAddress': establishmentAddressController.text,
        'type': 'establishment',
      });
      EasyLoading.showSuccess('Establishment account has been registered.');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return EstablishmentScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        EasyLoading.showError(
            'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
            ('Your email is already registered. Please enter a new email address.'));
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
            'An error occured while creating your account. Try again.');
      }

      print(ex.code);
    }
  }

  void validateInput() {
    //cause form to validate

    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        confirmBtnText: 'Yes',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          registerClient();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up (Establishment)',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/illustration.webp'),
                opacity: 0.4,
                alignment: Alignment.bottomCenter),
          ),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Register your establishment account:'),
                const SizedBox(
                  height: 12.0,
                ),
                //establishment name
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter establishment name';
                    }
                  },
                  controller: establishmentNameController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //contact person name
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter contact person name';
                    }
                  },
                  controller: contactPersonController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person Name',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 2,
                  maxLines: 5,
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //establishment address
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter establishment address';
                    }
                  },
                  controller: establishmentAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Address',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 2,
                  maxLines: 5,
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //email
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter an email address.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email address';
                    }
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),

                //password
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value.length <= 6) {
                      return 'Password must be more than 6 characters';
                    }
                  },
                  obscureText: obscurePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),

                //confirm password
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your password.';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords don\'t match';
                    }
                  },
                  obscureText: obscurePassword,
                  controller: confirmpassController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                ElevatedButton(
                  // onPressed: registerClient,
                  onPressed: () {
                    validateInput();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: roundedShape,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
