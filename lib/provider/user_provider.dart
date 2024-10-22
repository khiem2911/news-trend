import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNotifier extends StateNotifier<Map<String, String>> {
  UserNotifier() : super({});

  void getUser(Map<String, dynamic>? fbData) async {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (fbData != null) {
      state = {
        'name': fbData['name'],
        'email': fbData['email'],
        'userImage': fbData['picture']['data']['url']
      };
      return;
    }

    if (currentUser!.displayName != null) {
      state = {
        'name': currentUser.displayName!,
        'userImage': currentUser.photoURL!
      };
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((ds) {
      state = {
        'name': ds.data()?['username'],
        'userImage': ds.data()?['image_url']
      };
    });
  }
}

final UserProvider =
    StateNotifierProvider<UserNotifier, Map<String, String>>((ref) {
  return UserNotifier();
});
