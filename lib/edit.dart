import 'dart:convert';

import 'package:countdowntimer/displaypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'countdown_display_page.dart';
import 'package:http/http.dart' as http;
// Remove the import for the custom_date_range_picker

class EditEvent extends StatefulWidget {

  String id;
  String event;
  String date;
  EditEvent({required this.id,required this.event, required this.date });

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late TextEditingController nameController;
  late TextEditingController dobController;
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController dobController = TextEditingController();
  // String selectedGender = 'Male';
  late Duration timeUntilNextBirthday;
  

  // int calculateDaysLeft() {
  //   DateTime selectedDate = DateTime.parse(dobController.text);
  //   DateTime now = DateTime.now();
  //   Duration difference = selectedDate.difference(now);
  //   return difference.inDays;
  // }

  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Use picked as the selected date
      setState(() {
        dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }


  Future<void> postData() async {
    // const url = 'http://104.248.159.207:4000/countdown';
    // String url = 'http://10.0.2.2:4000/updateevent/${widget.id}';
    String url = 'http://104.248.159.207:4000/updateevent/${widget.id}';

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    
    print(nameController.text);
    print(dobController.text);
    // print(selectedGender);


    final response = await http.put(
      
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'eventname': nameController.text,
        'date': dobController.text,
        'userid': user!.uid.toString(),
      }),
      
    );
    

    if (response.statusCode == 201) {
      print('Data added successfully');
      print('Response data: ${response.body}');
      // nameController.text = "";
      // dobController.text = "";
      
    } else {
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  }


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event);
    dobController = TextEditingController(text: widget.date);
  }

  void showUpdatedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // int daysLeft = calculateDaysLeft();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                        labelText: 'Date of Event (DD-MM-YYYY)'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            // DropdownButton<String>(
            //   value: selectedGender,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedGender = newValue!;
            //     });
            //   },
            //   items: <String>['Male', 'Female']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                 print(nameController.text);
                    print(dobController.text);
                    print("usghdug76487rr4hhj");
                    // print(daysLeft);

                    // print(timeUntilNextBirthday.inDays);
                    //  print(selectedGender);
                postData();
                showUpdatedSnackBar(context);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Display(
                //     ),
                //   ),
                // );
              },
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
