import 'dart:convert';

import 'package:countdowntimer/eventinput.dart';
import 'package:countdowntimer/main.dart';
import 'package:countdowntimer/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Fetchevents extends StatefulWidget {
  const Fetchevents({Key? key}) : super(key: key);

  @override
  State<Fetchevents> createState() => _FetcheventsState();
}

class _FetcheventsState extends State<Fetchevents> {
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
      appBar: AppBar(
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
      body: Center(
        child: FutureBuilder<List<EventData>>(
          future: futureEventData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available for the user.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  EventData eventData = snapshot.data![index];
                  return ListTile(
                    title: Text('Event Name: ${eventData.eventname}'),
                    subtitle: Text('Date: ${eventData.date}, User ID: ${eventData.userid}'),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
          tooltip: 'Increment',
          child: Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  EventInput()),
              );
          }),
    );
  }
}

