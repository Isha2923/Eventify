import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/page2.dart';

class RegistrationPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final User user;

  RegistrationPage({required this.eventData, required this.user});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController nameController;
  late TextEditingController branchController;
  late TextEditingController yearController;
  late TextEditingController courseController;
  late TextEditingController howDidYouKnowController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    branchController = TextEditingController();
    yearController = TextEditingController();
    courseController = TextEditingController();
    howDidYouKnowController = TextEditingController();
  }

  void checkRegistration() async {
    // Check if the attendee has already registered for the event
    var registrationQuery = await FirebaseFirestore.instance
        .collection('attendeeRegistrations')
        .where('eventName', isEqualTo: widget.eventData['name'])
        .where('attendeeName', isEqualTo: nameController.text)
        .get();

    if (registrationQuery.docs.isNotEmpty) {
      // Attendee has already registered
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Already Registered'),
          content: Text('You have already registered for this event.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with registration
      register();
    }
  }

  void register() async {
    try {
      if (nameController.text.isEmpty ||
          branchController.text.isEmpty ||
          yearController.text.isEmpty ||
          howDidYouKnowController.text.isEmpty ||
          courseController.text.isEmpty) {
        print("Fill in all the details");
        return;
      }
      // Create a new document in the attendeeRegistrations collection
      await FirebaseFirestore.instance.collection('attendeeRegistrations').add({
        'eventName': widget.eventData['name'],
        'attendeeName': nameController.text,
        'branch': branchController.text,
        'year': yearController.text,
        'course': courseController.text,
        'howDidYouKnow': howDidYouKnowController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Thanks for registering!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog

              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error during registration: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration", style: TextStyle(fontFamily: 'Salsa',color: Colors.white70)),
        backgroundColor: Color(0xff9B61BD),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child:Center(
                    child:Image.asset(
                    "images/register.jpg",
                    height: 100,
                    width: 250,
                  ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Course",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: courseController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Branch",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: branchController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Year",
                    icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: yearController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                  labelText: 'How did you know about this event?',
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                  ),
                  controller: howDidYouKnowController,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: checkRegistration,
                  //register,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Register',style: TextStyle(fontFamily: 'Salsa',color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





