import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/loan.dart';
import 'package:group/models/member.dart';
import 'package:group/services/apiCalls.dart';

class MembersList extends StatefulWidget {
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  Future<List<Member>> members;
  List _members;

  Future<List<Loan>> loans;
  List _loans;

  var hasUnpaidLoans = false;

  @override
  void initState() {
    super.initState();
    members = API().getMembers();
    loans = API().getLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: Future.wait([members, loans]),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            _members = snapshot.data[0];
            _loans = snapshot.data[1];
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  String name = _members[index].name;
                  String _id = _members[index].id;
                  return Card(
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[50],
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                              name[0],
                              style: TextStyle(
                                  color: Color(0xffe46b10), fontSize: 35),
                            ),
                          ),
                        ),
                      ),
                      title: Text('${_members[index].name}'),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(columns: [
                            DataColumn(label: Text('🤑Total Contributions')),
                            DataColumn(label: Text('${_members[index].total}')),
                          ], rows: [
                            DataRow(
                              cells: [
                                DataCell(Text(
                                  '⌚Contributed Weeks',
                                )),
                                DataCell(Text('${_members[index].weeks}')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text(
                                  '👀Got Unpaid Loans?',
                                )),
                                _loans
                                        .where((element) =>
                                            element.status == "Unpaid" &&
                                            element.memberId == _id)
                                        .toList()
                                        .isEmpty
                                    ? DataCell(Text("Naaah...😊"))
                                    : DataCell(Text("Yeap!😬")),
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  );
                },
                itemCount: _members.length);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return ColorLoader3(
            dotRadius: 20,
            radius: 40,
          );
        },
      ),
    );
  }
}
