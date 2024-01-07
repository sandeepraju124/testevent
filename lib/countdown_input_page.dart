import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'countdown_display_page.dart';
import 'package:http/http.dart' as http;
// Remove the import for the custom_date_range_picker

class CountdownInputPage extends StatefulWidget {
  @override
  _CountdownInputPageState createState() => _CountdownInputPageState();
}

class _CountdownInputPageState extends State<CountdownInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String selectedGender = 'Male';
  
  

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
    const url = 'http://104.248.159.207:4000/countdown';
    // const url = 'http://10.0.2.2:3000/countdown';
    
    print(nameController.text);
    print(dobController.text);
    print(selectedGender);


    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'dob': "1995-08-20",
        'gender': selectedGender,
      }),

//       body: jsonEncode({
//   'name': 'John Dwoe',
//   'dob': '1995-08-20',
//   'gender': 'Male',
// }),

      
    );
    

    if (response.statusCode == 201) {
      print('Data added successfully');
      print('Response data: ${response.body}');
    } else {
      print('Failed to add data. Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                        labelText: 'Date of Birth (DD-MM-YYYY)'),
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
            DropdownButton<String>(
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                postData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CountdownDisplayPage(
                      name: nameController.text,
                      dob: dobController.text,
                      gender: selectedGender,
                    ),
                  ),
                );
              },
              child: Text('Show Countdown Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
