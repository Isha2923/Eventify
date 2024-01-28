import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/Myhomepage.dart';
import 'package:eventify/page2.dart';
import 'package:flutter/material.dart';
import 'package:eventify/profile.dart';

void main() {
  User user = User(userType: 'Attendee', name: 'Your Attendee Name');
  runApp(MaterialApp(home: AttendeeForm(user: user)));
  //runApp(MaterialApp(home: AttendeeForm()));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AttendeeForm extends StatefulWidget {
  final User user;
  AttendeeForm({required this.user});
  @override
  _AttendeeFormState createState() => _AttendeeFormState();
}

class _AttendeeFormState extends State<AttendeeForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final TextEditingController _branch = TextEditingController();
  final TextEditingController _year = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Check for existing attendee profile data
    checkExistingProfile();
  }

  Future<void> checkExistingProfile() async {
    try {
      CollectionReference attendeeCollection =
      firestore.collection('attendee users');

      // Check if the attendee profile already exists
      QuerySnapshot existingProfiles = await attendeeCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Attendee profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            _name.text = existingProfileData['name'] ?? '';
            _course.text = existingProfileData['course'] ?? '';
            _branch.text = existingProfileData['branch'] ?? '';
            _year.text = existingProfileData['year'] ?? '';
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendee Form",
            style: TextStyle(
              fontFamily: 'Salsa',
              color: Colors.white70,
            ),
          ),
          backgroundColor: Color(0xff9B61BD),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _name,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Course",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _course,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Branch",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _branch,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Year",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _year,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: addUser,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Color(0xffAE72FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(150, 50),
                ),
                child: const Text(
                  "Create Profile",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void addUser() async {
    try {
      if (_name.text.isEmpty ||
          _course.text.isEmpty ||
          _branch.text.isEmpty ||
          _year.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection = firestore.collection('attendee users');

      QuerySnapshot existingProfiles = await eventsCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Attendee profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to attendee profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendeeProfileScreen(
                name: existingProfileData['name'] ?? '',
                course: existingProfileData['course'] ?? '',
                branch: existingProfileData['branch'] ?? '',
                year: existingProfileData['year'] ?? '',
              ),
            ),
          );
        }
        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '', //Firestore will generate a unique ID
        'name': _name.text,
        'course': _course.text,
        'branch': _branch.text,
        'year': _year.text,
    });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Attendee profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendeeProfileScreen(
            name: _name.text,
            course: _course.text,
            branch: _branch.text,
            year: _year.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

}





