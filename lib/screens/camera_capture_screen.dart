import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeFuture;
  String? _imageData;
  bool _isSaving = false;
  final _titleController = TextEditingController(text: 'Photo memory');

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _initializeFuture = Future.error('No camera was found on this device.'));
        return;
      }

      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(camera, ResolutionPreset.medium, enableAudio: false);
      _controller = controller;
      _initializeFuture = controller.initialize();
      await _initializeFuture;
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _initializeFuture = Future.error(e));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || controller.value.isTakingPicture || _isSaving) return;

    try {
      final image = await controller.takePicture();
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _imageData = 'data:image/jpeg;base64,${base64Encode(bytes)}');
    } catch (e) {
      _showError('Could not take the photo: $e');
    }
  }

  Future<void> _save() async {
    if (_imageData == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final title = _titleController.text.trim().isEmpty ? 'Photo memory' : _titleController.text.trim();
      await context.read<AppProvider>().addNote(
        Note(
          id: 'photo-${now.microsecondsSinceEpoch}',
          title: title,
          content: 'Photo captured with MindVault.',
          category: 'Personal',
          mood: '📷',
          createdAt: now,
          updatedAt: now,
          tags: const ['photo'],
          type: 'photo',
          mediaData: _imageData,
          mediaType: 'image',
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Could not save photo memory: $e');
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
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo memory'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _isSaving ? null : () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: _titleController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give this photo a name',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 430,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF10111A) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? const Color(0xFF292B3E) : const Color(0xFFE5E7EB)),
                ),
                child: _imageData != null
                    ? Image.memory(base64Decode(_imageData!.split(',').last), fit: BoxFit.cover)
                    : FutureBuilder<void>(
                        future: _initializeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.no_photography_outlined, size: 48),
                                    const SizedBox(height: 12),
                                    const Text('Camera could not be opened.', textAlign: TextAlign.center),
                                    const SizedBox(height: 8),
                                    Text('Check Chrome camera permission and try again.', textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (snapshot.connectionState != ConnectionState.done || controller == null || !controller.value.isInitialized) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return CameraPreview(controller);
                        },
                      ),
              ),
              const SizedBox(height: 16),
              if (_imageData == null)
                FilledButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('Take photo'),
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.primaryViolet, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52)),
                )
              else ...[
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : () => setState(() => _imageData = null),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retake'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(_isSaving ? 'Saving…' : 'Save photo memory'),
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.primaryViolet, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
