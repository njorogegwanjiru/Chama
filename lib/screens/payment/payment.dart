import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/paymentsandtransactions.dart';
import 'package:group/models/statistics.dart';
import 'package:group/models/user.dart';
import 'package:group/screens/payment/statement.dart';
import 'package:group/services/apiCalls.dart';
import 'package:provider/provider.dart';

class MakePayment extends StatefulWidget {
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  Future<Statistics> statistics;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final paymentAmountController = TextEditingController();
  final transactionAmountController = TextEditingController();
  final purposeController = TextEditingController();

  int grossContr, netContr, transactionCosts;
  int newGrossContr, newNetContr, newSpentCash;
  double newTotalWorth, totalWorth, newCashInAcc, cashInAcc;
  bool loading = false;
  bool viewingStatement = false;
  String filtered = "all";

  Future<List<PaymentsAndTransactions>> pNtList;
  List _pNtList;
  String _memberName;
  String memberId;

  @override
  void initState() {
    super.initState();
    pNtList = API().getPaymentsAndTransactions();
    statistics = API().getStatistics();

    final user = Provider.of<UserModel>(context, listen: false);
    API().getMemberName(user.uid).then((value) {
      setState(() {
        _memberName = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    paymentAmountController.dispose();
    transactionAmountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return viewingStatement
        ? Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.sort),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  semanticLabel: "Filter Transactions",
                                  content: Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                      children: ListTile.divideTiles(
                                          context: context,
                                          tiles: [
                                            ListTile(
                                              title:
                                                  Text('View All Transactions'),
                                              onTap: () {
                                                Navigator.pop(context, "all");
                                              },
                                            ),
                                            ListTile(
                                              title: Text('View Payments'),
                                              onTap: () {
                                                Navigator.pop(
                                                    context, "payments");
                                              },
                                            ),
                                            ListTile(
                                              title: Text('View Expenditure'),
                                              onTap: () {
                                                Navigator.pop(
                                                    context, "expenditure");
                                              },
                                            ),
                                          ]).toList(),
                                    ),
                                  ),
                                );
                              }).then((value) {
                            loadFilter(value);
                            refresh();
                          });
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.close_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            viewingStatement = false;
                            filtered = "all";
                          });
                        }),
                  ],
                ),
                Expanded(
                    child: FutureBuilder(
                  future: API().getPaymentsAndTransactions(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      _pNtList = snapshot.data;

                      performFilter(filtered, snapshot.data);

                      _pNtList.sort((a, b) {
                        return b.pNtId.compareTo(a.pNtId);
                      });

                      return Statement(
                        pNtList: _pNtList,
                      );
                    } else {
                      return Center(child: Text('Nothing to see here...😶😶'));
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: ColorLoader3(
                          dotRadius: 20,
                          radius: 40,
                        ),
                      ),
                    );
                  },
                )),
              ],
            ),
          )
        : Expanded(
            child: FutureBuilder(
              future: statistics,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  grossContr = snapshot.data.grossContributions;
                  netContr = snapshot.data.netContributions;
                  totalWorth = snapshot.data.totalWorth;
                  cashInAcc = snapshot.data.currentCashInAccount;
                  transactionCosts = snapshot.data.transactionCosts;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: ListView(
                      children: [
                        ExpansionPanelList.radio(
                          children: [
                            ExpansionPanelRadio(
                              value: Text(""),
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Record Money In⤵'),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: Text('💰'),
                                    ),
                                  ),
                                );
                              },
                              body: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 3,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              controller:
                                                  paymentAmountController,
                                              onChanged: (value) {},
                                              decoration: InputDecoration(
                                                labelText: 'Amount Paid',
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter Amount';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType
                                                  .numberWithOptions(),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RaisedButton(
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                newCashInAcc = cashInAcc +
                                                    int.parse(
                                                        paymentAmountController
                                                            .text
                                                            .toString());
                                                newGrossContr = grossContr +
                                                    int.parse(
                                                        paymentAmountController
                                                            .text
                                                            .toString());
                                                newNetContr = netContr +
                                                    int.parse(
                                                        paymentAmountController
                                                            .text
                                                            .toString());
                                                newTotalWorth = totalWorth +
                                                    int.parse(
                                                        paymentAmountController
                                                            .text
                                                            .toString());
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      child: AlertDialog(
                                                        title: Text(
                                                          'Confirmation',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'SpecialElite',
                                                          ),
                                                        ),
                                                        content: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Text(
                                                              'Record payment of Ksh. ${int.parse(paymentAmountController.text.toString())}??👀'),
                                                        ),
                                                        actions: <Widget>[
                                                          InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              )),
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          InkWell(
                                                            child: Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            onTap: () {
                                                              API()
                                                                  .updateDetails(
                                                                      'Current Cash in Account',
                                                                      'Gross Contributions',
                                                                      'Net ContributionS',
                                                                      'Total Worth',
                                                                      newCashInAcc,
                                                                      newGrossContr,
                                                                      newNetContr,
                                                                      newTotalWorth)
                                                                  .catchError(
                                                                      (error) {
                                                                CoolAlert.show(
                                                                  context:
                                                                      context,
                                                                  type:
                                                                      CoolAlertType
                                                                          .error,
                                                                  text:
                                                                      "$error",
                                                                );
                                                              }).then((value) {
                                                                Navigator.pop(
                                                                    context);
                                                                API().recordPaymentAndTransaction(
                                                                    " P&T_" +
                                                                        DateTime.now()
                                                                            .year
                                                                            .toString() +
                                                                        '_' +
                                                                        DateTime.now()
                                                                            .day
                                                                            .toString() +
                                                                        '_' +
                                                                        DateTime.now()
                                                                            .minute
                                                                            .toString() +
                                                                        '_' +
                                                                        DateTime.now()
                                                                            .second
                                                                            .toString() +
                                                                        '_' +
                                                                        DateTime.now()
                                                                            .millisecond
                                                                            .toString(),
                                                                    paymentAmountController
                                                                        .text
                                                                        .toString(),
                                                                    "",
                                                                    _memberName,
                                                                    "Payment",
                                                                    DateTime
                                                                                .now()
                                                                            .day
                                                                            .toString() +
                                                                        '/' +
                                                                        DateTime.now()
                                                                            .month
                                                                            .toString() +
                                                                        '/' +
                                                                        DateTime.now()
                                                                            .year
                                                                            .toString() +
                                                                        ' ' +
                                                                        DateTime.now()
                                                                            .hour
                                                                            .toString()
                                                                            .padLeft(2,
                                                                                "0") +
                                                                        ':' +
                                                                        DateTime.now()
                                                                            .minute
                                                                            .toString()
                                                                            .padLeft(2,
                                                                                "0") +
                                                                        ' ' +
                                                                        'hrs');

                                                                setState(() {
                                                                  paymentAmountController
                                                                      .text = '';
                                                                  statistics = API()
                                                                      .getStatistics();
                                                                });
                                                                CoolAlert.show(
                                                                  backgroundColor:
                                                                      Colors.orange[
                                                                          100],
                                                                  confirmBtnColor:
                                                                      Color(
                                                                          0xfff7892b),
                                                                  context:
                                                                      context,
                                                                  type: CoolAlertType
                                                                      .success,
                                                                  text:
                                                                      'Contribution Added!',
                                                                );
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            color: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: BorderSide(
                                                    color: Colors.orange)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: DataTable(columns: [
                                      DataColumn(
                                        label: Text(
                                          'Cash in Account',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          cashInAcc.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ], rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Total Contributions')),
                                          DataCell(Text(
                                              grossContr.toStringAsFixed(2))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Remainder')),
                                          DataCell(Text(
                                              netContr.toStringAsFixed(2))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Total Worth')),
                                          DataCell(Text(
                                              totalWorth.toStringAsFixed(2))),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            ExpansionPanelRadio(
                              value: Text(""),
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text('Record Money Out⤴'),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: Text('💹'),
                                    ),
                                  ),
                                );
                              },
                              body: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Form(
                                      key: _formKey2,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller:
                                                transactionAmountController,
                                            decoration: InputDecoration(
                                              labelText: 'Amount Spent',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Enter Amount';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                          ),
                                          TextFormField(
                                            controller: purposeController,
                                            decoration: InputDecoration(
                                              labelText: 'Purpose',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Enter Purpose';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.text,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();

                                          setState(() {
                                            newCashInAcc = cashInAcc -
                                                int.parse(
                                                    transactionAmountController
                                                        .text
                                                        .toString());

                                            newSpentCash = transactionCosts +
                                                int.parse(
                                                    transactionAmountController
                                                        .text
                                                        .toString());

                                            newNetContr = netContr -
                                                int.parse(
                                                    transactionAmountController
                                                        .text
                                                        .toString());
                                            newTotalWorth = totalWorth -
                                                int.parse(
                                                    transactionAmountController
                                                        .text
                                                        .toString());
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: AlertDialog(
                                                    title: Text(
                                                      'Confirmation',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'SpecialElite',
                                                      ),
                                                    ),
                                                    content: Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Text(
                                                        'Record Transaction of Ksh. ${int.parse(transactionAmountController.text.toString())}??👀',
                                                      ),
                                                    ),
                                                    actions: [
                                                      loading
                                                          ? ColorLoader3(
                                                              radius: 10,
                                                              dotRadius: 4,
                                                            )
                                                          :InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          )),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              loading =
                                                              true;
                                                            });
                                                            API()
                                                                .updateDetails(
                                                                'Current Cash in Account',
                                                                'Transactions Costs',
                                                                'Net ContributionS',
                                                                'Total Worth',
                                                                newCashInAcc,
                                                                newSpentCash,
                                                                newNetContr,
                                                                newTotalWorth)
                                                                .catchError(
                                                                    (error) {
                                                                  CoolAlert
                                                                      .show(
                                                                    context:
                                                                    context,
                                                                    type: CoolAlertType
                                                                        .error,
                                                                    text:
                                                                    "$error",
                                                                  );
                                                                }).then((value) {
                                                              Navigator.pop(
                                                                  context);
                                                              API().recordPaymentAndTransaction(
                                                                  " P&T_" +
                                                                      DateTime.now()
                                                                          .year
                                                                          .toString() +
                                                                      '_' +
                                                                      DateTime.now()
                                                                          .day
                                                                          .toString() +
                                                                      '_' +
                                                                      DateTime.now()
                                                                          .minute
                                                                          .toString() +
                                                                      '_' +
                                                                      DateTime.now()
                                                                          .second
                                                                          .toString() +
                                                                      '_' +
                                                                      DateTime.now()
                                                                          .millisecond
                                                                          .toString(),
                                                                  transactionAmountController
                                                                      .text
                                                                      .toString(),
                                                                  purposeController
                                                                      .text
                                                                      .toString(),
                                                                  _memberName,
                                                                  "Transaction",
                                                                  DateTime.now().day.toString() +
                                                                      '/' +
                                                                      DateTime.now()
                                                                          .month
                                                                          .toString() +
                                                                      '/' +
                                                                      DateTime.now()
                                                                          .year
                                                                          .toString() +
                                                                      ' ' +
                                                                      DateTime.now()
                                                                          .hour
                                                                          .toString() +
                                                                      ':' +
                                                                      DateTime.now()
                                                                          .minute
                                                                          .toString() +
                                                                      ' ' +
                                                                      'hrs');
                                                              setState(() {
                                                                transactionAmountController
                                                                    .text = '';
                                                                purposeController
                                                                    .text = '';

                                                                statistics =
                                                                    API()
                                                                        .getStatistics();
                                                                loading =
                                                                false;
                                                              });
                                                              CoolAlert
                                                                  .show(
                                                                backgroundColor:
                                                                Colors.orange[
                                                                100],
                                                                confirmBtnColor:
                                                                Color(
                                                                    0xfff7892b),
                                                                context:
                                                                context,
                                                                type: CoolAlertType
                                                                    .success,
                                                                text:
                                                                'Transaction Cost Updated!',
                                                              );
                                                            });
                                                          },
                                                          child: Text(
                                                            'Confirm',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        color: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.orange)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: DataTable(columns: [
                                      DataColumn(
                                        label: Text(
                                          'Cash in Account',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          cashInAcc.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ], rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Spent Cash')),
                                          DataCell(Text(transactionCosts
                                              .toStringAsFixed(2))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Remaining Cash')),
                                          DataCell(Text(
                                              netContr.toStringAsFixed(2))),
                                        ],
                                      ),
                                      DataRow(
                                        cells: [
                                          DataCell(Text('Total Worth')),
                                          DataCell(Text(
                                              totalWorth.toStringAsFixed(2))),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RaisedButton(
                          child: Text(
                            'View History of Payments ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              viewingStatement = true;
                            });
                          },
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(
                  child: ColorLoader3(
                    dotRadius: 20,
                    radius: 40,
                  ),
                );
              },
            ),
          );
  }

  refresh() {
    setState(() {});
  }

  loadFilter(parameter) {
    if (parameter == "all") {
      setState(() {
        filtered = "all";
      });
    } else if (parameter == "payments") {
      setState(() {
        filtered = "payments";
      });
    } else if (parameter == "expenditure") {
      setState(() {
        filtered = "expenditure";
      });
    } else {
      setState(() {
        filtered = "all";
      });
    }
  }

  performFilter(filter, data) {
    filter == "payments"
        ? _pNtList = data.where((element) => element.type == "Payment").toList()
        : filter == "expenditure"
            ? _pNtList =
                data.where((element) => element.type == "Transaction").toList()
            : filter == "all"
                ? _pNtList = data
                : _pNtList = data;
  }
}
