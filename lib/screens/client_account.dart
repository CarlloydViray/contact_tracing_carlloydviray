import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace/constants/style_constants.dart';
import 'package:contact_trace/screens/client.dart';
import 'package:contact_trace/screens/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quickalert/quickalert.dart';

class clientAccount extends StatefulWidget {
  clientAccount({super.key, required this.uid});
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  State<clientAccount> createState() => _clientAccountState();
}

class _clientAccountState extends State<clientAccount> {
  final _formkey = GlobalKey<FormState>();
  var obscurePassword = true;

  late final TextEditingController _fnameController;
  late final TextEditingController _mnameController;
  late final TextEditingController _lnameController;
  late final TextEditingController _bdayController;
  late final TextEditingController _addressController;

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
    _fnameController = TextEditingController();
    _mnameController = TextEditingController();
    _lnameController = TextEditingController();
    _bdayController = TextEditingController();
    _addressController = TextEditingController();

    // Get the initial values from Firestore and set them on the controllers
    widget.firestore.collection('user').doc(widget.uid).get().then((snapshot) {
      var data = snapshot.data();
      _fnameController.text = data?['fname'] ?? '';
      _mnameController.text = data?['mname'] ?? '';
      _lnameController.text = data?['lname'] ?? '';
      _bdayController.text = data?['bday'] ?? '';
      _addressController.text = data?['address'] ?? '';
    });
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _mnameController.dispose();
    _lnameController.dispose();
    _bdayController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.firestore.collection('user').doc(widget.uid).update({
      'fname': _fnameController.text,
      'mname': _mnameController.text,
      'lname': _lnameController.text,
      'bday': _bdayController.text,
      'address': _addressController.text,
    });
    EasyLoading.showSuccess('User Credentials Updated');
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: ((context) => ClientScreen(UserID: widget.uid))));
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
          'My Account',
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
                if (value == 'QR') {
                  final userID = FirebaseAuth.instance.currentUser!.uid;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) =>
                              ClientScreen(UserID: userID))));
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
                        value: 'QR',
                        child: Text(
                          'My QR',
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
          //           value: 'QR',
          //           child: Text(
          //             'My QR',
          //             style: Theme.of(context).textTheme.titleSmall,
          //           ))
          //     ],
          //     onChanged: (value) async {
          //       if (value == 'logout') {
          //         await FirebaseAuth.instance.signOut();
          //         Navigator.push(context,
          //             CupertinoPageRoute(builder: ((context) => HomeScreen())));
          //       }
          //       if (value == 'QR') {
          //         final userID = FirebaseAuth.instance.currentUser!.uid;
          //          Navigator.push(context,
          //             CupertinoPageRoute(builder: ((context) => ClientScreen(UserID: userID))));
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
                //fname
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your first name';
                    }
                  },
                  controller: _fnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //mname
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your middle name';
                    }
                  },
                  controller: _mnameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                //lname
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your last name';
                    }
                  },
                  controller: _lnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),

                //bday
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter birthday';
                    }
                  },
                  controller: _bdayController,
                  decoration: InputDecoration(
                      labelText: 'Birthday',
                      border: OutlineInputBorder(),
                      hintText: 'Month-Day-Year',
                      suffixIcon: IconButton(
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2101));

                            if (selectedDate != null) {
                              setState(() {
                                _bdayController.text =
                                    DateFormat('MMMM-dd-yyyy')
                                        .format(selectedDate);
                              });
                            }
                          },
                          icon: Icon(Icons.date_range_outlined))),
                  keyboardType: TextInputType.datetime,
                  style: inputTextSize,
                ),
                const SizedBox(
                  height: 12.0,
                ),

                //address
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter address';
                    }
                  },
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 2,
                  maxLines: 5,
                  style: inputTextSize,
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
