import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:async';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final player = AudioCache(respectSilence: true);
  List _buffer = [];
  double _tempo = 1;

  void _playSound(String filename) => player.play(filename);

  void _setTempo(double tempo) => setState(() => _tempo = tempo);

  void _saveSound({String filename}) =>
      (_buffer.length > 10) ? _buffer.removeAt(0) : _buffer.add(filename);

  int _convertTempo(double tempo) => (_tempo * 1000).toInt() + 500;

  void _playMelody(int index) {
    if (index >= _buffer.length) return;
    Future.delayed(Duration(milliseconds: _convertTempo(_tempo)), () {
      _playSound(_buffer[index]);
      index++;
      _playMelody(index);
    });
  }

  Widget buildKey(
      {Color color = Colors.white,
      String filename = 'note1.wav',
      double factor}) {
    return Expanded(
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: factor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FlatButton(
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            onPressed: () {
              _saveSound(filename: filename);
              _playSound(filename);
            },
          ),
        ),
      ),
    );
  }

  Widget buildSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 600,
        child: Row(children: [
          Text(
            'TEMPO',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Slider(value: _tempo, onChanged: _setTempo, min: 0, max: 1),
          Text(
            _convertTempo(_tempo).toString(),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            _playMelody(0);
          },
        ),
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            buildKey(color: Colors.red, filename: 'note1.wav', factor: 1),
            buildKey(color: Colors.orange, filename: 'note2.wav', factor: 0.9),
            buildKey(color: Colors.yellow, filename: 'note3.wav', factor: 0.8),
            buildKey(color: Colors.green, filename: 'note4.wav', factor: 0.7),
            buildKey(color: Colors.teal, filename: 'note5.wav', factor: 0.6),
            buildKey(color: Colors.blue, filename: 'note6.wav', factor: 0.5),
            buildKey(color: Colors.purple, filename: 'note7.wav', factor: 0.4),
            buildSlider()
          ]),
        ),
      ),
    );
  }
}
