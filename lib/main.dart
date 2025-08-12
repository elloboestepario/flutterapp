import 'dart:convert';
import 'package:http/http.dart' as http;
import 'phraselist.dart';
import 'package:flutter/material.dart';
import 'console.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // json
  final url =
      'https://raw.githubusercontent.com/elloboestepario/flutterapp/master/lib/phar.json';
  final response = await http.get(Uri.parse(url));
  final jsonString = response.body;
  final data = jsonDecode(jsonString);

  PhraseList list = PhraseList.fromJson(data);

  //console flutter
  runApp(MaterialApp(home: Console(list: list)));
}
