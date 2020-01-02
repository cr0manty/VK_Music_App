import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:vk_parse/functions/utils/infoDialog.dart';
import 'package:vk_parse/api/requestProfile.dart';
import 'package:vk_parse/utils/urls.dart';

requestLogin(BuildContext context, String username, String password) async {
  Map<String, String> body = {
    'username': username,
    'password': password,
  };
  try {
    final response = await http
        .post(
          AUTH_URL,
          body: body,
        )
        .timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return requestProfile(context, responseJson['token']);
    } else {
      infoDialog(
          context,
          "Unable to Login",
          "You may have supplied an invalid 'Username' / 'Password' combination.");
      return null;
    }
  } on TimeoutException catch (_) {
    infoDialog(context, "Server Error", "Can't connect to server");
    return null;
  } catch (e) {
    print(e);
  }
}
