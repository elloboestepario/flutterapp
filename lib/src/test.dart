import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  //read json file
  final file = File('lib/src/phar.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  Phrase phraseObject = Phrase.fromJson(data);
  //for (Transcription object in phraseObject.transcription){
    //print(object.text);
  //}
  //is local
  //print(await phraseObject.isLocal());
  //download audio
  await phraseObject.download();
  //play audio
  phraseObject.start();
}

class Phrase {
  String url;
  String localpath;
  int duration;
  int filesize;
  String reader;
  String citation;
  Translation translation;
  List<Transcription> transcription;
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
      transcription: Transcription.fromJsonList(json['transcription']),
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
    'transcription': transcription.map((t) => t.toJson()).toList(),
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
  String system;
  String text;

  Transcription({required this.system, required this.text});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      system: json['system'],
      text: json['text'],
    );
  }

  static List<Transcription> fromJsonList(List<dynamic> list) {
    return list.map((item) => Transcription.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
    'system': system,
    'text': text,
  };
}



