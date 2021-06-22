import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/project.dart';
import 'package:group/services/apiCalls.dart';
import 'package:intl/intl.dart';

class ViewProjects extends StatefulWidget {
  @override
  _ViewProjectsState createState() => _ViewProjectsState();
}

class _ViewProjectsState extends State<ViewProjects> {
  Future<List<Project>> projects;
  List _projects;
  NumberFormat formatter = NumberFormat.decimalPattern("en_US");

  @override
  void initState() {
    super.initState();
    projects = API().getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().getProjects(),
      builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
        if (snapshot.hasData) {
          _projects = snapshot.data;
          String amountStr;

          return Container(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _projects.length,
              itemBuilder: (BuildContext context, int index) {
                int amount = _projects[index].totalAmountRaised;
                amountStr = formatter.format(amount);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(),
                    title: Text(
                        'Project Name: ' + '${_projects[index].projectName}'),
                    subtitle: Text('Amount Raised: ' + amountStr),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return ColorLoader3(
          dotRadius: 20,
          radius: 40,
        );
      },
    );
  }
}
