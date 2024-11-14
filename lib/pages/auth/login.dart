/// create a simple login page with a username and password field
/// if the user logs in successfully, pop the current page

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mtg_scanner/utils/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            // Add a password field to the form with a label 'Password' and a controller _passwordController
            // make the form field obscureText to hide the password and add a button to show the password
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
            ElevatedButton(
              onPressed: () async {
                log('Logging in with username: ${_usernameController.text}');
                log('Logging in with password: ${_passwordController.text}');
                final token = await loginWithEmailPassword(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (token != null) {
                  context.pop(token);
                }
              },
              child: const Text('Login'),
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
}
