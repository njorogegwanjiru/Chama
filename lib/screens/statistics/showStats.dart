import 'package:flutter/material.dart';
import 'package:group/assets/loader.dart';
import 'package:group/models/statistics.dart';
import 'package:group/services/apiCalls.dart';

class ShowStatistics extends StatefulWidget {
  @override
  _ShowStatisticsState createState() => _ShowStatisticsState();
}

class _ShowStatisticsState extends State<ShowStatistics> {
  Future<Statistics> statistics;
  @override
  void initState() {
    super.initState();
    statistics = API().getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: statistics,
        builder: (BuildContext context, AsyncSnapshot<Statistics> snapshot) {
          if (snapshot.hasData) {
            return DataTable(columns: [
              DataColumn(label: Text('🤑🤑')),
              DataColumn(label: Text('🤑🤑')),
            ], rows: [
              DataRow(
                cells: [
                  DataCell(Text(
                    'Total Contributions:',
                  )),
                  DataCell(Text('${snapshot.data.grossContributions.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text(
                    'Spent Cash:',
                    style: TextStyle(color: Colors.red),
                  )),
                  DataCell(Text(
                    '${snapshot.data.transactionCosts.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.red),
                  )),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text(
                    'Remainder:',
                    style: TextStyle(color: Colors.blue),
                  )),
                  DataCell(Text(
                    '${snapshot.data.netContributions.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.blue),
                  )),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Unpaid Loans')),
                  DataCell(Text('${snapshot.data.unpaidLoans.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Expected Interest')),
                  DataCell(Text('${snapshot.data.expectedInterest.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Paid Loans')),
                  DataCell(Text('${snapshot.data.paidLoans.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Earned Interest')),
                  DataCell(Text('${snapshot.data.earnedInterest.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text(
                    'Cash in Account',
                    style: TextStyle(color: Colors.blue),
                  )),
                  DataCell(Text('${snapshot.data.currentCashInAccount.toStringAsFixed(2)}')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text(
                    'Our Total Worth😋😋',
                    style: TextStyle(color: Colors.red),
                  )),
                  DataCell(Text('${snapshot.data.totalWorth.toStringAsFixed(2)}')),
                ],
              ),
            ]);
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
