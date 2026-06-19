import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const YouTubeApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppColors {
  static const youtubeRed = Color(0xFFFF0000);
  static const youtubeDarkRed = Color(0xFFCC0000);
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF2F2F2);
  static const lightDivider = Color(0xFFE5E5E5);
  static const lightTextPrimary = Color(0xFF0F0F0F);
  static const lightTextSecondary = Color(0xFF606060);
  static const darkBackground = Color(0xFF0F0F0F);
  static const darkSurface = Color(0xFF212121);
  static const darkSurfaceVariant = Color(0xFF272727);
  static const darkDivider = Color(0xFF3F3F3F);
  static const darkTextPrimary = Color(0xFFF1F1F1);
  static const darkTextSecondary = Color(0xFFAAAAAA);
  static const verifiedBlue = Color(0xFF606060);
  static const onlineGreen = Color(0xFF2BA640);
}

abstract final class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  static double responsive(BuildContext context, {required double compact, required double expanded}) {
    return context.isTablet ? expanded : compact;
  }
}

abstract final class AppRadius {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const full = 999.0;
}

abstract final class AppElevation {
  static List<BoxShadow> card(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> subtle(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
}

extension AppContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;
  double get contentMaxWidth => isTablet ? 720 : double.infinity;
  Color get textPrimary => isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get textSecondary => isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get surfaceColor => isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get dividerColor => isDark ? AppColors.darkDivider : AppColors.lightDivider;
}

// ─────────────────────────────────────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppThemes {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.youtubeRed,
      onPrimary: Colors.white,
      secondary: AppColors.youtubeDarkRed,
      onSecondary: Colors.white,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightTextPrimary,
    );
    return _build(scheme, isDark: false);
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.youtubeRed,
      onPrimary: Colors.white,
      secondary: AppColors.youtubeDarkRed,
      onSecondary: Colors.white,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
    );
    return _build(scheme, isDark: true);
  }

  static ThemeData _build(ColorScheme scheme, {required bool isDark}) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      dividerColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
      splashFactory: InkRipple.splashFactory,
    );
    return base.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        indicatorColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          );
        }),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        side: BorderSide.none,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        iconColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        textColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

class VideoItem {
  const VideoItem({
    required this.id,
    required this.title,
    required this.channelName,
    required this.viewCount,
    required this.uploadTime,
    required this.duration,
    required this.thumbnailSeed,
    required this.avatarSeed,
    this.isVerified = false,
  });

  final String id;
  final String title;
  final String channelName;
  final String viewCount;
  final String uploadTime;
  final String duration;
  final int thumbnailSeed;
  final int avatarSeed;
  final bool isVerified;
}

class ShortItem {
  const ShortItem({
    required this.id,
    required this.title,
    required this.channelName,
    required this.likes,
    required this.comments,
    required this.audioName,
    required this.thumbnailSeed,
    required this.avatarSeed,
    this.isSubscribed = false,
  });

  final String id;
  final String title;
  final String channelName;
  final String likes;
  final String comments;
  final String audioName;
  final int thumbnailSeed;
  final int avatarSeed;
  final bool isSubscribed;
}

class ChannelItem {
  const ChannelItem({
    required this.id,
    required this.name,
    required this.avatarSeed,
    this.isOnline = false,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final int avatarSeed;
  final bool isOnline;
  final bool isVerified;
}

class CreateAction {
  const CreateAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
}

class LibrarySection {
  const LibrarySection({
    required this.title,
    required this.icon,
    required this.count,
    required this.subtitle,
  });

  final String title;
  final IconData icon;
  final String count;
  final String subtitle;
}

// ─────────────────────────────────────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────

abstract final class MockData {
  static const categories = [
    'All',
    'Gaming',
    'Music',
    'Live',
    'Flutter',
    'Podcasts',
    'Computers',
    'Recently uploaded',
    'Watched',
    'New to you',
  ];

  static final videos = List<VideoItem>.generate(16, (index) {
    final seeds = [
      ('Building a Production Flutter App Architecture', 'Flutter Mastery', true),
      ('iPhone 16 Pro Max — 30 Days Later', 'MKBHD', true),
      ('Lo-Fi Beats to Code / Relax To', 'Lofi Girl', true),
      ('The Future of AI in Mobile Development', 'Google Developers', true),
      ('Minimal Desk Setup Tour 2026', 'Setup Wars', false),
      ('How I Learned System Design in 90 Days', 'TechWorld', true),
      ('Street Food Tokyo — Hidden Gems', 'Mark Wiens', true),
      ('React vs Flutter in 2026 — Honest Take', 'Fireship', true),
      ('Morning Routine of a Staff Engineer', 'Engineering With Utsav', false),
      ('Best Camera Settings for Cinematic Video', 'Peter McKinnon', true),
      ('Docker Explained in 100 Seconds', 'Fireship', true),
      ('Building Custom Animations in Flutter', 'Flutter Mastery', true),
      ('Why Your App Feels Slow (And How to Fix It)', 'Google Developers', true),
      ('Ultimate Productivity Stack for Developers', 'Ali Abdaal', true),
      ('Design Systems That Scale', 'Figma', true),
      ('Live Coding: YouTube Clone in Flutter', 'Flutter Mastery', true),
    ];
    final item = seeds[index % seeds.length];
    return VideoItem(
      id: 'video_$index',
      title: item.$1,
      channelName: item.$2,
      viewCount: '${(index + 1) * 137}K views',
      uploadTime: '${index + 1} days ago',
      duration: '${(index % 12) + 3}:${(index * 7 % 60).toString().padLeft(2, '0')}',
      thumbnailSeed: 100 + index,
      avatarSeed: 200 + index,
      isVerified: item.$3,
    );
  });

  static final shorts = List<ShortItem>.generate(8, (index) {
    final titles = [
      'This Flutter widget changed everything 🔥',
      'POV: You shipped before the deadline',
      '3 UI tricks every mobile dev should know',
      'When the design finally matches Figma',
      'Clean architecture in 60 seconds',
      'Dark mode done right ✨',
      'Micro-interactions that feel premium',
      'Why senior devs refactor last',
    ];
    final channels = [
      'Flutter Mastery',
      'CodeWithChris',
      'DesignCourse',
      'Mobile Dev Pro',
      'Tech Bytes',
      'UI Craft',
      'Dev Tips Daily',
      'Senior Flutter',
    ];
    return ShortItem(
      id: 'short_$index',
      title: titles[index],
      channelName: channels[index],
      likes: '${(index + 3) * 12}K',
      comments: '${(index + 1) * 890}',
      audioName: 'Original Audio — ${channels[index]}',
      thumbnailSeed: 300 + index,
      avatarSeed: 400 + index,
      isSubscribed: index.isEven,
    );
  });

  static final subscribedChannels = List<ChannelItem>.generate(12, (index) {
    final names = [
      'Flutter Mastery',
      'MKBHD',
      'Fireship',
      'Google Developers',
      'Lofi Girl',
      'Ali Abdaal',
      'Figma',
      'Peter McKinnon',
      'TechWorld',
      'Setup Wars',
      'DesignCourse',
      'Mobile Dev Pro',
    ];
    return ChannelItem(
      id: 'channel_$index',
      name: names[index],
      avatarSeed: 500 + index,
      isOnline: index % 3 == 0,
      isVerified: index != 5,
    );
  });

  static const createActions = [
    CreateAction(
      title: 'Upload Video',
      subtitle: 'Share long-form content with your audience',
      icon: Icons.video_call_rounded,
      gradient: [Color(0xFFFF4D4D), Color(0xFFFF0000)],
    ),
    CreateAction(
      title: 'Create Short',
      subtitle: 'Quick vertical videos up to 60 seconds',
      icon: Icons.play_circle_fill_rounded,
      gradient: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
    ),
    CreateAction(
      title: 'Go Live',
      subtitle: 'Stream to subscribers in real time',
      icon: Icons.sensors_rounded,
      gradient: [Color(0xFFFF7043), Color(0xFFFF5722)],
    ),
    CreateAction(
      title: 'Create Post',
      subtitle: 'Share updates, polls, and images',
      icon: Icons.edit_note_rounded,
      gradient: [Color(0xFF26A69A), Color(0xFF00897B)],
    ),
  ];

  static const librarySections = [
    LibrarySection(
      title: 'History',
      icon: Icons.history_rounded,
      count: '248',
      subtitle: 'Recently watched videos',
    ),
    LibrarySection(
      title: 'Downloads',
      icon: Icons.download_rounded,
      count: '12',
      subtitle: 'Available offline',
    ),
    LibrarySection(
      title: 'Playlists',
      icon: Icons.playlist_play_rounded,
      count: '8',
      subtitle: 'Curated collections',
    ),
    LibrarySection(
      title: 'Watch Later',
      icon: Icons.watch_later_rounded,
      count: '34',
      subtitle: 'Saved for later',
    ),
    LibrarySection(
      title: 'Liked Videos',
      icon: Icons.thumb_up_alt_rounded,
      count: '156',
      subtitle: 'Videos you liked',
    ),
    LibrarySection(
      title: 'Your Videos',
      icon: Icons.video_library_rounded,
      count: '3',
      subtitle: 'Manage your uploads',
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// UTILITIES
// ─────────────────────────────────────────────────────────────────────────────

String thumbnailUrl(int seed, {int width = 640, int height = 360}) {
  return 'https://picsum.photos/seed/$seed/$width/$height';
}

String avatarUrl(int seed) {
  return 'https://picsum.photos/seed/$seed/200/200';
}

List<Color> gradientFromSeed(int seed) {
  final random = math.Random(seed);
  final hue = random.nextDouble() * 360;
  return [
    HSLColor.fromAHSL(1, hue, 0.55, 0.45).toColor(),
    HSLColor.fromAHSL(1, (hue + 40) % 360, 0.65, 0.35).toColor(),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// ROOT APP
// ─────────────────────────────────────────────────────────────────────────────

class YouTubeApp extends StatefulWidget {
  const YouTubeApp({super.key});

  @override
  State<YouTubeApp> createState() => _YouTubeAppState();
}

class _YouTubeAppState extends State<YouTubeApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppThemes.light(),
      darkTheme: AppThemes.dark(),
      home: AppShell(onToggleTheme: _toggleTheme),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP SHELL
// ─────────────────────────────────────────────────────────────────────────────

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          HomeScreen(onToggleTheme: widget.onToggleTheme),
          const ShortsScreen(),
          CreateScreen(onToggleTheme: widget.onToggleTheme),
          const SubscriptionsScreen(),
          LibraryScreen(onToggleTheme: widget.onToggleTheme),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline_rounded),
            selectedIcon: Icon(Icons.play_circle_rounded),
            label: 'Shorts',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.subscriptions_outlined),
            selectedIcon: Icon(Icons.subscriptions_rounded),
            label: 'Subscriptions',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class ScaleTap extends StatefulWidget {
  const ScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel: widget.onTap == null ? null : () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class YouTubeLogo extends StatelessWidget {
  const YouTubeLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 24 : 28,
          height: compact ? 16 : 20,
          decoration: BoxDecoration(
            color: AppColors.youtubeRed,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
        ),
        if (!compact) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            'YouTube',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: context.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.size = 14});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified_rounded,
      size: size,
      color: context.isDark ? AppColors.darkTextSecondary : AppColors.verifiedBlue,
    );
  }
}

class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    required this.seed,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final int seed;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final gradient = gradientFromSeed(seed);
    final image = Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.play_circle_fill_rounded, color: Colors.white.withValues(alpha: 0.85), size: 48),
      ),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    required this.seed,
    this.radius = 18,
    this.showOnline = false,
  });

  final int seed;
  final double radius;
  final bool showOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: context.surfaceColor,
          child: ClipOval(
            child: NetworkImageBox(
              url: avatarUrl(seed),
              seed: seed,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.55,
              height: radius * 0.55,
              decoration: BoxDecoration(
                color: AppColors.onlineGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class YouTubeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YouTubeAppBar({
    super.key,
    this.showLogo = true,
    this.title,
    this.centerTitle = false,
    this.onToggleTheme,
    this.leading,
  });

  final bool showLogo;
  final Widget? title;
  final bool centerTitle;
  final VoidCallback? onToggleTheme;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return AppBar(
      leading: leading,
      leadingWidth: leading == null ? null : 56,
      titleSpacing: AppSpacing.sm,
      title: title ??
          (showLogo
              ? YouTubeLogo(compact: !isTablet)
              : const SizedBox.shrink()),
      centerTitle: centerTitle,
      actions: [
        IconButton(
          tooltip: 'Cast',
          onPressed: () {},
          icon: const Icon(Icons.cast_rounded),
        ),
        if (isTablet)
          IconButton(
            tooltip: 'Theme',
            onPressed: onToggleTheme,
            icon: Icon(context.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.youtubeRed,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  '9+',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          tooltip: 'Search',
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: AvatarImage(seed: 999, radius: 14),
        ),
      ],
    );
  }
}

class CategoryChipBar extends StatefulWidget {
  const CategoryChipBar({super.key, required this.categories});

  final List<String> categories;

  @override
  State<CategoryChipBar> createState() => _CategoryChipBarState();
}

class _CategoryChipBarState extends State<CategoryChipBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final selected = _selectedIndex == index;
          return AnimatedContainer(
            duration: AppDurations.normal,
            curve: Curves.easeOutCubic,
            child: Material(
              color: selected
                  ? (context.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                  : context.surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: selected ? Colors.transparent : context.dividerColor,
                    ),
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: AppDurations.normal,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? (context.isDark ? AppColors.darkBackground : AppColors.lightBackground)
                          : context.textPrimary,
                    ),
                    child: Text(widget.categories[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final VideoItem video;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final thumbnailAspect = isTablet ? 16 / 9 : 16 / 9;

    return ScaleTap(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.responsive(context, compact: AppSpacing.lg, expanded: AppSpacing.xl)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: thumbnailAspect,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageBox(
                    url: thumbnailUrl(video.thumbnailSeed),
                    seed: video.thumbnailSeed,
                    borderRadius: BorderRadius.circular(isTablet ? AppRadius.md : 0),
                  ),
                  Positioned(
                    right: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.responsive(context, compact: AppSpacing.md, expanded: AppSpacing.lg),
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarImage(seed: video.avatarSeed, radius: isTablet ? 20 : 18),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                height: 1.25,
                                color: context.textPrimary,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                video.channelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            if (video.isVerified) ...[
                              const SizedBox(width: AppSpacing.xxs),
                              const VerifiedBadge(size: 12),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '${video.viewCount} • ${video.uploadTime}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
                    icon: Icon(Icons.more_vert_rounded, color: context.textSecondary, size: 20),
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

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: () {},
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppElevation.subtle(context.isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YouTubeAppBar(onToggleTheme: onToggleTheme),
          const CategoryChipBar(categories: MockData.categories),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = context.contentMaxWidth;
                final useGrid = context.isTablet && constraints.maxWidth > 700;

                if (useGrid) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.92,
                          crossAxisSpacing: AppSpacing.lg,
                          mainAxisSpacing: AppSpacing.sm,
                        ),
                        itemCount: MockData.videos.length,
                        itemBuilder: (_, index) => VideoCard(video: MockData.videos[index]),
                      ),
                    ),
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: MockData.videos.length,
                      itemBuilder: (_, index) => VideoCard(video: MockData.videos[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHORTS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  late final PageController _controller;
  int _currentPage = 0;
  final Map<String, bool> _liked = {};
  final Map<String, bool> _saved = {};
  final Map<String, bool> _subscribed = {};

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    for (final short in MockData.shorts) {
      _subscribed[short.id] = short.isSubscribed;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const YouTubeLogo(),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              itemCount: MockData.shorts.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final short = MockData.shorts[index];
                return _ShortCard(
                  short: short,
                  isActive: _currentPage == index,
                  isLiked: _liked[short.id] ?? false,
                  isSaved: _saved[short.id] ?? false,
                  isSubscribed: _subscribed[short.id] ?? false,
                  onLike: () => setState(() => _liked[short.id] = !(_liked[short.id] ?? false)),
                  onSave: () => setState(() => _saved[short.id] = !(_saved[short.id] ?? false)),
                  onSubscribe: () => setState(() => _subscribed[short.id] = !(_subscribed[short.id] ?? false)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortActionButton extends StatelessWidget {
  const _ShortActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.28),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active ? AppColors.youtubeRed : Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortCard extends StatelessWidget {
  const _ShortCard({
    required this.short,
    required this.isActive,
    required this.isLiked,
    required this.isSaved,
    required this.isSubscribed,
    required this.onLike,
    required this.onSave,
    required this.onSubscribe,
  });

  final ShortItem short;
  final bool isActive;
  final bool isLiked;
  final bool isSaved;
  final bool isSubscribed;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              duration: AppDurations.normal,
              opacity: isActive ? 1 : 0.92,
              child: NetworkImageBox(
                url: thumbnailUrl(short.thumbnailSeed, width: 720, height: 1280),
                seed: short.thumbnailSeed,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              bottom: 120,
              child: Column(
                children: [
                  _ShortActionButton(
                    icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    label: short.likes,
                    active: isLiked,
                    onTap: onLike,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ShortActionButton(
                    icon: Icons.mode_comment_outlined,
                    label: short.comments,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ShortActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ShortActionButton(
                    icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    label: 'Save',
                    active: isSaved,
                    onTap: onSave,
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: 88,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      AvatarImage(seed: short.avatarSeed, radius: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          short.channelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ScaleTap(
                        onTap: onSubscribe,
                        child: AnimatedContainer(
                          duration: AppDurations.normal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isSubscribed ? Colors.white.withValues(alpha: 0.18) : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          child: Text(
                            isSubscribed ? 'Subscribed' : 'Subscribe',
                            style: TextStyle(
                              color: isSubscribed ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    short.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.music_note_rounded, color: Colors.white70, size: 16),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          short.audioName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// CREATE SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Create'),
            actions: [
              IconButton(
                onPressed: onToggleTheme,
                icon: Icon(context.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.responsive(context, compact: AppSpacing.lg, expanded: AppSpacing.xxxl),
              vertical: AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload center',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Create and share content with a studio-grade workflow.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 700 ? 2 : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: MockData.createActions.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: AppSpacing.lg,
                              mainAxisSpacing: AppSpacing.lg,
                              childAspectRatio: crossAxisCount == 2 ? 1.55 : 1.75,
                            ),
                            itemBuilder: (_, index) => _CreateActionCard(action: MockData.createActions[index]),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: AppElevation.subtle(context.isDark),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.youtubeRed.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded, color: AppColors.youtubeRed),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Creator tips', style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Short-form videos get 3x more engagement this week.',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateActionCard extends StatelessWidget {
  const _CreateActionCard({required this.action});

  final CreateAction action;

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: action.gradient,
          ),
          boxShadow: AppElevation.card(context.isDark),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(action.icon, color: Colors.white, size: 28),
            ),
            const Spacer(),
            Text(
              action.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              action.subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  'Get started',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.95), size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBSCRIPTIONS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text('Subscriptions'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                itemCount: MockData.subscribedChannels.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.lg),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _AllSubscriptionsTile();
                  }
                  final channel = MockData.subscribedChannels[index - 1];
                  return _SubscriptionAvatarTile(channel: channel);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(title: 'Latest from subscriptions', actionLabel: 'Manage'),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.responsive(context, compact: 0, expanded: AppSpacing.xxxl),
            ),
            sliver: SliverList.builder(
              itemCount: MockData.videos.take(8).length,
              itemBuilder: (_, index) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: VideoCard(video: MockData.videos[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllSubscriptionsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.surfaceColor,
              border: Border.all(color: context.dividerColor),
            ),
            child: Icon(Icons.expand_more_rounded, color: context.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'All',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionAvatarTile extends StatelessWidget {
  const _SubscriptionAvatarTile({required this.channel});

  final ChannelItem channel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          AvatarImage(seed: channel.avatarSeed, radius: 32, showOnline: channel.isOnline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            channel.name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LIBRARY SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Library'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
              IconButton(
                onPressed: onToggleTheme,
                icon: Icon(context.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.responsive(context, compact: AppSpacing.lg, expanded: AppSpacing.xxxl),
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          AvatarImage(seed: 888, radius: 24),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Amir Hossein', style: Theme.of(context).textTheme.titleMedium),
                                Text('View channel', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          OutlinedButton(onPressed: () {}, child: const Text('Switch account')),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Row(
                        children: const [
                          StatCard(
                            label: 'Watch time',
                            value: '128h',
                            icon: Icons.schedule_rounded,
                            color: Color(0xFF5C6BC0),
                          ),
                          SizedBox(width: AppSpacing.md),
                          StatCard(
                            label: 'Playlists',
                            value: '8',
                            icon: Icons.queue_music_rounded,
                            color: Color(0xFF26A69A),
                          ),
                          SizedBox(width: AppSpacing.md),
                          StatCard(
                            label: 'Downloads',
                            value: '12',
                            icon: Icons.download_done_rounded,
                            color: Color(0xFFFF7043),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ...MockData.librarySections.map(
                        (section) => _LibraryTile(section: section),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({required this.section});

  final LibrarySection section;

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.isDark ? AppColors.darkSurfaceVariant : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(section.icon, color: context.textPrimary),
          ),
          title: Text(section.title, style: Theme.of(context).textTheme.titleSmall),
          subtitle: Text(section.subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: context.isDark ? AppColors.darkSurfaceVariant : AppColors.lightDivider,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  section.count,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right_rounded, color: context.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
