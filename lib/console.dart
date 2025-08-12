import 'package:flutter/material.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'phraselist.dart';

class Console extends StatelessWidget {
  Console({super.key, required this.list});

  final PhraseList list;
  final FlutterConsoleController controller = FlutterConsoleController();

  void echoLoop() {
    controller.scan().then((value) async {
      controller.print(message: value, endline: true);
      controller.focusNode.requestFocus();
      switch (value.trim()) {
        case 'a':
          controller.print(message: "Repeat current phrase ...", endline: true);
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
          controller.print(
            message: 'transcription: ${await list.showTranscription()}',
            endline: true,
          );
          break;
        case 's':
          controller.print(
            message: 'translation: ${await list.showTranslation()}',
            endline: true,
          );
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
