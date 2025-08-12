import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

  Phrase({
    required this.url,
    required this.localpath,
    required this.duration,
    required this.filesize,
    required this.reader,
    required this.citation,
    required this.translation,
    required this.transcription,
    required this.tags,
  });

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
      citation: json['citation'] as String,
    );
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

  Future<void> download() async {
    if (!await isLocal()) {
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
    return Translation(text: json['text'], language: json['language']);
  }

  Map<String, dynamic> toJson() => {'text': text, 'language': language};
}

class Transcription {
  String language;
  String text;

  Transcription({required this.language, required this.text});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(language: json['language'], text: json['text']);
  }

  Map<String, dynamic> toJson() => {'language': language, 'text': text};
}
