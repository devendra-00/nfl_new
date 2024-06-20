import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = FlutterSecureStorage();


class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  String employeeName="XXXXX XXXX";
  int employeeNo=0;

  @override
  Widget build(BuildContext context) {
    void _loadEmployeeNameNo() async {
      String? name = await _storage.read(key: "Employee_Name");
      String? numberString = await _storage.read(key: "Employee_Number");
      int? number = numberString != null ? int.tryParse(numberString) : null;

      if (name != null && number != null) {
        setState(() {
          employeeName = name;
          employeeNo = number;
        });
      }
    }

    Future<String> _getEmployeeName = getEmployeeName();
    _getEmployeeName.then((name) {
      setState(() {
        _loadEmployeeNameNo();
      });
    });
    TextStyle txtsty=new TextStyle(fontSize: 18);
    return Scaffold(
        body:
        Container(
          color: Colors.black26,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Card(
                shadowColor: Colors.blue,
                elevation: 5,
                child: Container(//Container for Name and Image of Employee
                  decoration: ShapeDecoration(
                    color: Colors.cyan.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  height: 200,

                  width: MediaQuery.of(context).size.width-20,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: CircleAvatar(
                          backgroundColor: Colors.black26,
                          radius: 60,
                        ),
                      ),
                      Text(employeeName,style: TextStyle(
                          fontSize: 24
                      ),)

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  shadowColor: Colors.blue,
                  elevation: 5,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),

                    width: MediaQuery.of(context).size.width-20,
                    height: MediaQuery.of(context).size.height-240,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Employee Number',style: txtsty,),
                            Text('Deignation',style: txtsty,)
                          ],
                        ),
                      ),Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${employeeNo}',style: txtsty,),
                            Text('Manager',style: txtsty,)

                          ],
                        ),
                      )

                      ],
                    ),//Container for other information of Employee


                  ),
                ),
              ),


            ],

          ),
        )
    );
  }
  Future<String> getEmployeeName() async {
    String? name = await _storage.read(key: 'Employee_Name');
    if (name == null) {
      name = 'Default Name';
    }
    return name;
  }

}
