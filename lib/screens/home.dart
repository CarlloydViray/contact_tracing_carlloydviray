import 'package:contact_trace/constants/style_constants.dart';
import 'package:contact_trace/screens/login.dart';
import 'package:contact_trace/screens/register_client.dart';
import 'package:contact_trace/screens/register_establishment.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              alignment: Alignment.bottomCenter,
              opacity: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contact Trace',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'A contact tracing app for mobility of MAD students',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 16,
              ),
              // Image.asset('assets/images/background.png'),
              Text(
                'Welcome! Please login or signup.',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  shape: roundedShape,
                ),
                child: const Text(
                  'Login',
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterClientScreen(),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: roundedShape,
                ),
                child: const Text(
                  'Sign Up as Client',
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterEstablishmentScreen(),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: roundedShape,
                  backgroundColor: Colors.white60,
                ),
                child: const Text(
                  'Sign Up as Establishment',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
