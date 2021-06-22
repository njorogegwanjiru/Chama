import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/member.dart';
import 'package:group/models/user.dart';
import 'package:group/services/apiCalls.dart';
import 'package:provider/provider.dart';

class NewLoan extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<NewLoan> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  final _formKey = GlobalKey<FormState>();

  final loanIdController = TextEditingController();
  final amountController = TextEditingController();
  final interestController = TextEditingController();
  final dateController = TextEditingController();
  final byController = TextEditingController();

  String borrowerId;
  double interest;

  Future<List<Member>> members;
  List _members;

  @override
  void initState() {
    super.initState();
    members = API().getMembers();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    amountController.dispose();
    dateController.dispose();
    byController.dispose();
    loanIdController.dispose();

    super.dispose();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.value = TextEditingValue(
          text: picked.day.toString().padLeft(2, "0") +
              '/' +
              picked.month.toString().padLeft(2, "0") +
              '/' +
              picked.year.toString(),
        );
      });
  }

  Future<UserModel> userObject;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    Widget showMembers() {
      return Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: FutureBuilder(
                future: members,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Member>> snapshot) {
                  if (snapshot.hasData) {
                    _members = snapshot.data
                        .where((element) => element.id == user.uid)
                        .toList();
                    return ListView.builder(
                      itemCount: _members.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('${_members[index].name}'),
                          onTap: () {
                            setState(() {
                              byController.value =
                                  TextEditingValue(text: _members[index].name);
                              borrowerId = _members[index].id;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return ColorLoader3(
                    dotRadius: 20,
                    radius: 40,
                  );
                }),
          ));
    }

    loanIdController.value = TextEditingValue(
      text: DateTime.now().year.toString() +
          DateTime.now().month.toString().padLeft(2, '0') +
          DateTime.now().day.toString().padLeft(2, '0') +
          DateTime.now().hour.toString() +
          DateTime.now().minute.toString() +
          DateTime.now().second.toString() +
          DateTime.now().microsecond.toString(),
    );

    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Text(
            'New Loan💸',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          //--------------------------Amount----------------
          TextFormField(
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(labelText: 'Amount'),
            onChanged: (value) {
              double amount = double.parse(value);
              interest = amount * 0.1;
              setState(() {
                interestController.value =
                    TextEditingValue(text: interest.toString());
              });
            },
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: amountController,
          ),
          //---------------------INTEREST---------------
          TextFormField(
            enabled: false,
            decoration: InputDecoration(labelText: 'Interest'),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                return 'Error calculating interest!';
              }
              return null;
            },
            controller: interestController,
          ),

          //-----------------------Date-----------------------
          GestureDetector(
            onTap: () => _pickDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: dateController,
              ),
            ),
          ),
          //--------------------BorrowedBy---------------------
          GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: showMembers(),
                  );
                }),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Borrowed By'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: byController,
              ),
            ),
          ),
          //--------------------Submit-------------------------
          RaisedButton(
            color: Color(0xfff7892b),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // Validate returns true if the form is valid, otherwise false.
                API()
                    .updateLoan(
                  amount: int.parse(amountController.text),
                  dateBorrowed: dateController.text,
                  interest: double.parse(interestController.text),
                  loanId: loanIdController.text,
                  memberId: borrowerId,
                  status: "Pending",
                )
                    .catchError((error) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: "$error",
                  );
                }).then((value) {
                  Navigator.pop(context, true);
                  CoolAlert.show(
                    backgroundColor: Colors.orange[100],
                    confirmBtnColor: Color(0xfff7892b),
                    context: context,
                    type: CoolAlertType.success,
                    text: 'Loan Added!',
                  );
                });
              }
            },
            child: Text(
              'Submit',
              style: TextStyle(fontSize: 18),
            ),
          )
        ]),
      ),
    );
  }
}
