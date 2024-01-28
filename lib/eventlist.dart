import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventPage.dart';
import 'package:eventify/page2.dart';

class EventListPage extends StatefulWidget {
  final User user;

  EventListPage({required this.user});
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late Future<List<Map<String, dynamic>>> events;

  @override
  void initState() {
    super.initState();
    events = fetchEvents();
  }

  // fetches data from the firestore
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
      //.where('org', isEqualTo: 'Lean In')
          .get();
      return querySnapshot.docs.map((doc) {
        // converting entire document data into a map and finally returning a list of all the maps
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events List",style: TextStyle(fontFamily: 'Salsa',color: Colors.white70),),
        backgroundColor:  Color(0xff9B61BD),

      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: events,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("There is some error fetching the data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No events are available"));
              } else {
                print(snapshot.data!);
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var event = snapshot.data![index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(8.0),
                      color: Color(0xffF5ECCD),
                      child: ListTile(
                        title: Text(
                          event['name'] + ' by ' + event['org'],
                          style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4C2A85)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: " + event['date']),
                            Text("Time: " + event['time']),
                            Text("Venue: " + event['venue']),
                          ],
                        ),
                        hoverColor: Color(0xffE8DBC5),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventPage(
                              data: event,
                              index: index + 1,
                                user: widget.user
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


