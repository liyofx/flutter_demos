import 'package:flutter/material.dart';
import 'package:flutter_demos/medium.com/overlay/auto_complete_field.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            AutoCompleteField(),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'City'),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('SUBMIT'))
          ],
        )),
      ),
    );
  }
}
