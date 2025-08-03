import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            // TRY THIS: Change to "Brightness.light"
            //           and see that all colors change
            //           to better contrast a light background.
            brightness: Brightness.dark,
          )), // Fuerza el modo oscuro// ✅ este contexto sí está dentro del árbol de Navigator
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
              Container(
                width: 500,
                child: LinearProgressIndicator(value: 0.75,),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          IconButton(
          icon: Icon(Icons.play_circle_outline_sharp,size: 62,),
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
