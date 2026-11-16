// WIB Bakery - Halaman Tentang Aplikasi
//
// Halaman ini diakses dari Drawer melalui named route '/about'
// (Navigator.pushNamed) sehingga menjadi bukti penerapan pola Drawer
// pada Pertemuan 8.
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String appVersion = '1.0.0 (build 1)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tentang Aplikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          // Identitas aplikasi
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.bakery_dining,
                  size: 52, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'WIB Bakery',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Versi $appVersion',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildCard(
            title: 'Deskripsi Aplikasi',
            child: const Text(
              'WIB Bakery adalah aplikasi pemesanan roti dan kue berbasis '
              'Flutter yang dibangun sebagai proyek mata kuliah Pemrograman '
              'Mobile. Aplikasi memuat katalog produk, keranjang, proses '
              'checkout, serta pelacakan status pesanan dengan penyimpanan '
              'lokal SQLite.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: 'Fitur Utama',
            child: Column(
              children: const [
                _FeatureRow(
                  icon: Icons.grid_view_rounded,
                  text: 'Katalog produk dengan filter kategori dan pencarian',
                ),
                _FeatureRow(
                  icon: Icons.shopping_bag_outlined,
                  text: 'Keranjang belanja dengan pengaturan jumlah & catatan',
                ),
                _FeatureRow(
                  icon: Icons.receipt_long_outlined,
                  text: 'Checkout, kode promo, dan riwayat pesanan',
                ),
                _FeatureRow(
                  icon: Icons.route_outlined,
                  text: 'Navigasi named route, bottom navigation, dan drawer',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            title: 'Informasi Pengembang',
            child: Column(
              children: const [
                _InfoRow(label: 'Mata Kuliah', value: 'Pemrograman Mobile'),
                _InfoRow(
                    label: 'Pertemuan',
                    value: 'Pertemuan 8 - Navigasi Lanjutan'),
                _InfoRow(label: 'Program Studi', value: 'Teknik Informatika'),
                _InfoRow(label: 'Institusi', value: 'Universitas Esa Unggul'),
                _InfoRow(
                    label: 'Teknologi',
                    value: 'Flutter, Dart, Provider, SQLite'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Navigasi balik eksplisit (selain tombol kembali bawaan AppBar)
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Beranda'),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (route) => false,
              ),
              child: const Text(
                'Muat Ulang Menu Utama',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
