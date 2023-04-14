import 'package:contact_trace/screens/client_account.dart';
import 'package:contact_trace/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientScreen extends StatelessWidget {
  final String UserID;

  const ClientScreen({super.key, required this.UserID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My QR',
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
                          builder: ((context) => clientAccount(uid: userID))));
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
          //       if (value == 'account') {
          //         final userID = FirebaseAuth.instance.currentUser!.uid;
          //         Navigator.push(
          //             context,
          //             CupertinoPageRoute(
          //                 builder: ((context) => clientAccount(uid: userID))));
          //       }
          //     })
        ],
      ),
      body: Center(
        child: QrImage(
          data: UserID,
          size: 300,
        ),
      ),
    );
  }
}
