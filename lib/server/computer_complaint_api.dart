import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../dataclasses/compcomplaints.dart';


Future<List<ComplaintModel>> fetchComplaints(BuildContext context,String empno,String deptcode) async {
  String url_ = 'http://10.0.2.2:3000/compcomplaint/fetchcomplaints?empno=$empno&deptcode=$deptcode';
  final url = Uri.parse(url_);

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Received data: $data');  // Print the received data
      return data.map((entry) => ComplaintModel.fromJson(entry)).toList();
    }else if(response.statusCode == 500){
      showError(context, 'Internal server error' );
      throw Exception('Internal server error' );
    }else if(response.statusCode == 204){
      showError(context, 'No data available' );
      throw Exception('No data available' );
    }else{
      showErrorWithReport(context, "Unexpected Error");
      throw Exception('${response.statusCode}: ${response.reasonPhrase}');
    }
  } on SocketException catch (e) {

    if (e.osError != null && e.osError!.message.contains('Connection refused')) {
      showError(context, "Server is down. Please try again later.");
    } else {
      showError(context, "No internet connection. Please check your network settings.");
    }
    throw Exception('error: $e');
  }
}

Future<bool> fileComplaint(BuildContext context,String empno, String description, String location) async {
  String url_ = 'http://10.0.2.2:3000/compcomplaint/fileComplaint';
  final url = Uri.parse(url_);
  try {
    // Define the data to be sent in the request body
    var body = {
      'empno': empno,
      'description': description,
      'location': location,
    };

    // Make a POST request
    var response = await http.post(url, body: body);

    // Check if the request was successful
    if (response.statusCode == 200) {
      return true;
    }else if(response.statusCode == 500){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("1 Failed to file complaint"),
      ));
      return false;

    } else {
      print('Failed to file complaint. Error ${response.statusCode}: ${response.reasonPhrase}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("2 Failed to file complaint"),
      ));
      return false;
      print('Failed to file complaint. Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  } on SocketException catch (e) {
    if (e.osError != null && e.osError!.message.contains('Connection refused')) {
      showError(context, "3 Server is down. Please try again later.");
      return false;
    } else {
      showError(context, "4 No internet connection. Please check your network settings.");
      return false;
    }
  }
}

Future<bool> updateComplaintStatus(BuildContext context,String complaintId,String attempno,String status) async {
  String url_ = 'http://10.0.2.2:3000/compcomplaint/updateComplaintStatus';
  final url = Uri.parse(url_);

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'complaintId': complaintId,
        'att_empno':attempno,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return true;
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internal server error')),
      );
      throw Exception('Internal server error');
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bad request')),
      );
      throw Exception('Bad request');
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint not found')),
      );
      throw Exception('Complaint not found');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected Error. Please report this to the support team.')),
      );
      throw Exception('${response.statusCode}: ${response.reasonPhrase}');
    }
  } on SocketException catch (e) {
    if (e.osError != null && e.osError!.message.contains('Connection refused')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server is down. Please try again later.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No internet connection. Please check your network settings.')),
      );
    }
    throw Exception('Error: $e');
  }
}


void showError(context,String err){
  showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.teal.shade100,
          content: Text('${err}',style: TextStyle(fontSize: 18),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      }
  );
}

void showErrorWithReport(context,String err){
  showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.teal.shade100,
          content: Text('${err}',style: TextStyle(fontSize: 18),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Report Bug'),
            ),

          ],
        );
      }
  );
}