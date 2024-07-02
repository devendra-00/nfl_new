import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nfl_new/home_screen.dart';
import 'package:nfl_new/splash_nfl_logo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = FlutterSecureStorage();

  TextEditingController empnocontroller=TextEditingController();
  TextEditingController namecontroller=TextEditingController();
  TextEditingController deptnocontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal.shade100,Colors.grey.shade200, ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextField(
                cursorColor: Colors.teal,
                style: TextStyle(fontSize: 24),
                controller: empnocontroller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusColor: Colors.greenAccent,
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)
                  ),
                  labelText: 'Employee Number',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.number,
                maxLength: 5, // Assuming the employee number is 10 digits long
              ),
              TextField(
                cursorColor: Colors.teal,
                style: TextStyle(fontSize: 24),
                controller: deptnocontroller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)
                  ),
                  labelText: 'Department Code',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              TextField(
                cursorColor: Colors.teal,
                style: TextStyle(fontSize: 24),
                controller: namecontroller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)
                  ),
                  labelText: 'Employee Name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          width: 1, // The thickness of the border
                          color: Colors.black, // The color of the border
                        ),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.teal.shade50,
                        shape: RoundedRectangleBorder( // Rounded corners
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 8.0, //
                      ),
                      onPressed: () {
                        doLogin();

                      },
                      child:Text("SUBMIT",style: TextStyle(fontSize: 18,fontFamily: "Varela"),)
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  void doLogin() async {
    final _storage = FlutterSecureStorage();
    String employeeName = namecontroller.text;
    int employeeNumber = int.parse(empnocontroller.text);
    String departmentNumber=deptnocontroller.text;

    await _storage.write(key: "Employee_Name", value: employeeName);
    await _storage.write(key: "Employee_Number", value: employeeNumber.toString());
    await _storage.write(key: "Department_Code", value: departmentNumber);
    await _storage.write(key: "LoggedIn", value: "true");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => homeScrren()),
    );
  }

}
