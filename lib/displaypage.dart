import 'dart:convert';
import 'dart:math';

import 'package:countdowntimer/edit.dart';
import 'package:countdowntimer/eventinput.dart';
import 'package:countdowntimer/main.dart';
import 'package:countdowntimer/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Display extends StatefulWidget {
  // const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
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


  Future<void> _refreshData() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;

      // Fetch new data
      List<EventData> newData = await fetchEventData(user!.uid.toString());

      // Update the data
      setState(() {
        futureEventData = Future.value(newData);
      });
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }


  int? calculateDaysLeft(String selectedDate) {
  try {
    // Check if the date string has the correct format
    RegExp dateRegex = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');
    if (!dateRegex.hasMatch(selectedDate)) {
      print('Invalid date format');
      return null;
    }

    // Parse the selected date string into a DateTime object
    List<String> dateParts = selectedDate.split('-');
    print(dateParts);
    if (dateParts.length != 3) {
      print('Invalid date format');
      return null;
    }

     print(int.parse(dateParts[0]));
    DateTime selectedDateTime = DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
     
    );

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in days
    Duration difference = selectedDateTime.difference(currentDate);

    // Return the number of days left
    return difference.inDays;
  } catch (e) {
    // Handle parsing errors
    print('Error parsing date: $e');
    return null;
  }
}



  Future<List<EventData>> fetchEventData(String userId) async {
    // final String apiUrl = 'http://10.0.2.2:4000/getevent/$userId';
    final String apiUrl = 'http://104.248.159.207:4000/getevent/$userId';

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
            child: Text("signout")),
            
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Center(
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
          itemCount: snapshot.data?.length,
          itemBuilder: (BuildContext, index){
            EventData eventData = snapshot.data![index];
            print(eventData.date[index]);
            print("date sinlge");
            int? daysLeft = calculateDaysLeft(eventData.date);
            
            print(daysLeft);
            print("xxxx");
            Color randomColor = getRandomColor();
            return GestureDetector(
              onTap: (){
                
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditEvent(id: eventData.id.toString(),date:eventData.date ,event:eventData.eventname ,)),
                  );
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
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
                    title: Text(eventData.eventname,style: TextStyle(color: Colors.white,fontSize: 19)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(daysLeft.toString(),style: TextStyle(color: Colors.white,fontSize: 12)),
                      Text("days left",style: TextStyle(color: Colors.white,fontSize: 12)),
                    ]),
                    ),
                ),
              ),
            );
          });
              }
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
              backgroundColor: Color.fromARGB(255, 49, 95, 186),
              tooltip: 'Increment',
              child: Icon(Icons.refresh, color: Colors.white, size: 28),
              onPressed: (){
                _refreshData();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) =>  EventInput()),
                //   );
              }),
              SizedBox(height: 10,),
              FloatingActionButton(
                heroTag: "btn2",
              backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
              tooltip: 'Increment',
              child: Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EventInput()),
                  );
              }),
        ],
      ),
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