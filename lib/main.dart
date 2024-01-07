import 'package:countdowntimer/displaypage.dart';
import 'package:countdowntimer/eventinput.dart';
import 'package:countdowntimer/firebase_options.dart';
import 'package:countdowntimer/homepage.dart';
import 'package:countdowntimer/login.dart';
import 'package:countdowntimer/register.dart';
import 'package:countdowntimer/testing.dart';
import 'package:flutter/material.dart';
import 'countdown_input_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Display();
          // Fetchevents();
        } else {
          return LoginPage();
        }
      },
    ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Countdown Timer App!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventInput(),
                  ),
                );
              },
              child: const Text('Start Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
