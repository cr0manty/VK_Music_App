import 'package:flutter/material.dart';
import 'package:fox_music/models/playlist.dart';

class DialogPlaylistContent extends StatefulWidget {
  final List<PlaylistCheckbox> playlistList;

  DialogPlaylistContent({Key key, this.playlistList}) : super(key: key);

  @override
  DialogPlaylistContentState createState() => new DialogPlaylistContentState();
}

class DialogPlaylistContentState extends State<DialogPlaylistContent> {
  @override
  Widget build(BuildContext context) {
    return widget.playlistList.length == 0
        ? Container()
        : Column(
            children: List<Column>.generate(widget.playlistList.length,
                (int index) => _buildPlaylistList(index)));
  }

  _buildPlaylistList(int index) {
    PlaylistCheckbox playlist = widget.playlistList[index];
    return Column(children: [
      GestureDetector(
        onTap: () {
          setState(() {
            playlist.checked = !playlist.checked;
          });
        },
          child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 12, left: 25, right: 25, bottom: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(playlist.playlist.title,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    playlist.checked
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 15,
                          )
                        : Container()
                  ]))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Divider(color: Colors.grey),
      )
    ]);
  }
}
