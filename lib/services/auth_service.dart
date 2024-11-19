import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/screens/tabs/tabs.dart';

class AuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ["publish_video", "email"]);

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)", // Trường dữ liệu cần lấy
        );
        print(userData);
        // Tiếp tục với Firebase Authentication nếu cần
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TabsScreen(
                      userData: userData,
                    )));
        // ...
      } else {
        // Xử lý khi người dùng hủy đăng nhập hoặc có lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${result.message}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $error')),
      );
    }
  }
}
