import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../dataclasses/compcomplaints.dart';
import '../../server/computer_complaint_api.dart';

class CC_OTHER extends StatefulWidget {
  const CC_OTHER({super.key});

  @override
  State<CC_OTHER> createState() => _CC_OTHERState();
}

class _CC_OTHERState extends State<CC_OTHER> {
  List<ComplaintModel> complaintList = [];
  final _storage = FlutterSecureStorage();
  String empNumber = '';
  String deptCode='';

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
                backgroundColor: listTile.status == "NC"? Colors.amber.shade100:Colors.teal,
                child: listTile.status == "NC" ? Icon(Icons.pending_actions) : Icon(Icons.done),
              ),
              title: Text(
                'Comp No : ${listTile.complaint_id}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              subtitle:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${listTile.location}',style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text('${DateFormat("dd-MM-yyyy    hh:mm a")
                      .format(DateFormat("MMM dd yyyy HH:mm:ss")
                      .parse(listTile.dt_complaint.split(' ').sublist(1, 5)
                      .join(' ')))}',
                    style: TextStyle(color: Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold),),
                  Text('${listTile.description}',style: TextStyle(color: Colors.black54),),
                  Text(listTile.attended_empno!='-'?
                  '\n${listTile.attended_empno} || ${_formatDateTime(listTile.dt_attended)}':"",
                    style:TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showComplaintDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
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
  }

  Future<void> fetchOtherComplaints(String empno,String deptcode) async {
    List<ComplaintModel> fetchedComplaints = await fetchComplaints(context, empno,deptcode);
    setState(() {
      complaintList = fetchedComplaints;
    });
  }

  void _showComplaintDialog() {
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File a New Complaint'),
          content: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width), // Adjust max width as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String description = _descriptionController.text;
                String location = _locationController.text;

                // Assume `fileComplaint` is a method in your API class
                bool success = await fileComplaint(context,empNumber, description, location);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Submitted Successfully"),
                  ));
                  fetchOtherComplaints(empNumber,deptCode);
                  Navigator.of(context).pop();
                }
                else{
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateFormat("MMM dd yyyy HH:mm:ss")
          .parse(dateTimeStr.split(' ').sublist(1, 5).join(' '));
      return DateFormat("dd-MM-yyyy || hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }
}
