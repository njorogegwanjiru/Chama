import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/paymentsandtransactions.dart';
import 'package:group/models/user.dart';
import 'package:group/services/apiCalls.dart';
import 'package:provider/provider.dart';

class Statement extends StatefulWidget {
  final List pNtList;

  Statement({Key key, @required this.pNtList}) : super(key: key);

  @override
  _StatementState createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List _pNtList = widget.pNtList;


    return _pNtList.isEmpty? Center(child: Text('Nothing to see here..😶😶')):
    Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: _pNtList.length,
        itemBuilder: (BuildContext context, int index) {

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_pNtList[index].date}',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _pNtList[index].type == 'Payment'
                                    ? Colors.green
                                    : Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: 100,
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Center(
                            child: _pNtList[index].type == 'Payment'
                                ? Text(
                                    'Money In ⤵',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  )
                                : Text(
                                    'Money Out ⤴',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                            // child: Text(
                            //   '${_pNtList[index].type}',
                            //   style: TextStyle(
                            //       fontSize: 12, color: Colors.black87),
                            // ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_pNtList[index].member}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        _pNtList[index].type == 'Transaction'
                            ? Text(
                                '-' +
                                    'Ksh.' +
                                    '${_pNtList[index].amount}' +
                                    '.00',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                '+' +
                                    'Ksh.' +
                                    '${_pNtList[index].amount}' +
                                    '.00',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _pNtList[index].type == 'Transaction'
                        ? Row(
                            children: [
                              Text(
                                "Purpose: ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${_pNtList[index].purpose}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          )
                        : Text('')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
