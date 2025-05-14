import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/entities/User/user_entity.dart';
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

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    context.read<AuthCubit>().signUp(username: _username, email: _email, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          if (currentState is AuthSignedUp) {
            // Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }

          if (currentState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(currentState.message),
                )
            );
          }
        },
        builder: (BuildContext context, AuthState currentState) {
          if (currentState is AuthLoading) {
            return Center(
                child: CircularProgressIndicator()
            );
          }

          return SafeArea(
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
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
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
                      TextButton(onPressed: () {
                        _submit(context);
                      }, child: Text('Sign Up')),
                      TextButton(onPressed: () {
                        Navigator.of(context).pushReplacementNamed(SignInScreen.id);
                      }, child: Text('Sign In Instead')),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
