import 'package:eventify/Myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:eventify/page2.dart' as page2;

class AttendeeProfileScreen extends StatelessWidget {
  final String name;
  final String course;
  final String branch;
  final String year;


  AttendeeProfileScreen({
    required this.name,
    required this.course,
    required this.branch,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendee Profile', style: TextStyle(fontFamily: 'Salsa',),),
        backgroundColor: Color(0xff9B61BD),
        automaticallyImplyLeading: false,

      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('images/bg2.jpg'),
        fit: BoxFit.cover,
        ),
        ),
      child:Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 120,
                right: 20,
              ),
            ),
            // Profile Image
            Container(
              width: 150,
              height: 200,
              child :CircleAvatar(
                backgroundImage: AssetImage('images/att.jpg'),
                backgroundColor: Colors.transparent,
                radius: 70,
              ),
            ),
            SizedBox(height: 20),
            // Profile Information
            Text('Name: $name',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Course: $course',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8),fontFamily: 'Salsa',
                letterSpacing: 0.5, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Branch: $branch',style: TextStyle(fontSize: 18,color: Color.fromRGBO(
                111, 20, 128, 0.8), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Year: $year',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            // Add other profile information based on user type
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(user: page2.User(userType: 'Attendee', name: name)),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Go to Home", style: TextStyle(fontFamily: 'Salsa')),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class OrganizationProfileScreen extends StatelessWidget {
  final String name;
  final String tagline;
  final String vision;
  final String description;

  OrganizationProfileScreen({
    required this.name,
    required this.tagline,
    required this.vision,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile', style: TextStyle(fontFamily: 'Salsa',),),
        backgroundColor: Color(0xff9B61BD),
        automaticallyImplyLeading: false,
      ),
      body: Container(
      decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/bg2.jpg'),
        fit: BoxFit.cover,
      ),
      ),
      child:Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 120,
                right: 20,
              ),
            ),
            // Profile Image
            Container(
               width: 200,
               height: 150,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/main.png'),
                backgroundColor: Colors.transparent, // Set a transparent background to make it a circle
                radius: 80,
              ),
            ),
            SizedBox(height: 20),
            // Profile Info
            Text('Name: $name',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Tagline: $tagline',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Vision: $vision',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Description: $description',style: TextStyle(fontSize: 18, color: Color.fromRGBO(
                111, 20, 128, 0.8),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(user: page2.User(userType: 'Org', name: name)),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Go to Home", style: TextStyle(fontFamily: 'Salsa')),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

