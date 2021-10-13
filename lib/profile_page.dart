import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_integration/sign_in.dart';
import 'homepage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        FlatButton(
                          child: const Text("NO"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text("YES"),
                          onPressed: () {
                            final provider = Provider.of<SignInProvider>(context, listen: false);
                            provider.googleLogOut();
                            provider.facebookLogOut();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                          },
                        )
                      ],
                    ));
              },
              child: const Icon(Icons.power_settings_new, color: Colors.white,),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text("There is no expense");
              return ListView(
                  padding: const EdgeInsets.only(top: 100),
                  children: getProfile(snapshot));
            }),
      );
  }

  getProfile(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((doc) => Column(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(doc["imageUrl"]),
        ),
        const SizedBox(height: 20,),
        Text(
          "Name:- ${doc["name"]}",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        const SizedBox(height: 20,),
        Text(
          "Email:- ${doc["email"]}",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
      ],
    )).toList();
  }
}