import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_generator_and_scanner/main.dart';
import 'package:screenshot/screenshot.dart';
import 'print_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScreenshotController _silentScreenshotController = ScreenshotController();

  Future<void> _handlePrintMenu() async {
    if (globalQrData == null || globalQrData!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada QR yang dibuat. Silakan ke menu Create.')),
      );
      return;
    }

    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));

    final Uint8List? imageBytes = await _silentScreenshotController.captureFromWidget(
      Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: PrettyQrView.data(
          data: globalQrData!,
          decoration: const PrettyQrDecoration(shape: PrettyQrSmoothSymbol()),
        ),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (imageBytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrintScreen(qrImageBytes: imageBytes, qrData: globalQrData!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR S&G'), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () {})]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserProfileHeader(),
            const SizedBox(height: 30),
            const Text('Welcome to QR S&G', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _MenuButton(icon: Icons.qr_code_2, label: 'Create', color: Colors.blue, route: '/create'),
                  _MenuButton(icon: Icons.qr_code_scanner, label: 'Scan', color: Colors.red, route: '/scan'),
                  _MenuButton(icon: Icons.send, label: 'Share', color: Colors.green, route: '/share'),
                  _MenuButton(icon: Icons.print, label: 'Print', color: Colors.purple, onTap: _handlePrintMenu),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 30, backgroundColor: Colors.indigo, child: Icon(Icons.person, color: Colors.white)),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Hello, Wibowo Assariy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Fullstack Developer', style: TextStyle(color: Colors.grey)),
        ]),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? route;
  final VoidCallback? onTap;

  const _MenuButton({required this.icon, required this.label, required this.color, this.route, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pushNamed(context, route!),
      child: Container(
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}