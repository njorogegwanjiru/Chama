class Loan {
  final int amountBorrowed;
  final double interest;
  final String status;
  final String dateBorrowed;
  final String loanId;
  final String memberId;
  Loan(
      {this.amountBorrowed,
      this.dateBorrowed,
      this.interest,
      this.status,
      this.loanId,
      this.memberId});

  factory Loan.fromJson(Map<dynamic, dynamic> json) {
    return Loan(
        amountBorrowed: json['amount'] as int,
        interest: json['interest'] as double,
        status: json['status'] as String,
        loanId: json['loanId'] as String,
        memberId: json['memberId'] as String,
        dateBorrowed: json['dateBorrowed'] as String);
  }
}
