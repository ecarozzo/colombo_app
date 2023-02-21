import 'package:colombo_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/auth_methods.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();

  getOccupazione() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collectionGroup('postazioni')
        .where('mail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
    return FirebaseFirestore.instance
        .collection(data.docs.first.reference.path + "/database_occupazione")
        .orderBy("data")
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
              setState(() {
              });
              await Authentication.signOut(context: context);
              setState(() {
              });
              Navigator.of(context)
                  .pushReplacement(_routeToSignInScreen());
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: getOccupazione(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<DataRow> rows = [];
                snapshot.data.docs.forEach((doc) {
                  rows.add(DataRow(cells: <DataCell>[
                    DataCell(Text(getFormattedData(doc.data()["data"]))),
                    DataCell(
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: doc.data()["libero"],
                        onChanged: (bool? value) {
                          setState(() {
                            FirebaseFirestore.instance.doc(doc.reference.path).update(({'libero': value}));
                          });
                        },
                      ),
                    ),
                    DataCell(Checkbox(
                      value: doc.data()["venduto"],
                      onChanged: (bool? value) {},
                    ))
                  ]));
                });
                return SingleChildScrollView(child: DataTable(columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Data'),
                  ),
                  DataColumn(
                    label: Text('Libero'),
                  ),
                  DataColumn(
                    label: Text('Venduto'),
                  ),
                ], rows: rows));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String getFormattedData(var date){
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

class NavigateDrawer extends StatefulWidget {
  final String uid;
  final String path;

  NavigateDrawer({required Key key, required this.uid, required this.path}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
                future: FirebaseFirestore.instance.doc(widget.path).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data?['mail']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            accountName: FutureBuilder(
                future: FirebaseFirestore.instance.doc(widget.path).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data?['nome']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Home'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.settings, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Settings'),
            onTap: () {
              print(widget.uid);
            },
          ),
        ],
      ),
    );
  }
}
