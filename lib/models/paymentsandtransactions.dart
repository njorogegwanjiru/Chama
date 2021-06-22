class PaymentsAndTransactions {
  final String type;
  final String amount;
  final String date;
  final String member;
  final String pNtId;
  final String purpose;
  PaymentsAndTransactions({this.type, this.amount, this.date, this.member, this.pNtId,this.purpose});

  factory PaymentsAndTransactions.fromJson(dynamic json) {
    return PaymentsAndTransactions(
        type: json['type'],
        amount: json['amount'],
        member: json['member'],
        date: json['date'],
        purpose: json['purpose'],
        pNtId: json['pNtId']);
  }
}
