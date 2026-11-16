import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/screens/home_screen.dart';
import '../../products/screens/menu_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../orders/screens/order_status_screen.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/products/providers/product_provider.dart';
import '../../../features/cart/providers/cart_provider.dart';
import '../../../features/orders/providers/order_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_drawer.dart';

/// Kerangka utama aplikasi pelanggan.
/// Menggabungkan dua pola navigasi tingkat aplikasi:
///   1. Drawer  -> menu tersembunyi (termasuk "Tentang Aplikasi")
///   2. BottomNavigationBar -> 4 menu utama dengan ikon + label teks
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  /// Key dipakai agar tombol menu pada tiap tab dapat membuka Drawer
  /// milik Scaffold di level MainScreen (bukan Scaffold milik tab).
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  Future<void> _initData() async {
    final auth = context.read<AuthProvider>();
    if (auth.currentUser == null) return;

    final userId = auth.currentUser!.userId!;
    await Future.wait([
      context.read<ProductProvider>().loadAll(),
      context.read<CartProvider>().loadCart(userId),
      context.read<OrderProvider>().loadUserOrders(userId),
    ]);
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Halaman tiap tab dibuat ulang setiap build agar callback
    // pembuka drawer selalu mengarah ke Scaffold induk yang benar.
    final screens = <Widget>[
      HomeScreen(onOpenDrawer: _openDrawer),
      MenuScreen(onOpenDrawer: _openDrawer),
      CartScreen(onOpenDrawer: _openDrawer),
      OrderStatusScreen(onOpenDrawer: _openDrawer),
    ];

    return Scaffold(
      key: _scaffoldKey,
      // ---------------------------------------------------------------
      // POLA 1: Drawer sebagai menu navigasi tambahan
      // ---------------------------------------------------------------
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onSelectTab: _selectTab,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      // ---------------------------------------------------------------
      // POLA 2: BottomNavigationBar sebagai menu utama (ikon + label)
      // ---------------------------------------------------------------
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _selectTab,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, cart, __) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: -8,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cart.itemCount > 9 ? '9+' : '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              activeIcon: Consumer<CartProvider>(
                builder: (_, cart, __) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_bag),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: -8,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cart.itemCount > 9 ? '9+' : '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.access_time_outlined),
              activeIcon: Icon(Icons.access_time_filled),
              label: 'Status',
            ),
          ],
        ),
      ),
    );
  }
}
