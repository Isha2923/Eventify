import 'package:eventify/eventlist.dart';
import 'package:eventify/form.dart';
import 'package:flutter/material.dart';
import 'package:eventify/attendee.dart';
import 'package:eventify/page2.dart';
import 'package:eventify/AttendeeRegistered.dart';
import 'package:eventify/OrgRegistered.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: MyHomePage(user: user)));
}

class MyHomePage extends StatelessWidget {
  final User user;
  MyHomePage({required this.user});


  Future<int> fetchRegistrationCount(String eventName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendeeRegistrations')
          .where('eventName', isEqualTo: eventName)
          .get();
      return querySnapshot.size; // Number of registered attendees
    } catch (e) {
      print("Error fetching registration count: $e");
      return 0;
    }
  }
  Future<List<Map<String, dynamic>>> fetchOrganizationEvents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('org', isEqualTo: user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  TextButton buildRegistrationInfoButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (user.userType == 'Org') {
          // Get the organization's events
          List<Map<String, dynamic>> orgEvents = await fetchOrganizationEvents();

          if (orgEvents.isNotEmpty) {
            String eventName = orgEvents[0]['name']; // Assuming the first event
            int registrationCount = await fetchRegistrationCount(eventName);

            // Show the registration info
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Registration Info'),
                content: user.userType == 'Org'
                    ? Text(
                    "Congratulations! Your organization's $eventName has $registrationCount registrations.")
                    : Text(
                    "This particular event of your organization has $registrationCount registered attendees."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Error'),
                content: Text('No events available for your organization.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      child: const Text("Show Registration Info", style: TextStyle(fontFamily: 'Salsa')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Hub", style: TextStyle(
            fontWeight: FontWeight.w200,
            fontFamily: 'Salsa',
            color: Colors.white70,)
        ),
        backgroundColor: Color(0xff9B61BD),
        elevation: 10.0,
        shadowColor: Color(0xffB287BB),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Eventify",
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Salsa',fontSize: 50, color: Colors.deepPurple),
              ),
              const Text(
                "where every event finds its stage",
                style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Salsa', fontSize: 20, color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundImage: AssetImage('images/logo.jpeg'),
                backgroundColor: Colors.transparent,
                radius: 55,
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(50,150)),
                child: Image.asset(
                  "images/theme.png",
                  height: 230,
                  width: 270,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildRegistrationInfoButton(context),
                  TextButton(
                    onPressed: () {
                      // Check if the user is an attendee
                      if (user.userType == 'Attendee') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('As an attendee, you cannot add events. Only organizations can add events.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Allow organization to add events
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyForm(user: user)));
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Add Event", style: TextStyle(fontFamily: 'Salsa')),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventListPage(user: user)));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white),
                    child: const Text("Show Events",style:TextStyle(fontFamily: 'Salsa',)),
                  ),
                ],
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              TextButton(
                onPressed: () {
                  if (user.userType == 'Attendee') {
                  // Allow only attendees to view registered events
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AttendeeRegisteredEvents(
                    user: user)),
                    );
                  } else {
                    showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                    title: Text('Error'),
                    content: Text(
                    'Only attendees can view registered events. Organizations cannot view registered events.'),
                    actions: <Widget>[
                    TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                    ),
              ],
              ),
              );
              }
              },
              style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white),
              child: const Text("View Registered Events",
              style: TextStyle(fontFamily: 'Salsa')),
              ),

                TextButton(
                  onPressed: () {
                    if (user.userType == 'Org') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrganizationEventsPage(
                                user: user)),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'Only organizations can view their events.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white),
                  child: const Text("View Their Events",
                      style: TextStyle(fontFamily: 'Salsa')),
                ),

              ],
          ),
          ],
        ),
      ),
      ),
    );
  }
}

