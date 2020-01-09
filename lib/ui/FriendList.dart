import 'package:flutter/material.dart';

import 'package:vk_parse/utils/urls.dart';
import 'package:vk_parse/ui/AppBar.dart';
import 'package:vk_parse/models/User.dart';
import 'package:vk_parse/utils/colors.dart';
import 'package:vk_parse/functions/save/saveCurrentRoute.dart';
import 'package:vk_parse/api/requestFriendList.dart';
import 'package:vk_parse/functions/utils/infoDialog.dart';

class FriendList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendListState();
  }
}

class FriendListState extends State<FriendList> {
  final GlobalKey<ScaffoldState> _menuKey = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();
  List<User> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _menuKey,
      drawer: makeDrawer(context),
      appBar: makeAppBar('Friends', _menuKey),
      backgroundColor: lightGrey,
      body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: () async => await _loadFriends(),
          child: ListView(
            children: _buildList(),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFriends();
    saveCurrentRoute('/FriendList');
  }

  _loadFriends() async {
    final friendList = await requestFriendList();
    if (friendList != null) {
      setState(() {
        _data = friendList;
      });
    } else {
      infoDialog(
          context, "Unable to get Friends List", "Something went wrong.");
    }
  }

  List<Widget> _buildList() {
    if (_data == null) {
      return null;
    }
    return _data
        .map((User user) => ListTile(
            title: Text(user.last_name != null ? user.last_name : 'Unknown'),
            subtitle: Text(
                user.first_name != null ? user.first_name : 'Unknown',
                style: TextStyle(color: Colors.black54)),
            onTap: () {

            },
            trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert,
                    size: 35, color: Color.fromRGBO(100, 100, 100, 1))),
            leading: CircleAvatar(
                radius: 25,
                backgroundImage: user.image != null
                    ? Image.network(BASE_URL + user.image).image
                    : AssetImage('assets/images/user-default.jpg'))))
        .toList();
  }
}
