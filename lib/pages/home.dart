import 'package:appcontrolled/pages/color_picker.dart';
import 'package:appcontrolled/pages/control_led.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageCurrent = 0;
  final List<Widget> _pages = [
    //const Conection(),
    const ControlLed(),
    const LightControl()  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _pages[_pageCurrent],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _pageCurrent = index;
          });
        },
        currentIndex: _pageCurrent,
        items: const [
          //BottomNavigationBarItem(icon: Icon(Icons.bluetooth_connected), label: "CONNECTION"),
          BottomNavigationBarItem(icon: Icon(Icons.light_mode), label: "ON/OFF"),
          BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: "Color RGB"),
        ],
      ),
    );
  }
}
