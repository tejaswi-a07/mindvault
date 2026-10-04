import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioMemoryPlayer extends StatefulWidget {
  final String dataUri;

  const AudioMemoryPlayer({super.key, required this.dataUri});

  @override
  State<AudioMemoryPlayer> createState() => _AudioMemoryPlayerState();
}

class _AudioMemoryPlayerState extends State<AudioMemoryPlayer> {
  late final AudioPlayer _player;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _load();
  }

  Future<void> _load() async {
    try {
      await _player.setUrl(widget.dataUri);
    } catch (e) {
      if (mounted) setState(() => _error = 'Audio could not be loaded.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return ListTile(
        leading: const Icon(Icons.error_outline_rounded),
        title: Text(_error!),
      );
    }

    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        final completed = snapshot.data?.processingState == ProcessingState.completed;
        return Row(
          children: [
            IconButton.filled(
              tooltip: playing ? 'Pause' : 'Play voice memory',
              onPressed: () async {
                if (completed) await _player.seek(Duration.zero);
                if (playing) {
                  await _player.pause();
                } else {
                  await _player.play();
                }
              },
              icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Voice memory',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                final duration = _player.duration ?? Duration.zero;
                return Text(
                  '${_format(position)} / ${_format(duration)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _format(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
