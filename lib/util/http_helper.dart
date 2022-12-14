import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:http/http.dart';
import 'package:wordling/models/definition.dart';

class HttpHelper {
  static Future<List<Definition>> search(String searchTerm) async {
    Uri url =
        Uri.parse('https://api.urbandictionary.com/v0/define?term=$searchTerm');
    Response response = await get(url);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Problem while attempting to fetch data from API.');
    }
    List raw = json.decode(response.body)['list'];
    return raw
        .map((e) => Definition(
              id: e['defid'],
              word: stripAngleBrackets(e['word']),
              definition: stripAngleBrackets(e['definition']),
              example: stripAngleBrackets(e['example']),
              origin: Origin.downloaded,
            ))
        .toList();
  }

  static String stripAngleBrackets(String input) {
    String newString = "";
    for (int i = 0; i < input.length; i++) {
      if (input[i] == ']' || input[i] == '[') continue;
      newString += input[i];
    }
    return newString;
  }
}
