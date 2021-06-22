import 'dart:math';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/assets/widget/bezierContainer.dart';
import 'package:group/screens/authenticate/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final TextEditingController emailController = new TextEditingController();
    bool linkSent = false;

    Future resetPassword(String email) async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }

    @override
    void dispose() {
      emailController.dispose();
      super.dispose();
    }

    Widget _entryField(
        String title, TextEditingController controller, String err,
        {bool isPassword = false}) {
      return TextFormField(
          validator: (val) => val.isEmpty ? err : null,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
              labelText: title,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
          if (formKey.currentState.validate()) {
            resetPassword(emailController.text).then((value) {
              setState(() {
                linkSent = true;
              });
              CoolAlert.show(
                      backgroundColor: Colors.orange[100],
                      confirmBtnColor: Color(0xfff7892b),
                      context: context,
                      type: CoolAlertType.success,
                      text: 'Reset Link sent to email!',
                      cancelBtnText: "Sign In")
                  .whenComplete(() => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => SignIn()))
                      });
            }).catchError((error) {
              CoolAlert.show(
                  context: context, type: CoolAlertType.error, text: "$error");
            });
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
            'Send me the password reset link',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
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

    return SafeArea(
        child: Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
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
            Positioned(
                top: 30,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Password?",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height * .02),
                    _title(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: Column(
                        children: [
                          Form(
                            child: Column(
                              children: [
                                _entryField("Email", emailController,
                                    "Enter your email"),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                            key: formKey,
                          ),
                          _submitButton(),
                          SizedBox(height: 20),
                          _divider(),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Text('Sign In',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
