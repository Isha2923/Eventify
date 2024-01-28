import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/Myhomepage.dart';
import 'package:eventify/page2.dart';
import 'package:flutter/material.dart';
import 'package:eventify/profile.dart';

void main() {
  User user = User(userType: 'Org', name: 'Your Org Name');
  runApp(MaterialApp(home: OrgForm(user: user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class OrgForm extends StatefulWidget {
  final User user;

  OrgForm({required this.user});
  @override
  _OrgFormState createState() => _OrgFormState();
}

class _OrgFormState extends State<OrgForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _tagline = TextEditingController();
  final TextEditingController _vision = TextEditingController();
  final TextEditingController _desc = TextEditingController();


  @override
  void initState() {
    super.initState();

    // Check for existing org profile data
    checkExistingProfile();
  }
  Future<void> checkExistingProfile() async {
    try {
      CollectionReference orgCollection = firestore.collection('org users');

      // Check if the org profile already exists
      QuerySnapshot existingProfiles = await orgCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Organization profile already exists');

        // Get the existing org profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            // Populate the text controllers with existing data
            _name.text = existingProfileData['name'] ?? '';
            _tagline.text = existingProfileData['tagline'] ?? '';
            _vision.text = existingProfileData['vision'] ?? '';
            _desc.text = existingProfileData['description'] ?? '';
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
          title: Text("Organization Details form",
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
                  labelText: "Tagline",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _tagline,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Vision",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _vision,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _desc,
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
          _vision.text.isEmpty ||
          _tagline.text.isEmpty ||
          _desc.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection = firestore.collection('org users');

      // Check if the org profile already exists
      QuerySnapshot existingProfiles = await eventsCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Organization profile already exists');

        // Get the existing org profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to the organization profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizationProfileScreen(
                name: existingProfileData['name'] ?? '',
                tagline: existingProfileData['tagline'] ?? '',
                vision: existingProfileData['vision'] ?? '',
                description: existingProfileData['description'] ?? '',
              ),
            ),
          );
        }

        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '', // Leave it empty; Firestore will generate a unique ID
        'name': _name.text,
        'vision': _vision.text,
        'tagline': _tagline.text,
        'description': _desc.text,
      });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Organization profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrganizationProfileScreen(
            name: _name.text,
            tagline: _tagline.text,
            vision: _vision.text,
            description: _desc.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

}





