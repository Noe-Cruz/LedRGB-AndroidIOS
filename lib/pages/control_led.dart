import 'package:appcontrolled/services/notification_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ControlLed extends StatefulWidget {
  const ControlLed({super.key});

  @override
  State<ControlLed> createState() => _ControlLedState();
}

class _ControlLedState extends State<ControlLed> {
  late String _status;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _statusSubscription;

  @override
  void initState() {
    _status = "OFF";
    _startListeningToStatusChanges();
    super.initState();
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    super.dispose();
  }


  //Actualización de las claves en Firebase y variables locales
  Future<void> _updateStatus(String status) async {
    try {
      await _database.child('status').set(status);
      await _database.child('color').set(status == "ON" ? "255,255,255" : "0,0,0");
      setState(() {
        _status = status;
      });
    } catch (e) {
      // Handle error
      print('Error updating status: $e');
    }
  }

  //Escucha y actualización automatica de claves en Firebase y variables locales
  void _startListeningToStatusChanges() {
    _statusSubscription = _database.child('status').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final newStatus = event.snapshot.value.toString();
        if (newStatus != _status) {
          showNotification(newStatus);
          setState(() {
            _status = newStatus;
          });
        }
      } else {
        print('Status is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Control Led',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buttons()
        ],
      ),
    );
  }

  Widget _buttons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    color: Colors.green,
                    iconSize: 100.0,
                    hoverColor: Colors.green,
                    onPressed: ()  {
                      showNotification("ON");
                      _updateStatus("ON");
                    },
                  ),
                  const Text(
                    'ON',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 90.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    color: Colors.red,
                    iconSize: 100.0,
                    hoverColor: Colors.red,
                    onPressed: ()  {
                      showNotification("OFF");
                      _updateStatus("OFF");
                    },
                  ),
                  const Text(
                    'OFF',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
