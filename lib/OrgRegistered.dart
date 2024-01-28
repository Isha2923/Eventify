import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventPage.dart';
import 'package:eventify/Myhomepage.dart';
import 'package:eventify/page2.dart';

class OrganizationEventsPage extends StatefulWidget {
  final User user;

  OrganizationEventsPage({required this.user});

  @override
  _OrganizationEventsPageState createState() => _OrganizationEventsPageState();
}

class _OrganizationEventsPageState extends State<OrganizationEventsPage> {
  late Future<List<Map<String, dynamic>>> organizationEvents;
  late Map<String, int> registrationCounts;


  @override
  void initState() {
    super.initState();
    organizationEvents = fetchOrganizationEvents();
    registrationCounts = {}; // Initialize an empty map
  }

  Future<List<Map<String, dynamic>>> fetchOrganizationEvents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('org', isEqualTo: widget.user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  Future<int> fetchRegistrationCount(String eventName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendeeRegistrations')
          .where('eventName', isEqualTo: eventName)
          .get();
      return querySnapshot.size; // Num of registered attendees
    } catch (e) {
      print("Error fetching registration count: $e");
      return 0;
    }
  }
  Future<void> fetchRegistrationCounts() async {
    for (var event in (await organizationEvents)) {
      String eventName = event['name'];
      int registrationCount = await fetchRegistrationCount(eventName);
      setState(() {
        registrationCounts[eventName] = registrationCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organization Events", style: TextStyle(fontFamily: 'Salsa', color: Colors.white70)),
        backgroundColor: Color(0xff9B61BD),
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
            future: organizationEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("There is some error fetching the data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No events are available for your organization"));
              } else {
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
                          event['name'],
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
                              user: widget.user,
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
