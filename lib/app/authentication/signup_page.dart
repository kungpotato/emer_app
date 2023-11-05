import 'package:emer_app/app/authentication/logo_widget.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:emer_app/shared/utils/validator_utils.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: context.hideKeyBoard,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: context.theme.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: context.theme.primaryColor,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('assets/images/shape.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: LogoWidget(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'REGISTER',
                            style:
                                context.theme.textTheme.headlineSmall?.copyWith(
                              color: context.theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
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
                        const SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
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
                            controller: _passwordController2,
                            decoration: const InputDecoration(
                              hintText: 'Confirm password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please re-enter your password';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_passwordController.value.text ==
                                      _passwordController2.value.text) {
                                    context.authStore.register(
                                      _emailController.value.text,
                                      _passwordController.value.text,
                                    );
                                  } else {
                                    showSnack(
                                      context,
                                      text: 'Incorrect password',
                                    );
                                  }
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('SIGN UP'),
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
                            onTap: context.authStore.signInWithGoogle,
                            child: Image.asset(
                              'assets/images/devicon_google.png',
                              fit: BoxFit.cover,
                              width: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
