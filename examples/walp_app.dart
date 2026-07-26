
// ============================================================================
// PREMIUM WALLPAPER APP 
//
// Requires these dependencies in pubspec.yaml:
//   google_fonts: ^6.2.1
//   cached_network_image: ^3.4.1
//   shimmer: ^3.0.0
//   flutter_animate: ^4.5.2
//
// Images are served from https://picsum.photos (no local assets needed).
// Download / Share actions are simulated with UI feedback (SnackBars) since
// this file intentionally has zero platform-specific plugins or permissions.
// ============================================================================
// ============================================================================
// AURORA — premium wallpaper app, single-file Flutter application (main.dart)
//
// pubspec.yaml dependencies required:
//   google_fonts: ^6.2.1
//   cached_network_image: ^3.4.1
//   shimmer: ^3.0.0
//   flutter_animate: ^4.5.2
//   dio: ^5.7.0
//   gal: ^2.3.1
//   shared_preferences: ^2.3.3
//   smooth_page_indicator: ^1.2.1
//
// Platform setup for real downloads (Gal saves to the photo library):
//   iOS  -> ios/Runner/Info.plist: add
//           <key>NSPhotoLibraryAddUsageDescription</key>
//           <string>Aurora saves wallpapers to your photo library.</string>
//   Android -> gal ships its own manifest entries for scoped storage
//           (API 29+); no manual changes needed for a standard Flutter project
//           with minSdkVersion 21+.
//
// Images are served from https://picsum.photos — no local assets required.
// ============================================================================

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const WallpaperApp());
}

// ============================================================================
// BRAND COLORS, PALETTE (LIGHT/DARK) & THEME
// ============================================================================

/// Brand accent colors stay constant across light and dark mode — an
/// emerald-to-amber gradient that reads as premium in either theme.
class AppBrand {
  AppBrand._();

  static const Color tealDeep = Color(0xFF0D9488);
  static const Color teal = Color(0xFF14B8A6);
  static const Color amber = Color(0xFFF59E0B);
  static const Color coral = Color(0xFFFB7185);

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tealDeep, teal, amber],
  );

  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000018)],
    stops: [0.4, 1.0],
  );
}

/// Surface / text colors that flip between light and dark mode.
class AppPalette {
  final Color bg;
  final Color card;
  final Color cardAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color divider;

  const AppPalette({
    required this.bg,
    required this.card,
    required this.cardAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.divider,
  });

  static const dark = AppPalette(
    bg: Color(0xFF0A0F14),
    card: Color(0xFF151F27),
    cardAlt: Color(0xFF1D2A33),
    textPrimary: Color(0xFFF3F6F5),
    textSecondary: Color(0xFFA7B4BC),
    textMuted: Color(0xFF67757D),
    divider: Color(0xFF223038),
  );

  static const light = AppPalette(
    bg: Color(0xFFF6F8F7),
    card: Color(0xFFFFFFFF),
    cardAlt: Color(0xFFEEF3F1),
    textPrimary: Color(0xFF10201C),
    textSecondary: Color(0xFF54655F),
    textMuted: Color(0xFF8C9C96),
    divider: Color(0xFFE2E9E6),
  );
}

extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
}

ThemeData buildAppTheme(Brightness brightness) {
  final palette = brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
  final base = ThemeData(brightness: brightness, useMaterial3: true);
  final textTheme = GoogleFonts.interTextTheme(
    base.textTheme,
  ).apply(bodyColor: palette.textPrimary, displayColor: palette.textPrimary);

  return base.copyWith(
    scaffoldBackgroundColor: palette.bg,
    textTheme: textTheme,
    colorScheme: base.colorScheme.copyWith(
      primary: AppBrand.teal,
      secondary: AppBrand.amber,
      surface: palette.card,
      brightness: brightness,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}

// ============================================================================
// APP-WIDE CONTROLLERS (theme mode, grid density, favorites)
// ============================================================================

class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;

  void setMode(ThemeMode value) {
    if (value == _mode) return;
    _mode = value;
    notifyListeners();
  }
}

class GridPrefsController extends ChangeNotifier {
  GridPrefsController._();
  static final GridPrefsController instance = GridPrefsController._();

  int _columns = 2;
  int get columns => _columns;

  void setColumns(int value) {
    if (value == _columns) return;
    _columns = value;
    notifyListeners();
  }

  void toggle() => setColumns(_columns == 2 ? 3 : 2);
}

class FavoritesController extends ChangeNotifier {
  FavoritesController._();
  static final FavoritesController instance = FavoritesController._();

  final Map<String, Wallpaper> _items = {};

  bool isFavorite(String id) => _items.containsKey(id);
  List<Wallpaper> get all => _items.values.toList();

  void toggle(Wallpaper wallpaper) {
    if (_items.containsKey(wallpaper.id)) {
      _items.remove(wallpaper.id);
    } else {
      _items[wallpaper.id] = wallpaper;
    }
    notifyListeners();
  }
}

// ============================================================================
// MODEL
// ============================================================================

class Wallpaper {
  final String id;
  final String category;
  final String author;
  final int likes;
  final String imageUrl;
  final String thumbUrl;

  const Wallpaper({
    required this.id,
    required this.category,
    required this.author,
    required this.likes,
    required this.imageUrl,
    required this.thumbUrl,
  });
}

// ============================================================================
// MOCK REPOSITORY
// ============================================================================

class WallpaperRepository {
  WallpaperRepository._();

  static const List<String> categories = [
    'All',
    'Nature',
    'Abstract',
    'Minimal',
    'Space',
    'City',
    'Dark',
    'Neon',
    'Ocean',
  ];

  static const List<String> _authors = [
    'Ava Stone',
    'Leo Kim',
    'Maya Ortiz',
    'Noah Reyes',
    'Zara Lin',
    'Kai Andersson',
    'Ivy Chen',
    'Theo Marsh',
    'Nora Vale',
    'Dev Patel',
  ];

  static List<Wallpaper> generate({
    required int count,
    String? category,
    int offset = 0,
  }) {
    final rnd = Random(offset * 7 + (category?.hashCode ?? 13));
    final pool = (category == null || category == 'All')
        ? categories.where((c) => c != 'All').toList()
        : [category];

    return List.generate(count, (i) {
      final id = 'wp_${offset}_$i';
      final cat = pool[rnd.nextInt(pool.length)];
      // Vary the *source* image aspect for visual variety; the grid cell
      // itself stays a fixed shape (see FixedWallpaperGrid).
      final aspect = 1.1 + rnd.nextDouble() * 0.9;
      const width = 640;
      final height = (width * aspect).round();
      const thumbWidth = 400;
      final thumbHeight = (thumbWidth * aspect).round();

      return Wallpaper(
        id: id,
        category: cat,
        author: _authors[rnd.nextInt(_authors.length)],
        likes: 40 + rnd.nextInt(19960),
        imageUrl: 'https://picsum.photos/seed/$id/$width/$height',
        thumbUrl: 'https://picsum.photos/seed/$id/$thumbWidth/$thumbHeight',
      );
    });
  }
}

// ============================================================================
// SHARED VIEWER ROUTE + DOWNLOAD HELPER
// ============================================================================

Route _viewerRoute(Wallpaper wallpaper) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) =>
        WallpaperViewerScreen(wallpaper: wallpaper),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Downloads the full-resolution image and saves it to the device photo
/// gallery using the `gal` plugin. Requests photo-library access first.
Future<void> downloadWallpaper(
  BuildContext context,
  Wallpaper wallpaper,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final cardColor = context.palette.card;
  final textColor = context.palette.textPrimary;

  void showSnack(String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: cardColor,
          duration: const Duration(milliseconds: 1700),
          content: Text(
            message,
            style: GoogleFonts.inter(fontSize: 13, color: textColor),
          ),
        ),
      );
  }

  try {
    showSnack('Downloading wallpaper...');

    var hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      hasAccess = await Gal.requestAccess();
    }
    if (!hasAccess) {
      showSnack('Photo access denied. Enable it in system settings.');
      return;
    }

    final dio = Dio();
    final response = await dio.get(
      wallpaper.imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(seconds: 25),
      ),
    );
    final bytes = Uint8List.fromList(response.data as List<int>);
    if (bytes.isEmpty) throw Exception('Empty image response');

    await Gal.putImageBytes(bytes, name: 'aurora_${wallpaper.id}');
    showSnack('Saved to your gallery');
  } on GalException catch (e) {
    showSnack('Could not save: ${e.type.message}');
  } catch (_) {
    showSnack('Download failed. Check your connection.');
  }
}

// ============================================================================
// APP ROOT
// ============================================================================

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Aurora Wallpapers',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(Brightness.light),
          darkTheme: buildAppTheme(Brightness.dark),
          themeMode: ThemeController.instance.mode,
          home: const OnboardingGate(),
        );
      },
    );
  }
}

// ============================================================================
// ONBOARDING GATE — checks SharedPreferences once, then routes accordingly
// ============================================================================

class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key});

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  bool? _onboardingSeen;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _onboardingSeen = prefs.getBool('onboarding_seen') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingSeen == null) {
      return Scaffold(
        backgroundColor: context.palette.bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppBrand.teal),
        ),
      );
    }
    if (_onboardingSeen == false) {
      return OnboardingScreen(
        onFinish: () => setState(() => _onboardingSeen = true),
      );
    }
    return const RootShell();
  }
}

// ============================================================================
// ONBOARDING SCREEN
// ============================================================================

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardData(
      icon: Icons.auto_awesome_rounded,
      title: 'Discover stunning wallpapers',
      subtitle: 'Curated collections across nature, abstract, space and more.',
    ),
    _OnboardData(
      icon: Icons.favorite_rounded,
      title: 'Save your favorites',
      subtitle: 'Build your own collection and revisit it anytime.',
    ),
    _OnboardData(
      icon: Icons.download_rounded,
      title: 'Download in one tap',
      subtitle: 'Save wallpapers straight to your gallery in full resolution.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(color: palette.textSecondary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppBrand.hero,
                          ),
                          child: Icon(data.icon, size: 56, color: Colors.white),
                        ).animate().scale(
                          duration: 420.ms,
                          curve: Curves.easeOutBack,
                        ),
                        const SizedBox(height: 36),
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: palette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 320.ms);
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: WormEffect(
                dotColor: palette.divider,
                activeDotColor: AppBrand.teal,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      _finish();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppBrand.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isLast ? 'Get Started' : 'Next',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ROOT SHELL — bottom navigation between Home / Favorites / Settings
// ============================================================================

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _pages = [HomeScreen(), FavoritesScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.palette.bg,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _FloatingNavBar(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _FloatingNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _FloatingNavBar({required this.index, required this.onChanged});

  static const _items = [
    _NavItem(Icons.home_rounded, 'Home'),
    _NavItem(Icons.favorite_rounded, 'Favorites'),
    _NavItem(Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: palette.card.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: palette.divider),
              ),
              child: Row(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final selected = i == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: selected ? AppBrand.hero : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: selected
                                  ? Colors.white
                                  : palette.textMuted,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HOME SCREEN
// ============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Random _rnd = Random();

  bool _isLoading = true;
  bool _hasError = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Wallpaper> _featured = [];
  List<Wallpaper> _wallpapers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool isRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 850));

    if (isRefresh && _rnd.nextDouble() < 0.12) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    final freshOffset = DateTime.now().millisecondsSinceEpoch % 100000;
    final featured = WallpaperRepository.generate(
      count: 6,
      offset: 900 + freshOffset,
    );
    final list = WallpaperRepository.generate(
      count: 26,
      category: _selectedCategory,
      offset: freshOffset,
    );

    if (!mounted) return;
    setState(() {
      _featured = featured;
      _wallpapers = list;
      _isLoading = false;
    });
  }

  void _onCategorySelected(String category) {
    if (category == _selectedCategory) return;
    setState(() => _selectedCategory = category);
    _loadData();
  }

  List<Wallpaper> get _filteredWallpapers {
    if (_searchQuery.trim().isEmpty) return _wallpapers;
    final q = _searchQuery.trim().toLowerCase();
    return _wallpapers
        .where(
          (w) =>
              w.category.toLowerCase().contains(q) ||
              w.author.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openViewer(Wallpaper wallpaper) {
    Navigator.of(context).push(_viewerRoute(wallpaper));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final showSecondarySections =
        _searchQuery.trim().isEmpty && !_isLoading && !_hasError;

    return Scaffold(
      backgroundColor: palette.bg,
      body: RefreshIndicator(
        color: AppBrand.teal,
        backgroundColor: palette.card,
        onRefresh: () => _loadData(isRefresh: true),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(child: _buildSearchBar(palette)),
            if (_searchQuery.trim().isEmpty)
              SliverToBoxAdapter(child: _buildCategoryChips(palette)),
            if (showSecondarySections)
              SliverToBoxAdapter(child: _buildFeaturedSection(palette)),
            if (showSecondarySections)
              SliverToBoxAdapter(
                child: _sectionTitle(
                  palette,
                  'Trending now',
                  trailing: const GridToggleButton(),
                ),
              ),
            SliverToBoxAdapter(child: _buildContent(palette)),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  // ---- App bar -----------------------------------------------------------

  Widget _buildSliverAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: context.palette.bg,
      expandedHeight: 150,
      elevation: 0,
      actions: [
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: () => ThemeController.instance.setMode(
            isDark ? ThemeMode.light : ThemeMode.dark,
          ),
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 12),
        title: Text(
          'Aurora',
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: const BoxDecoration(gradient: AppBrand.hero)),
            Positioned(
              top: -40,
              right: -30,
              child: _blurCircle(120, Colors.white.withOpacity(0.12)),
            ),
            Positioned(
              bottom: -50,
              left: -20,
              child: _blurCircle(160, Colors.black.withOpacity(0.16)),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                'Wallpapers curated for you',
                style: GoogleFonts.inter(
                  fontSize: 11,

                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(width: size, height: size, color: color),
      ),
    );
  }

  // ---- Search --------------------------------------------------------------

  Widget _buildSearchBar(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: GlassContainer(
        borderRadius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: palette.textSecondary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  color: palette.textPrimary,
                  fontSize: 15,
                ),
                cursorColor: AppBrand.teal,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search wallpapers, authors...',
                  hintStyle: GoogleFonts.inter(
                    color: palette.textMuted,
                    fontSize: 15,
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: Icon(
                  Icons.close_rounded,
                  color: palette.textSecondary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---- Category chips --------------------------------------------------------

  Widget _buildCategoryChips(AppPalette palette) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: WallpaperRepository.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = WallpaperRepository.categories[index];
          final selected = category == _selectedCategory;
          return CategoryChip(
            label: category,
            selected: selected,
            onTap: () => _onCategorySelected(category),
          );
        },
      ),
    );
  }

  // ---- Section title -----------------------------------------------------

  Widget _sectionTitle(
    AppPalette palette,
    String title, {
    String? action,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          ?trailing,
          if (trailing == null && action != null)
            Text(
              action,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: palette.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  // ---- Featured section ----------------------------------------------------

  Widget _buildFeaturedSection(AppPalette palette) {
    if (_isLoading) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(palette, 'Featured', action: 'Editors\' picks'),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final wallpaper = _featured[index];
              return FeaturedCard(
                    wallpaper: wallpaper,
                    onTap: () => _openViewer(wallpaper),
                  )
                  .animate()
                  .fadeIn(delay: (60 * index).ms, duration: 320.ms)
                  .slideX(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        ),
      ],
    );
  }

  // ---- Main content (loading / error / empty / grid) ------------------------

  Widget _buildContent(AppPalette palette) {
    if (_isLoading) return const ShimmerGridSkeleton();
    if (_hasError)
      return ErrorStateWidget(onRetry: () => _loadData(isRefresh: true));
    final filtered = _filteredWallpapers;
    if (filtered.isEmpty) return EmptyStateWidget(query: _searchQuery);
    return FixedWallpaperGrid(
      wallpapers: filtered,
      onWallpaperTap: _openViewer,
    );
  }
}

// ============================================================================
// GLASSMORPHIC CONTAINER
// ============================================================================

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double height;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(12),
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.035);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.black.withOpacity(0.08);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY CHIP
// ============================================================================

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppBrand.hero : null,
          color: selected ? null : palette.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.transparent : palette.divider,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppBrand.teal.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// GRID TOGGLE BUTTON (2 / 3 columns)
// ============================================================================

class GridToggleButton extends StatelessWidget {
  const GridToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedBuilder(
      animation: GridPrefsController.instance,
      builder: (context, _) {
        final columns = GridPrefsController.instance.columns;
        return GestureDetector(
          onTap: GridPrefsController.instance.toggle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: palette.divider),
            ),
            child: Icon(
              columns == 2 ? Icons.grid_view_rounded : Icons.apps_rounded,
              size: 18,
              color: palette.textSecondary,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// FEATURED CARD (large horizontal card)
// ============================================================================

class FeaturedCard extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;

  const FeaturedCard({super.key, required this.wallpaper, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'wallpaper_${wallpaper.id}',
              child: CachedNetworkImage(
                imageUrl: wallpaper.thumbUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppPalette.dark.card),
                errorWidget: (context, url, error) => Container(
                  color: AppPalette.dark.card,
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: AppPalette.dark.textMuted,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(gradient: AppBrand.cardOverlay),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 12,
                      color: AppBrand.amber,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Featured',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallpaper.category,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    wallpaper.author,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FIXED-COLUMN WALLPAPER GRID (2 or 3 columns, toggled via GridPrefsController)
// ============================================================================

class FixedWallpaperGrid extends StatelessWidget {
  final List<Wallpaper> wallpapers;
  final ValueChanged<Wallpaper> onWallpaperTap;

  const FixedWallpaperGrid({
    super.key,
    required this.wallpapers,
    required this.onWallpaperTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GridPrefsController.instance,
      builder: (context, _) {
        final columns = GridPrefsController.instance.columns;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wallpapers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: columns == 2 ? 0.68 : 0.62,
            ),
            itemBuilder: (context, index) {
              final wallpaper = wallpapers[index];
              return WallpaperCard(
                    wallpaper: wallpaper,
                    onTap: () => onWallpaperTap(wallpaper),
                  )
                  .animate()
                  .fadeIn(delay: (25 * index).ms, duration: 280.ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
// WALLPAPER CARD (grid tile)
// ============================================================================

class WallpaperCard extends StatefulWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.onTap,
  });

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  bool _pressed = false;

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.palette.card,
          duration: const Duration(milliseconds: 1400),
          content: Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.palette.textPrimary,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = widget.wallpaper;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'wallpaper_${wallpaper.id}',
                child: CachedNetworkImage(
                  imageUrl: wallpaper.thumbUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 250),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: context.palette.card,
                    highlightColor: context.palette.cardAlt,
                    child: Container(color: context.palette.card),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: context.palette.card,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: context.palette.textMuted,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(gradient: AppBrand.cardOverlay),
              ),

              // Category badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    wallpaper.category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Favorite button
              Positioned(
                top: 6,
                right: 6,
                child: AnimatedBuilder(
                  animation: FavoritesController.instance,
                  builder: (context, _) {
                    final favorite = FavoritesController.instance.isFavorite(
                      wallpaper.id,
                    );
                    return GestureDetector(
                      onTap: () {
                        FavoritesController.instance.toggle(wallpaper);
                        _showSnack(
                          context,
                          favorite
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            favorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(favorite),
                            size: 16,
                            color: favorite ? AppBrand.coral : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom row: likes + download
              Positioned(
                left: 10,
                right: 8,
                bottom: 8,
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatLikes(wallpaper.likes),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => downloadWallpaper(context, wallpaper),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.file_download_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatLikes(int likes) {
  if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
  return '$likes';
}

// ============================================================================
// LOADING SKELETON (shimmer grid placeholder, matches current column count)
// ============================================================================

class ShimmerGridSkeleton extends StatelessWidget {
  const ShimmerGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedBuilder(
      animation: GridPrefsController.instance,
      builder: (context, _) {
        final columns = GridPrefsController.instance.columns;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: palette.card,
            highlightColor: palette.cardAlt,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: columns * 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: columns == 2 ? 0.68 : 0.62,
              ),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(color: palette.card),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class EmptyStateWidget extends StatelessWidget {
  final String query;

  const EmptyStateWidget({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppBrand.hero,
            ),
            child: const Icon(
              Icons.image_search_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No wallpapers found',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Try a different category.'
                : 'No results for "$query". Try another search.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ============================================================================
// ERROR STATE
// ============================================================================

class ErrorStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorStateWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppBrand.coral.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: AppBrand.coral,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Something went wrong',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'We couldn\'t load wallpapers. Check your connection and try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppBrand.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ============================================================================
// FAVORITES SCREEN
// ============================================================================

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: FavoritesController.instance,
          builder: (context, _) {
            final favorites = FavoritesController.instance.all;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Favorites',
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                          ),
                        ),
                        if (favorites.isNotEmpty) const GridToggleButton(),
                      ],
                    ),
                  ),
                ),
                if (favorites.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 48,
                            color: palette.textMuted,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No favorites yet',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the heart on any wallpaper to save it here.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: FixedWallpaperGrid(
                      wallpapers: favorites,
                      onWallpaperTap: (w) =>
                          Navigator.of(context).push(_viewerRoute(w)),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// SETTINGS SCREEN
// ============================================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          children: [
            Text(
              'Settings',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _SettingsSection(
              title: 'APPEARANCE',
              children: [
                AnimatedBuilder(
                  animation: ThemeController.instance,
                  builder: (context, _) => _ThemeModeSelector(
                    mode: ThemeController.instance.mode,
                    onChanged: ThemeController.instance.setMode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsSection(
              title: 'WALLPAPER GRID',
              children: [
                AnimatedBuilder(
                  animation: GridPrefsController.instance,
                  builder: (context, _) => _GridColumnSelector(
                    columns: GridPrefsController.instance.columns,
                    onChanged: GridPrefsController.instance.setColumns,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsSection(
              title: 'ABOUT',
              children: const [
                _SettingsRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Version',
                  value: '1.0.0',
                ),
                _SettingsRow(
                  icon: Icons.brush_outlined,
                  label: 'Design',
                  value: 'Aurora Emerald',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: palette.textMuted,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: palette.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.divider),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final IconData icon;
  final String label;
  const _ThemeOption(this.mode, this.icon, this.label);
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeSelector({required this.mode, required this.onChanged});

  static const _options = [
    _ThemeOption(ThemeMode.light, Icons.light_mode_rounded, 'Light'),
    _ThemeOption(ThemeMode.dark, Icons.dark_mode_rounded, 'Dark'),
    _ThemeOption(ThemeMode.system, Icons.smartphone_rounded, 'System'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: _options.map((o) {
        final selected = o.mode == mode;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(o.mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: selected ? AppBrand.hero : null,
                color: selected ? null : palette.cardAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    o.icon,
                    size: 18,
                    color: selected ? Colors.white : palette.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    o.label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GridColumnSelector extends StatelessWidget {
  final int columns;
  final ValueChanged<int> onChanged;

  const _GridColumnSelector({required this.columns, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [2, 3].map((count) {
        final selected = count == columns;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(count),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: selected ? AppBrand.hero : null,
                color: selected ? null : palette.cardAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count columns',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : palette.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: palette.textSecondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: palette.textPrimary),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 13, color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FULL-SCREEN WALLPAPER VIEWER
// ============================================================================

class WallpaperViewerScreen extends StatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperViewerScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperViewerScreen> createState() => _WallpaperViewerScreenState();
}

class _WallpaperViewerScreenState extends State<WallpaperViewerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  double _dragOffset = 0;
  bool _showChrome = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.palette.card,
          duration: const Duration(milliseconds: 1500),
          content: Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.palette.textPrimary,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = widget.wallpaper;
    final dragProgress = (_dragOffset.abs() / 400).clamp(0.0, 1.0);

    return GestureDetector(
      onVerticalDragUpdate: (details) =>
          setState(() => _dragOffset += details.delta.dy),
      onVerticalDragEnd: (details) {
        if (_dragOffset.abs() > 130) {
          Navigator.of(context).pop();
        } else {
          setState(() => _dragOffset = 0);
        }
      },
      onTap: () => setState(() => _showChrome = !_showChrome),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, _dragOffset),
                child: Opacity(
                  opacity: 1 - dragProgress * 0.7,
                  child: Hero(
                    tag: 'wallpaper_${wallpaper.id}',
                    child: FadeTransition(
                      opacity: _fade,
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: CachedNetworkImage(
                          imageUrl: wallpaper.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: AppPalette.dark.card,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: AppBrand.teal,
                              strokeWidth: 2.4,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppPalette.dark.card,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: AppPalette.dark.textMuted,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _showChrome ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _buildTopBar(context, wallpaper),
                    const Spacer(),
                    _buildBottomBar(context, wallpaper),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Wallpaper wallpaper) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              wallpaper.category,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, Wallpaper wallpaper) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            wallpaper.author,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Text(
                '${_formatLikes(wallpaper.likes)} likes',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.file_download_outlined,
                  label: 'Download',
                  filled: true,
                  onTap: () => downloadWallpaper(context, wallpaper),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedBuilder(
                animation: FavoritesController.instance,
                builder: (context, _) {
                  final favorite = FavoritesController.instance.isFavorite(
                    wallpaper.id,
                  );
                  return _ActionIconButton(
                    icon: favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: favorite ? AppBrand.coral : Colors.white,
                    onTap: () {
                      FavoritesController.instance.toggle(wallpaper);
                      _showSnack(
                        favorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 12),
              _ActionIconButton(
                icon: Icons.ios_share_rounded,
                color: Colors.white,
                onTap: () => _showSnack('Share sheet opened'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: filled ? AppBrand.hero : null,
          borderRadius: BorderRadius.circular(16),
          border: filled
              ? null
              : Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
