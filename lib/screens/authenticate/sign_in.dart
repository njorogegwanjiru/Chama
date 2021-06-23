import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/assets/widget/bezierContainer.dart';
import 'package:group/screens/authenticate/forgotPassword.dart';
import 'package:group/screens/home/home.dart';
import 'package:group/services/auth.dart';
import 'dart:math';

class SignIn extends StatefulWidget {
  final String title;

  const SignIn({Key key, this.title}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final __formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _entryField(String title, TextEditingController controller, String err,TextInputType type,{bool isPassword = false} ) {
    return TextFormField(
        keyboardType: type,

        validator: (val) => val.isEmpty ? err : null,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            labelText: title,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            isDense: true,
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.orangeAccent, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.orange, width: 1.0),
            ),
            fillColor: Colors.white,
            filled: true));
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (__formKey.currentState.validate()) {
          setState(() {
            loading = true;
          });

          dynamic result = await _auth.signInWithEmailPassword(
              emailController.text, passwordController.text);
          if (result == null) {
            setState(() {
              error = 'Could not sign in..';
              loading = false;
            });
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xfffbb448),
                  Color(0xfff7892b),
                ])),
        child: Text(
          'Sign In',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _anonymousSignIn() {
    return InkWell(
      onTap: () async {
        dynamic result = await _auth.signInAnon();
        if (result == null) {
          print("Error");
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          'Sign in Anonymously..👀👀',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '👑',
          style: TextStyle(fontSize: 30),
        ),
        Text(
          'Qu',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 50),
        ),
        Text(
          'ee',
          style: TextStyle(color: Colors.black, fontSize: 28),
        ),
        Text(
          'nS',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 50),
        ),
        Text(
          '👑',
          style: TextStyle(fontSize: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          child: loading
              ? Center(
                  child: ColorLoader3(
                    dotRadius: 20,
                    radius: 40,
                  ),
                )
              : Stack(
                  children: <Widget>[
                    Positioned(
                        top: -height * .2,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer(
                          angle: -pi / 4,
                        )),
                    Positioned(
                        top: height * .7,
                        right: MediaQuery.of(context).size.width * .3,
                        child: BezierContainer(
                          angle: pi / 1.485,
                        )),
                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: height * .09),
                            _title(),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              child: Column(
                                children: [
                                  Form(
                                      key: __formKey,
                                      child: Column(
                                        children: [
                                          _entryField("Email", emailController,
                                              "Enter your email",TextInputType.emailAddress),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          _entryField(
                                              "Password",
                                              passwordController,
                                              "Enter Password",TextInputType.numberWithOptions(),
                                              isPassword: true),
                                        ],
                                      )),
                                  SizedBox(height: 10),
                                  error == ''
                                      ? SizedBox(
                                          height: 1,
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$error😐😐',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ),
                                  _submitButton(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.centerRight,
                                      child: Text('Forgot Password ?',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 20),
                            // _divider(),
                            // SizedBox(height: 20),
                            // _anonymousSignIn(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
