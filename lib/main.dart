import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // ✅ este contexto sí está dentro del árbol de Navigator
    );
  }
}


class HomePage extends StatelessWidget {
  String obtenerMensaje() {
    int hora = DateTime.now().hour;
    if (hora < 12) {
      return 'Buenos días';
    } else if (hora < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vista 1")),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('hola'),
          ElevatedButton(
          child: Text(obtenerMensaje()),
          onPressed: () {
            print(obtenerMensaje());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _Vista2()),
            );
          },
        ),
  ],
      ),
    ),
    );
  }
}

class _Vista2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // o cualquier acción que desees
          },
        ),
        title: Text('Vista 2'),
      ),
      body: Center(child: Text("Hola desde la vista 2")),
    );
  }
}
