class ComplaintModel {
  final int complaint_id;   final int empno;
  final String location;       final String description;
  final String dt_complaint;   final String attended_empno;
  final String dt_attended;    final String status;

  ComplaintModel({
    required this.complaint_id,    required this.empno,
    required this.location,        required this.description,
    required this.dt_complaint,    required this.attended_empno,
    required this.dt_attended,     required this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaint_id: json['complaint_id'],
      empno: json['empno'],
      location: json['location'],
      description: json['description'],
      dt_complaint: json['dt_complaint']==null? "-":json['dt_complaint'],
      attended_empno: json['attended_empno'],
      dt_attended: json['dt_attended']==null? "-":json['dt_attended'],
      status: json['status'],
    );
  }
}