import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/provider/saved_provider.dart';
import 'package:news_app/provider/user_provider.dart';
import 'package:news_app/screens/auth/auth.dart';
import 'package:news_app/screens/password/change_password.dart';
import 'package:news_app/widgets/profile_item.dart';

FirebaseAuth currentAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _onSignOut(BuildContext context) async {
    final fbToken = await FacebookAuth.instance.accessToken;

    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
      return;
    } else if (fbToken != null) {
      await FacebookAuth.instance.logOut();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Auth(),
        ),
      );
      return;
    }

    await currentAuth.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, String> user = ref.read(UserProvider);
    final savedLength = ref.read(SavedProvider).length;
    final email = currentAuth.currentUser?.email ?? user['email'];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['userImage']!),
              )),
          const SizedBox(
            height: 8,
          ),
          Text(
            user['name']!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(email!),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ProfileItem(count: 0, type: 'Interesting'),
                ProfileItem(count: savedLength, type: 'Saved'),
                const ProfileItem(count: 0, type: 'Following')
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                },
                leading: const Icon(
                  Icons.key,
                  color: Colors.orange,
                  size: 20,
                ),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_rounded),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton.icon(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _onSignOut(context);
                  },
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
