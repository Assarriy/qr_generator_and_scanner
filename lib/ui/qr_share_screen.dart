import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Digital Card')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('Wibowo Assariy', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: globalQrData == null 
                        ? const Icon(Icons.qr_code, size: 150)
                        : SizedBox(height: 150, width: 150, child: PrettyQrView.data(data: globalQrData!)),
                    ),
                    const SizedBox(height: 10),
                    const Text('SCAN ME', style: TextStyle(color: Colors.white, letterSpacing: 5)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share Card'),
              onPressed: () async {
                final bytes = await _screenshotController.capture();
                if (bytes != null) {
                  await Share.shareXFiles([XFile.fromData(bytes, name: 'card.png')], text: 'Ini kartu QR saya');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}