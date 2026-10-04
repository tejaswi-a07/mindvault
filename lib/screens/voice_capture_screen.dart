import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({super.key});

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> {
  static const _sampleRate = 16000;
  static const _maxSeconds = 20;

  final AudioRecorder _recorder = AudioRecorder();
  final TextEditingController _titleController = TextEditingController(text: 'Voice memory');
  final List<Uint8List> _chunks = [];

  StreamSubscription<Uint8List>? _streamSubscription;
  Timer? _timer;
  int _seconds = 0;
  bool _isRecording = false;
  bool _isSaving = false;
  String? _audioData;

  @override
  void dispose() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    _recorder.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (!await _recorder.hasPermission()) {
        _showError('Microphone permission was denied. Please allow microphone access in Chrome.');
        return;
      }

      _chunks.clear();
      _seconds = 0;
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: _sampleRate,
          numChannels: 1,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
        ),
      );

      _streamSubscription = stream.listen(_chunks.add);
      setState(() => _isRecording = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (!mounted) return;
        setState(() => _seconds++);
        if (_seconds >= _maxSeconds) await _stopRecording();
      });
    } catch (e) {
      _showError('Could not start the microphone: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    _timer?.cancel();
    _timer = null;
    await _recorder.stop();
    await _streamSubscription?.cancel();
    _streamSubscription = null;

    if (_chunks.isEmpty) {
      if (mounted) setState(() => _isRecording = false);
      _showError('No audio was captured. Please try again.');
      return;
    }

    final wav = _buildWav(_chunks);
    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _audioData = 'data:audio/wav;base64,${base64Encode(wav)}';
    });
  }

  Uint8List _buildWav(List<Uint8List> chunks) {
    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final bytes = Uint8List(totalLength);
    var offset = 0;
    for (final chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    final output = Uint8List(44 + bytes.length);
    final data = ByteData.view(output.buffer);

    void writeString(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        output[offset + i] = value.codeUnitAt(i);
      }
    }

    writeString(0, 'RIFF');
    data.setUint32(4, 36 + bytes.length, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, _sampleRate, Endian.little);
    data.setUint32(28, _sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    writeString(36, 'data');
    data.setUint32(40, bytes.length, Endian.little);
    output.setRange(44, output.length, bytes);
    return output;
  }

  Future<void> _save() async {
    if (_audioData == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final title = _titleController.text.trim().isEmpty ? 'Voice memory' : _titleController.text.trim();
      final now = DateTime.now();
      await context.read<AppProvider>().addNote(
        Note(
          id: 'voice-${now.microsecondsSinceEpoch}',
          title: title,
          content: 'Voice memo recorded for ${_seconds.clamp(1, _maxSeconds)} seconds.',
          category: 'Personal',
          mood: '🎙️',
          createdAt: now,
          updatedAt: now,
          tags: const ['voice'],
          type: 'voice',
          mediaData: _audioData,
          mediaType: 'audio',
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Could not save voice memory: $e');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice memory'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _isSaving ? null : () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                controller: _titleController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give this voice memory a name',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF191A28) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? const Color(0xFF292B3E) : const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red.withOpacity(0.14) : AppTheme.primaryViolet.withOpacity(0.12),
                      ),
                      child: Icon(
                        _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                        size: 44,
                        color: _isRecording ? Colors.red : AppTheme.primaryViolet,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _isRecording ? 'Recording… $_seconds s' : (_audioData == null ? 'Ready to record' : 'Recording ready'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRecording ? 'Speak naturally. Recording stops automatically after $_maxSeconds seconds.' : 'Chrome will ask for microphone permission the first time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : (_isRecording ? _stopRecording : _startRecording),
                      icon: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded),
                      label: Text(_isRecording ? 'Stop recording' : 'Start recording'),
                    ),
                    if (_audioData != null && !_isRecording) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isSaving ? null : _startRecording,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Record again'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(_isSaving ? 'Saving…' : 'Save voice memory'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
