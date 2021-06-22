import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:group/services/apiCalls.dart';

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final _formKey = GlobalKey<FormState>();

  final projectIdController = TextEditingController();
  final projectNameController = TextEditingController();
  final amountRaisedController = TextEditingController();
  int amountInt;

  @override
  void dispose() {
    super.dispose();
    projectIdController.dispose();
    projectNameController.dispose();
    amountRaisedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    projectIdController.value = TextEditingValue(
        text: 'P_' +
            DateTime.now().year.toString() +
            '_' +
            DateTime.now().minute.toString());

    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            child: Column(
              children: [
                Text(
                  'New Project➕',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Project Name'),
                  controller: projectNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(labelText: 'Amount Raised'),
                  controller: amountRaisedController,
                  onChanged: (value) {
                    String amountStr = amountRaisedController.text;
                    amountInt = int.parse(amountStr);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Spacer(),
                Row(
                  children: [
                    RaisedButton(
                      color: Color(0xfff7892b),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          API()
                              .addProject(
                            projectIdController.text,
                            projectNameController.text,
                            amountInt,
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
                              text: 'Project Added!',
                            );
                            //Navigator.popAndPushNamed(context, '/projects');
                          });
                        } //
                      },
                      child: Text(
                        'Add Project',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
