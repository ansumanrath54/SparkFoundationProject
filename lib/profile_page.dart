import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
              const SizedBox(height: 20,),
              Text(
                "Name:- ${user.displayName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                "Email:- ${user.email}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
