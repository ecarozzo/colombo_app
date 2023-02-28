import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import '../constant/screen_name.dart';
import '../services/auth_methods.dart';

class HomeScreen extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  const HomeScreen({Key? key, required this.sessionStateStream}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getUserData() async {
    return await FirebaseFirestore.instance
        .collection('users_database')
        .where('mail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
  }

  getUserPrenotazioni() async {
    return await FirebaseFirestore.instance
        .collectionGroup('postazioni')
        .where('mail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date Libere"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              setState(() {});
              await Authentication(sessionStateStream: widget.sessionStateStream).signOut(context: context);
              setState(() {});
              Navigator.pushNamed(context, signInScreenRoute);
            },
          )
        ],
      ),
      body: Center(
          child: Row(
        children: [
          FutureBuilder(
              future: getUserData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  String data ="";
                  snapshot.data.docs.forEach((doc) {
                    data = doc.data()["nome"];
                  });
                  return Text(data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          FutureBuilder(
              future: getUserPrenotazioni(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<DataRow> rows = [];
                  snapshot.data.docs.forEach((doc) {
                    String path = doc.reference.path;

                    if (path.startsWith("/")) {
                      path = path.substring(1);
                    }
                    List<String> parts = path.split("/");

                    rows.add(DataRow(cells: <DataCell>[
                      DataCell(Text(parts[1] + " " + parts[3])),
                    ]));
                  });
                  return SingleChildScrollView(
                      child: DataTable(columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Data'),
                    )
                  ], rows: rows));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedData(var date) {
    // String locale = Localizations.localeOf(context).languageCode;
    // DateTime now = new DateTime.now();
    // String dayOfWeek = DateFormat.EEEE(locale).format(now);
    // String dayMonth = DateFormat.MMMMd(locale).format(now);
    // String year = DateFormat.y(locale).format(now);

    final Timestamp timestamp = date as Timestamp;
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('EEEE dd-MM-yyyy').format(dateTime);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
