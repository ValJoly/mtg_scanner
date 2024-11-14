/**
 * File: /lib/pages/auth/register.dart
 * create a simple register page with a username and password field and a button to register
 * make the password field double as a confirm password field
 * if the user registers successfully, pop the current page with the user's token
 * if the user already exists, show an error message
 */

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/utils/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                    onPressed: showPassword,
                    icon: Icon(isPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off)),
              ),
              obscureText: isPasswordObscure,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                    onPressed: showConfirmPassword,
                    icon: Icon(isConfirmPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off)),
              ),
              obscureText: isConfirmPasswordObscure,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  log('Passwords do not match');
                  context.push('/show_dialog/Error/Passwords do not match');
                  return;
                }
                final token = await registerWithEmailPassword(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (token != null) {
                  log('Registered successfully');
                  GoRouter.of(context).pop(token);
                } else {
                  log('Error registering');
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      isPasswordObscure = !isPasswordObscure;
    });
  }

  void showConfirmPassword() {
    setState(() {
      isConfirmPasswordObscure = !isConfirmPasswordObscure;
    });
  }
}
