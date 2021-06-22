import 'package:group/models/loan.dart';
import 'package:group/models/member.dart';
import 'package:group/models/paymentsandtransactions.dart';
import 'package:group/models/project.dart';
import 'package:group/models/statistics.dart';
import 'package:group/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class API {
  Future<List<Member>> getMembers() async {
    final response =
    await http.get('https://flutter-5d49d.firebaseio.com/Members.json');

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body) as Map<String, dynamic>;

      final List<Member> members = [];
      parsedResponse.forEach((id, memberData) {
        members.add(Member.fromJson(memberData));
      });
      return members;
    } else {
      throw Exception('Failed to load Members');
    }
  }

  Future<String> getMemberName(String memberId) async {
    final response = await http.get(
        'https://flutter-5d49d.firebaseio.com/Members/$memberId/name.json');
    final parsedResponse = jsonDecode(response.body);
    String memberName = parsedResponse; //parsedResponse["name"];
    return memberName;
  }

  Future<UserModel> getCurrentMember(String memberId) async {
    final response = await http
        .get('https://flutter-5d49d.firebaseio.com/Members/$memberId.json');
    if (response.statusCode == 200) {
      final UserModel user = UserModel.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Failed to load Statistics');
    }
  }

  Future<Statistics> getStatistics() async {
    final response =
    await http.get('https://flutter-5d49d.firebaseio.com/Statistics.json');
    if (response.statusCode == 200) {
      return Statistics.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Statistics');
    }
  }

  Future<List<Project>> getProjects() async {
    final response =
    await http.get('https://flutter-5d49d.firebaseio.com/Projects.json');

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Project> projects = [];
      parsedResponse.forEach((projectId, projectData) {
        projects.add(Project.fronJson(projectData));
      });
      return projects;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<void> addProject(
      String projectId, String projectName, int amountRaised) async {
    await http.put(
        'https://flutter-5d49d.firebaseio.com/Projects/$projectId.json',
        body: json.encode({
          'projectId': projectId,
          'projectName': projectName,
          'totalAmountRaised': amountRaised
        }));
  }

  Future<void> recordPaymentAndTransaction(String pNtId, String amount,
      String purpose, String member, String type, String date) async {
    await http.put(
        'https://flutter-5d49d.firebaseio.com/PaymentsAndTransactions/$pNtId.json',
        body: json.encode({
          'type': type,
          'amount': amount,
          'member': member,
          'date': date,
          'purpose': purpose,
          'pNtId': pNtId
        }));
  }

  Future<List<PaymentsAndTransactions>> getPaymentsAndTransactions() async {
    final response = await http.get(
        'https://flutter-5d49d.firebaseio.com/PaymentsAndTransactions.json');

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<PaymentsAndTransactions> paymentsAndTransactions = [];
      parsedResponse.forEach((pNtId, projectData) {
        paymentsAndTransactions
            .add(PaymentsAndTransactions.fromJson(projectData));
      });
      return paymentsAndTransactions;
    } else {
      throw Exception('Failed to load history');
    }
  }

  Future<Loan> getLoan(String loanId) async {
    final response = await http
        .get('https://flutter-5d49d.firebaseio.com/Loans/$loanId.json');
    if (response.statusCode == 200) {
      return Loan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load loan');
    }
  }

  Future<void> changeLoanStatus(String loanId, String status) async {
    if (status == "Pending"||status=="Unpaid") {
      await http.patch(
          'https://flutter-5d49d.firebaseio.com/Loans/$loanId.json/',
          body: json.encode({
            'status': status,
          }));
    }
    if (status == "Paid") {
      await http
          .patch('https://flutter-5d49d.firebaseio.com/Loans/$loanId.json/',
          body: json.encode({
            'status': status,
          }))
          .then((value) {
        getLoan(loanId).then((loan) {
          print(loan);
          getStatistics().then((stats) {
            updateStats(
              currentCashInAccount: stats.currentCashInAccount +
                  loan.amountBorrowed +
                  loan.interest,
              earnedInterest: stats.earnedInterest + loan.interest,
              expectedInterest: stats.expectedInterest - loan.interest,
              paidLoans: stats.paidLoans + loan.amountBorrowed,
              totalWorth: stats.totalWorth,
              grossContributions: stats.grossContributions,
              unpaidLoans: stats.unpaidLoans - loan.amountBorrowed,
              contributedSundays: stats.contributedSundays,
              transactionCosts: stats.transactionCosts,
              netContributions: stats.netContributions,
            );
          });
        });
      });
    }
  }

  Future<void> updateLoan(
      {int amount,
        String dateBorrowed,
        double interest,
        String loanId,
        String memberId,
        String status}) async {
    if (status == "Pending") {
      await http.put('https://flutter-5d49d.firebaseio.com/Loans/$loanId.json/',
          body: json.encode({
            'amount': amount,
            'dateBorrowed': dateBorrowed,
            'interest': interest,
            'loanId': loanId,
            'memberId': memberId,
            'status': status
          }));
    } else if (status == "Unpaid") {
      await http
          .put('https://flutter-5d49d.firebaseio.com/Loans/$loanId.json/',
          body: json.encode({
            'amount': amount,
            'dateBorrowed': dateBorrowed,
            'interest': interest,
            'loanId': loanId,
            'memberId': memberId,
            'status': status
          }))
          .then((value) {
        getStatistics().then((value) {
          updateStats(
            currentCashInAccount: value.currentCashInAccount - amount,
            earnedInterest: value.earnedInterest,
            expectedInterest: value.expectedInterest + interest,
            paidLoans: value.paidLoans,
            totalWorth: value.totalWorth + value.expectedInterest,
            grossContributions: value.grossContributions,
            unpaidLoans: value.unpaidLoans + amount,
            contributedSundays: value.contributedSundays,
            transactionCosts: value.transactionCosts,
            netContributions: value.netContributions,
          );
        });
      });
    }
  }

  Future<List<Loan>> getLoans() async {
    final response =
    await http.get('https://flutter-5d49d.firebaseio.com/Loans.json');
    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Loan> loans = [];
      parsedResponse.forEach((loanId, loanData) {
        loans.add(Loan.fromJson(loanData));
      });
      return loans;
    } else {
      throw Exception('Failed to load loans');
    }
  }

  Future<void> updateStats(
      {double currentCashInAccount,
        double earnedInterest,
        double expectedInterest,
        int paidLoans,
        double totalWorth,
        int grossContributions,
        int unpaidLoans,
        int contributedSundays,
        int transactionCosts,
        int netContributions}) async {
    await http.patch('https://flutter-5d49d.firebaseio.com/Statistics.json',
        body: json.encode({
          'Contributed Sundays': contributedSundays,
          'Current Cash in Account': currentCashInAccount,
          'Earned Interest': earnedInterest,
          'Expected Interest': expectedInterest,
          'Gross Contributions': grossContributions,
          'Net ContributionS': netContributions,
          'Paid Loans': paidLoans,
          'Total Worth': totalWorth,
          'Transactions Costs': transactionCosts,
          'Unpaid Loans': unpaidLoans,
        }));
  }

  Future<void> updateSomeDetails(String variable, int newValue) async {
    await http.patch(
        'https://flutter-5d49d.firebaseio.com/Statistics/$variable.json',
        body: json.encode({variable: newValue}));
  }

  Future<void> updateDetails(
      String variable1,
      String variable2,
      String variable3,
      String variable4,
      double newValue1,
      int newValue2,
      int newValue3,
      double newValue4) async {
    await http.patch('https://flutter-5d49d.firebaseio.com/Statistics.json',
        body: json.encode({
          variable1: newValue1,
          variable2: newValue2,
          variable3: newValue3,
          variable4: newValue4,
        }));
  }


}
