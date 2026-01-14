import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Konstanta warna agar konsisten dengan screen sebelumnya
const Color primaryColor = Color(0xFF3A2EC3);

class PrintScreen extends StatelessWidget {
  final Uint8List qrImageBytes;
  final String qrData;

  const PrintScreen({
    super.key,
    required this.qrImageBytes,
    required this.qrData,
  });

  /// Membuat dokumen PDF dengan layout yang lebih bersih dan profesional
  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(
      title: 'QR Code Report - QR S&G',
      author: 'Wibowo Assariy',
    );
    
    final qrImage = pw.MemoryImage(qrImageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // HEADER DOKUMEN
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('QR S&G APP', 
                    style: pw.TextStyle(
                      fontSize: 12, 
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo,
                    )),
                  pw.Text(DateTime.now().toString().substring(0, 16), 
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 40),

              // JUDUL LAPORAN
              pw.Text('QR CODE RESULT', 
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                width: 40,
                height: 3,
                color: PdfColors.indigo,
              ),
              pw.SizedBox(height: 50),
              
              // KONTEN UTAMA (QR IMAGE)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 2),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Image(qrImage, width: 250, height: 250),
              ),
              
              pw.SizedBox(height: 40),
              
              // DATA QR
              pw.Text('Informasi Terenkripsi:', 
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
              pw.SizedBox(height: 8),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 50),
                child: pw.Text(
                  qrData, 
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                ),
              ),
              
              pw.Spacer(),
              
              // FOOTER
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Dokumen ini dihasilkan secara otomatis oleh ', 
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                  pw.Text('QR Scanner & Generator S&G', 
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('Cetak Dokumen QR', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Banner Info Kecil
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: primaryColor.withOpacity(0.1),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pratinjau PDF dalam format A4. Klik ikon cetak untuk melanjutkan.',
                    style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          
          // PDF Preview Area
          Expanded(
            child: PdfPreview(
              initialPageFormat: PdfPageFormat.a4,
              padding: const EdgeInsets.all(16),
              build: (format) => _generatePdf(format),
              
              // Styling Preview
              pdfPreviewPageDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              
              // Actions Konfigurasi
              allowSharing: true,
              allowPrinting: true,
              canChangePageFormat: false,
              canDebug: false,
              
              // Custom buttons colors
              actions: [
                PdfPreviewAction(
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  onPressed: (context, build, format) async {
                    // Logika tambahan jika ingin menyimpan PDF secara manual
                  },
                ),
              ],
              
              loadingWidget: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}