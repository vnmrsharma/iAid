import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoder/geocoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iAid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'iAid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _database() async {
    LocationData currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      double lat = currentLocation.latitude;
      double lng = currentLocation.longitude;
      final coordinates = new Coordinates(lat, lng);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      _neverSatisfied(first);
    } catch (e) {
      print("error");
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("iAid"),
      ),
      body: bodyData(),
    );
  }

  Future<void> _neverSatisfied(var first) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("${first.addressLine}")],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget bodyData() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Ink(
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.all_inclusive,
                    color: Colors.blueAccent,
                  ),
                  iconSize: 150.0,
                  splashColor: Colors.redAccent,
                  padding: EdgeInsets.all(40.0),
                  onPressed: () {
                    _database();
                  },
                )),
            Padding(
              padding: EdgeInsets.all(25.0),
            ),
            Text(
              "Emergency",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.2,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
}
