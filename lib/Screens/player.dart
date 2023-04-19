// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerWidget extends StatefulWidget {
  final path;

  const PlayerWidget(this.path, {super.key});

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            if (_isPlaying) {
              await _audioPlayer.stop();
            } else {
              await _audioPlayer.play(widget.path);
            }
            setState(() {
              _isPlaying = !_isPlaying;
            });
          },
          icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
        ),
        Text(widget.path.split('/').last),
      ],
    );
  }
}
