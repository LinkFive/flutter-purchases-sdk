import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/cupertino.dart';

class Keys {
  final String linkFiveApiKey;

  Keys({this.linkFiveApiKey = ""});

  factory Keys.fromJson(Map<String, dynamic> jsonMap) {
    return new Keys(linkFiveApiKey: jsonMap["linkfive_api_key"]);
  }
}

class KeyLoader {
  final String keyPath = "assets/apikey.json";

  KeyLoader();

  Future<Keys> load(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString(keyPath);
    final jsonResult = json.decode(data);
    return Keys.fromJson(jsonResult);
  }
}
