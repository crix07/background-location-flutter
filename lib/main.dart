import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:boot_completed/boot_completed.dart' as boot_completed;

void main() {
  runApp(MyApp());
  boot_completed.setBootCompletedFunction(currentLocation);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Location APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Background Location APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

StreamSubscription subscriptionLocation;


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    checkPermission();
    currentLocation();
  }

  currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(position == null
        ? 'Unknown'
        : position.latitude.toString() + ', ' + position.longitude.toString());
    realtimeLocation();
  }

  checkPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      await Geolocator.openLocationSettings();
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Favor de activar la ubicación para tener una mejor experiencia");
    }
    debugPrint(permission.toString());
  }

  @override
  dispose() {
    subscriptionLocation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hii:',
              )
            ],
          ),
        ));
  }
}

currentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  print(position == null
      ? 'Unknown'
      : position.latitude.toString() + ', ' + position.longitude.toString());
  realtimeLocation();
}

realtimeLocation() {
  subscriptionLocation =
      Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
          .listen((Position position) {
    print(position == null
        ? 'Unknown'
        : position.latitude.toString() + ', ' + position.longitude.toString());
  });
}
