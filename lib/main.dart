import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  //json
  final url = 'https://raw.githubusercontent.com/elloboestepario/flutterapp/master/lib/phar.json';
  //rest api
  final response = await http.get(Uri.parse(url));
  final jsonString = response.body;
  List<dynamic> data = jsonDecode(jsonString);

  PhraseList list = PhraseList.fromJson(data);
  list.playAgain();
}

class Phrase {
  String url;
  String localpath;
  int duration;
  int filesize;
  String reader;
  String citation;
  Translation translation;
  Transcription transcription;
  List<String> tags;

  late final AudioPlayer _player = AudioPlayer();

  Phrase({required this.url, required this.localpath, required this.duration, required this.filesize, required this.reader, required this.citation, required this.translation, required this.transcription, required this.tags});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      url: json['url'],
      localpath: json['localpath'] as String,
      duration: json['duration'] as int,
      filesize: json['filesize'] as int,
      translation: Translation.fromJson(json['translation']),
      transcription: Transcription.fromJson(json['transcription']),
      tags: List<String>.from(json['tags']),
      reader: json['reader'] as String,
      citation: json['citation'] as String,);
  }

  Future<bool> isLocal() async {
    final audioFile = await resolvedPath;
    return await audioFile.exists();
  }
  //rout multiplatform
  Future<File> get resolvedPath async {
    final dir = await getApplicationDocumentsDirectory();
    final path = File(p.join(dir.path, localpath));
    if (!(await path.exists())) {
      await path.create(recursive: true);
    }
    return path;
  }

  Future<void> download() async{
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //rout multiplatform
      final file = await resolvedPath;
      await file.writeAsBytes(response.bodyBytes);
      print('download in $localpath');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> start () async{
    final file = await resolvedPath;
    await _player.play(DeviceFileSource(file.path));
  }

  Future<void> play () async{
    await _player.resume();
  }

  Future<void> pause () async{
    await _player.pause();
  }

  Future<void> stop () async{
    await _player.dispose();
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'localpath': localpath,
    'duration': duration,
    'filesize': filesize,
    'translation': translation.toJson(),
    'transcription': transcription.toJson(),
    'tags': tags,
    'reader': reader,
    'citation': citation,
  };

}

class Translation {
  String text;
  String language;

  Translation({required this.text, required this.language});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      text: json['text'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'language': language,
  };
}

class Transcription {
  String language;
  String text;

  Transcription({required this.language, required this.text});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      language: json['language'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'text': text,
  };
}

class PhraseList {
  final List<Phrase> phrases;
  int _index = 0;

  PhraseList({required this.phrases});
  
  factory PhraseList.fromJson(List<dynamic> jsonList) {
    return PhraseList(
      phrases: jsonList.map((item) => Phrase.fromJson(item)).toList(),
    );
  }

  Future<void> playNext() async  {
    //_index++;
    if (_index < phrases.length - 1) {
      await phrases[_index].start();
      print(_index);
    }
  }

  Future<void> playAgain() async {
    await phrases[_index].start();
    print('repeat audio');
  }

  Future<void> showTranslation() async {
    print(phrases[_index].translation.text);
  }

  Future<void> showTranscription() async {
    print(phrases[_index].transcription.text);
  }
}



