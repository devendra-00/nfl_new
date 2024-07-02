import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../dataclasses/compcomplaints.dart';
import '../../server/computer_complaint_api.dart';

class CC_IT extends StatefulWidget {
  const CC_IT({super.key});

  @override
  State<CC_IT> createState() => _CC_ITState();
}

class _CC_ITState extends State<CC_IT> {
  List<ComplaintModel> complaintList = [];
  final _storage = FlutterSecureStorage();
  String empNumber = "";
  String deptCode = "";

  @override
  void initState() {
    super.initState();
    _fetchEmployeeNumber().then((_) {
      fetchOtherComplaints(empNumber, deptCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: complaintList.length,
        itemBuilder: (context, index) {
          final listTile = complaintList[index];
          return Card(
            surfaceTintColor: Colors.teal,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: listTile.status == "NC"
                    ? Colors.amber.shade100
                    : Colors.teal.shade400,
                child: listTile.status == "NC"
                    ? Icon(Icons.pending_actions)
                    : Icon(Icons.done),
              ),
              title: Text(
                'Comp No : ${listTile.complaint_id}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${listTile.empno} , ${listTile.location}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _formatDateTime(listTile.dt_complaint),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${listTile.description}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(listTile.attended_empno!='-'?
                    '\n${listTile.attended_empno} || ${_formatDateTime(listTile.dt_attended)}':"",
                    style:TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),),

                ],
              ),
              trailing: listTile.status == "NC"
                  ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.teal.shade200,
                  shape: CircleBorder(), // Make the button circular
                  padding: EdgeInsets.all(
                      20), // Adjust the padding to make it circular
                ),
                child: Text(
                  "Attend",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                onPressed: () =>
                    changeComplaintStatus("${listTile.complaint_id}",empNumber),
              )
                  : null
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchEmployeeNumber() async {
    String? deptcode = await _storage.read(key:'Department_Code');
    String? empNo = await _storage.read(key:'Employee_Number');

    if ( deptcode != null && empNo != null) {
      setState(() {
        deptCode = deptcode;
        empNumber = empNo;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.teal.shade100,
            content: Text(
              'Empno or DeptCode not found in secure storage',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } //fetch Empno and DeptCode from Secure Storage

  Future<void> fetchOtherComplaints(String empNumber, String deptCode) async {
    List<ComplaintModel> fetchedComplaints =
    await fetchComplaints(context, empNumber, deptCode);
    setState(() {
      complaintList = fetchedComplaints;
    });
  }

  Future<void> changeComplaintStatus(String complaintId,String empno) async {
    // Assume `updateComplaintStatus` is a method in your API class
    bool success = await updateComplaintStatus(context, complaintId,empno, 'C');
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Status Updated Successfully"),
      ));
      fetchOtherComplaints(empNumber, deptCode);
    }
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateFormat("MMM dd yyyy HH:mm:ss")
          .parse(dateTimeStr.split(' ').sublist(1, 5).join(' '));
      return DateFormat("dd-MM-yyyy || hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }  //for dt_complaint
}
