import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_generator_and_scanner/main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

const Color primaryColor = Color(0xFF3A2EC3);

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _shareCard() async {
    final Uint8List? bytes = await _screenshotController.capture(
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
    
    if (bytes != null) {
      await Share.shareXFiles(
        [XFile.fromData(bytes, name: 'digital_card.png', mimeType: 'image/png')],
        text: 'Halo! Ini adalah kartu kontak digital saya. Scan QR untuk melihat informasi.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Digital Business Card', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Decorative Area
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  child: Text(
                    'Preview Kartu Anda',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // KARTU DIGITAL (Screenshot Area)
            Screenshot(
              controller: _screenshotController,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      // Background Gradasi Premium
                      Container(
                        height: 450,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4E43D8), Color(0xFF2E24AB)],
                          ),
                        ),
                      ),
                      // Ornamen Lingkaran Dekoratif
                      Positioned(
                        top: -50,
                        right: -50,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      
                      // Konten Kartu
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Wibowo Assariy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const Text(
                              'QR Designer & Developer',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 30),
                            
                            // Kontainer QR
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: globalQrData == null || globalQrData!.isEmpty
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.qr_code_2_rounded, size: 140, color: Colors.grey.shade300),
                                        const Text('Data Kosong', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 140,
                                      width: 140,
                                      child: PrettyQrView.data(
                                        data: globalQrData!,
                                        decoration: const PrettyQrDecoration(
                                          shape: PrettyQrSmoothSymbol(),
                                        ),
                                      ),
                                    ),
                            ),
                            
                            const SizedBox(height: 25),
                            const Text(
                              'SCAN ME TO CONNECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Colors.white.withOpacity(0.2), indent: 40, endIndent: 40),
                            const Text(
                              'www.wibowo-assariy.com',
                              style: TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Aksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('SHARE DIGITAL CARD', 
                        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                      onPressed: _shareCard,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit_note_rounded, color: Colors.grey),
                    label: const Text('Edit QR Data', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}