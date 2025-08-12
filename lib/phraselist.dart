import 'phrase.dart';
import 'package:audioplayers/audioplayers.dart';

class PhraseList {
  final List<Phrase> phrases;
  int _index = 0;

  final AudioPlayer _player = AudioPlayer();

  PhraseList({required this.phrases});

  factory PhraseList.fromJson(List<dynamic> jsonList) {
    return PhraseList(
      phrases: jsonList.map((item) => Phrase.fromJson(item)).toList(),
    );
  }

  Future<void> playNext() async {
    if (_index < phrases.length - 1) {
      _index++;
      await start();
      print(_index);
    }
  }

  Future<void> start() async {
    final file = await phrases[_index].resolvedPath;
    await _player.play(DeviceFileSource(file.path));
  }

  Future<void> play() async {
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.dispose();
  }

  Future<void> playAgain() async {
    await _player.seek(Duration.zero);
    await play();
    print('repeat audio');
  }

  Future<void> showTranslation() async {
    print('translation: ${phrases[_index].translation.text}');
  }

  Future<void> showTranscription() async {
    print('transcription: ${phrases[_index].transcription.text}');
  }
}
