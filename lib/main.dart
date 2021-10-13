import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:social_media_integration/sign_in.dart';
import 'package:social_media_integration/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignInProvider(),
      child: const MaterialApp(
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                padding: const EdgeInsets.only(left: 20,right: 20,top: 3,bottom: 3),
                onPressed: () {
                  final provider = Provider.of<SignInProvider>(context, listen: false);
                  provider.googleLogin();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              ),
              const SizedBox(height: 20,),
              SignInButton(
                Buttons.Facebook,
                padding: const EdgeInsets.only(left: 20,right: 20,top: 3,bottom: 3),
                text: "Sign up with Facebook",
                onPressed: () {
                  final provider = Provider.of<SignInProvider>(context, listen: false);
                  provider.facebookLogin();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


