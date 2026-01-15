/// Image compression service for Cosmo Management
///
/// Compresses images before upload to reduce bandwidth and storage.
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

/// Configuration for image compression
class ImageCompressionConfig {
  const ImageCompressionConfig({
    this.maxWidth = 1920,
    this.maxHeight = 1920,
    this.quality = 85,
    this.maxFileSizeKB = 500,
  });

  /// Maximum width in pixels
  final int maxWidth;

  /// Maximum height in pixels
  final int maxHeight;

  /// JPEG quality (0-100)
  final int quality;

  /// Maximum file size in KB (will iteratively reduce quality if exceeded)
  final int maxFileSizeKB;

  /// Default config for general photos
  static const general = ImageCompressionConfig();

  /// Config for thumbnails
  static const thumbnail = ImageCompressionConfig(
    maxWidth: 400,
    maxHeight: 400,
    quality: 75,
    maxFileSizeKB: 100,
  );

  /// Config for high quality photos
  static const highQuality = ImageCompressionConfig(
    maxWidth: 2560,
    maxHeight: 2560,
    quality: 92,
    maxFileSizeKB: 1024,
  );
}

/// Result of image compression
class CompressionResult {
  const CompressionResult({
    required this.path,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
    required this.width,
    required this.height,
  });

  final String path;
  final int originalSizeBytes;
  final int compressedSizeBytes;
  final int width;
  final int height;

  double get compressionRatio =>
      originalSizeBytes > 0 ? compressedSizeBytes / originalSizeBytes : 1.0;

  double get savingsPercent => (1 - compressionRatio) * 100;
}

/// Service for compressing images before upload
class ImageCompressionService {
  ImageCompressionService();

  /// Compress an image file
  ///
  /// Returns the path to the compressed image (may be same as input if no
  /// compression needed).
  Future<CompressionResult> compressImage(
    String inputPath, {
    ImageCompressionConfig config = const ImageCompressionConfig(),
  }) async {
    final inputFile = File(inputPath);
    if (!inputFile.existsSync()) {
      throw Exception('File not found: $inputPath');
    }

    final originalBytes = await inputFile.readAsBytes();
    final originalSize = originalBytes.length;

    // Skip compression for small files
    if (originalSize < config.maxFileSizeKB * 1024 * 0.8) {
      return CompressionResult(
        path: inputPath,
        originalSizeBytes: originalSize,
        compressedSizeBytes: originalSize,
        width: 0,
        height: 0,
      );
    }

    // Compress in isolate for better performance
    final result = await compute(
      _compressInIsolate,
      _CompressionParams(
        bytes: originalBytes,
        maxWidth: config.maxWidth,
        maxHeight: config.maxHeight,
        quality: config.quality,
        maxSizeKB: config.maxFileSizeKB,
      ),
    );

    // Write compressed image to temp file
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = '${tempDir.path}/compressed_$timestamp.jpg';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(result.bytes);

    return CompressionResult(
      path: outputPath,
      originalSizeBytes: originalSize,
      compressedSizeBytes: result.bytes.length,
      width: result.width,
      height: result.height,
    );
  }

  /// Compress multiple images
  Future<List<CompressionResult>> compressImages(
    List<String> inputPaths, {
    ImageCompressionConfig config = const ImageCompressionConfig(),
    void Function(int completed, int total)? onProgress,
  }) async {
    final results = <CompressionResult>[];

    for (var i = 0; i < inputPaths.length; i++) {
      final result = await compressImage(inputPaths[i], config: config);
      results.add(result);
      onProgress?.call(i + 1, inputPaths.length);
    }

    return results;
  }

  /// Check if file needs compression
  bool needsCompression(
    String path, {
    int maxSizeKB = 500,
  }) {
    final file = File(path);
    if (!file.existsSync()) return false;
    return file.lengthSync() > maxSizeKB * 1024;
  }

  /// Clean up temporary compressed files
  Future<void> cleanupTempFiles(List<String> paths) async {
    for (final path in paths) {
      if (path.contains('compressed_')) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }
}

/// Parameters for compression isolate
class _CompressionParams {
  const _CompressionParams({
    required this.bytes,
    required this.maxWidth,
    required this.maxHeight,
    required this.quality,
    required this.maxSizeKB,
  });

  final Uint8List bytes;
  final int maxWidth;
  final int maxHeight;
  final int quality;
  final int maxSizeKB;
}

/// Result from compression isolate
class _CompressionResult {
  const _CompressionResult({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
}

/// Compress image in isolate
Future<_CompressionResult> _compressInIsolate(_CompressionParams params) async {
  // Decode image
  final codec = await ui.instantiateImageCodec(params.bytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  // Calculate new dimensions maintaining aspect ratio
  var targetWidth = image.width;
  var targetHeight = image.height;

  if (targetWidth > params.maxWidth || targetHeight > params.maxHeight) {
    final aspectRatio = targetWidth / targetHeight;
    if (targetWidth > targetHeight) {
      targetWidth = params.maxWidth;
      targetHeight = (params.maxWidth / aspectRatio).round();
    } else {
      targetHeight = params.maxHeight;
      targetWidth = (params.maxHeight * aspectRatio).round();
    }
  }

  // Create resized image
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  canvas.drawImageRect(
    image,
    ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    ui.Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
    ui.Paint()..filterQuality = ui.FilterQuality.high,
  );

  final picture = recorder.endRecording();
  final resizedImage = await picture.toImage(targetWidth, targetHeight);

  // Encode as JPEG with quality
  var quality = params.quality;
  Uint8List? outputBytes;

  // Iteratively reduce quality if file is too large
  while (quality >= 50) {
    final byteData = await resizedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      outputBytes = byteData.buffer.asUint8List();

      // Check if size is acceptable
      if (outputBytes.length <= params.maxSizeKB * 1024) {
        break;
      }
    }

    quality -= 10;
  }

  image.dispose();
  resizedImage.dispose();

  return _CompressionResult(
    bytes: outputBytes ?? params.bytes,
    width: targetWidth,
    height: targetHeight,
  );
}
