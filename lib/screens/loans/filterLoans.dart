import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/member.dart';
import 'package:group/services/apiCalls.dart';

class FilterLoan extends StatefulWidget {
  @override
  _FilterLoanState createState() => _FilterLoanState();
}

class _FilterLoanState extends State<FilterLoan> {
  Future<List<Member>> members;
  List _members;

  @override
  void initState() {
    super.initState();
    members = API().getMembers();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey expansionTileKey = GlobalKey();
    void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
      final keyContext = expansionTileKey.currentContext;
      if (keyContext != null) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Scrollable.ensureVisible(keyContext,
              duration: Duration(milliseconds: 200));
        });
      }
    }
    return Container(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          ListTile(
            title: Text('View All Loans'),
            onTap: () {
              Navigator.pop(context, "all");
            },
          ),
          ListTile(
            title: Text('View Paid Loans'),
            onTap: () {
              Navigator.pop(context, "paid");
            },
          ),
          ListTile(
            title: Text('View Unpaid Loans'),
            onTap: () {
              Navigator.pop(context, "unpaid");
            },
          ),
          ListTile(
            title: Text('View Pending Loans'),
            onTap: () {
              Navigator.pop(context, "pending");
            },
          ),
          ExpansionTile(
            title: Text("View Loans by Year"),
            children: [
              ListTile(
                title: Text('View 2019 Loans'),
                onTap: () {
                  Navigator.pop(context, "2019");
                  print("submitted");
                },
              ),
              ListTile(
                title: Text('View 2020 Loans'),
                onTap: () {
                  Navigator.pop(context, "2020");
                },
              ),
              ListTile(
                title: Text('View 2021 Loans'),
                onTap: () {
                  Navigator.pop(context, "2021");
                },
              )
            ],
          ),
          ExpansionTile(
            key: expansionTileKey,
            onExpansionChanged: (value) {
              if (value) {
                _scrollToSelectedContent(expansionTileKey: expansionTileKey);
              }
            },
            title: Text("View Member's Loans"),
            children: [
              FutureBuilder(
                builder: (BuildContext context,
                    AsyncSnapshot<List<Member>> snapshot) {
                  if (snapshot.hasData) {
                    _members = snapshot.data;
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: _members.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              '${_members[index].name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              String id = '${_members[index].id}';
                              Navigator.pop(context, id);
                            },
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
                future: members,
              )
            ],
          ),
        ]).toList(),
      ),
    );
  }
}
