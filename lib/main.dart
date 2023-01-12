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

const people1Url = 'http://10.0.2.2:5500/api/people1.json';
const people2Url = 'http://10.0.2.2:5500/api/people2.json';

Future<Iterable<Person>> parseJson(String url) => HttpClient()
    .getUrl(Uri.parse(url)) // 1st pipe to create request Future
    .then((req) => req.close()) // Take req
    .then((resp) => resp
        .transform(utf8.decoder)
        .join()) // Create response pipe & parse it as string
    .then((str) =>
        json.decode(str) as List<dynamic>) // Take string & parse it as json
    .then((json) => json.map((e) => Person.fromJson(
        e))); // json is split into various instances of Person class to become Future<Iterable> type

extension EmptyOnError<E> on Future<List<Iterable<E>>> {
  Future<List<Iterable<E>>> emptyOnError() => catchError(
        (_, __) => List<Iterable<E>>.empty(),
      );
}

extension EmptyOnErrorOnFuture<E> on Future<Iterable<E>> {
  Future<Iterable<E>> emptyOnError() => catchError(
        (_, __) => Iterable<E>.empty(),
      );
}

void TestIt() async {
  final persons = await Future.wait([
    parseJson(people1Url).emptyOnError(),
    parseJson(people2Url).emptyOnError(),
  ]);
  // .catchError((_, __) => List<Iterable<Person>>.empty())
  persons.log();
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
