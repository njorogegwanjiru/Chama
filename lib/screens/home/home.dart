import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/user.dart';
import 'package:group/screens/home/components/header.dart';
import 'package:group/services/apiCalls.dart';
import 'package:provider/provider.dart';
import 'components/menus.dart';
import 'package:group/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  Future<UserModel> userObject;
  String memberId;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Text('🚶‍♀️Are you sure you want to exit?👀👀'),
            ),
            actions: <Widget>[
              InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.of(context).pop(false);
                },
              ),
              SizedBox(
                width: 12,
              ),
              InkWell(
                child: Text(
                  'I\'m sure😏',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    setState(() {
      memberId = user.uid;
    });

    userObject = API().getCurrentMember(memberId);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.orange[50],
              child: Container(
                height: 50,
                width: 50,
                child: Center(
                  child: FutureBuilder(
                      future: userObject,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.name[0]);
                        } else {
                          return Text("?");
                        }
                      }),
                ),
              ),
            ),
            onPressed: () {},
          ),
          title: Header(),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => this.widget));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                CoolAlert.show(
                  context: context,
                  backgroundColor: Colors.orange[100],
                  confirmBtnColor: Color(0xfff7892b),
                  type: CoolAlertType.confirm,
                  cancelBtnText: "Cancel",
                  confirmBtnText: "Log out",
                  onConfirmBtnTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      loading = true;
                    });
                    await AuthService().signUserOut();
                  },
                );
              },
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Menus(),],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
