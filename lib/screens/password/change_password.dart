import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/password/verification_code.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _currentMailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _onGetEmailOTP() {
      if (_currentMailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter email field')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      EmailOTP.config(
        appName: 'News App',
        otpType: OTPType.numeric,
        emailTheme: EmailTheme.v6,
        otpLength: 4,
      );
      EmailOTP.sendOTP(email: _currentMailController.text).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => VertificationCode(
                  emailSent: _currentMailController.text,
                )));
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
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: _onGetEmailOTP,
                                child: const Text(
                                  'Send',
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
