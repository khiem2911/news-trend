import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/services/auth_service.dart';
import 'package:news_app/widgets/user_image_picker.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> {
  bool _isVisiblePassword = false;
  final keyForm = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUserName = '';
  bool _isAuth = false;
  bool _isLoading = false;
  File? _selectedImage;

  void _onSubmit() async {
    final isValidated = keyForm.currentState!.validate();

    setState(() {
      _isLoading = true;
    });

    if (!isValidated) {
      return;
    }

    keyForm.currentState!.save();

    try {
      if (_isAuth) {
        final userCredential = await auth.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _enteredUserName,
          'email': _enteredEmail,
          'image_url': imageUrl
        });
      } else {
        _signIn();
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed')));
    }
  }

  void _signIn() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Email không hợp lệ.';
          break;
        case 'user-disabled':
          message = 'Tài khoản của bạn đã bị vô hiệu hóa.';
          break;
        case 'user-not-found':
          message = 'Không tìm thấy người dùng với email này.';
          break;
        case 'wrong-password':
          message = 'Mật khẩu không chính xác.';
          break;
        default:
          message = 'Đã xảy ra lỗi. Vui lòng thử lại.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 6),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: const Text(
                      'News',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    )),
                Text(
                  'Tren.',
                  style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: 14, bottom: 14),
              child: Text(
                'Start exploring various hottest news topics around the world with us.',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: keyForm,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email @';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _enteredEmail = value!;
                                });
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Email Adress',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (_isAuth)
                              TextFormField(
                                style: const TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter valid username';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _enteredUserName = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'User Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              autocorrect: false,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.length < 6) {
                                  return 'Please enter password length at least > 6';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _enteredPassword = value!;
                                });
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisiblePassword =
                                            !_isVisiblePassword;
                                      });
                                    },
                                    icon: Icon(_isVisiblePassword == false
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: Colors.orange,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              obscureText: !_isVisiblePassword,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (_isAuth)
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                          ],
                        )),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            color: Theme.of(context).colorScheme.primary),
                        child: TextButton(
                            onPressed: _onSubmit,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    !_isAuth ? 'Login' : 'Register',
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Or sign in with'),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                AuthService().signInWithFacebook(context),
                            icon: Image.asset(
                              'assets/images/facebook_icon.png',
                              height: 25,
                              width: 25,
                            ),
                            label: const Text(
                              'Facebook',
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => AuthService().signInWithGoogle(),
                            icon: Image.asset(
                              'assets/images/google_icon.png',
                              height: 25,
                              width: 25,
                            ),
                            label: const Text('Google'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(!_isAuth
                            ? 'Dont have an account?'
                            : 'Already have an account?'),
                        InkWell(
                          child: Text(
                            !_isAuth ? 'Sign up' : 'Login',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          onTap: () {
                            setState(() {
                              _isAuth = !_isAuth;
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
