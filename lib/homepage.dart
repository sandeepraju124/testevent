// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import 'package:countdowntimer/eventinput.dart';
import 'package:countdowntimer/main.dart';
import 'package:countdowntimer/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}



class _LandingPageState extends State<LandingPage> {
  late Future<List<EventData>> futureEventData;

  @override
  void initState() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    print("jyghegd");
    print(user!.uid);
    super.initState();
    futureEventData = fetchEventData(user.uid.toString()); // Replace with the actual user ID
  }


  Future<List<EventData>> fetchEventData(String userId) async {
    final String apiUrl = 'http://10.0.2.2:4000/getevent/$userId';
    // const url = 'http://10.0.2.2:4000/addevent';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<EventData> eventDataList = data.map((event) => EventData.fromJson(event)).toList();
        return eventDataList;
      } else if (response.statusCode == 404) {
        print('User not found');
        return [];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Fetched Events'),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                FirebaseAuth.instance.signOut();
              });
              
            },
            child: Text("signout"))
        ],
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (BuildContext, int){
          Color randomColor = getRandomColor();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment:Alignment.center,
              height: 70,
              // color: Colors.blue,
              decoration: BoxDecoration(
                // color: Colors.green,
                color: randomColor,
                borderRadius:  BorderRadius.all(Radius.circular(10)),),
              child: ListTile(
                leading: Icon(Icons.celebration,color: Colors.white),
                title: Text("New Year",style: TextStyle(color: Colors.white,fontSize: 19)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("7",style: TextStyle(color: Colors.white,fontSize: 12)),
                  Text("days left",style: TextStyle(color: Colors.white,fontSize: 12)),
                ]),
                ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
          tooltip: 'Increment',
          child: Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );
          }),
        );
  }
}


Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
