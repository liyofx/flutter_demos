import 'package:flutter/material.dart';
import 'package:flutter_demos/pub.dev/geolocator/utils.dart';
import 'package:geolocator/geolocator.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (position != null) Text(position!.toJson().toString()),
            TextButton(
              child: Text("My Location"),
              onPressed: () => determinePosition().then((value) {
                setState(() {
                  position = value;
                });
              }),
            )
          ],
        ),
      ),
    );
  }
}
