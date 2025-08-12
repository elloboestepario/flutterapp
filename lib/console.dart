import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'phraselist.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.list});

  final PhraseList list;
  final FlutterConsoleController controller = FlutterConsoleController();

  void echoLoop() {
    controller.scan().then((value) {
      controller.print(message: value, endline: true);
      controller.focusNode.requestFocus();
      switch (value.trim()) {
        case 'a':
          controller.print(
            message: "Repeat current phrase ...",
            endline: true,
          );
          list.start();
          break;
        case 'n':
          controller.print(
            message: "Replay the audio from the beginning...",
            endline: true,
          );
          list.playAgain();
          break;
        case 't':
          list.showTranscription();
          break;
        case 's':
          list.showTranslation();
          break;
      }

      echoLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.print(message: "Console", endline: true);
    echoLoop();

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: FlutterConsole(
        controller: controller,
        height: size.height,
        width: size.width,
      ),
    );
  }
}