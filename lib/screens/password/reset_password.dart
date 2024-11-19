import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/profile/profile.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _onSavePassword() async {
      if (_passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill password field')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.currentUser!
          .updatePassword(_passwordController.text)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Update Password Sucsessfull')));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => const ProfileScreen()),
            (Route<dynamic> route) => false);
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change Password'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 1, color: Colors.orange)),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    border: InputBorder.none,
                    labelText: 'New Password'),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: _onSavePassword,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(25)),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
