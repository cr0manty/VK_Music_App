import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:vk_parse/functions/getToken.dart';
import 'package:vk_parse/functions/getLastRoute.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final int splashDuration = 2;

  startTime() async {
    final token = await getToken();
    final lastPage = await getLastRoute();
    return Timer(Duration(seconds: splashDuration), () {
      bool needToken = true;
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (lastPage != 'Login') {
        if (token == null || token.length == 0) {
          needToken = false;
        }
      }
      Navigator.of(context)
          .pushReplacementNamed(needToken ? lastPage : '/Login');
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer();

    return Scaffold(
        drawer: drawer,
        body: Container(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    alignment: FractionalOffset(0.5, 0.3),
                    child: Text(
                      "VK Music",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                  ),
                ),
                Center(
                    child: new Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: SpinKitCircle(
                          color: Colors.white,
                          size: 80,
                        ))),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                  child: Text(
                    "© Cr0manty 2019",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}
