import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/Myhomepage.dart';
import 'package:eventify/page2.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventlist.dart';

void main() {
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: MyForm(user:user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyForm extends StatefulWidget {
  final User user;

  MyForm({required this.user});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _venue = TextEditingController();
  final TextEditingController _org = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Registration",
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Salsa',
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
        children: [
          Padding(padding: EdgeInsets.only(top:20)),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name",
              icon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            controller: _name,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onTap: () => _selectDate(context),
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Date",
              icon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            controller: _selectedDate != null
                ? TextEditingController(text: _formatDate(_selectedDate!))
                : TextEditingController(),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Time",
              icon: Icon(Icons.timelapse),
              border: OutlineInputBorder(),
            ),
            controller: _time,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Venue",
              icon: Icon(Icons.location_pin),
              border: OutlineInputBorder(),
            ),
            controller: _venue,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Organisation",
              icon: Icon(Icons.work),
              border: OutlineInputBorder(),
            ),
            controller: _org,
          ),
          const SizedBox(
            height: 3
            ,
          ),
          ElevatedButton(
            onPressed: addEvent,
            style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Color(0xffAE72FD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(100, 50),
            ),
            child: const Text(
              "Add Event",
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
  void addEvent() async {
    try {
      if (_name.text.isEmpty ||
          _selectedDate == null ||
          _time.text.isEmpty ||
          _venue.text.isEmpty ||
          _org.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection = firestore.collection('events');

      // Add a new document with automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '',  // Leave it empty; Firestore will generate a unique ID
        'name': _name.text,
        'date': _formatDate(_selectedDate!),
        'time': _time.text,
        'venue': _venue.text,
        'org': _org.text,
      });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Event added');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventListPage(user: widget.user)),
      );
    } catch (e) {
      print(e);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}





