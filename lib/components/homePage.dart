import 'dart:convert';
import 'package:flutter/semantics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:weather/helpers/weather.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Geolocator _geo = Geolocator()..forceAndroidLocationManager;
  Position _position;
  String _city;

  @override
  void initState() {
    _city = "XXX";
    super.initState();
    _getCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(_city)));
  }

  _getCurrent() {
    _geo
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _position = position;
        debugPrint(position.toString());
      });
    });

    _getCityAndWeather();
  }

  _getCityAndWeather() async {
    try {
      List<Placemark> p = await _geo.placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      Placemark place = p[0];
      setState(() {
        print(json.encode(place));
        _city = place.name;
      });
    } catch (e) {
      print(e);
    }
  }
}
