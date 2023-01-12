import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'dart:math' as math;

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

const names = [
  'foo',
  'bar',
  'baz',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

// Sink
class UpperCaseSink implements EventSink<String> {
  final EventSink<String> _sink;
  const UpperCaseSink(this._sink);

  @override
  void add(String event) => _sink.add(event.toUpperCase());

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  void close() => _sink.close();
}

// Transformer
class StreamTransformUpperCaseString
    extends StreamTransformerBase<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) => Stream<String>.eventTransformed(
        stream,
        (sink) => UpperCaseSink(sink),
      );
}

void TestIt() async {
  await for (final name in Stream.periodic(
    Duration(seconds: 1),
    (_) => names.getRandomElement(),
  ).transform(StreamTransformUpperCaseString())) {
    name.log();
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
