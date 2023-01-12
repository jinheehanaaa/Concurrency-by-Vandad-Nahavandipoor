import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

// Person Constructor: Instance of Person class with given json map
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person ($name, $age years old)';
}

// http://localhost:5500/api/people1.json
//const people1Url = 'http://10.0.2.2:5500/api/people1.json';
//const people2Url = 'http://10.0.2.2:5500/api/people2.json';

mixin ListOfThingsAPI<T> {
  Future<Iterable<T>> get(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((resp) => resp.transform(utf8.decoder).join())
      .then((str) => json.decode(str) as List<dynamic>)
      .then((list) => list.cast());
}

class GetApiEndPoints with ListOfThingsAPI<String> {}

class GetPeople with ListOfThingsAPI<Map<String, dynamic>> {
  Future<Iterable<Person>> getPeople(String url) =>
      get(url).then((jsons) => jsons.map(
            (json) => Person.fromJson(json),
          ));
}

void TestIt() async {
  await for (final people
      in Stream.periodic(const Duration(seconds: 3)).asyncExpand(
    (_) => GetPeople()
        .getPeople('http://10.0.2.2:5500/api/people1.json')
        .asStream(),
  )) {
    people.log();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TestIt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}
