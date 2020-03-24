import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fox_music/api/app_version.dart';
import 'package:fox_music/functions/get/last_tab.dart';
import 'package:fox_music/functions/get/version.dart';
import 'package:fox_music/functions/save/version.dart';
import 'package:fox_music/functions/utils/info_dialog.dart';
import 'package:fox_music/utils/check_connection.dart';
import 'package:fox_music/utils/fade_route.dart';
import 'package:provider/provider.dart';
import 'package:fox_music/provider/account_data.dart';

import 'package:fox_music/provider/music_data.dart';
import 'package:fox_music/provider/download_data.dart';
import 'package:fox_music/ui/main_tab.dart';
import 'package:fox_music/utils/hex_color.dart';
import 'package:package_info/package_info.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => new _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final int splashDuration = 1;

  startTime() async {
    ConnectionsCheck connection = ConnectionsCheck.instance;
    await connection.initialise();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var currentAppVersion =
        connection.isOnline ? await appVersionGet() : await getLastVersion();
    if (packageInfo.version != currentAppVersion['version']) {
            saveLastVersion(currentAppVersion);
      await infoDialog(
          context, 'New version available', currentAppVersion['details']);
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    int lastIndex = await getLastTab();
    MusicData musicData = new MusicData();
    AccountData accountData = new AccountData();
    MusicDownloadData downloadData = new MusicDownloadData();
    await musicData.init(Theme.of(context).platform);
    await accountData.init();
    await downloadData.init(musicData);

    Navigator.popUntil(context, (Route<dynamic> route) => true);
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(
            page: MultiProvider(providers: [
          ChangeNotifierProvider<MusicData>.value(value: musicData),
          ChangeNotifierProvider<AccountData>.value(value: accountData),
          ChangeNotifierProvider<MusicDownloadData>.value(value: downloadData),
        ], child: MainPage(lastIndex))),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark
              ? HexColor('#282828')
              : Colors.white,
      child: Container(
        child: Image.asset('assets/images/audio-cover.png'),
        width: 0,
        height: 0,
      ),
    );
  }
}
