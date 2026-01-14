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
        const SnackBar(
          content: Text('Belum ada QR yang dibuat!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final Uint8List? imageBytes = await _silentScreenshotController.captureFromWidget(
      Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: PrettyQrView.data(
          data: globalQrData!,
          decoration: const PrettyQrDecoration(shape: PrettyQrSmoothSymbol()),
        ),
      ),
      pixelRatio: 2.0, // Optimasi agar tidak berat
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
      backgroundColor: const Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // Background Decoration (Lingkaran Gradasi)
          Positioned(
            top: -100,
            right: -50,
            child: _buildCircle(400, Colors.indigo.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildCircle(300, Colors.blue.withOpacity(0.05)),
          ),
          
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Custom App Bar Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const UserProfileHeader(),
                        const SizedBox(height: 32),
                        const Text(
                          'Apa yang ingin\nAnda lakukan?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D1B20),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Grid Menu
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.9,
                    children: [
                      _MenuCard(
                        icon: Icons.add_rounded,
                        label: 'Create',
                        subtitle: 'Generate QR',
                        color: Colors.blueAccent,
                        route: '/create',
                      ),
                      _MenuCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan',
                        subtitle: 'Read QR Code',
                        color: Colors.redAccent,
                        route: '/scan',
                      ),
                      _MenuCard(
                        icon: Icons.ios_share_rounded,
                        label: 'Share',
                        subtitle: 'Send Card',
                        color: Colors.green,
                        route: '/share',
                      ),
                      _MenuCard(
                        icon: Icons.print_rounded,
                        label: 'Print',
                        subtitle: 'Export to PDF',
                        color: Colors.deepPurpleAccent,
                        onTap: _handlePrintMenu,
                      ),
                    ],
                  ),
                ),
                
                // Footer / Stats Area (Opsional)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade900,
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: const NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
                          opacity: 0.1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.white70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Gunakan menu Create untuk menyimpan QR ke memori.',
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue.shade300]),
              ),
              child: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                // backgroundImage: AssetImage('assets/images/profile.jpg'),
                child: Icon(Icons.person_rounded, size: 30, color: Colors.indigo),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Wibowo',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Fullstack Dev',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final String? route;
  final VoidCallback? onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap ?? () => Navigator.pushNamed(context, route!),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B20)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}