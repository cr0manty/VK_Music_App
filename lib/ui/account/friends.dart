import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fox_music/utils/hex_color.dart';
import 'package:fox_music/models/relationship.dart';
import 'package:fox_music/instances/account_data.dart';
import 'package:fox_music/ui/Account/people.dart';
import 'package:fox_music/widgets/apple_search.dart';

class FriendListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FriendListPageState();
}

class FriendListPageState extends State<FriendListPage> {
  TextEditingController controller = TextEditingController();
  List<Relationship> friendListSorted = AccountData.instance.friendList;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Friends'),
          actionsForegroundColor: HexColor.main(),
          previousPageTitle: 'Back',
        ),
        child: SafeArea(
            child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverRefreshControl(
              onRefresh: () => AccountData.instance.loadFiendList()),
          friendListSorted.length > 0
              ? SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      friendListSorted.length + 1,
                      (index) => _buildUserCard(index))))
              : SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'Your friends list is empty',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                        textAlign: TextAlign.center,
                      ))),
        ])));
  }

  void _filterFriends(String value) {
    String newValue = value.toLowerCase();
    setState(() {
      friendListSorted = AccountData.instance.friendList
          .where((Relationship relationship) =>
              relationship.user.firstName.toLowerCase().contains(newValue) ||
              relationship.user.lastName.toLowerCase().contains(newValue))
          .toList();
    });
  }

  _buildUserCard(int index) {
    if (index == 0) {
      return AppleSearch(
          controller: controller,
          onChange: (value) {
            _filterFriends(value);
          });
    }
    Relationship relationship = friendListSorted[index - 1];

    return Material(
      color: HexColor.background(),
        child: Column(children: [
      Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            child: ListTile(
                title: Text(
                    relationship.user.lastName.isEmpty
                        ? 'Unknown'
                        : relationship.user.lastName,
                    style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1))),
                subtitle: Text(
                    relationship.user.firstName.isEmpty
                        ? 'Unknown'
                        : relationship.user.firstName,
                    style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1))),
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => PeoplePage(relationship)));
                },
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        Image.network(relationship.user.imageUrl()).image))),
        secondaryActions: <Widget>[
          SlideAction(
            color: HexColor('#5994ce'),
            child: Icon(Icons.block, color: Colors.white),
            onTap: null,
          ),
          SlideAction(
            color: HexColor('#d62d2d'),
            child: Icon(SFSymbols.trash, color: Colors.white),
            onTap: null,
          ),
        ],
      ),
      Padding(padding: EdgeInsets.only(left: 12.0), child: Divider(height: 1))
    ]));
  }
}
