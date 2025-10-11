import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sdg7_app/core/api_client.dart';
import 'package:sdg7_app/core/user_config.dart';

class BillUploadPage extends StatefulWidget {
  const BillUploadPage({super.key});
  @override
  State<BillUploadPage> createState() => _BillUploadPageState();
}

class _BillUploadPageState extends State<BillUploadPage> {
  Uint8List? _previewBytes;   // for web preview
  String? _filePath;          // for mobile path
  String? _fileName;
  bool _uploading = false;

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // gives bytes for web/mobile
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    setState(() {
      _fileName = file.name;
      _previewBytes = file.bytes;
      _filePath = file.path;
    });
  }

  Future<void> _upload() async {
    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an image file first.')),
      );
      return;
    }

    setState(() => _uploading = true);

    try {
      final res = await ApiClient.uploadBill(
        userId: UserConfig.userId,
        filename: _fileName!,
        bytes: _previewBytes,            // works on web/mobile
        filePath: kIsWeb ? null : _filePath, // path for mobile/desktop (non-web)
      );

      final msg = res['message'] ?? 'Uploaded';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Upload Successful'),
          content: Text('$msg\nFile: ${res['file']?['filename'] ?? _fileName}'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Electricity Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: SizedBox(
                height: 240,
                child: Center(
                  child: _previewBytes != null
                      ? Image.memory(_previewBytes!, fit: BoxFit.contain, height: 220)
                      : const Text('No image selected'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uploading ? null : _pick,
                    icon: const Icon(Icons.image),
                    label: const Text('Choose Bill Image'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _uploading ? null : _upload,
                    icon: _uploading
                        ? const SizedBox(
                            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.cloud_upload),
                    label: const Text('Upload'),
                  ),
                ),
              ],
            ),
            if (_fileName != null) Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Selected: $_fileName'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: After verification, Rs. 50 will be deducted from your current bill once you reach 50 coins.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
