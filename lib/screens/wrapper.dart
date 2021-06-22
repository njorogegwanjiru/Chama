import 'package:flutter/material.dart';
import 'package:group/models/user.dart';
import 'package:provider/provider.dart';

import 'authenticate/sign_in.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    if (user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}
