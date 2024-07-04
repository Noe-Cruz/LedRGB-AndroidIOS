import 'package:appcontrolled/services/notification_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'dart:async';

class LightControl extends StatefulWidget {
  const LightControl({Key? key}) : super(key: key);

  @override
  State<LightControl> createState() => _LightControl();
}

class _LightControl extends State<LightControl> {
  final _controller = CircleColorPickerController(
    initialColor: Colors.white,
  );
  Color colorSelect = Colors.white;
  double redValue = 0.0;
  double greenValue = 0.0;
  double blueValue = 255.0;
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

  //Actualización de las claves en Firebase ("color" RGB)
  Future<void> _sendColor(Color color) async {

    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    String data = '$red,$green,$blue';

    try {
      await _database.child('color').set(data);
    } catch (e) {
      // Handle error
      print('Error updating color: $e');
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

  void updateSelectedColor() {
    // Calcula el color combinado usando los valores de los sliders
    _controller.color = Color.fromARGB(255, redValue.toInt(), greenValue.toInt(), blueValue.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Control RGB',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.change_circle_outlined),
              color: Colors.blue, 
              iconSize: 80.0,
              hoverColor: Colors.grey,
              onPressed: () {
                showNotification(colorSelect);
                _sendColor(colorSelect);
              },
            ),
              const Text(
                'Change Color',
                style: TextStyle(fontSize: 15.0),
              ),
            const SizedBox(height: 30),
            CircleColorPicker(
              controller: _controller,
              onChanged: (color) {
                setState(() {
                  colorSelect = color;
                  redValue = color.red.toDouble();
                  greenValue = color.green.toDouble();
                  blueValue = color.blue.toDouble();
                });
              },
              strokeWidth: 15,
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Text(
                  'Red    ', 
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                ),
                Expanded(
                  child: Slider(
                    value: colorSelect.red.toDouble(),
                    min: 0.0,
                    max: 255.0,
                    onChanged: (double value) {
                      setState(() {
                        redValue = value;
                        updateSelectedColor();
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text(
                  'Green', 
                  style: TextStyle(fontSize: 20.0, color: Colors.green),
                ),
                Expanded(
                  child: Slider(
                    value: colorSelect.green.toDouble(),
                    min: 0.0,
                    max: 255.0,
                    onChanged: (double value) {
                      setState(() {
                        greenValue = value;
                        updateSelectedColor();
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text(
                  'Blue   ', 
                  style: TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 0, 119, 216)),
                ),
                Expanded(
                  child: Slider(
                    value: colorSelect.blue.toDouble(),
                    min: 0.0,
                    max: 255.0,
                    onChanged: (double value) {
                      setState(() {
                        blueValue = value;
                        updateSelectedColor();
                      });
                    },
                    activeColor: const Color.fromARGB(255, 0, 119, 216),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
