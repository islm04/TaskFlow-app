import 'package:flutter/material.dart';
import 'package:taskflow/components/my_button.dart';
import 'package:taskflow/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // email and password controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // email and password focusNode
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPwFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPwFocusNode.dispose();
    super.dispose();
  }

  void register() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // dismiss keyboard on tap outside
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 120,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 20),
              // let's create an account text
              Text(
                "Let's create an account for you",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),

              // username textfield
              MyTextfield(
                controller: _usernameController,
                hintText: "Username",
                focusNode: _usernameFocusNode,
                obscureText: false,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocusNode),
              ),

              const SizedBox(height: 10),

              // email textfield
              MyTextfield(
                controller: _emailController,
                hintText: "Email",
                focusNode: _emailFocusNode,
                obscureText: false,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocusNode),
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextfield(
                controller: _passwordController,
                hintText: "Password",
                focusNode: _passwordFocusNode,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_confirmPwFocusNode),
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextfield(
                controller: _confirmPwController,
                hintText: "Confirm Password",
                focusNode: _confirmPwFocusNode,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  // Optionally trigger login
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 10),

              // login button
              MyButton(text: "Register", onTap: register),

              const SizedBox(height: 25),

              // Already have an account? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
