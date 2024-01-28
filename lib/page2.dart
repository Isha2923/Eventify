import 'package:flutter/material.dart';
import 'package:eventify/login.dart';
import 'package:eventify/attendee.dart'; // Import the attendee.dart file
import 'package:eventify/org.dart'; // Import the org.dart file
import 'package:eventify/profile.dart';

class User {
  final String userType;
  final String name;

  User({required this.userType, required this.name});
}

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',style: TextStyle(fontFamily: 'Salsa',),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${user.name}'),
            Text('User Type: ${user.userType}'),
          ],
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserTypeSelectionScreen(),
    );
  }
}

class UserTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type',style: TextStyle(color:Colors.white70),),
        backgroundColor: Color(0xff9B61BD),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "images/org.png",
                  height: 220,
                  width: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(context, User(userType: 'Organization', name: 'Organization Name'));
                  },
                  child: Text(
                    'Organization',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Image.asset(
                  "images/attendee.png",
                  height: 220,
                  width: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(context, User(userType: 'Attendee', name: 'Attendee Name'));
                  },
                  child: Text(
                    'Attendee',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, User user) {
    if (user.userType == 'Organization') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrgForm(user: user)),
      );
    } else if (user.userType == 'Attendee') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendeeForm(user: user)),
      );
    }
  }
}

void main() {
  runApp(MyPage());
}


