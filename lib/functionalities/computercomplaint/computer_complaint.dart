import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nfl_new/functionalities/computercomplaint/computer_complaint_IT.dart';
import 'package:nfl_new/functionalities/computercomplaint/computer_complaint_others.dart';

class CompputerComplaintScreen extends StatefulWidget {
  const CompputerComplaintScreen({super.key});

  @override
  State<CompputerComplaintScreen> createState() => _CompputerComplaintScreenState();
}

class _CompputerComplaintScreenState extends State<CompputerComplaintScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Computer Complaint"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100, Colors.grey.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: fetchDeptCode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching department code'));
          } else if (snapshot.hasData) {
            String? deptCode = snapshot.data;
            if (deptCode == '078') {
              return CC_IT();
            } else {
              return CC_OTHER();
            }
          } else {
            return Center(child: Text('No department code found'));
          }
        },
      ),

    );
  }
  Future<String?> fetchDeptCode() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'Department_Code');
  }

}
