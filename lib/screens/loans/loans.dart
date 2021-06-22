import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/loan.dart';
import 'package:group/models/member.dart';
import 'package:group/models/user.dart';
import 'package:group/screens/loans/filterLoans.dart';
import 'package:group/screens/loans/updateLoans.dart';
import 'package:group/services/apiCalls.dart';
import 'package:provider/provider.dart';

class Loans extends StatefulWidget {
  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  Future<List<Loan>> loans;
  Future<List<Member>> members;

  List _loans = [];
  List _members = [];

  Future<String> memberName;

  String filtered = "all";
  String filteredId;
  bool selectedYear = false;

  @override
  void initState() {
    super.initState();
    loans = API().getLoans();
    members = API().getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          semanticLabel: "Filter Loans",
                          content: Container(height: 500, child: FilterLoan()));
                    }).then((value) {
                  loadFilter(value);
                  refresh();
                });
              }),
          Expanded(
            child: FutureBuilder(
                future: Future.wait([loans, members]),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    _loans = snapshot.data[0];
                    print('$_loans');
                    _members = snapshot.data[1];

                    performFilter(filtered, snapshot.data[0]);

                    _loans.sort((a,b){
                      return b.loanId.compareTo(a.loanId);
                    });


                    return _loans.isEmpty
                        ? Center(child: Text('No loans match that criteria😶😶'))
                        :
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _loans.length,
                        itemBuilder: (BuildContext context, int index) {
                          return loanItem(index, context);
                        },
                      ),
                    );
                  }
                  return Center(
                    child: ColorLoader3(
                      dotRadius: 20,
                      radius: 40,
                    ),
                  );
                }),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Colors.orangeAccent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(content: NewLoan());
                      }).then((value) {
                    setState(() {
                      loans = API().getLoans();
                    });
                    if (value) refresh();
                  });
                },
                child: Text(
                  'Request Loan',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loanItem(int index, BuildContext context) {
    List mbr = _members
        .where((element) => element.id == _loans[index].memberId)
        .toList();
    String name = mbr[0].name;
    return Card(
      color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Who🤑:  '),
              Text(name),
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('How Much💸: '),
              Text('${_loans[index].amountBorrowed}'),
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('When⌚:  '),
              Text('${_loans[index].dateBorrowed}'),
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Status👀: '),
              Text('${_loans[index].status}'),
            ]),
            Divider(),
            _loans[index].status == "Unpaid"
                ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mark As Paid✔ '),
                  InkWell(
                    onTap: () {
                      var user =
                      Provider.of<UserModel>(context, listen: false);
                      String memberId = user.uid;
                      memberId == "G1qruc3IImTFbjpQcwuFZG9rTM62"
                          ? API()
                          .changeLoanStatus(
                          _loans[index].loanId, "Paid")
                          .then((value) {
                        setState(() {
                          loans = API().getLoans();
                        });
                      })
                          : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                height: 50,
                                width:
                                MediaQuery.of(context).size.width,
                                child: Text(
                                    '👀 You are not the treasurer🤷‍♀️🤷‍♀️'),
                              ),
                              actions: [
                                InkWell(
                                  child: Text(
                                    'Okay Then..🤦‍♀️',
                                    style:
                                    TextStyle(color: Colors.blue),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      'Change to Paid',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ])
                : _loans[index].status == "Pending"
                ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Confirm Paid out✔ '),
                  InkWell(
                    onTap: () {
                      var user = Provider.of<UserModel>(context,
                          listen: false);
                      String memberId = user.uid;
                      memberId == "G1qruc3IImTFbjpQcwuFZG9rTM62"
                          ? API()
                          .changeLoanStatus(
                          _loans[index].loanId, "Unpaid")
                          .then((value) {
                        setState(() {
                          loans = API().getLoans();
                        });
                      })
                          : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                height: 50,
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                                child: Text(
                                    '👀You are not the treasurer🤷‍♀️🤷‍♀️'),
                              ),
                              actions: [
                                InkWell(
                                  child: Text(
                                    'Okay Then..🤦‍♀️',
                                    style: TextStyle(
                                        color: Colors.blue),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      'Confirm Paid out',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ])
                : Row(),
          ],
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  performFilter(filter, data) {
    filter == "unpaid"
        ? _loans = data.where((element) => element.status == "Unpaid").toList()
        : filter == "pending"
        ? _loans =
        data.where((element) => element.status == "Pending").toList()
        : filter == "paid"
        ? _loans =
        data.where((element) => element.status == "Paid").toList()
        : filter == "2019"
        ? _loans = data
        .where((element) =>
    element.dateBorrowed.substring(9) == "9")
        .toList()
        : filter == "2020"
        ? _loans = data
        .where((element) =>
    element.dateBorrowed.substring(9) == "0")
        .toList()
        : filter == "2021"
        ? _loans = data
        .where((element) =>
    element.dateBorrowed.substring(9) == "1")
        .toList()
        : filter == "member"
        ? _loans = data
        .where((element) =>
    element.memberId == filteredId)
        .toList()
        : filter == "all"
        ? _loans = data
        : _loans = data;
  }

  loadFilter(parameter) {
    if (parameter == "unpaid") {
      setState(() {
        filtered = "unpaid";
      });
    } else if (parameter == "paid") {
      setState(() {
        filtered = "paid";
      });
    } else if (parameter == "all") {
      setState(() {
        filtered = "all";
      });
    } else if (parameter == "pending") {
      setState(() {
        filtered = "pending";
      });
    } else if (parameter == "2019") {
      setState(() {
        filtered = "2019";
      });
      print("passed on");
    } else if (parameter == "2020") {
      setState(() {
        filtered = "2020";
      });
    } else if (parameter == "2021") {
      setState(() {
        filtered = "2021";
      });
    } else {
      setState(() {
        filtered = "member";
        filteredId = parameter;
      });
    }
  }
}
