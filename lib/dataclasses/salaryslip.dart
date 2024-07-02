class EarningsDeductiomModel {
  final String code;
  final String label;
  final String earn_deduc;
  final String hlabel;
  final String amount;

  EarningsDeductiomModel({required this.code,required this.label,required this.earn_deduc, required this.hlabel,required this.amount});

  factory EarningsDeductiomModel.fromJson(Map<String, dynamic> json) {
    return EarningsDeductiomModel(
      code: json['code'],
      label: json['label'],
      earn_deduc:json['earn_deduc'],
      hlabel: json['hlabel'],
      amount: json['amount']  ,

    );
  }
}