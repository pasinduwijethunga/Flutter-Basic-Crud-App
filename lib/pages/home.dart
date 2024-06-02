import 'package:basic_app/pages/employee.dart';
import 'package:basic_app/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();
  Stream? EmployeeStream;

  getontheload()async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {
      
    });

  }
  @override
  void initState(){
    getontheload();
    super.initState();
  }
  
  Widget allEmployeeDetails(){
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData
      ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Material(
              elevation: 0.50,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding:  EdgeInsets.only(left: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), 
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Name      : "+ds["Name"],style: 
                      const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(onTap: (){
                          namecontroller.text = ds["Name"]; 
                          agecontroller.text = ds["Age"]; 
                          locationcontroller.text = ds["Location"]; 
                          EditEmployeeDetails(ds["Id"]);
                        },
                        child: const Icon(Icons.edit, color: Color.fromARGB(255, 57, 58, 59),),),
                      ),
                      
                    ],
                  ),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Age          : "+ds["Age"],style: 
                      const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(onTap: ()async{
                          await DatabaseMethods().deleteEmployeeDetails(ds["Id"]).then((value) {
                      Fluttertoast.showToast(
                        msg: "Employee details Deleted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                        );
                    });
                        },
                        child: const Icon(Icons.delete, color: Color.fromARGB(255, 248, 1, 1),),),
                      ),
                   ],
                 ),
                  Text("Location : "+ds["Location"],style: 
                  const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],),
              
              ),
            ),
          );
        })
      : Container();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Employee()));
      },
       child: const Icon(Icons.add),),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Employee List",
            style: TextStyle(
              color: Color.fromARGB(255, 43, 99, 112),
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0,top: 10.0),
        child:  Column(children: [
          Expanded(child: allEmployeeDetails()),
        ],),
      ),
    );
  }

  Future EditEmployeeDetails(String id)=> showDialog(
    context: context, 
    builder: (context)=> 
     AlertDialog(
      content:  Container(
        width: MediaQuery.of(context).size.width * 0.90, // Set the width to 80% of the screen width
      padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel),
                ),
                const Text("Edit Details",
                style: TextStyle(color: Colors.blueGrey,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),)
               ],
            ),
            SizedBox(height: 10.0,),
            const Text(
              "Name",
              style: TextStyle(
                  color: Color.fromARGB(255, 43, 99, 112),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: namecontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Age",
              style: TextStyle(
                  color: Color.fromARGB(255, 43, 99, 112),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: agecontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Location",
              style: TextStyle(
                  color: Color.fromARGB(255, 43, 99, 112),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: locationcontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 10.0,),
            Center(child: ElevatedButton(onPressed: ()async{
             Map<String, dynamic>updateInfo = {
              "Name": namecontroller.text,
              "Age" : agecontroller.text,
              "Location" : locationcontroller.text,
             };
             await DatabaseMethods().updateEmployeeDetails(id, updateInfo).then((value) {
              Navigator.pop(context);
             });
            }, child: const Text("Update"),)),
          ],
        ),
      ),
    ));
  
}