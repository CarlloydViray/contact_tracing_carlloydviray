import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_trace/firebase_options.dart';
import 'package:contact_trace/screens/client.dart';
import 'package:contact_trace/screens/establishment.dart';
import 'package:contact_trace/screens/home.dart';
import 'package:contact_trace/screens/login.dart';
import 'package:contact_trace/screens/register_client.dart';
import 'package:contact_trace/screens/register_establishment.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

//!!! CONTACT TRACING APP
//TODO
//!1. Registration of a) clients/ users b) Establishments
//2. Login a) clients/users b) esbtablishments
//3. Generate QR codes
//4. Scan QR codes
//5. Trace

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ContactTrace());
}

class ContactTrace extends StatelessWidget {
  const ContactTrace({super.key});

  // String login() async {
  //   //get current logged in
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   final doc =
  //       await FirebaseFirestore.instance.collection('user').doc(uid).get();
  //   dynamic data = doc.data();
  //   return data['type'];
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
              fontSize: 14,
              // fontWeight: FontWeight.bold,
              color: Colors.black38),
          displayMedium: TextStyle(
            fontSize: 18,
            // fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[200],
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
      
      
      // StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       // show loading indicator while waiting for authentication data
      //       return CircularProgressIndicator();
      //     } else if (snapshot.data == null) {
      //       // show login page if there is no authenticated user
      //       return LoginScreen();
      //     } else {
      //       // show the authenticated user's data
      //       return EstablishmentScreen();
      //     }
      //   },
      // ),
      builder: EasyLoading.init(),
    );

   
  }
}