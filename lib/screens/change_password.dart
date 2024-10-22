import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _currentMailController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _onChangePass() {
      final temptCurrent = _currentMailController.text;
      final temptNew = _newPassController.text;
      final currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        _isLoading = true;
      });

      if ((temptCurrent.trim().isEmpty || temptNew.trim().isEmpty) &&
          (temptCurrent.length < 6 || temptNew.length < 6) &&
          temptCurrent != currentUser!.email) {
        return;
      }

      currentUser!.updatePassword(temptNew).then((_) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Change Password Sucsessfull')));
        setState(() {
          _isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }

    return Scaffold(
      appBar: AppBar(
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
                controller: _currentMailController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    border: InputBorder.none,
                    labelText: 'Current Mail'),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
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
                controller: _newPassController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 16),
                    border: InputBorder.none,
                    labelText: 'New Password'),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              const Spacer(),
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextButton(
                            onPressed: _onChangePass,
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
            ],
          )
        ],
      )),
    );
  }
}
