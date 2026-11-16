# 🥖 WIB Bakery — Aplikasi Pemesanan Roti & Kue (Flutter)

> **Proyek Mata Kuliah Pemrograman Mobile — Pertemuan 8**
> Topik: **Navigasi Lanjutan — Named Route, Drawer, Tab, dan Bottom Navigation**
> Program Studi Teknik Informatika · Universitas Esa Unggul · Kelompok 1
> Repositori: `Pendragon-Ancestor/WIBakeryPendragonAncestorPertemuan4`

Aplikasi mobile pemesanan roti & kue dengan dua peran pengguna (**customer** dan **admin**),
penyimpanan lokal **SQLite (offline-first)**, state management **Provider**, dan navigasi
terpusat berbasis **named route**.

---

## Daftar Isi

1. [Ringkasan Proyek](#1-ringkasan-proyek)
2. [Status Verifikasi (Hasil Eksekusi Nyata)](#2-status-verifikasi-hasil-eksekusi-nyata)
3. [Apa yang Baru di Versi Ini (Pertemuan 8)](#3-apa-yang-baru-di-versi-ini-pertemuan-8)
4. [Peta Route Lengkap](#4-peta-route-lengkap)
5. [Diagram Alur Navigasi](#5-diagram-alur-navigasi)
6. [Arsitektur & Struktur Folder](#6-arsitektur--struktur-folder)
7. [Fitur Aplikasi](#7-fitur-aplikasi)
8. [Basis Data (SQLite)](#8-basis-data-sqlite)
9. [State Management & Model Data](#9-state-management--model-data)
10. [Spesifikasi Menjalankan Proyek](#10-spesifikasi-menjalankan-proyek)
11. [Akun Demo](#11-akun-demo)
12. [Catatan Teknis & Known Issues](#12-catatan-teknis--known-issues)
13. [Troubleshooting](#13-troubleshooting)
14. [Checklist Rubrik & Skenario Uji](#14-checklist-rubrik--skenario-uji)
15. [Rencana Pengembangan](#15-rencana-pengembangan)

---

## 1. Ringkasan Proyek

| Item | Keterangan |
|---|---|
| Nama aplikasi | **WIB Bakery** (`wib_bakery`) |
| Versi | `1.0.0+1` |
| Jenis | Aplikasi mobile e-commerce makanan (roti, kue, pastry, minuman) |
| Framework | Flutter (Material 3) |
| Bahasa | Dart |
| State management | `provider` (ChangeNotifier) |
| Basis data | SQLite lokal via `sqflite` — **tanpa backend/API**, sepenuhnya offline |
| Autentikasi | Login lokal, password di-hash **SHA-256** (`crypto`) |
| Peran pengguna | `customer` dan `admin` (satu tabel `users`, kolom `role`) |
| Navigasi | **Named route terpusat** (`AppRouter`) + `BottomNavigationBar` + `Drawer` |
| Platform terkonfigurasi | Android (folder `android/`); web/desktop belum di-*generate* |

### Skala kode

| Metrik | Jumlah |
|---|---|
| File Dart di `lib/` | **41 file** |
| Total baris kode Dart | **± 10.528 baris** |
| Layar | 13 file `*_screen.dart` + 4 tab admin = **17 halaman** |
| Provider | 5 (`Auth`, `Product`, `Cart`, `Order`, `Promo`) |
| Model | 7 (`User`, `Product`, `Cart`, `Order`, `Promo`, `Address`, `Category`) |
| Repository | 3 (`User`, `Product`, `Order` — sisanya query langsung di provider) |
| Tabel database | **15 tabel** |
| Named route | **9 route** (8 statis + 1 dinamis) |
| Aset gambar | 10 file JPG (± 770 KB) |

---

## 2. Status Verifikasi (Hasil Eksekusi Nyata)

Semua angka di bawah adalah hasil menjalankan perintah pada mesin pengembang
(Windows 11, Flutter 3.50.0 stable, Dart 3.14.0), **bukan estimasi**.

| Pemeriksaan | Perintah | Hasil |
|---|---|---|
| Analisis statis | `flutter analyze` | **0 error**, 124 *info/warning* (mayoritas API deprecated di Flutter 3.50) |
| Widget test | `flutter test` | **1 test lulus** (`WIB Bakery App smoke test`) |
| Build Android | `flutter build apk --debug` | **Sukses** (`√ Built`, ~24 detik pada build inkremental) → `build/app/outputs/flutter-apk/app-debug.apk` (± 186 MB, debug) |
| Dependensi | `flutter pub get` | Resolve normal, `pubspec.lock` tersedia |
| Toolchain | `flutter doctor` | Android SDK 36.0.0 ✔, Chrome ✔, Visual Studio ✖ (tidak diperlukan) |

> Catatan: `flutter doctor` memberi peringatan `cmdline-tools component is missing` dan
> `Android license status unknown`. Build tetap berhasil, tetapi sebaiknya jalankan
> `flutter doctor --android-licenses` bila muncul error lisensi saat build di mesin lain.

---

## 3. Apa yang Baru di Versi Ini (Pertemuan 8)

Versi ini adalah **lapisan navigasi lanjutan** di atas aplikasi katalog yang sudah ada.
Perlu dicatat: `AppRouter` **sudah ada** sejak Pertemuan 7 (8 route, transisi *fade*, dan
`ProductCard` sudah memakai `pushNamed`). Jadi "baru" di versi ini bukan named route itu
sendiri, melainkan **penyempurnaan + penambahan**: route `/about`, `Drawer` global,
peta `routes`, dan penggantian *cast* paksa menjadi pemeriksaan tipe dengan halaman error.

### 3.1 Ringkasan perubahan per file

| File | Status | Isi perubahan |
|---|---|---|
| `lib/app/router.dart` | **Diperluas** (+131 baris) | Route baru `/about`; peta `routes` (`Map<String, WidgetBuilder>`) untuk 8 halaman statis; `productDetail` tidak lagi memakai *cast* paksa; `order-detail` divalidasi `arguments is int`; `_buildRoute` menerima `WidgetBuilder`; kelas baru `_RouteErrorScreen` |
| `lib/core/widgets/app_drawer.dart` | **BARU** (file untracked) | `AppDrawer`: header profil bergradien, 4 menu tab, menu "Tentang Aplikasi", tombol keluar |
| `lib/features/about/screens/about_screen.dart` | **BARU** (folder untracked) | `AboutScreen`: deskripsi aplikasi, 4 fitur utama, 5 baris info pengembang, tombol kembali & muat ulang |
| `lib/main.dart` | Diubah | `MaterialApp` memakai `initialRoute`, `routes: AppRouter.routes`, `onGenerateRoute: AppRouter.generateRoute` |
| `lib/features/home/screens/main_screen.dart` | Diubah (+45 baris) | `GlobalKey<ScaffoldState>`, `drawer: AppDrawer(...)`, `IndexedStack`, callback `onOpenDrawer` ke 4 tab, badge jumlah keranjang |
| `lib/features/home/screens/home_screen.dart` | Diubah | Tombol hamburger (`Icons.menu`) + parameter `onOpenDrawer`, produk diklik → `pushNamed(productDetail, arguments: product)` |
| `lib/features/products/screens/menu_screen.dart` | Diubah | Tombol hamburger + `onOpenDrawer`, grid produk memakai `ProductCard` berbasis named route |
| `lib/features/cart/screens/cart_screen.dart` | Diubah | Tombol hamburger, "Pesan Sekarang" → `pushNamed(checkout)` |
| `lib/features/orders/screens/order_status_screen.dart` | Diubah | Tombol hamburger, kartu pesanan → `pushNamed(orderDetail, arguments: order.orderId)` |
| `lib/features/products/screens/product_detail_screen.dart` | Diubah (+105 baris) | Membaca `ProductModel` dari `arguments` lewat `_resolveProduct()` (fallback ke konstruktor), validasi tipe, layar `_ProductArgumentErrorScreen` ("Data produk tidak tersedia" + tombol "Kembali ke Beranda" via `pushNamedAndRemoveUntil`), AppBar bergaya *collapsing* berjudul "Detail Produk" |
| `android/settings.gradle.kts` | Diubah | AGP `9.1.0` → `9.1.1` (Gradle 9.3.1, Kotlin 2.4.0) |
| `pubspec.lock` | Diubah | Penyesuaian versi dependensi hasil `pub get` |

### 3.2 `AppRouter` — satu sumber kebenaran untuk navigasi

Seluruh nama halaman berada di satu kelas sebagai konstanta `static const`, sehingga tidak
ada *magic string* yang tersebar. Di versi ini `AppRouter` bertambah dari 8 → **9 route**:

```dart
class AppRouter {
  static const String splash        = '/';
  static const String login         = '/login';
  static const String register      = '/register';
  static const String home          = '/home';
  static const String adminHome     = '/admin-home';
  static const String productDetail = '/product-detail';
  static const String checkout      = '/checkout';
  static const String orderDetail   = '/order-detail';
  static const String about         = '/about';   // ★ baru
```

Tiga mekanisme dipakai bersama:

1. **`routes`** — getter `Map<String, WidgetBuilder>` untuk **8 halaman statis**
   (`splash`, `login`, `register`, `home`, `adminHome`, `checkout`, `productDetail`, `about`).
   Dipasang di `MaterialApp.routes`, sehingga Flutter membangun halaman langsung dari nama route.
   `productDetail` didaftarkan sebagai `const ProductDetailScreen()` **tanpa argumen konstruktor** —
   data produk dikirim lewat `arguments` dan dibaca sendiri oleh halaman tujuan.
2. **`generateRoute`** — `onGenerateRoute` untuk route yang **butuh validasi argumen**
   (`/order-detail`). Argumen diperiksa dengan `arguments is int`; jika salah tipe,
   pengguna tidak mendapat *crash* melainkan layar error yang ramah.
   Ini menggantikan pola lama `settings.arguments as int` / `as ProductModel` yang
   melempar `TypeError` saat argumen kosong.
3. **`_buildRoute`** — pembungkus `PageRouteBuilder` dengan `FadeTransition`
   (`Curves.easeInOut`, 250 ms). Sejak versi ini parameter pertama `_buildRoute` berupa
   `WidgetBuilder`, bukan `Widget` jadi, sehingga halaman dibangun *lazy* saat transisi dimulai.

```dart
static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case orderDetail:
      final arguments = settings.arguments;
      if (arguments is int) {
        return _buildRoute((_) => OrderDetailScreen(orderId: arguments), settings);
      }
      return _buildRoute(
        (_) => const _RouteErrorScreen(
          title: 'Data pesanan tidak ditemukan',
          message: 'Route /order-detail membutuhkan argument berupa int (orderId).',
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
```

**Halaman error route** (`_RouteErrorScreen`) menampilkan ikon peringatan, pesan, dan tombol
**"Kembali ke Beranda"** (`pushReplacementNamed(home)`) supaya pengguna tidak terjebak di layar kosong.
Ini adalah penerapan prinsip *defensive navigation*.

### 3.3 `main.dart` — pendaftaran route di `MaterialApp`

Perubahan di `main.dart` kecil tetapi menentukan: satu baris `routes: AppRouter.routes`
ditambahkan agar peta route statis aktif. `initialRoute` dan `onGenerateRoute` sudah ada
sejak sebelumnya.

```dart
child: MaterialApp(
  title: 'WIB Bakery',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.lightTheme,

  // KONFIGURASI NAVIGASI (Pertemuan 8)
  // initialRoute    : halaman pertama yang dibuka saat aplikasi jalan
  // routes          : peta nama route -> WidgetBuilder halaman statis
  // onGenerateRoute : route yang butuh argument dinamis / validasi
  initialRoute: AppRouter.splash,
  routes: AppRouter.routes,              // ★ baru
  onGenerateRoute: AppRouter.generateRoute,
),
```

Sebelum `runApp`, `main()` melakukan tiga hal: mengatur *status bar* transparan,
mengunci orientasi ke *portrait*, dan `await DatabaseHelper.instance.database`
agar skema + seed SQLite siap sebelum UI pertama tampil.

`initialRoute: '/'` membuat aplikasi **selalu mulai dari SplashScreen**, lalu Splash yang
menentukan tujuan berdasarkan sesi dan peran pengguna.

### 3.4 `AppDrawer` — menu navigasi tersembunyi

Drawer hanya ada **satu**, yaitu milik `Scaffold` di `MainScreen` (bukan milik tiap tab).
Isi drawer:

| Bagian | Isi |
|---|---|
| Header (`DrawerHeader`) | Gradien cokelat `#3D2B1F → #8B5E3C`, `CircleAvatar` berisi inisial nama (fallback `W`), nama pengguna (fallback "WIB Bakery"), email (fallback "Belum masuk") |
| Menu tab | Beranda · Menu Bakery · Keranjang · Status Pesanan — sinkron dengan `currentIndex` bottom navigation |
| Menu route | **Tentang Aplikasi** → `_goToRoute(context, AppRouter.about)` |
| Aksi | **Keluar** (ikon & teks `AppColors.error`) → `logout()` lalu `pushReplacementNamed('/login')` |
| Footer | Teks "WIB Bakery v1.0.0" |

Detail penting:

- `_closeDrawer()` memanggil `Navigator.pop(context)` **lebih dulu** di `_goToTab()`,
  supaya drawer tidak tertinggal terbuka di atas halaman baru.
- `_goToRoute()` juga menutup drawer sebelum `pushNamed`, sehingga tombol *back*
  dari halaman Tentang kembali ke tab yang sedang aktif (bukan menampilkan drawer).
- `_DrawerItem` menandai item aktif dengan `selected: true`, `selectedTileColor`
  `AppColors.primary` @ 8% opasitas, ikon & teks berwarna `primary`, dan `fontWeight.w700`.
- `_selectTab()` di `MainScreen` mengabaikan tap pada tab yang sama (`if (index == _currentIndex) return;`)
  sehingga tidak ada `setState` sia-sia.
- Logout di drawer **tanpa dialog konfirmasi** (langsung `await logout()` lalu pindah ke `/login`) —
  berbeda dari tombol keluar di Dashboard admin yang memakai dialog konfirmasi.

### 3.5 `MainScreen` — dua pola navigasi tingkat aplikasi

```dart
Scaffold(
  key: _scaffoldKey,                    // GlobalKey<ScaffoldState>
  drawer: AppDrawer(currentIndex: _currentIndex, onSelectTab: _selectTab),
  body: IndexedStack(index: _currentIndex, children: screens),
  bottomNavigationBar: BottomNavigationBar(...),  // 4 item
)
```

- **Pola 1 — Drawer**: menu tambahan (termasuk Tentang Aplikasi) yang bisa dibuka dari
  tombol hamburger di AppBar tiap tab.
- **Pola 2 — BottomNavigationBar**: 4 menu utama dengan **ikon + label teks**
  (Beranda, Menu, Keranjang, Status), ikon `activeIcon` terisi saat terpilih.
  Item Keranjang memakai `Consumer<CartProvider>` untuk menampilkan **badge jumlah item**
  (`itemCount`), dan badge menampilkan **"9+"** bila jumlahnya lebih dari 9.
- `IndexedStack` dipakai agar **state tiap tab tidak hilang** saat berpindah
  (posisi scroll, hasil pencarian, isi keranjang tetap terjaga).
- `GlobalKey<ScaffoldState>` diperlukan karena tombol hamburger berada di `AppBar`
  milik **screen anak** (Home/Menu/Cart/OrderStatus), sedangkan `Drawer` berada di
  `Scaffold` milik **MainScreen**. Callback `onOpenDrawer` meneruskan aksi
  `_scaffoldKey.currentState?.openDrawer()` ke bawah.

### 3.6 Pengiriman data antarhalaman

| Pola | Dipakai pada | Cara |
|---|---|---|
| **Named route + `arguments`** | Produk → Detail Produk | `Navigator.pushNamed(context, AppRouter.productDetail, arguments: product)` lalu dibaca `ModalRoute.of(context)?.settings.arguments` |
| **Named route + `arguments` (divalidasi)** | Status Pesanan / Admin Pesanan → Detail Pesanan | `arguments: order.orderId` (`int`), divalidasi di `generateRoute` |
| **Constructor** | `ProductDetailScreen(product: ...)` | Tetap didukung sebagai alternatif (berguna untuk *preview*/testing) |
| **Route error** | Argumen kosong/salah tipe | Layar `_ProductArgumentErrorScreen` / `_RouteErrorScreen`, bukan *crash* |

`ProductDetailScreen` melakukan pemeriksaan tipe secara eksplisit:

```dart
ProductModel? _resolveProduct(BuildContext context) {
  if (product != null) return product;                       // via konstruktor
  final arguments = ModalRoute.of(context)?.settings.arguments;
  if (arguments is ProductModel) return arguments;           // via named route
  return null;                                               // argumen tidak valid
}
```

### 3.7 `AboutScreen` — halaman "Tentang Aplikasi"

Konten halaman `/about` (widget `ListView` dengan tiga kartu):

- **Identitas**: kotak ikon `Icons.bakery_dining` 96×96 di atas, teks "WIB Bakery",
  dan "Versi 1.0.0 (build 1)" — dari konstanta `static const String appVersion = '1.0.0 (build 1)'`.
- **Kartu "Deskripsi Aplikasi"**: penjelasan aplikasi pemesanan roti & kue berbasis Flutter
  (katalog, keranjang, checkout, pelacakan status, penyimpanan lokal SQLite).
- **Kartu "Fitur Utama"** — 4 baris ikon + teks:
  1. Katalog produk dengan filter kategori dan pencarian
  2. Keranjang belanja dengan pengaturan jumlah & catatan
  3. Checkout, kode promo, dan riwayat pesanan
  4. Navigasi named route, bottom navigation, dan drawer
- **Kartu "Informasi Pengembang"** — 5 baris label/nilai: Mata Kuliah *Pemrograman Mobile*,
  Pertemuan *Pertemuan 8 - Navigasi Lanjutan*, Program Studi *Teknik Informatika*,
  Institusi *Universitas Esa Unggul*, Teknologi *Flutter, Dart, Provider, SQLite*.
- **Dua aksi navigasi berbeda**:
  - `OutlinedButton.icon` **"Kembali ke Beranda"** → `Navigator.pop(context)` (kembali ke tab asal).
  - `TextButton` **"Muat Ulang Menu Utama"** → `Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false)`
    (membersihkan seluruh tumpukan navigasi lalu membuka `/home`).

### 3.8 Perubahan pola navigasi (sebelum → sesudah)

| Interaksi | Sebelum (Pertemuan 7) | Sesudah (Pertemuan 8) |
|---|---|---|
| Detail produk | `generateRoute` melakukan `settings.arguments as ProductModel` lalu `ProductDetailScreen(product: ...)` | `productDetail` masuk peta `routes`; halaman membaca `arguments` sendiri dan memvalidasi tipe (`arguments is ProductModel`) |
| Detail pesanan | `settings.arguments as int` (melempar `TypeError` bila kosong) | `arguments is int` + `_RouteErrorScreen` bila tidak valid |
| Menu tambahan | Tidak ada | **Drawer** global (`AppDrawer`) di `MainScreen` |
| Tombol hamburger | Tidak ada di AppBar tab | Ada di Beranda, Menu, Keranjang, Status (via `onOpenDrawer`) |
| Halaman Tentang | Tidak ada | `/about` (`AboutScreen`) |
| Route tidak dikenal | `Text('Route not found: ...')` polos di tengah layar | `_RouteErrorScreen`: ikon, pesan, dan tombol "Kembali ke Beranda" |
| Halaman detail tanpa argumen | `TypeError` / layar rusak | `_ProductArgumentErrorScreen` dengan penjelasan + tombol kembali |
| Sumber halaman | Seluruhnya lewat `onGenerateRoute` | 8 halaman statis lewat `MaterialApp.routes`, 1 route dinamis lewat `onGenerateRoute` |
| Transisi halaman | Fade 250 ms untuk semua route | Fade 250 ms untuk route yang lewat `generateRoute` (`/order-detail` + halaman error); halaman pada peta `routes` memakai transisi default platform (`MaterialPageRoute`) |

---

## 4. Peta Route Lengkap

| No | Nama route | Konstanta | Widget | Argumen | Dibuka dari |
|---|---|---|---|---|---|
| 1 | `/` | `AppRouter.splash` | `SplashScreen` | – | `initialRoute` aplikasi |
| 2 | `/login` | `AppRouter.login` | `LoginScreen` | – | Splash (belum login), Drawer "Keluar", logout admin |
| 3 | `/register` | `AppRouter.register` | `RegisterScreen` | – | Link "Daftar" di halaman login |
| 4 | `/home` | `AppRouter.home` | `MainScreen` | – | Splash (customer), login, register, setelah checkout, AboutScreen, route error |
| 5 | `/admin-home` | `AppRouter.adminHome` | `AdminMainScreen` | – | Splash & login (role `admin`) |
| 6 | `/product-detail` | `AppRouter.productDetail` | `ProductDetailScreen` | **`ProductModel`** | Kartu produk di Beranda & Menu Bakery |
| 7 | `/checkout` | `AppRouter.checkout` | `CheckoutScreen` | – | Tombol "Pesan Sekarang" di Keranjang |
| 8 | `/order-detail` | `AppRouter.orderDetail` | `OrderDetailScreen` | **`int` orderId** | Kartu pesanan di Status Pesanan & tab Pesanan admin |
| 9 | `/about` | `AppRouter.about` | `AboutScreen` | – | Drawer → "Tentang Aplikasi" |

**Cara menambah route baru** (misal `/profile`):

1. Tambahkan konstanta di `AppRouter`: `static const String profile = '/profile';`
2. Daftarkan builder di `AppRouter.routes` → `profile: (_) => const ProfileScreen(),`
3. Bila butuh argumen bertipe, tambahkan `case profile:` di `generateRoute` + validasi tipe.
4. Panggil `Navigator.pushNamed(context, AppRouter.profile)` — jangan menulis string mentah.

---

## 5. Diagram Alur Navigasi

```
                         ┌──────────────────┐
                         │   SplashScreen   │  initialRoute: '/'
                         │   (2 detik)      │
                         └────────┬─────────┘
                    sudah login? │ belum login
              ┌──────────────────┴──────────────────┐
     role=admin                  role=customer      │
              │                       │             ▼
              ▼                       ▼      ┌─────────────┐
   ┌──────────────────┐      ┌──────────────┐ │ LoginScreen │◄──┐
   │ AdminMainScreen  │      │  MainScreen  │ └──────┬──────┘   │
   │  /admin-home     │      │    /home     │        │ Daftar   │
   │                  │      │              │        ▼          │
   │ Tab:             │      │ Drawer ◄─────┼──► ┌────────────┐ │
   │ 1 Dashboard      │      │ BottomNav:   │    │ Register   │ │
   │ 2 Pesanan        │      │  Beranda     │    │ /register  │ │
   │ 3 Produk & Stok  │      │  Menu        │    └─────┬──────┘ │
   │ 4 Promo          │      │  Keranjang   │          │        │
   └────────┬─────────┘      │  Status      │          │        │
            │                └───┬───┬───┬──┘          │        │
            │                    │   │   │             │        │
            │        ┌───────────┘   │   └──────────┐  │        │
            │        ▼               ▼              ▼  │        │
            │  ┌──────────────┐ ┌──────────┐ ┌────────────────┐│
            │  │ProductDetail │ │ Checkout │ │ OrderStatusTab ││
            │  │/product-     │ │/checkout │ │ (tab)          ││
            │  │  detail      │ └────┬─────┘ └───────┬────────┘│
            │  │arg: Product  │      │ sukses        │ tap kartu│
            │  └──────────────┘      │               ▼         │
            │                        │        ┌─────────────┐  │
            │  ┌─────────────────────┘        │OrderDetail  │  │
            │  │  pushNamedAndRemoveUntil     │/order-detail│  │
            │  ▼  (home)                     │arg: int     │  │
            │ ┌──────────┐                   └─────────────┘  │
            └►│ /home    │                                    │
              └──────────┘                                    │
                                                              │
   Drawer (semua tab) ──► /about ──► "Kembali"/"Muat Ulang" ───┘
   Drawer (semua tab) ──► Keluar ──► /login (tanpa konfirmasi) ────┘
   Admin Dashboard ─────► Keluar ──► dialog konfirmasi ──► /login
```

---

## 6. Arsitektur & Struktur Folder

Pola: **feature-first** (folder per fitur) dengan lapisan `screens → providers → repositories → database`.

```
lib/
├── main.dart                     # Bootstrap: MultiProvider + MaterialApp + AppRouter
├── app/
│   └── router.dart               # ★ diperluas — AppRouter: konstanta, routes, generateRoute, error screen
├── core/
│   ├── database/
│   │   └── database_helper.dart  # Skema 15 tabel, seed data, hashing SHA-256, singleton
│   ├── models/                   # 7 model data (toMap/fromMap)
│   │   ├── user_model.dart       ├── product_model.dart   ├── cart_model.dart
│   │   ├── order_model.dart      ├── promo_model.dart     ├── address_model.dart
│   │   └── category_model.dart
│   ├── theme/
│   │   ├── app_colors.dart       # Palet warna (primary #D4823A, status, dsb.)
│   │   └── app_theme.dart        # ThemeData Material 3 (fontFamily 'Poppins')
│   └── widgets/
│       ├── app_drawer.dart       # ★ BARU — Drawer global (tab + Tentang + Keluar)
│       └── bakery_image.dart     # Pemetaan nama file gambar → asset, fallback
└── features/
    ├── about/screens/about_screen.dart      # ★ BARU — /about
    ├── auth/
    │   ├── screens/  splash_screen.dart, login_screen.dart, register_screen.dart
    │   ├── providers/auth_provider.dart
    │   └── repositories/user_repository.dart
    ├── home/screens/  main_screen.dart (Scaffold + Drawer + BottomNav), home_screen.dart
    ├── products/
    │   ├── screens/  menu_screen.dart, product_detail_screen.dart
    │   ├── providers/product_provider.dart
    │   ├── repositories/product_repository.dart
    │   └── widgets/product_card.dart
    ├── cart/
    │   ├── screens/cart_screen.dart
    │   └── providers/cart_provider.dart
    ├── orders/
    │   ├── screens/  checkout_screen.dart, order_status_screen.dart, order_detail_screen.dart
    │   └── providers/order_provider.dart
    ├── promo/providers/promo_provider.dart
    └── admin/
        ├── screens/  admin_main_screen.dart, admin_dashboard_tab.dart,
        │             admin_orders_tab.dart, admin_products_tab.dart, admin_promo_tab.dart
        └── widgets/  add_edit_product_dialog.dart, add_edit_promo_dialog.dart
```

**Aliran data satu arah:**

```
Widget (UI)  ──baca/tulis──►  Provider (ChangeNotifier)  ──►  Repository  ──►  DatabaseHelper (SQLite)
     ▲                                    │
     └──────── notifyListeners() ─────────┘
```

- **UI** tidak pernah menulis SQL; UI memanggil method provider.
- **Provider** menyimpan state + status loading/error, memanggil repository.
- **Repository** menyusun query SQL (JOIN produk + kategori + stok).
- **DatabaseHelper** singleton: satu koneksi `wib_bakery.db`, `PRAGMA foreign_keys = ON`.

---

## 7. Fitur Aplikasi

### 7.1 Alur customer

| # | Layar / Fitur | Detail perilaku |
|---|---|---|
| 1 | **Splash** (`/`) | Animasi logo 1.200 ms, jeda 2 detik, cek sesi → `/home` (customer), `/admin-home` (admin), atau `/login` |
| 2 | **Login** (`/login`) | Validasi email format + password, toggle lihat sandi, hash SHA-256, redirect sesuai `role`, tautan ke `/register` |
| 3 | **Register** (`/register`) | Form nama, email, telepon, password + konfirmasi; cek duplikat email/telepon; setelah sukses langsung ke `/home` |
| 4 | **Beranda** (tab 1) | Sapaan "Welcome, {nama}", pencarian, banner promo (carousel), chip kategori, "Terlaris Hari Ini" (urut `sold`), "Lihat Semua" → tab Menu, tombol hamburger |
| 5 | **Menu Bakery** (tab 2) | Pencarian produk, filter kategori, grid 2 kolom `ProductCard`, tombol hamburger |
| 6 | **Detail Produk** (`/product-detail`) | `SliverAppBar` 300 px + judul "Detail Produk", gambar, nama, rating, harga, deskripsi, stok, tombol **"Tambah ke Keranjang"** yang membuka *bottom sheet* (jumlah + catatan, tombol "Tambahkan ke Keranjang") |
| 7 | **Keranjang** (tab 3) | Daftar item + catatan, ubah jumlah (+/−), hapus item, alamat pengiriman, ringkasan (subtotal, ongkir, total), tombol "Pesan Sekarang" |
| 8 | **Checkout** (`/checkout`) | Alamat, daftar produk, input **kode promo**, pilih **metode pembayaran** (`cash` "Cash (Bayar di Tempat)" / `transfer` "Transfer Bank" / `ewallet` "E-Wallet"), catatan pesanan, ongkir tetap **Rp 10.000** (`static const double _shippingCost`), ringkasan total, tombol buat pesanan |
| 9 | **Status Pesanan** (tab 4) | Daftar pesanan milik pengguna dengan badge status berwarna; tap → detail |
| 10 | **Detail Pesanan** (`/order-detail`) | Info pesanan, daftar item, alamat, pembayaran, rincian biaya (subtotal/diskon/ongkir/total), **riwayat status** (timeline) |
| 11 | **Drawer** | Navigasi 4 tab + Tentang Aplikasi + Keluar (langsung logout, tanpa dialog) |
| 12 | **Tentang Aplikasi** (`/about`) | Deskripsi, fitur utama, info pengembang, tombol kembali/muat ulang |

### 7.2 Alur admin (`/admin-home`)

| Tab | Fitur |
|---|---|
| **Dashboard** | Statistik: **Total Omzet Selesai**, **Total Produk Menu**, **Perlu Diproses** (pending), **Stok Menipis (≤ 5)**; status "Sistem Bakery Aktif"; **"Aksi Cepat Admin"** (Kelola Pesanan, Manajemen Katalog & Stok, Kupon Promo); daftar pesanan terbaru; tombol keluar admin |
| **Pesanan** | Daftar seluruh pesanan + filter status, ubah status pesanan (`pending` → `processing` → `ready` → `completed`, plus `cancelled`), tap kartu → `/order-detail` |
| **Produk & Stok** | Daftar produk, tambah produk (nama, kategori, harga, stok, deskripsi), edit, hapus, ubah status aktif/nonaktif, update stok |
| **Promo** | Daftar promo, tambah/edit promo (kode, nama, tipe diskon `percent`/`fixed`, nilai, min. transaksi, maks. diskon), aktif/nonaktif, hapus dengan konfirmasi |

### 7.3 Aturan bisnis penting

| Aturan | Implementasi |
|---|---|
| Ongkos kirim | Flat **Rp 10.000** (`_shippingCost` di `CheckoutScreen`) |
| Total | `subtotal − diskon + ongkir` |
| Diskon persen | `subtotal × nilai%`, dibatasi `max_discount` |
| Diskon nominal | Nilai tetap (mis. Rp 10.000) |
| Syarat promo | Status aktif, dalam rentang tanggal, `subtotal ≥ min_transaction` |
| Stok | Berkurang saat pesanan dibuat; `sold` bertambah (dalam satu transaksi DB) |
| Status awal pesanan | `pending`, `payment_status = 'pending'` |
| Riwayat status | Setiap perubahan status dicatat di `order_status_history` |
| Hapus promo | Konfirmasi dialog sebelum menghapus |

---

## 8. Basis Data (SQLite)

- Nama file: **`wib_bakery.db`** (di direktori database aplikasi Android)
- Versi skema: **1** (`version: 1`, hanya `onCreate` — **belum ada `onUpgrade`**)
- `PRAGMA foreign_keys = ON` di `onConfigure`
- Semua tabel memakai `INTEGER PRIMARY KEY AUTOINCREMENT`

### 8.1 Daftar tabel (15)

| # | Tabel | Kolom utama | Relasi |
|---|---|---|---|
| 1 | `users` | `user_id`, `name`, `email` (unik), `phone` (unik), `password` (SHA-256), `role`, `photo`, `created_at`, `updated_at` | – |
| 2 | `user_address` | `address_id`, `user_id`, `label`, `receiver_name`, `phone`, `address_detail`, `city`, `postal_code`, `is_default` | → `users` (CASCADE) |
| 3 | `category` | `category_id`, `category_name` (unik), `description`, `image`, `status` | – |
| 4 | `product` | `product_id`, `category_id`, `product_name`, `description`, `price`, `image`, `status` (`active`/`inactive`), `sold`, `rating`, `created_at` | → `category` |
| 5 | `product_stock` | `stock_id`, `product_id` (unik), `quantity`, `min_stock` (default 5), `updated_at` | → `product` |
| 6 | `promo` | `promo_id`, `promo_code` (unik), `promo_name`, `discount_type`, `discount_value`, `min_transaction`, `max_discount`, `start_date`, `end_date`, `status` | – |
| 7 | `product_promo` | `product_promo_id`, `product_id`, `promo_id` | → `product`, `promo` |
| 8 | `cart` | `cart_id`, `user_id` (unik), `created_at` | → `users` (CASCADE) |
| 9 | `cart_detail` | `cart_detail_id`, `cart_id`, `product_id`, `quantity`, `note`, `price` | → `cart` (CASCADE), `product` |
| 10 | `orders` | `order_id`, `user_id`, `address_id`, `order_number` (unik), `subtotal`, `discount`, `shipping_cost`, `total_price`, `promo_code`, `status`, `order_date`, `note` | → `users`, `user_address` |
| 11 | `order_detail` | `order_detail_id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`, `note` | → `orders`, `product` |
| 12 | `payment` | `payment_id`, `order_id` (unik), `payment_method`, `payment_status`, `payment_date`, `transaction_id`, `amount` | → `orders` |
| 13 | `order_status_history` | `history_id`, `order_id`, `status`, `description`, `created_at` | → `orders` |
| 14 | `review` | `review_id`, `user_id`, `product_id`, `rating` (1–5), `comment`, `created_at` | → `users`, `product` |
| 15 | `favorite` | `favorite_id`, `user_id`, `product_id`, `created_at` (unik per user+produk) | → `users`, `product` |

### 8.2 Relasi inti (ERD ringkas)

```
users 1───N user_address          category 1───N product 1───1 product_stock
  │                                              │
  │ 1───1 cart ───N cart_detail ───N ────────────┘
  │
  │ 1───N orders ───N order_detail ───N product
  │          │ 1───1 payment
  │          │ 1───N order_status_history
  │
  └─ 1───N review, favorite, product_promo
promo 1───N product_promo
```

### 8.3 Seed data (otomatis saat database pertama kali dibuat)

| Data | Isi |
|---|---|
| Pengguna | 1 admin (`admin@wibbakery.com`) + 1 customer (`fanduy@gmail.com`) — lihat [Akun Demo](#11-akun-demo) |
| Alamat | 1 alamat customer: label "Rumah", Jl. Kebayoran Baru No. 12, Jakarta Selatan, 12120 |
| Kategori (4) | Roti, Kue, Pastry, Minuman |
| Produk (8) | Almond Croissant, Roti Sisir Mentega, Kue Lumpur Surga, Es Kopi Susu Aren, Cinnamon Roll, Sourdough Plain, Brownies Cokelat, Matcha Latte |
| Promo (2) | `WIBANGET` (diskon 20%, min. Rp 50.000, maks. Rp 30.000) dan `WIBNEW` (potongan Rp 10.000, min. Rp 30.000) |

> ⚠️ **Penting:** kedua promo seed memiliki `end_date = 2025-12-31`. Jika tanggal perangkat
> sudah melewati tanggal tersebut (mis. 2026), promo akan ditolak dengan pesan
> *"Kode promo sudah kadaluarsa"*. Solusi: buat promo baru dari **Admin → Promo**
> dengan tanggal yang valid. Detail di [Known Issues](#12-catatan-teknis--known-issues).

### 8.4 Reset / migrasi database

Karena `DatabaseHelper` baru memakai `onCreate` (belum `onUpgrade`), perubahan skema
**tidak otomatis** diterapkan pada instalasi lama. Untuk memulai dari nol:

```bash
# Hapus data aplikasi (menghapus wib_bakery.db)
adb shell pm clear com.wib.wib_bakery
# atau uninstall lalu install ulang
adb uninstall com.wib.wib_bakery
flutter run
```

Jika ingin menambah kolom/tabel di kemudian hari, naikkan `version` dan implementasikan
`onUpgrade` (mis. `ALTER TABLE ... ADD COLUMN ...`).

---

## 9. State Management & Model Data

### 9.1 Provider (5)

| Provider | Tanggung jawab | Method utama |
|---|---|---|
| `AuthProvider` | Sesi login, data pengguna aktif, peran | `login`, `register`, `logout`, `isAdmin`, `currentUser` |
| `ProductProvider` | Katalog, kategori, pencarian, CRUD admin | `loadAll`, `loadByCategory`, `search`, `addProduct`, `updateProduct`, `deleteProduct`, `updateStock` |
| `CartProvider` | Keranjang pengguna | `loadCart`, `addToCart`, `updateQuantity`, `removeItem`, `clearCart`, `subtotal`, `itemCount` |
| `OrderProvider` | Pembuatan & pelacakan pesanan | `createOrder` (transaksional), `loadUserOrders`, `loadAllOrders`, `updateStatus`, `loadStatusHistory` |
| `PromoProvider` | Validasi & CRUD promo | `applyPromo`, `removePromo`, `loadPromos`, `loadAllPromos`, `createPromo`, `updatePromo`, `togglePromoStatus`, `deletePromo` |

Kelima provider didaftarkan sebagai `ChangeNotifierProvider` biasa di `MultiProvider`
(`main.dart`) — **tidak** memakai `ProxyProvider`. Karena itu `CartProvider` dan
`OrderProvider` menerima `userId` sebagai parameter (`loadCart(userId)`,
`loadUserOrders(userId)`), dan layar yang memanggilnya mengambil
`context.read<AuthProvider>().currentUser!.userId`.

### 9.2 Model (7)

| Model | Field penting |
|---|---|
| `UserModel` | `userId`, `name`, `email`, `phone`, `password`, `role`, `photo`, `createdAt`, `updatedAt` (+ `isAdmin`) |
| `ProductModel` | `productId`, `categoryId`, `productName`, `description`, `price`, `image`, `status`, `sold`, `rating`, `stock`, `categoryName` |
| `CartModel` / `CartItemModel` | `cartId`, `userId`, item: `productId`, `productName`, `price`, `quantity`, `note`, `image`, `subtotal` |
| `OrderModel` | `orderId`, `userId`, `addressId`, `orderNumber`, `subtotal`, `discount`, `shippingCost`, `totalPrice`, `promoCode`, `status`, `orderDate`, `note`, items, payment |
| `PromoModel` | `promoId`, `promoCode`, `promoName`, `discountType`, `discountValue`, `minTransaction`, `maxDiscount`, `startDate`, `endDate`, `status` (+ `calculateDiscount`, `isValid`, `discountLabel`) |
| `AddressModel` | `addressId`, `userId`, `label`, `receiverName`, `phone`, `addressDetail`, `city`, `postalCode`, `isDefault` |
| `CategoryModel` | `categoryId`, `categoryName`, `description`, `image`, `status` |

---

## 10. Spesifikasi Menjalankan Proyek

### 10.1 Kebutuhan perangkat lunak

| Komponen | Versi minimum | Versi terverifikasi |
|---|---|---|
| **Flutter SDK** | 3.24+ (stable) | **3.50.0** stable |
| **Dart SDK** | 3.0.0 (sesuai `environment: sdk: '>=3.0.0 <4.0.0'`) | **3.14.0** |
| **Android SDK** | API 24+ (mengikuti `flutter.minSdkVersion`) | **Android SDK 36.0.0** |
| **JDK** | 17+ (wajib untuk AGP 9.x) | **JBR 25.0.4** bawaan Android Studio (`C:\Program Files\Android\Android Studio\jbr`) |
| **Gradle / AGP / Kotlin** | – | Gradle **9.3.1**, AGP **9.1.1**, Kotlin dideklarasikan **2.4.0** di `settings.gradle.kts` (build melaporkan KGP **2.4.10**) |
| **Perangkat** | Emulator Android atau HP fisik (USB debugging) | Emulator **Pixel_10_Pro** tersedia |
| **RAM** | 8 GB (disarankan) | – |
| **OS pengembangan** | Windows 10/11, macOS, Linux | Windows 11 (25H2) |

> Proyek **hanya** memiliki folder `android/`. Menjalankan `flutter run -d windows` atau
> `-d chrome` akan gagal karena platform desktop/web belum di-*generate*, dan `sqflite`
> memang tidak mendukung web tanpa adapter tambahan.

### 10.2 Dependensi (`pubspec.yaml`)

| Paket | Versi | Fungsi |
|---|---|---|
| `provider` | `^6.1.2` | State management (ChangeNotifier) |
| `sqflite` | `^2.3.3+1` | Database SQLite lokal |
| `path` | `^1.9.0` | Menyusun path file database |
| `cached_network_image` | `^3.3.1` | Gambar jaringan + cache (cadangan untuk gambar non-asset) |
| `flutter_svg` | `^2.0.10+1` | Dukungan ikon/gambar SVG |
| `shimmer` | `^3.0.0` | Efek loading *skeleton* |
| `carousel_slider` | `^4.2.1` | Banner promo di Beranda |
| `shared_preferences` | `^2.2.3` | Preferensi/sesi ringan |
| `intl` | `^0.19.0` | Format tanggal & angka |
| `crypto` | `^3.0.3` | Hash password SHA-256 |
| `uuid` | `^4.4.2` | Nomor pesanan unik |
| `cupertino_icons` | `^1.0.8` | Ikon Cupertino |
| `flutter_iconly` | `^1.0.2` | Set ikon UI |
| `flutter_lints` (dev) | `^4.0.0` | Aturan lint |

### 10.3 Langkah instalasi & menjalankan

```bash
# 1. Masuk ke folder proyek
cd WIBakeryPendragonAncestorPertemuan4      # sesuaikan dengan lokasi clone Anda

# 2. Pastikan toolchain siap (harus tanpa error Android)
flutter doctor

# 3. Unduh dependensi
flutter pub get

# 4. Lihat perangkat/emulator yang tersedia
flutter devices
flutter emulators                 # contoh: Pixel_10_Pro
flutter emulators --launch Pixel_10_Pro

# 5. Jalankan aplikasi (debug)
flutter run

# Opsional: pilih perangkat tertentu
flutter run -d emulator-5554
```

### 10.4 Build APK

```bash
# Debug (paling cepat, untuk demo)
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk  (± 186 MB)

# Release (butuh signing; gunakan --split-per-abi agar kecil)
flutter build apk --release --split-per-abi
```

Install ke perangkat:

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### 10.5 Pemeriksaan kualitas

```bash
flutter analyze     # 0 error (124 info: API deprecated Flutter 3.50)
flutter test        # 1 widget test lulus
dart format lib     # opsional: rapikan format
```

### 10.6 Aset

| Folder | Isi |
|---|---|
| `assets/images/` | 10 gambar JPG: `banner_promo.jpg`, `almond_croissant.jpg`, `roti_sisir.jpg`, `kue_lumpur.jpg`, `kopi_susu.jpg`, `cinnamon_roll.jpg`, `sourdough.jpg`, `brownies.jpg`, `matcha_latte.jpg`, `bread_default.jpg` (fallback) |
| `assets/icons/` | Kosong (sudah dideklarasikan di `pubspec.yaml`, siap diisi) |

`BakeryImage` memetakan kolom `image` di database (mis. `"roti"`, `"kue"`) ke file aset
yang sesuai, dan memakai `bread_default.jpg` bila gambar tidak ditemukan.

---

## 11. Akun Demo

Data ini dibuat otomatis oleh seed database saat aplikasi pertama kali dijalankan
(file `Data Akun Demo Untuk Login.txt` juga tersedia di root proyek).

**Admin**

```
Email    : admin@wibbakery.com
Password : admin123
```

**Customer**

```
Email    : fanduy@gmail.com
Password : customer123
```

Keduanya adalah **akun demo lokal** (bukan kredensial produksi); password disimpan
sebagai hash SHA-256 di tabel `users`.

---

## 12. Catatan Teknis & Known Issues

| # | Temuan | Dampak | Rekomendasi |
|---|---|---|---|
| 1 | **Promo seed kedaluwarsa** (`end_date = 2025-12-31`) | Kode `WIBANGET`/`WIBNEW` ditolak jika tanggal perangkat > 31 Des 2025 | Buat promo baru via Admin → Promo, atau ubah `end_date` di `database_helper.dart` lalu reset DB |
| 2 | **`addressId` di-hardcode `1`** di `CheckoutScreen` | Pesanan selalu memakai alamat `address_id = 1` (alamat seed) | Ambil alamat default dari `AddressModel`/provider alamat |
| 3 | **Font `Poppins` tidak dideklarasikan** di `pubspec.yaml` (tidak ada bagian `fonts:`) | Teks memakai font *fallback* sistem, bukan Poppins | Tambahkan file `assets/fonts/Poppins-*.ttf` + deklarasi `fonts:` |
| 4 | **`onUpgrade` belum diimplementasikan** (DB versi 1) | Perubahan skema tidak berlaku pada instalasi lama | Naikkan versi + tulis migrasi, atau `pm clear` saat pengembangan |
| 5 | **124 temuan `flutter analyze`** (info) | Tidak menggagalkan build; mayoritas `withOpacity` deprecated | Ganti `withOpacity(x)` → `withValues(alpha: x)` saat upgrade Flutter |
| 6 | **Setelah checkout** diarahkan ke `/home`, bukan detail/status pesanan | Pengguna harus membuka tab Status Pesanan untuk melihat pesanan baru | Pertimbangkan `pushNamed(orderDetail, arguments: newOrderId)` |
| 7 | **Platform hanya Android** | Tidak bisa `flutter run -d chrome/windows` | Jalankan `flutter create --platforms=web .` bila perlu (sqflite butuh adapter) |
| 8 | **Folder `android/build/` belum di-*ignore*** | Artefak build muncul sebagai untracked | Tambahkan `android/build/` ke `.gitignore` |
| 9 | **`assets/icons/` kosong** | Tidak ada ikon kustom | Isi atau hapus deklarasi folder |
| 10 | **Tabel `review` & `favorite` belum dipakai UI** | Fitur rating/favorit belum aktif | Kembangkan pada pertemuan berikutnya |
| 11 | **Test hanya smoke test** | Cakupan pengujian rendah | Tambah widget test untuk login, keranjang, dan navigasi route |
| 12 | **Peringatan versi toolchain saat build** | Build sukses, tetapi Flutter memperingatkan dukungan AGP 9.1.1 dan KGP 2.4.10 "akan segera dihentikan" dan menyarankan Kotlin ≥ 2.4.20 | Naikkan `org.jetbrains.kotlin.android` di `settings.gradle.kts` ke ≥ 2.4.20 saat ingin upgrade; untuk sekarang aman diabaikan (atau pakai `--android-skip-build-dependency-validation`) |
| 13 | **Status `delivery` tidak bisa dipilih admin** | `OrderModel`/`OrderStatusScreen`/`AppColors` mengenali `delivery` ("Dalam Pengiriman"), tetapi daftar pilihan di `admin_orders_tab.dart` hanya 5 status (tanpa `delivery`) | Tambahkan `{'key': 'delivery', 'label': 'Dikirim'}` ke daftar status admin |

---

## 13. Troubleshooting

| Gejala | Penyebab | Solusi |
|---|---|---|
| `flutter: command not found` | Flutter tidak ada di `PATH` | Tambahkan `C:\...\flutter\bin` ke Environment Variables, buka terminal baru |
| `Unable to locate Android SDK` | `ANDROID_HOME` belum diset | Set `ANDROID_HOME=%LOCALAPPDATA%\Android\sdk` dan `PATH` ke `platform-tools` |
| `Android license status unknown` | Lisensi SDK belum diterima | `flutter doctor --android-licenses` lalu tekan `y` |
| `cmdline-tools component is missing` | Komponen SDK hilang | Install "Android SDK Command-line Tools" via SDK Manager |
| `java: command not found` (di Git Bash) | `java` tidak ada di `PATH`; Gradle memakai JBR bawaan Android Studio | Tidak perlu diperbaiki — build tetap jalan. Bila perlu, set `JAVA_HOME` ke folder `jbr` Android Studio |
| Gradle gagal / lambat | Cache korup atau unduhan pertama | `flutter clean && flutter pub get`, lalu jalankan ulang (unduhan Gradle 9.3.1 butuh waktu) |
| `Execution failed for task ':app:...'` | Konflik versi plugin | Cek `android/settings.gradle.kts` (AGP 9.1.1, Kotlin 2.4.0), `flutter pub upgrade` |
| Emulator tidak terdeteksi | Emulator belum booting | `flutter emulators --launch Pixel_10_Pro`, tunggu hingga home screen, lalu `flutter devices` |
| Database lama membuat data aneh | Skema lama tersimpan | `adb shell pm clear com.wib.wib_bakery` |
| Kode promo ditolak | Promo seed kedaluwarsa | Lihat Known Issue #1 |
| Layar error "Halaman tidak ditemukan" | Route tidak terdaftar di `AppRouter.routes` | Daftarkan route + konstanta baru |

---

## 14. Checklist Rubrik & Skenario Uji

### 14.1 Pemenuhan tugas Pertemuan 8

| Ketentuan tugas | Status | Bukti |
|---|---|---|
| Minimal tiga halaman utama + nama route | ✅ | 17 halaman, **9 named route** (`/`, `/login`, `/register`, `/home`, `/admin-home`, `/product-detail`, `/checkout`, `/order-detail`, `/about`) |
| Named route untuk seluruh perpindahan | ✅ | Semua `Navigator.*` memakai `AppRouter.*`; tidak ada `MaterialPageRoute` lepas di layar |
| Kirim data produk ke halaman detail via `arguments` | ✅ | `pushNamed(productDetail, arguments: product)` + validasi tipe di `ProductDetailScreen` |
| Bottom navigation sebagai menu utama | ✅ | 4 item + badge keranjang, `IndexedStack` menjaga state |
| Drawer atau tab | ✅ | **Drawer** global (`AppDrawer`) + menu Tentang Aplikasi |
| Dokumentasi peta route & tampilan | ✅ | Bagian [4](#4-peta-route-lengkap), [5](#5-diagram-alur-navigasi), [7](#7-fitur-aplikasi) di README ini |

### 14.2 Skenario uji manual

| # | Skenario | Langkah | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Splash → Login | Buka aplikasi tanpa sesi | Splash 2 detik → `/login` |
| 2 | Login customer | `fanduy@gmail.com` / `customer123` | Masuk `/home`, sapaan "Welcome, Fanduy" |
| 3 | Login admin | `admin@wibbakery.com` / `admin123` | Masuk `/admin-home` dengan 4 tab |
| 4 | Buka drawer | Tap ikon hamburger di Beranda/Menu/Keranjang/Status | Drawer terbuka, item aktif tersorot |
| 5 | Pindah tab via drawer | Tap "Keranjang" di drawer | Drawer tertutup, tab Keranjang aktif |
| 6 | Tentang Aplikasi | Drawer → Tentang Aplikasi | `/about` tampil; tombol back kembali ke tab asal |
| 7 | Detail produk | Tap kartu produk di Beranda | `/product-detail` menampilkan **produk yang benar** (bukan produk pertama) |
| 8 | Argumen salah | Panggil `/product-detail` tanpa argumen (uji kode) | Layar error argumen, bukan crash |
| 9 | Tambah ke keranjang | Detail produk → jumlah + catatan → "Tambahkan ke Keranjang" | Badge keranjang bertambah, SnackBar sukses |
| 10 | Checkout | Keranjang → "Pesan Sekarang" → pilih pembayaran → buat pesanan | Pesanan tersimpan, status `pending`, kembali ke `/home`, SnackBar "Pesanan berhasil dibuat" |
| 11 | Detail pesanan | Tab Status → tap kartu pesanan | `/order-detail` dengan `orderId` yang benar + timeline status |
| 12 | Route tidak dikenal | `pushNamed('/tidak-ada')` | Layar "Halaman tidak ditemukan" + tombol "Kembali ke Beranda" |
| 13 | Admin ubah status | Admin → Pesanan → ubah status | Status berubah, riwayat status bertambah, dashboard ikut ter-update |
| 14 | Admin tambah produk | Admin → Produk & Stok → Tambah | Produk muncul di katalog customer |
| 15 | Logout | Drawer → Keluar (langsung, tanpa dialog) | Kembali ke `/login`; `pushReplacementNamed` membuat tombol *back* tidak kembali ke halaman sebelumnya |

---

## 15. Rencana Pengembangan

1. **Manajemen alamat** — form tambah/ubah alamat, pilih alamat saat checkout (menghapus `addressId = 1`).
2. **Pembayaran** — unggah bukti transfer, verifikasi pembayaran oleh admin (`payment_status`).
3. **Rating & favorit** — aktifkan tabel `review` dan `favorite` yang sudah ada.
4. **Migrasi database** — implementasi `onUpgrade` + versi skema.
5. **Tema & font** — bundel font Poppins, dukungan *dark mode* (`AppColors.backgroundDark` sudah tersedia).
6. **Pengujian** — widget test untuk login, keranjang, checkout, dan seluruh route.
7. **Screenshot dokumentasi** — tambahkan `docs/screenshots/` untuk melengkapi rubrik dokumentasi.

---

<div align="center">

**WIB Bakery** · Pemrograman Mobile · Pertemuan 8 — Navigasi Lanjutan
Dibangun dengan Flutter, Provider, dan SQLite

</div>
