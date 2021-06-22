import 'package:flutter/material.dart';
import 'package:group/screens/loans/loans.dart';
import 'package:group/screens/members/showMembers.dart';
import 'package:group/screens/payment/payment.dart';
import 'package:group/screens/projects/projects.dart';
import 'package:group/screens/statistics/showStats.dart';

class Menus extends StatefulWidget {
  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  List<String> menuItems = [
    'Summary',
    'Members',
    'Loans',
    'Monies',
    'Projects',
  ];
  int selectedMenu;


  @override
  Widget build(BuildContext context) {

    setState(() {
      selectedMenu == null ? selectedMenu = 0 : selectedMenu = selectedMenu;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMenu = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          height: 50,
                          width: 80,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  menuItems[index],
                                  style: TextStyle(
                                      color: selectedMenu == index
                                          ? Colors.black
                                          : Colors.black54),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: 2,
                                  width: 25,
                                  color: selectedMenu == index
                                      ? Color(0xFF162A49)
                                      : Colors.transparent,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              selectedMenu == 0
                  ? ShowStatistics()
                  : selectedMenu == 1
                      ? MembersList()
                      : selectedMenu == 2
                          ? Loans()
                          : selectedMenu == 3
                              ? MakePayment()
                              : ProjectsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
