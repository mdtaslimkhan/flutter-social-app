import 'dart:convert';

import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:http/http.dart' as http;


class GroupFunctions{

  Future updateGroup({String groupId, String text, String field}) async {
    final String url = BaseUrl.baseUrl("updateNameGroup");
    final response = await http.post(Uri.parse(url), headers: {
      'test-pass': ApiRequest.mToken
    }, body: {
      'id': groupId,
      'text': text,
      'field' : field
    });

    Map data = jsonDecode(response.body);

    print(data);

    if (response.statusCode == 200) {
      if (!data['error']) {
        return true;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}