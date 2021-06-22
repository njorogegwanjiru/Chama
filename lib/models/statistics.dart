class Statistics {
  final double currentCashInAccount;
  final double earnedInterest;
  final double expectedInterest;
  final int paidLoans;
  final double totalWorth;
  final int grossContributions;
  final int unpaidLoans;
  final int contributedSundays;
  final int transactionCosts;
  final int netContributions;

  Statistics(
      {this.currentCashInAccount,
        this.earnedInterest,
        this.expectedInterest,
        this.paidLoans,
        this.contributedSundays,
        this.grossContributions,
        this.netContributions,
        this.totalWorth,
        this.unpaidLoans,
        this.transactionCosts});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
        currentCashInAccount: json['Current Cash in Account'],
        earnedInterest: json['Earned Interest'],
        expectedInterest: json['Expected Interest'],
        paidLoans: json['Paid Loans'],
        totalWorth: json['Total Worth'],
        grossContributions: json['Gross Contributions'],
        netContributions: json['Net ContributionS'],
        transactionCosts: json['Transactions Costs'],
        unpaidLoans: json['Unpaid Loans'],
        contributedSundays: json['Contributed Sundays']);
  }
}
