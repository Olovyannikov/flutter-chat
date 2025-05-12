import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/pages.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign_up_screen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _username = "";
  String _password = "";

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Social Media App',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter your email",
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_usernameFocusNode);
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your email';
              
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    focusNode: _usernameFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter your username",
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    onSaved: (value) {
                      _username = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your user name';
              
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: "Enter your password",
                    ),
                    onFieldSubmitted: (_) {},
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter your password';
                      if (value.length < 5) {
                        return 'Password must contains at least 5 characters';
                      }
              
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 16,),
                  TextButton(onPressed: () {}, child: Text('Sign Up')),
                  TextButton(onPressed: () {
                    Navigator.of(context).pushReplacementNamed(SignInScreen.id);
                  }, child: Text('Sign In Instead')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
