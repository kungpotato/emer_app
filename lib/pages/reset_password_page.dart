import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/utils/validator_utils.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showCheckEmailDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check Your Email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We have sent a password reset link to your email.'),
                Text(
                    'Please check your inbox and follow the instructions to reset your password.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetPassword() async {
    await context.authStore.auth
        .sendPasswordResetEmail(email: _emailController.text);
    _showCheckEmailDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      extendBody: true,
      appBar: AppBar(
        title: Text('Reset Password'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (!ValidatorUtils.isValidEmail(value ?? '')) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
