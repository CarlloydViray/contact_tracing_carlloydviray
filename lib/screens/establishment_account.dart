import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace/constants/style_constants.dart';
import 'package:contact_trace/screens/establishment.dart';
import 'package:contact_trace/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

class establishmentAccount extends StatefulWidget {
  establishmentAccount({super.key, required this.uid});
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  State<establishmentAccount> createState() => _establishmentAccountState();
}

class _establishmentAccountState extends State<establishmentAccount> {
  final _formkey = GlobalKey<FormState>();
  var obscurePassword = true;

  late final TextEditingController _establishmentNameController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _establishmentAddressController;

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
          _updateData();
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _establishmentNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _establishmentAddressController = TextEditingController();

    // Get the initial values from Firestore and set them on the controllers
    widget.firestore.collection('user').doc(widget.uid).get().then((snapshot) {
      var data = snapshot.data();
      _establishmentNameController.text = data?['establishmentName'] ?? '';
      _contactPersonController.text = data?['contactPersonName'] ?? '';
      _establishmentAddressController.text =
          data?['establishmentAddress'] ?? '';
    });
  }

  @override
  void dispose() {
    _establishmentNameController.dispose();
    _contactPersonController.dispose();
    _establishmentAddressController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.firestore.collection('user').doc(widget.uid).update({
      'establishmentName': _establishmentNameController.text,
      'contactPersonName': _contactPersonController.text,
      'establishmentAddress': _establishmentAddressController.text,
    });
    EasyLoading.showSuccess('Establishment Credentials Updated');
    Navigator.push(context,
        CupertinoPageRoute(builder: ((context) => EstablishmentScreen())));
  }

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Client Account',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.black,
              ),
              onSelected: (value) async {
                if (value == 'logout') {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) => HomeScreen())));
                }
                if (value == 'scan') {
                  final userID = FirebaseAuth.instance.currentUser!.uid;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) => EstablishmentScreen())));
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'logout',
                        child: Text(
                          'Logout',
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                    PopupMenuItem(
                        value: 'scan',
                        child: Text(
                          'Scan QR',
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                  ])

          // DropdownButton(
          //     icon: Icon(Icons.more_vert),
          //     items: [
          //       DropdownMenuItem(
          //           value: 'logout',
          //           child: Text(
          //             'Logout',
          //             style: Theme.of(context).textTheme.titleSmall,
          //           )),
          //       DropdownMenuItem(
          //           value: 'scan',
          //           child: Text(
          //             'Scan QR',
          //             style: Theme.of(context).textTheme.titleSmall,
          //           ))
          //     ],
          //     onChanged: (value) async {
          //       if (value == 'logout') {
          //         await FirebaseAuth.instance.signOut();
          //         Navigator.push(context,
          //             CupertinoPageRoute(builder: ((context) => HomeScreen())));
          //       }
          //       if (value == 'scan') {
          //         final userID = FirebaseAuth.instance.currentUser!.uid;
          //         Navigator.push(
          //             context,
          //             CupertinoPageRoute(
          //                 builder: ((context) => EstablishmentScreen())));
          //       }
          //     })
        ],
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
                const Text('Update your account:'),
                const SizedBox(
                  height: 12.0,
                ),
                //estab name
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your first name';
                    }
                  },
                  controller: _establishmentNameController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //Contact Person
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your middle name';
                    }
                  },
                  controller: _contactPersonController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //estab address
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your last name';
                    }
                  },
                  controller: _establishmentAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Establishment Address',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),

                const SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  onPressed: validateInput,
                  style: ElevatedButton.styleFrom(
                    shape: roundedShape,
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
