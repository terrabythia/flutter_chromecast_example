import 'dart:async';

import 'package:dart_chromecast/casting/cast.dart';
import 'package:flutter/material.dart';

class CastMiniMediaControls extends StatefulWidget {

  final CastSender activeSender;
  final bool canExtend;

  CastMiniMediaControls(this.activeSender, {bool canExtend})
    : this.canExtend = canExtend;

  @override
  _CastMiniMediaControlsState createState() => _CastMiniMediaControlsState();

}

class _CastMiniMediaControlsState extends State<CastMiniMediaControls> {

  CastMediaStatus _mediaStatus;

  @override
  void initState() {

    super.initState();

    widget.activeSender.castMediaStatusController.stream.listen(_mediaStatusChanged);
    setState(() {
      if (null != widget.activeSender.castSession)
        _mediaStatus = widget.activeSender.castSession.castMediaStatus;
    });

  }

  _mediaStatusChanged(CastMediaStatus mediaStatus) {
    if (this.mounted) {
      setState(() {
        _mediaStatus = mediaStatus;
      });
    }
  }

  void _openExtendedMediaControls() {

  }

  void _togglePause() {
    widget.activeSender.togglePause();
  }

  @override
  Widget build(BuildContext context) {

    // build icon here (or loading when not casting
    IconButton playButton = IconButton(
      icon: Icon(Icons.access_time),
      onPressed: () {},
    );

    if (null != _mediaStatus) {
      playButton = IconButton(
        onPressed: _togglePause,
        icon: _mediaStatus.isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause),
      );
    }

    Widget image;
    if (null != _mediaStatus && null != _mediaStatus.media && !_mediaStatus.isLoading && !_mediaStatus.isBuffering) {
      image = Image.network(
        _mediaStatus.media['images'][0],
        width: 100.0,
        fit: BoxFit.cover,
      );
    }
    else if (null != _mediaStatus && (_mediaStatus.isLoading || _mediaStatus.isBuffering)) {
      image = Container(
        constraints: BoxConstraints(
          maxWidth: 100.0,
          maxHeight: double.infinity,
        ),
        child: CircularProgressIndicator(),
      );
    }
    else {
      image = Container(
        constraints: BoxConstraints(
          maxWidth: 100.0,
          maxHeight: double.infinity,
        ),
      );
    }

    Widget container = Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              image,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text( null != _mediaStatus && null != _mediaStatus.media ? _mediaStatus.media['title'] : 'Waiting for media'),
                      Text('Casting to ${null != widget.activeSender.device ? widget.activeSender.device.friendlyName : 'Uknown device'}')
                    ],
                  )
                ),
              ),
              playButton,
            ],
          ),
          Stack(
            children: <Widget>[
              Container(color: Colors.grey,),
              Container(color: Colors.blue),
            ],
          )
        ],
      ),
    );

    if (widget.canExtend) {
      container = GestureDetector(
        onTap: () => _openExtendedMediaControls,
        child: container,
      );
    }

    return container;

  }

  dispose() {
    super.dispose();

  }

}
