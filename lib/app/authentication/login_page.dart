import 'package:emer_app/app/authentication/logo_widget.dart';
import 'package:emer_app/app/authentication/signup_page.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/pages/reset_password_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/utils/validator_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'test@mail.com');
  final _passwordController = TextEditingController(text: '12345678');

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: context.hideKeyBoard,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('assets/images/shape.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: isLoad
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 60),
          const Center(child: LogoWidget()),
          const SizedBox(height: 50),
          Text(
            'Member',
            style: context.theme.textTheme.headlineMedium
                ?.copyWith(color: context.theme.primaryColor),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(
                    0,
                    2,
                  ), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!ValidatorUtils.isValidEmail(value)) {
                  return 'Incorrect Email';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(
                    0,
                    2,
                  ), // changes position of shadow
                ),
              ],
            ),
            child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              obscureText: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute<void>(
                    builder: (context) => ResetPasswordPage(),));
                },
                child: Text(
                  'Forgot password',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        isLoad = true;
                      });
                      await context.authStore.login(
                        _emailController.value.text,
                        _passwordController.value.text,
                      );
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                        setState(() {
                          isLoad = false;
                        });
                      }
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('LOGIN'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Or login with',
              style: context.theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: InkWell(
              onTap: () async {
                try {
                  setState(() {
                    isLoad = true;
                  });
                  await context.authStore.signInWithGoogle();
                } catch (err, st) {
                  handleError(err, st);
                }
                setState(() {
                  isLoad = false;
                });
              },
              child: Image.asset(
                'assets/images/devicon_google.png',
                fit: BoxFit.cover,
                width: 35,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Dont't have account?",
                style: context.theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: Text(
                  'Sign up',
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
