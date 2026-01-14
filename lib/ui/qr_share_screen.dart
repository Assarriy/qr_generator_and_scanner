import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart'; // Tambahkan ini
import 'package:qr_generator_and_scanner/main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  // Data User
  final String _userName = 'Wibowo Assariy';
  final String _userRole = 'Fullstack Developer';

  Future<void> _processShare({required bool isEmail}) async {
    // Validasi jika QR belum dibuat
    if (globalQrData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada QR Code yang dibuat di Generator!')),
      );
      return;
    }

    try {
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        final String fileName = 'Shared_QR_${DateTime.now().millisecondsSinceEpoch}.png';
        
        final String shareText = 
            'Halo! Ini QR Code saya.\n'
            'Isi QR: $globalQrData\n'
            'Dibuat menggunakan QR S&G oleh $_userName';

        await Share.shareXFiles(
          [XFile.fromData(imageBytes, name: fileName, mimeType: 'image/png')],
          subject: isEmail ? 'QR Code shared by $_userName' : null,
          text: shareText,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Saved QR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A2EC3), Color(0xFF6A5AE0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF3A2EC3)),
                    ),
                    const SizedBox(height: 12),
                    Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(_userRole, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 24),
                    
                    // PENAMPIL QR CODE DARI GENERATOR
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: globalQrData == null 
                        ? const SizedBox(
                            height: 180,
                            width: 180,
                            child: Center(child: Text('Belum ada QR\ndibuat', textAlign: TextAlign.center)),
                          )
                        : SizedBox(
                            height: 180,
                            width: 180,
                            child: PrettyQrView.data(
                              data: globalQrData!,
                              decoration: const PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(),
                              ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 12),
                    const Text('SCAN ME', style: TextStyle(color: Colors.white, letterSpacing: 4, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _processShare(isEmail: false),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _processShare(isEmail: true),
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}