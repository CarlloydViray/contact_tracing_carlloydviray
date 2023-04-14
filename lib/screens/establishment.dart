import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace/constants/style_constants.dart';
import 'package:contact_trace/screens/establishment_account.dart';
import 'package:contact_trace/screens/home.dart';
import 'package:contact_trace/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EstablishmentScreen extends StatefulWidget {
  const EstablishmentScreen({super.key});

  @override
  State<EstablishmentScreen> createState() => _EstablishmentScreenState();
}

class _EstablishmentScreenState extends State<EstablishmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Establishment',
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
                if (value == 'account') {
                  final userID = FirebaseAuth.instance.currentUser!.uid;
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) =>
                              establishmentAccount(uid: userID))));
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
                        value: 'account',
                        child: Text(
                          'Account',
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
          //           value: 'account',
          //           child: Text(
          //             'Account',
          //             style: Theme.of(context).textTheme.titleSmall,
          //           ))
          //     ],
          //     onChanged: (value) async {
          //       if (value == 'logout') {
          //         await FirebaseAuth.instance.signOut();
          //         Navigator.push(context,
          //             CupertinoPageRoute(builder: ((context) => HomeScreen())));
          //       }
          //       if(value == 'account'){
          //         final userID = FirebaseAuth.instance.currentUser!.uid;
          //         Navigator.push(context,
          //             CupertinoPageRoute(builder: ((context) => establishmentAccount(uid: userID))));
          //       }
          //     })
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.qr_code_scanner_outlined,
              size: 300,
            ),
            ElevatedButton(
              onPressed: () async {
                String COLOR_CODE = '#ffffff';
                String CANCEL_BUTTON_TEXT = 'CANCEL';
                bool isShowFlashIcon = true;
                ScanMode scanMode = ScanMode.QR;

                String qr = await FlutterBarcodeScanner.scanBarcode(
                    COLOR_CODE, CANCEL_BUTTON_TEXT, isShowFlashIcon, scanMode);

                if (qr != '-1') {
                  final DocumentReference documentRef =
                      FirebaseFirestore.instance.collection('user').doc(qr);
                  final DocumentSnapshot snapshot = await documentRef.get();

                  if (snapshot.exists) {
                    //log firestore
                    EasyLoading.show(status: 'Processing...');
                    String collectionPath = 'user';
                    FirebaseFirestore.instance.collection(collectionPath).add({
                      'client_uid': qr,
                      'establishment_uid':
                          FirebaseAuth.instance.currentUser!.uid,
                      'datetime': DateTime.now(),
                    });
                    EasyLoading.showSuccess('QR Code Logged Successfully.');
                    print('Document exists.');
                  } else {
                    EasyLoading.showError(('User QR code not found.'));
                  }
                }
              },
              style: ElevatedButton.styleFrom(shape: roundedShape),
              child: const Text('Scan'),
            ),
          ],
        ),
      )),
    );
  }
}
