import 'package:flutter/material.dart';
import 'package:group/screens/projects/addProject.dart';
import 'package:group/screens/projects/viewProjects.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Expanded(
      child: Scaffold(
        body: Center(
          child: ViewProjects(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xfff7892b),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewProject();
                }).then((value) {
              if (value) {
                refresh();
              }
            });
          },
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
