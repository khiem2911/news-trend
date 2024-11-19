import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/password/reset_password.dart';
import 'package:pinput/pinput.dart';

class VertificationCode extends StatelessWidget {
  const VertificationCode({super.key, required this.emailSent});
  final String emailSent;

  @override
  Widget build(BuildContext context) {
    TextEditingController _pinController = TextEditingController();

    void _onVerificationCode() {
      final emailCode = EmailOTP.getOTP();
      final pinEntered = _pinController.text;

      if (emailCode == pinEntered) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const ResetPassword()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please check your code in email again')));
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Verification Code')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We sent a verification code to',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              emailSent,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
                child: Pinput(
              controller: _pinController,
            )),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: _onVerificationCode,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange),
                child: const Text(
                  'Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
