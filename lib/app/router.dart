// WIB Bakery - Peta Route Aplikasi (Named Route)
//
// Seluruh nama halaman didaftarkan pada satu tempat agar alur navigasi
// mudah ditelusuri, diuji, dan dirawat.
import 'package:flutter/material.dart';
import '../features/about/screens/about_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/orders/screens/order_detail_screen.dart';
import '../features/orders/screens/checkout_screen.dart';
import '../features/products/screens/product_detail_screen.dart';
import '../features/admin/screens/admin_main_screen.dart';
import '../core/theme/app_colors.dart';

class AppRouter {
  // ---------------------------------------------------------------------
  // 1. Daftar nama route (konstanta) -> menghindari "magic string"
  // ---------------------------------------------------------------------
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminHome = '/admin-home';
  static const String productDetail = '/product-detail';
  static const String checkout = '/checkout';
  static const String orderDetail = '/order-detail';
  static const String about = '/about';

  // ---------------------------------------------------------------------
  // 2. Peta route statis: nama route -> builder halaman.
  //    Dipasang pada properti `routes` milik MaterialApp.
  // ---------------------------------------------------------------------
  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        home: (_) => const MainScreen(),
        adminHome: (_) => const AdminMainScreen(),
        checkout: (_) => const CheckoutScreen(),
        // Halaman detail tidak memakai konstruktor berparameter di sini:
        // data produk dikirim lewat `arguments` dan dibaca sendiri oleh
        // halaman tujuan melalui ModalRoute.of(context).
        productDetail: (_) => const ProductDetailScreen(),
        about: (_) => const AboutScreen(),
      };

  // ---------------------------------------------------------------------
  // 3. onGenerateRoute -> dipakai untuk route yang membutuhkan
  //    pemeriksaan argument secara dinamis (mis. order-detail).
  //    Setiap argument diperiksa tipenya sebelum dipakai agar aplikasi
  //    tidak crash ketika data kosong / salah tipe.
  // ---------------------------------------------------------------------
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case orderDetail:
        final arguments = settings.arguments;
        if (arguments is int) {
          return _buildRoute(
            (_) => OrderDetailScreen(orderId: arguments),
            settings,
          );
        }
        return _buildRoute(
          (_) => const _RouteErrorScreen(
            title: 'Data pesanan tidak ditemukan',
            message:
                'Route /order-detail membutuhkan argument berupa int (orderId).',
          ),
          settings,
        );

      default:
        return _buildRoute(
          (_) => _RouteErrorScreen(
            title: 'Halaman tidak ditemukan',
            message: 'Route "${settings.name}" belum terdaftar pada AppRouter.',
          ),
          settings,
        );
    }
  }

  // Transisi fade konsisten untuk seluruh halaman.
  static PageRoute _buildRoute(WidgetBuilder builder, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, _, __) => builder(context),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

/// Halaman cadangan ketika route tidak dikenal atau argument tidak valid.
/// Halaman ini tetap menyediakan tombol kembali agar pengguna tidak
/// terjebak pada layar kosong.
class _RouteErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const _RouteErrorScreen({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.warning),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRouter.home),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
