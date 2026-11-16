// WIB Bakery - Drawer navigasi utama
//
// Drawer dipasang pada Scaffold milik MainScreen. Setiap item menu:
//   1. menutup drawer terlebih dahulu dengan Navigator.pop(context), lalu
//   2. berpindah halaman / berganti tab.
// Menu "Tentang Aplikasi" memakai named route '/about'.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../../app/router.dart';
import '../../features/auth/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  /// Indeks tab bottom navigation yang sedang aktif.
  final int currentIndex;

  /// Callback untuk berpindah tab pada MainScreen.
  final ValueChanged<int> onSelectTab;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelectTab,
  });

  /// Menutup drawer lebih dulu agar menu tidak tertinggal terbuka,
  /// baru kemudian berpindah halaman.
  void _closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  void _goToTab(BuildContext context, int index) {
    _closeDrawer(context);
    onSelectTab(index);
  }

  void _goToRoute(BuildContext context, String routeName) {
    _closeDrawer(context);
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'W';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ---------------------------------------------------------------
          // Header identitas aplikasi + pengguna
          // ---------------------------------------------------------------
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3D2B1F), Color(0xFF8B5E3C)],
              ),
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? 'WIB Bakery',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  user?.email ?? 'Belum masuk',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------------
          // Menu utama (sinkron dengan bottom navigation)
          // ---------------------------------------------------------------
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Beranda',
            selected: currentIndex == 0,
            onTap: () => _goToTab(context, 0),
          ),
          _DrawerItem(
            icon: Icons.menu_book_outlined,
            label: 'Menu Bakery',
            selected: currentIndex == 1,
            onTap: () => _goToTab(context, 1),
          ),
          _DrawerItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Keranjang',
            selected: currentIndex == 2,
            onTap: () => _goToTab(context, 2),
          ),
          _DrawerItem(
            icon: Icons.access_time_outlined,
            label: 'Status Pesanan',
            selected: currentIndex == 3,
            onTap: () => _goToTab(context, 3),
          ),

          const Divider(height: 24, color: AppColors.divider),

          // ---------------------------------------------------------------
          // Menu sekunder -> named route
          // ---------------------------------------------------------------
          _DrawerItem(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            onTap: () => _goToRoute(context, AppRouter.about),
          ),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Keluar',
            color: AppColors.error,
            onTap: () async {
              _closeDrawer(context);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              }
            },
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'WIB Bakery v1.0.0',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tint =
        color ?? (selected ? AppColors.primary : AppColors.textPrimary);
    return ListTile(
      leading: Icon(icon, color: tint, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: tint,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.primary.withOpacity(0.08),
      onTap: onTap,
    );
  }
}
