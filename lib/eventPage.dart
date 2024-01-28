import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventify/page2.dart';
import 'package:eventify/Register_page.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final User user;

  EventPage({required this.data, required this.index,required this.user});

  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late TextEditingController name;
  late TextEditingController org;
  late TextEditingController date;
  late TextEditingController time;
  late TextEditingController venue;

  late String documentId = ''; // Initialize with  empty string

  bool isUpdating = false;

  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data['name']);
    org = TextEditingController(text: widget.data['org']);
    date = TextEditingController(text: widget.data['date']);
    time = TextEditingController(text: widget.data['time']);
    venue = TextEditingController(text: widget.data['venue']);

    // Fetch and store the document ID
    documentId = widget.data['id'] ?? '';
  }

  Future<void> updateData() async {
    try {
      if (widget.user.userType == 'Org') {
        if (documentId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('events')
              .doc(documentId)
              .update({
            'name': name.text,
            'org': org.text,
            'date': date.text,
            'time': time.text,
            'venue': venue.text,
          });

          print("Data updated");
          setState(() {
            isUpdating = false;
          });
        } else {
          print("Document ID is empty");
        }
      } else {
        // Attendee cannot update data
        print(widget.user.userType);
        showErrorMessage("Only organizations can update data.");
      }
    } catch (e) {
      //print('$e');
      print('Error deleting document: $e');
    }
  }

  // // New function to fetch document ID and data
  // Future<void> fetchData() async {
  //   try {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('events')
  //         .doc(widget.data['id'])
  //         .get();
  //
  //     if (documentSnapshot.exists) {
  //       // Access document data
  //       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //
  //       // Access document ID
  //       String fetchedDocumentId = documentSnapshot.id;
  //
  //       // Now you can use data and fetchedDocumentId as needed
  //       print('Fetched Document ID: $fetchedDocumentId, Fetched Data: $data');
  //     } else {
  //       print('Document does not exist');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  Future<void> deleteData() async {
    try {
      print(widget.user.userType);
      if (widget.user.userType == 'Org') {
        if (documentId.isNotEmpty) {
          bool confirmDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirm Deletion'),
                content: Text('Are you sure you want to delete this data?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );

          if (confirmDelete == true) {
            await FirebaseFirestore.instance
                .collection('events')
                .doc(documentId)
                .delete();

            print('Document deleted successfully');
            Navigator.pop(context); // Go back to the previous screen
          }
        } else {
          print("Document ID is empty");
        }
      } else {
        // Attendee cannot delete data
        showErrorMessage("Only organizations can delete data.");
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
    
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events Details",style: TextStyle(fontFamily: 'Salsa',color: Colors.white70),),
        backgroundColor:  Color(0xff9B61BD),
      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
      child:Center(
        //padding: EdgeInsets.all(130.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top:80,)
              //padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            ),
            userState("Name", name),
            userState("Organization", org),
            userState("Date", date),
            userState("Time", time),
            userState("Venue", venue),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Check if the user is an attendee
                    if (widget.user.userType == 'Attendee') {
                      // Allow the attendee to register for the event
                      // You can add your registration logic here
                      // For example, navigate to a registration page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage(eventData: widget.data, user: widget.user)),
                      );
                    } else {
                      // Display an error message because only attendees can register
                      showErrorMessage("Only attendees can register for events.");
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Register for Event", style: TextStyle(fontFamily: 'Salsa')),
                ),

                TextButton(
               onPressed: (){
                 if (widget.user.userType == 'Org'){
                   if (isUpdating) {
                     updateData();
                   } else {
                     setState(() {
                       isUpdating = true;
                     });
                   }
                 }else{
                   print(widget.user.userType);
                   updateData();
                 }
               },
               style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white),
               child: Text("Update Event"),
               ),
               TextButton(
                onPressed: deleteData,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white),
                child: Text("Delete Event",style:TextStyle(fontFamily: 'Salsa',)),
            ),
            ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget userState(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: isUpdating
          ? TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      )
          : Text(
        '$label: ${controller.text}',
        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w600,fontFamily: 'Salsa', color: Colors.deepPurple),
      ),
    );
  }
}


