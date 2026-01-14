import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_generator_and_scanner/main.dart'; // Pastikan path variabel globalQrData benar
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// Konfigurasi Warna Tema
const Color primaryColor = Color(0xFF3A2EC3);

// Daftar warna yang lebih banyak agar bisa di-scroll
const List<Color> qrColors = [
  Colors.white,
  Color(0xFFF5F5F5), // Abu-abu muda
  Color(0xFFFFE0B2), // Oranye Pastel
  Color(0xFFFFF9C4), // Kuning Pastel
  Color(0xFFC8E6C9), // Hijau Pastel
  Color(0xFFB2EBF2), // Cyan Pastel
  Color(0xFFE1BEE7), // Ungu Pastel
  Color(0xFFFFCDD2), // Merah Muda
  Color(0xFFD1C4E9), // Deep Purple
  Color(0xFFBBDEFB), // Biru Pastel
];

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  String? _qrData;
  Color _qrColor = Colors.white;

  /// Fungsi untuk menangani sharing QR Code
  Future<void> _handleShare({required bool isEmailFriendly}) async {
    if (_qrData == null || _qrData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan teks atau link terlebih dahulu'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Memberi jeda agar UI stabil sebelum di-capture
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final Uint8List? imageBytes = await _screenshotController.capture(
        pixelRatio: 2.0, 
      );

      if (imageBytes != null) {
        final String fileName = 'QR_${DateTime.now().millisecondsSinceEpoch}.png';
        final String shareText = 'Ini QR Code untuk: $_qrData\n'
            'Dibuat menggunakan QR S&G oleh Wibowo Assariy';

        await Share.shareXFiles(
          [XFile.fromData(imageBytes, name: fileName, mimeType: 'image/png')],
          subject: isEmailFriendly ? 'QR Code dari QR S&G App' : null,
          text: shareText,
        );
      }
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Create QR', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Header Melengkung
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  // CARD UTAMA
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 25,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PREVIEW QR AREA (DI-CENTER)
                        Center(
                          child: Screenshot(
                            controller: _screenshotController,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: _qrColor,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade100, width: 2),
                              ),
                              child: _qrData == null
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.qr_code_2_rounded, 
                                          size: 160, color: Colors.grey.shade200),
                                        const Text('Preview QR', 
                                          style: TextStyle(color: Colors.grey)),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: PrettyQrView.data(
                                        data: _qrData!,
                                        decoration: const PrettyQrDecoration(
                                          shape: PrettyQrSmoothSymbol(),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // INPUT FIELD
                        const Text('Konten QR', 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        TextField(
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: 'Masukkan link atau teks di sini...',
                            prefixIcon: const Icon(Icons.link_rounded, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F5F9),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _qrData = value.trim().isEmpty ? null : value.trim();
                              globalQrData = _qrData; // Simpan ke global
                            });
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        const Text('Warna Latar Belakang', 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 16),
                        
                        // COLOR PICKER (SUDAH BISA DI-SCROLL)
                        SizedBox(
                          height: 55,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(), // Memungkinkan scroll meski dalam SingleChildScrollView
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            itemCount: qrColors.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              bool isSelected = _qrColor == qrColors[index];
                              return GestureDetector(
                                onTap: () => setState(() => _qrColor = qrColors[index]),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: qrColors[index],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.black12,
                                      width: isSelected ? 3 : 1,
                                    ),
                                    boxShadow: isSelected ? [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3), 
                                        blurRadius: 10,
                                        spreadRadius: 1
                                      )
                                    ] : [],
                                  ),
                                  child: isSelected 
                                    ? const Icon(Icons.check, size: 22, color: primaryColor) 
                                    : null,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        
                        // ACTION BUTTONS (RESET & SHARE)
                        Row(
                          children: [
                            _buildActionButton(
                              label: 'Reset',
                              icon: Icons.refresh_rounded,
                              color: Colors.grey.shade100,
                              textColor: Colors.black87,
                              onTap: () {
                                setState(() {
                                  _qrData = null;
                                  _qrColor = Colors.white;
                                });
                              },
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(
                              label: 'Share QR',
                              icon: Icons.ios_share_rounded,
                              color: primaryColor,
                              textColor: Colors.white,
                              onTap: () => _handleShare(isEmailFriendly: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // EMAIL BUTTON (FULL WIDTH)
                        _buildActionButton(
                          label: 'Kirim via Email',
                          icon: Icons.alternate_email_rounded,
                          color: const Color(0xFFE8F5E9),
                          textColor: Colors.green.shade700,
                          isFullWidth: true,
                          onTap: () => _handleShare(isEmailFriendly: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk membangun tombol aksi agar kode lebih bersih
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    Widget button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 10),
            Text(
              label, 
              style: TextStyle(
                color: textColor, 
                fontWeight: FontWeight.bold,
                fontSize: 14
              )
            ),
          ],
        ),
      ),
    );

    return isFullWidth ? button : Expanded(child: button);
  }
}