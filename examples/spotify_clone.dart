// =============================================================================

// Packages required (add to pubspec.yaml):
//   google_fonts: ^6.2.1
//   cached_network_image: ^3.4.1
//
// Everything else uses Flutter's built-in widgets. Pure UI/mock-state demo —
// =============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

// =============================================================================
// 1. APP THEME / CONSTANTS
// =============================================================================

class VColors {
  VColors._();
  static const Color bg = Color(0xFF0A0A0C);
  static const Color bgElevated = Color(0xFF141417);
  static const Color card = Color(0xFF1A1B1F);
  static const Color cardHigh = Color(0xFF222327);
  static const Color accent = Color(0xFF1ED760);
  static const Color accentDim = Color(0xFF15A34A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA7A7AC);
  static const Color textTertiary = Color(0xFF6E6E73);
  static const Color divider = Color(0xFF232327);
  static const Color danger = Color(0xFFFF5C5C);

  static const List<Color> gradPurple = [Color(0xFF8E2DE2), Color(0xFF4A00E0)];
  static const List<Color> gradPink = [Color(0xFFFF5F6D), Color(0xFFFFC371)];
  static const List<Color> gradBlue = [Color(0xFF2193B0), Color(0xFF6DD5ED)];
  static const List<Color> gradGreen = [Color(0xFF11998E), Color(0xFF38EF7D)];
  static const List<Color> gradOrange = [Color(0xFFF2994A), Color(0xFFF2C94C)];
  static const List<Color> gradRed = [Color(0xFFCB356B), Color(0xFFBD3F32)];
  static const List<Color> gradIndigo = [Color(0xFF3A1C71), Color(0xFFD76D77)];
  static const List<Color> gradTeal = [Color(0xFF134E5E), Color(0xFF71B280)];
  static const List<Color> gradDark = [Color(0xFF232526), Color(0xFF414345)];
  static const List<Color> gradRose = [Color(0xFFEB3349), Color(0xFFF45C43)];
}

class VSpace {
  VSpace._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class VRadius {
  VRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 100;
}

TextStyle vFont(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = VColors.textPrimary,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

ThemeData buildVibraTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: VColors.bg,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: VColors.accent,
      secondary: VColors.accent,
      surface: VColors.bgElevated,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

String formatDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(1, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

void showVibraSnack(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: VColors.cardHigh,
      elevation: 6,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 110),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VRadius.md),
      ),
      duration: const Duration(milliseconds: 1500),
      content: Row(
        children: [
          Icon(icon, color: VColors.accent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: vFont(13, weight: FontWeight.w600)),
          ),
        ],
      ),
    ),
  );
}

// A placeholder-safe network image with graceful fallback.
class VImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;
  final IconData fallbackIcon;
  const VImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
    this.fallbackIcon = Icons.music_note_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (c, u) => Container(
        width: width,
        height: height,
        color: VColors.card,
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: VColors.accent,
            ),
          ),
        ),
      ),
      errorWidget: (c, u, e) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A2E), Color(0xFF1A1A1D)],
          ),
        ),
        child: Icon(
          fallbackIcon,
          color: VColors.textTertiary,
          size: (width ?? 60) * 0.32,
        ),
      ),
    );
    if (radius != null) {
      return ClipRRect(borderRadius: radius!, child: img);
    }
    return img;
  }
}

// =============================================================================
// 2. MOCK MODELS
// =============================================================================

class Song {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String album;
  final String artUrl;
  final Duration duration;
  bool isLiked;
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.album,
    required this.artUrl,
    required this.duration,
    this.isLiked = false,
  });
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String listeners;
  final bool verified;
  final List<String> topSongIds;
  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.listeners,
    this.verified = true,
    required this.topSongIds,
  });
}

class Album {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String artUrl;
  final int year;
  final List<String> songIds;
  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.artUrl,
    required this.year,
    required this.songIds,
  });
}

class Playlist {
  final String id;
  final String title;
  final String description;
  final String creator;
  final String artUrl;
  final List<String> songIds;
  final List<Color> gradient;
  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.artUrl,
    required this.songIds,
    required this.gradient,
  });
}

class MoodCategory {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  MoodCategory(this.title, this.icon, this.gradient);
}

// =============================================================================
// 3. MOCK DATA
// =============================================================================

class MockData {
  MockData._();

  static String art(String seed, [int size = 500]) =>
      'https://picsum.photos/seed/$seed/$size/$size';

  static String artistImg(String seed, [int size = 600]) =>
      'https://picsum.photos/seed/artist-$seed/$size/$size';

  // ---- Artists ----
  static final List<Artist> artists = [
    Artist(
      id: 'a1',
      name: 'The Weeknd',
      imageUrl: artistImg('weeknd'),
      listeners: '94.2M monthly listeners',
      topSongIds: ['s1', 's2', 's3', 's4', 's5'],
    ),
    Artist(
      id: 'a2',
      name: 'Drake',
      imageUrl: artistImg('drake'),
      listeners: '78.5M monthly listeners',
      topSongIds: ['s6', 's7', 's8'],
    ),
    Artist(
      id: 'a3',
      name: 'Billie Eilish',
      imageUrl: artistImg('billie'),
      listeners: '61.3M monthly listeners',
      topSongIds: ['s9', 's10'],
    ),
    Artist(
      id: 'a4',
      name: 'Dua Lipa',
      imageUrl: artistImg('dua'),
      listeners: '55.7M monthly listeners',
      topSongIds: ['s11', 's12'],
    ),
    Artist(
      id: 'a5',
      name: 'Ed Sheeran',
      imageUrl: artistImg('ed'),
      listeners: '82.1M monthly listeners',
      topSongIds: ['s13', 's14'],
    ),
    Artist(
      id: 'a6',
      name: 'Travis Scott',
      imageUrl: artistImg('travis'),
      listeners: '48.9M monthly listeners',
      topSongIds: ['s15', 's16'],
    ),
    Artist(
      id: 'a7',
      name: 'SZA',
      imageUrl: artistImg('sza'),
      listeners: '44.6M monthly listeners',
      topSongIds: ['s17', 's18'],
    ),
    Artist(
      id: 'a8',
      name: 'Bad Bunny',
      imageUrl: artistImg('badbunny'),
      listeners: '89.4M monthly listeners',
      topSongIds: ['s19', 's20'],
    ),
  ];

  // ---- Songs ----
  static final List<Song> songs = [
    Song(
      id: 's1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's2',
      title: 'Starboy',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'Starboy',
      artUrl: art('starboy'),
      duration: const Duration(minutes: 3, seconds: 50),
    ),
    Song(
      id: 's3',
      title: 'Save Your Tears',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 35),
    ),
    Song(
      id: 's4',
      title: 'The Hills',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'Beauty Behind the Madness',
      artUrl: art('thehills'),
      duration: const Duration(minutes: 4, seconds: 2),
    ),
    Song(
      id: 's5',
      title: 'Die For You',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'Starboy',
      artUrl: art('starboy'),
      duration: const Duration(minutes: 4, seconds: 20),
    ),
    Song(
      id: 's6',
      title: 'God\'s Plan',
      artist: 'Drake',
      artistId: 'a2',
      album: 'Scorpion',
      artUrl: art('scorpion'),
      duration: const Duration(minutes: 3, seconds: 18),
    ),
    Song(
      id: 's7',
      title: 'One Dance',
      artist: 'Drake',
      artistId: 'a2',
      album: 'Views',
      artUrl: art('views'),
      duration: const Duration(minutes: 2, seconds: 54),
    ),
    Song(
      id: 's8',
      title: 'Hotline Bling',
      artist: 'Drake',
      artistId: 'a2',
      album: 'Views',
      artUrl: art('views'),
      duration: const Duration(minutes: 4, seconds: 27),
    ),
    Song(
      id: 's9',
      title: 'Happier Than Ever',
      artist: 'Billie Eilish',
      artistId: 'a3',
      album: 'Happier Than Ever',
      artUrl: art('happier'),
      duration: const Duration(minutes: 4, seconds: 58),
    ),
    Song(
      id: 's10',
      title: 'Bad Guy',
      artist: 'Billie Eilish',
      artistId: 'a3',
      album: 'When We All Fall Asleep',
      artUrl: art('badguy'),
      duration: const Duration(minutes: 3, seconds: 14),
    ),
    Song(
      id: 's11',
      title: 'Levitating',
      artist: 'Dua Lipa',
      artistId: 'a4',
      album: 'Future Nostalgia',
      artUrl: art('futurenostalgia'),
      duration: const Duration(minutes: 3, seconds: 23),
    ),
    Song(
      id: 's12',
      title: 'Don\'t Start Now',
      artist: 'Dua Lipa',
      artistId: 'a4',
      album: 'Future Nostalgia',
      artUrl: art('futurenostalgia'),
      duration: const Duration(minutes: 3, seconds: 3),
    ),
    Song(
      id: 's13',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      artistId: 'a5',
      album: '÷ (Divide)',
      artUrl: art('divide'),
      duration: const Duration(minutes: 3, seconds: 53),
    ),
    Song(
      id: 's14',
      title: 'Perfect',
      artist: 'Ed Sheeran',
      artistId: 'a5',
      album: '÷ (Divide)',
      artUrl: art('divide'),
      duration: const Duration(minutes: 4, seconds: 23),
    ),
    Song(
      id: 's15',
      title: 'SICKO MODE',
      artist: 'Travis Scott',
      artistId: 'a6',
      album: 'Astroworld',
      artUrl: art('astroworld'),
      duration: const Duration(minutes: 5, seconds: 12),
    ),
    Song(
      id: 's16',
      title: 'Goosebumps',
      artist: 'Travis Scott',
      artistId: 'a6',
      album: 'Birds in the Trap',
      artUrl: art('birds'),
      duration: const Duration(minutes: 3, seconds: 58),
    ),
    Song(
      id: 's17',
      title: 'Kill Bill',
      artist: 'SZA',
      artistId: 'a7',
      album: 'SOS',
      artUrl: art('sos'),
      duration: const Duration(minutes: 2, seconds: 33),
    ),
    Song(
      id: 's18',
      title: 'Good Days',
      artist: 'SZA',
      artistId: 'a7',
      album: 'SOS',
      artUrl: art('sos'),
      duration: const Duration(minutes: 4, seconds: 39),
    ),
    Song(
      id: 's19',
      title: 'Titi Me Pregunto',
      artist: 'Bad Bunny',
      artistId: 'a8',
      album: 'Un Verano Sin Ti',
      artUrl: art('unverano'),
      duration: const Duration(minutes: 4, seconds: 3),
    ),
    Song(
      id: 's20',
      title: 'Me Porto Bonito',
      artist: 'Bad Bunny',
      artistId: 'a8',
      album: 'Un Verano Sin Ti',
      artUrl: art('unverano'),
      duration: const Duration(minutes: 2, seconds: 58),
    ),
    // Extra album tracks — After Hours full tracklist
    Song(
      id: 's21',
      title: 'Alone Again',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 4, seconds: 10),
    ),
    Song(
      id: 's22',
      title: 'Too Late',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 59),
    ),
    Song(
      id: 's23',
      title: 'Hardest To Love',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 5),
    ),
    Song(
      id: 's24',
      title: 'Scared To Live',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 10),
    ),
    Song(
      id: 's25',
      title: 'Snowchild',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 4, seconds: 4),
    ),
    Song(
      id: 's26',
      title: 'Escape From LA',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 5, seconds: 55),
    ),
    Song(
      id: 's27',
      title: 'In Your Eyes',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 3, seconds: 57),
    ),
    Song(
      id: 's28',
      title: 'After Hours',
      artist: 'The Weeknd',
      artistId: 'a1',
      album: 'After Hours',
      artUrl: art('afterhours'),
      duration: const Duration(minutes: 6, seconds: 1),
    ),
  ];

  static Song songById(String id) => songs.firstWhere((s) => s.id == id);
  static Artist artistById(String id) => artists.firstWhere((a) => a.id == id);

  // ---- Albums ----
  static final List<Album> albums = [
    Album(
      id: 'al1',
      title: 'After Hours',
      artist: 'The Weeknd',
      artistId: 'a1',
      artUrl: art('afterhours'),
      year: 2020,
      songIds: [
        's21',
        's22',
        's23',
        's24',
        's25',
        's26',
        's1',
        's27',
        's3',
        's28',
      ],
    ),
    Album(
      id: 'al2',
      title: 'SOS',
      artist: 'SZA',
      artistId: 'a7',
      artUrl: art('sos'),
      year: 2022,
      songIds: ['s17', 's18'],
    ),
    Album(
      id: 'al3',
      title: 'Happier Than Ever',
      artist: 'Billie Eilish',
      artistId: 'a3',
      artUrl: art('happier'),
      year: 2021,
      songIds: ['s9', 's10'],
    ),
    Album(
      id: 'al4',
      title: 'Future Nostalgia',
      artist: 'Dua Lipa',
      artistId: 'a4',
      artUrl: art('futurenostalgia'),
      year: 2020,
      songIds: ['s11', 's12'],
    ),
    Album(
      id: 'al5',
      title: 'Starboy',
      artist: 'The Weeknd',
      artistId: 'a1',
      artUrl: art('starboy'),
      year: 2016,
      songIds: ['s2', 's5'],
    ),
    Album(
      id: 'al6',
      title: 'Scorpion',
      artist: 'Drake',
      artistId: 'a2',
      artUrl: art('scorpion'),
      year: 2018,
      songIds: ['s6'],
    ),
    Album(
      id: 'al7',
      title: 'Un Verano Sin Ti',
      artist: 'Bad Bunny',
      artistId: 'a8',
      artUrl: art('unverano'),
      year: 2022,
      songIds: ['s19', 's20'],
    ),
    Album(
      id: 'al8',
      title: 'Astroworld',
      artist: 'Travis Scott',
      artistId: 'a6',
      artUrl: art('astroworld'),
      year: 2018,
      songIds: ['s15'],
    ),
  ];

  static Album albumById(String id) => albums.firstWhere((a) => a.id == id);

  // ---- Playlists ----
  static final List<Playlist> playlists = [
    Playlist(
      id: 'p1',
      title: 'Daily Mix 1',
      description: 'The Weeknd, Drake, Travis Scott and more',
      creator: 'VIBRA',
      artUrl: art('dailymix1'),
      songIds: ['s1', 's6', 's15', 's2', 's7'],
      gradient: VColors.gradPurple,
    ),
    Playlist(
      id: 'p2',
      title: 'Daily Mix 2',
      description: 'Billie Eilish, SZA, Dua Lipa and more',
      creator: 'VIBRA',
      artUrl: art('dailymix2'),
      songIds: ['s9', 's17', 's11', 's10', 's18'],
      gradient: VColors.gradPink,
    ),
    Playlist(
      id: 'p3',
      title: 'Discover Weekly',
      description: 'Your weekly mixtape of fresh music',
      creator: 'VIBRA',
      artUrl: art('discoverweekly'),
      songIds: ['s13', 's19', 's16', 's8', 's14'],
      gradient: VColors.gradBlue,
    ),
    Playlist(
      id: 'p4',
      title: 'Release Radar',
      description: 'Catch all the latest music from artists you follow',
      creator: 'VIBRA',
      artUrl: art('releaseradar'),
      songIds: ['s20', 's4', 's12', 's3'],
      gradient: VColors.gradGreen,
    ),
    Playlist(
      id: 'p5',
      title: 'Late Night Vibes',
      description:
          'Smooth, moody tracks for the after-hours crowd. Perfect for winding down or driving through the city lights.',
      creator: 'Amir',
      artUrl: art('latenight'),
      songIds: ['s1', 's3', 's9', 's17', 's22'],
      gradient: VColors.gradIndigo,
    ),
    Playlist(
      id: 'p6',
      title: 'My Favorites',
      description: 'Your all-time most loved tracks',
      creator: 'Amir',
      artUrl: art('myfavs'),
      songIds: ['s1', 's11', 's13', 's6'],
      gradient: VColors.gradRose,
    ),
    Playlist(
      id: 'p7',
      title: 'Workout Mix',
      description: 'High energy tracks to power your workout',
      creator: 'Amir',
      artUrl: art('workout'),
      songIds: ['s15', 's6', 's19', 's16'],
      gradient: VColors.gradOrange,
    ),
    Playlist(
      id: 'p8',
      title: 'Coding Session',
      description: 'Focused beats for deep work',
      creator: 'Amir',
      artUrl: art('coding'),
      songIds: ['s25', 's22', 's27'],
      gradient: VColors.gradTeal,
    ),
    Playlist(
      id: 'p9',
      title: 'Chill Vibes',
      description: 'Laid back tunes for relaxing',
      creator: 'Amir',
      artUrl: art('chillvibes'),
      songIds: ['s9', 's18', 's12'],
      gradient: VColors.gradBlue,
    ),
    Playlist(
      id: 'p10',
      title: 'Road Trip',
      description: 'Anthems for the open road',
      creator: 'Amir',
      artUrl: art('roadtrip'),
      songIds: ['s2', 's7', 's20'],
      gradient: VColors.gradRed,
    ),
    Playlist(
      id: 'p11',
      title: 'Top 50 Global',
      description:
          'Your daily update of the most played tracks right now — Global',
      creator: 'VIBRA Charts',
      artUrl: art('top50global'),
      songIds: ['s1', 's6', 's19', 's9', 's11', 's15'],
      gradient: VColors.gradDark,
    ),
    Playlist(
      id: 'p12',
      title: 'Top 50 USA',
      description:
          'Your daily update of the most played tracks right now — USA',
      creator: 'VIBRA Charts',
      artUrl: art('top50usa'),
      songIds: ['s6', 's1', 's17', 's13'],
      gradient: VColors.gradIndigo,
    ),
    Playlist(
      id: 'p13',
      title: 'Viral Hits',
      description: 'The tracks going viral across social media',
      creator: 'VIBRA Charts',
      artUrl: art('viralhits'),
      songIds: ['s10', 's20', 's2'],
      gradient: VColors.gradPink,
    ),
    Playlist(
      id: 'p14',
      title: 'Global Trending',
      description: 'What the world is streaming right now',
      creator: 'VIBRA Charts',
      artUrl: art('globaltrending'),
      songIds: ['s15', 's11', 's6', 's19'],
      gradient: VColors.gradGreen,
    ),
  ];

  static Playlist playlistById(String id) =>
      playlists.firstWhere((p) => p.id == id);

  // ---- Home rails ----
  static final List<Song> recentlyPlayed = [
    songs[0],
    songs[10],
    songs[5],
    songs[16],
    songs[2],
    songs[18],
    songs[8],
  ];
  static final List<Playlist> madeForYou = [
    playlists[0],
    playlists[1],
    playlists[2],
    playlists[3],
  ];
  static final List<Song> trendingNow = [
    songs[14],
    songs[9],
    songs[1],
    songs[19],
    songs[16],
    songs[4],
  ];
  static final List<Album> newReleases = [
    albums[2],
    albums[3],
    albums[6],
    albums[1],
    albums[4],
  ];
  static final List<Playlist> recommended = [
    playlists[4],
    playlists[6],
    playlists[8],
    playlists[9],
  ];
  static final List<Playlist> charts = [
    playlists[10],
    playlists[11],
    playlists[12],
    playlists[13],
  ];

  static final List<MoodCategory> moods = [
    MoodCategory('Chill', Icons.spa_rounded, VColors.gradBlue),
    MoodCategory('Workout', Icons.fitness_center_rounded, VColors.gradOrange),
    MoodCategory('Focus', Icons.center_focus_strong_rounded, VColors.gradTeal),
    MoodCategory('Sleep', Icons.nightlight_round, VColors.gradIndigo),
    MoodCategory('Party', Icons.celebration_rounded, VColors.gradPink),
    MoodCategory('Romance', Icons.favorite_rounded, VColors.gradRose),
    MoodCategory('Hip Hop', Icons.graphic_eq_rounded, VColors.gradDark),
    MoodCategory('Pop', Icons.star_rounded, VColors.gradPurple),
    MoodCategory('Rock', Icons.bolt_rounded, VColors.gradRed),
    MoodCategory('Electronic', Icons.waves_rounded, VColors.gradGreen),
  ];

  static final List<MoodCategory> browseCategories = [
    MoodCategory('Music', Icons.library_music_rounded, VColors.gradPurple),
    MoodCategory('Podcasts', Icons.podcasts_rounded, VColors.gradOrange),
    MoodCategory('Made For You', Icons.person_rounded, VColors.gradPink),
    MoodCategory('Charts', Icons.leaderboard_rounded, VColors.gradDark),
    MoodCategory('New Releases', Icons.new_releases_rounded, VColors.gradGreen),
    MoodCategory('Pop', Icons.star_rounded, VColors.gradRose),
    MoodCategory('Hip-Hop', Icons.graphic_eq_rounded, VColors.gradIndigo),
    MoodCategory('Rock', Icons.bolt_rounded, VColors.gradRed),
    MoodCategory('Electronic', Icons.waves_rounded, VColors.gradBlue),
    MoodCategory('R&B', Icons.mic_external_on_rounded, VColors.gradTeal),
    MoodCategory('Jazz', Icons.piano_rounded, VColors.gradOrange),
    MoodCategory('Classical', Icons.music_note_rounded, VColors.gradDark),
    MoodCategory('Workout', Icons.fitness_center_rounded, VColors.gradPurple),
    MoodCategory('Chill', Icons.spa_rounded, VColors.gradBlue),
    MoodCategory('Focus', Icons.center_focus_strong_rounded, VColors.gradTeal),
    MoodCategory('Sleep', Icons.nightlight_round, VColors.gradIndigo),
  ];

  static final List<Playlist> libraryPlaylists = [
    playlists[5],
    playlists[6],
    playlists[7],
    playlists[8],
    playlists[9],
    playlists[4],
  ];

  static final List<Artist> libraryArtists = artists.sublist(0, 6);
  static final List<Album> libraryAlbums = [
    albums[0],
    albums[1],
    albums[2],
    albums[3],
  ];
}

// =============================================================================
// 4. PLAYER CONTROLLER (global mock playback state)
// =============================================================================

class PlayerController extends ChangeNotifier {
  List<Song> _queue = [];
  int _currentIndex = 0;
  bool isPlaying = false;
  bool shuffle = false;
  int repeatMode = 0; // 0 off, 1 repeat all, 2 repeat one
  Duration position = const Duration(seconds: 47);
  final Set<String> likedSongIds = {'s1', 's11', 's13'};

  Song? get current => _queue.isEmpty ? null : _queue[_currentIndex];
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;

  List<Song> get upNext {
    if (_queue.isEmpty) return [];
    return _queue.sublist(
      _currentIndex + 1 > _queue.length ? _queue.length : _currentIndex + 1,
    );
  }

  void playSong(Song song, {List<Song>? context}) {
    _queue = context ?? [song];
    _currentIndex = _queue.indexWhere((s) => s.id == song.id);
    if (_currentIndex == -1) _currentIndex = 0;
    isPlaying = true;
    position = Duration.zero;
    notifyListeners();
  }

  void togglePlay() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty) return;
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    position = Duration.zero;
    isPlaying = true;
    notifyListeners();
  }

  void previous() {
    if (_queue.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _queue.length - 1;
    }
    position = Duration.zero;
    notifyListeners();
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  void cycleRepeat() {
    repeatMode = (repeatMode + 1) % 3;
    notifyListeners();
  }

  void toggleLike(String songId) {
    if (likedSongIds.contains(songId)) {
      likedSongIds.remove(songId);
    } else {
      likedSongIds.add(songId);
    }
    notifyListeners();
  }

  bool isLiked(String songId) => likedSongIds.contains(songId);

  void seek(Duration d) {
    position = d;
    notifyListeners();
  }

  void playFromQueueIndex(int index) {
    _currentIndex = index;
    position = Duration.zero;
    isPlaying = true;
    notifyListeners();
  }
}

final PlayerController playerController = PlayerController();

// =============================================================================
// 5. MAIN / APP ROOT
// =============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: VColors.bg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const VibraApp());
}

class VibraApp extends StatelessWidget {
  const VibraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIBRA',
      debugShowCheckedModeBanner: false,
      theme: buildVibraTheme(),
      home: const RootShell(),
    );
  }
}

// =============================================================================
// 6. ROOT SHELL — bottom nav + mini player overlay
// =============================================================================

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  void _openNowPlaying() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, anim, __) => const NowPlayingScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.bg,
      body: Stack(
        children: [
          IndexedStack(index: _tabIndex, children: _screens),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListenableBuilder(
                    listenable: playerController,
                    builder: (context, _) {
                      if (playerController.current == null)
                        return const SizedBox.shrink();
                      return MiniPlayer(onTap: _openNowPlaying);
                    },
                  ),
                  _BottomNav(
                    index: _tabIndex,
                    onChanged: (i) => setState(() => _tabIndex = i),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNav({required this.index, required this.onChanged});

  static const _items = [
    (icon: Icons.home_rounded, outline: Icons.home_outlined, label: 'Home'),
    (
      icon: Icons.search_rounded,
      outline: Icons.search_rounded,
      label: 'Search',
    ),
    (
      icon: Icons.library_music_rounded,
      outline: Icons.library_music_outlined,
      label: 'Your Library',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0F),
        border: Border(top: BorderSide(color: VColors.divider, width: 0.6)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final selected = i == index;
          final item = _items[i];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      selected ? item.icon : item.outline,
                      color: selected ? VColors.accent : VColors.textTertiary,
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: vFont(
                      11,
                      weight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? VColors.accent : VColors.textTertiary,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// =============================================================================
// 7. REUSABLE COMPONENTS
// =============================================================================

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VSpace.md,
        VSpace.lg,
        VSpace.md,
        VSpace.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: vFont(20, weight: FontWeight.w800, letterSpacing: -0.3),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: vFont(
                  13,
                  weight: FontWeight.w700,
                  color: VColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HorizontalRail extends StatelessWidget {
  final double height;
  final List<Widget> children;
  const HorizontalRail({
    super.key,
    required this.height,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: VSpace.md),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: VSpace.sm),
        itemBuilder: (_, i) => children[i],
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final Song song;
  final double size;
  final List<Song>? context_;
  const SongCard({
    super.key,
    required this.song,
    this.size = 140,
    this.context_,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playerController.playSong(song, context: context_ ?? [song]);
        HapticFeedback.selectionClick();
      },
      onLongPress: () => showSongOptionsSheet(context, song),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VImage(
              url: song.artUrl,
              width: size,
              height: size,
              radius: BorderRadius.circular(VRadius.md),
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(13, weight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(12, color: VColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final Album album;
  final double size;
  const AlbumCard({super.key, required this.album, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AlbumScreen(album: album)),
      ),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VImage(
              url: album.artUrl,
              width: size,
              height: size,
              radius: BorderRadius.circular(VRadius.md),
            ),
            const SizedBox(height: 8),
            Text(
              album.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(13, weight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              '${album.artist} · ${album.year}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(12, color: VColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final double size;
  const PlaylistCard({super.key, required this.playlist, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist)),
      ),
      child: SizedBox(
        width: size,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VImage(
                  url: playlist.artUrl,
                  width: size,
                  height: size,
                  radius: BorderRadius.circular(VRadius.md),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(VRadius.md),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          playlist.gradient.last.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              playlist.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(13, weight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              playlist.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: vFont(12, color: VColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class WideChartCard extends StatelessWidget {
  final Playlist playlist;
  const WideChartCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist)),
      ),
      child: Container(
        width: 260,
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VRadius.lg),
          gradient: LinearGradient(
            colors: playlist.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playlist.title,
                    style: vFont(16, weight: FontWeight.w800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.songIds.length} songs',
                    style: vFont(11, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),
            Transform.rotate(
              angle: -0.35,
              child: VImage(
                url: playlist.artUrl,
                width: 72,
                height: 72,
                radius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtistAvatarCard extends StatelessWidget {
  final Artist artist;
  const ArtistAvatarCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArtistScreen(artist: artist)),
      ),
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            ClipOval(
              child: VImage(
                url: artist.imageUrl,
                width: 100,
                height: 100,
                fallbackIcon: Icons.person_rounded,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artist.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: vFont(12, weight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodTile extends StatelessWidget {
  final MoodCategory mood;
  const MoodTile({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlaylistScreen(
            playlist: Playlist(
              id: 'mood-${mood.title}',
              title: mood.title,
              description:
                  'The best ${mood.title.toLowerCase()} tracks, hand-picked for you',
              creator: 'VIBRA',
              artUrl: MockData.art(mood.title),
              songIds: MockData.songs.map((s) => s.id).toList()..shuffle(),
              gradient: mood.gradient,
            ),
          ),
        ),
      ),
      child: Container(
        width: 160,
        height: 90,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VRadius.lg),
          gradient: LinearGradient(
            colors: mood.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: mood.gradient.first.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              bottom: -10,
              child: Icon(
                mood.icon,
                size: 56,
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                mood.title,
                style: vFont(16, weight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  final Song song;
  final int? trackNumber;
  final List<Song>? context_;
  final bool showAlbumArt;
  const SongTile({
    super.key,
    required this.song,
    this.trackNumber,
    this.context_,
    this.showAlbumArt = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final isCurrent = playerController.current?.id == song.id;
        return InkWell(
          onTap: () {
            playerController.playSong(song, context: context_ ?? [song]);
            HapticFeedback.selectionClick();
          },
          onLongPress: () => showSongOptionsSheet(context, song),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: VSpace.md,
              vertical: 8,
            ),
            child: Row(
              children: [
                if (trackNumber != null)
                  SizedBox(
                    width: 24,
                    child: isCurrent
                        ? const Icon(
                            Icons.equalizer_rounded,
                            color: VColors.accent,
                            size: 16,
                          )
                        : Text(
                            '$trackNumber',
                            style: vFont(13, color: VColors.textTertiary),
                          ),
                  ),
                if (trackNumber != null) const SizedBox(width: 8),
                if (showAlbumArt) ...[
                  VImage(
                    url: song.artUrl,
                    width: 48,
                    height: 48,
                    radius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: vFont(
                          14,
                          weight: FontWeight.w700,
                          color: isCurrent
                              ? VColors.accent
                              : VColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: vFont(12, color: VColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatDuration(song.duration),
                  style: vFont(12, color: VColors.textTertiary),
                ),
                IconButton(
                  onPressed: () => showSongOptionsSheet(context, song),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: VColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---- Song options bottom sheet ----
void showSongOptionsSheet(BuildContext context, Song song) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _SongOptionsSheet(song: song),
  );
}

class _SongOptionsSheet extends StatelessWidget {
  final Song song;
  const _SongOptionsSheet({required this.song});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(VRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 12,
            top: 12,
          ),
          decoration: BoxDecoration(
            color: VColors.bgElevated.withOpacity(0.96),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(VRadius.xl),
            ),
            border: const Border(top: BorderSide(color: VColors.divider)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: VColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: VSpace.md),
                child: Row(
                  children: [
                    VImage(
                      url: song.artUrl,
                      width: 56,
                      height: 56,
                      radius: BorderRadius.circular(10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: vFont(15, weight: FontWeight.w800),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            style: vFont(13, color: VColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: VColors.divider, height: 1),
              ),
              ListenableBuilder(
                listenable: playerController,
                builder: (context, _) => _SheetTile(
                  icon: playerController.isLiked(song.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: playerController.isLiked(song.id)
                      ? VColors.accent
                      : VColors.textPrimary,
                  label: playerController.isLiked(song.id)
                      ? 'Remove from Liked Songs'
                      : 'Save to Liked Songs',
                  onTap: () {
                    playerController.toggleLike(song.id);
                    Navigator.pop(context);
                  },
                ),
              ),
              _SheetTile(
                icon: Icons.playlist_add_rounded,
                label: 'Add to playlist',
                onTap: () {
                  Navigator.pop(context);
                  showVibraSnack(context, 'Added to playlist');
                },
              ),
              _SheetTile(
                icon: Icons.queue_music_rounded,
                label: 'Add to queue',
                onTap: () {
                  Navigator.pop(context);
                  showVibraSnack(context, 'Added to queue');
                },
              ),
              _SheetTile(
                icon: Icons.person_rounded,
                label: 'Go to artist',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArtistScreen(
                        artist: MockData.artistById(song.artistId),
                      ),
                    ),
                  );
                },
              ),
              _SheetTile(
                icon: Icons.download_rounded,
                label: 'Download',
                onTap: () {
                  Navigator.pop(context);
                  showVibraSnack(
                    context,
                    'Downloading "${song.title}"',
                    icon: Icons.download_done_rounded,
                  );
                },
              ),
              _SheetTile(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? VColors.textPrimary, size: 22),
      title: Text(label, style: vFont(14, weight: FontWeight.w600)),
    );
  }
}

// =============================================================================
// 8. HOME SCREEN
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : (hour < 18 ? 'Good afternoon' : 'Good evening');

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.md,
                VSpace.md,
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => showVibraSnack(context, 'Profile'),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: VColors.gradGreen,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'A',
                        style: vFont(15, weight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$greeting, Amir',
                      style: vFont(
                        19,
                        weight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        showVibraSnack(context, 'No new notifications'),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: VColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showVibraSnack(context, 'Settings'),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: VColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.lg,
                VSpace.md,
                VSpace.xs,
              ),
              child: _RecentGrid(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Made For You')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 220,
              children: MockData.madeForYou
                  .map((p) => PlaylistCard(playlist: p, size: 150))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Trending Now')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 200,
              children: MockData.trendingNow
                  .map((s) => SongCard(song: s, context_: MockData.trendingNow))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Popular Artists')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 150,
              children: MockData.artists
                  .map((a) => ArtistAvatarCard(artist: a))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'New Releases')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 210,
              children: MockData.newReleases
                  .map((a) => AlbumCard(album: a))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(title: 'Recommended For You'),
          ),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 220,
              children: MockData.recommended
                  .map((p) => PlaylistCard(playlist: p))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Charts')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 100,
              children: MockData.charts
                  .map((p) => WideChartCard(playlist: p))
                  .toList(),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Moods & Genres')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: VSpace.md),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: .8 / 1.1,
                ),
                itemCount: MockData.moods.length,
                itemBuilder: (_, i) => MoodTile(mood: MockData.moods[i]),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

class _RecentGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = MockData.recentlyPlayed.take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.0,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final song = items[i];
        return GestureDetector(
          onTap: () =>
              playerController.playSong(song, context: MockData.recentlyPlayed),
          child: Container(
            decoration: BoxDecoration(
              color: VColors.card,
              borderRadius: BorderRadius.circular(VRadius.sm),
            ),
            child: Row(
              children: [
                VImage(
                  url: song.artUrl,
                  width: 52,
                  height: 52,
                  radius: const BorderRadius.horizontal(
                    left: Radius.circular(VRadius.sm),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    song.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: vFont(12, weight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 9. SEARCH SCREEN
// =============================================================================

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.md,
              VSpace.md,
              VSpace.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: vFont(
                    26,
                    weight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: VSpace.md),
                Container(
                  decoration: BoxDecoration(
                    color: VColors.card,
                    borderRadius: BorderRadius.circular(VRadius.md),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: vFont(14, weight: FontWeight.w600),
                    onChanged: (v) => setState(() => _query = v),
                    cursorColor: VColors.accent,
                    decoration: InputDecoration(
                      hintText: 'Search songs, artists, albums, playlists',
                      hintStyle: vFont(13, color: VColors.textTertiary),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: VColors.textSecondary,
                      ),
                      suffixIcon: _query.isEmpty
                          ? IconButton(
                              onPressed: () => showVibraSnack(
                                context,
                                'Listening…',
                                icon: Icons.mic_rounded,
                              ),
                              icon: const Icon(
                                Icons.mic_none_rounded,
                                color: VColors.textSecondary,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: VColors.textSecondary,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? const _BrowseAllGrid()
                : _SearchResultsList(query: _query),
          ),
        ],
      ),
    );
  }
}

class _BrowseAllGrid extends StatelessWidget {
  const _BrowseAllGrid();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.sm,
              VSpace.md,
              4,
            ),
            child: Text(
              'Browse all',
              style: vFont(18, weight: FontWeight.w800),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(VSpace.md, 8, VSpace.md, 140),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final cat = MockData.browseCategories[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaylistScreen(
                      playlist: Playlist(
                        id: 'cat-${cat.title}',
                        title: cat.title,
                        description: 'Explore the best of ${cat.title}',
                        creator: 'VIBRA',
                        artUrl: MockData.art(cat.title),
                        songIds: MockData.songs.map((s) => s.id).toList()
                          ..shuffle(),
                        gradient: cat.gradient,
                      ),
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(VRadius.lg),
                    gradient: LinearGradient(
                      colors: cat.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -12,
                        child: Transform.rotate(
                          angle: 0.35,
                          child: Icon(
                            cat.icon,
                            size: 62,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          cat.title,
                          style: vFont(15, weight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: MockData.browseCategories.length),
          ),
        ),
      ],
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final String query;
  const _SearchResultsList({required this.query});

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final songResults = MockData.songs
        .where(
          (s) =>
              s.title.toLowerCase().contains(q) ||
              s.artist.toLowerCase().contains(q),
        )
        .take(6)
        .toList();
    final artistResults = MockData.artists
        .where((a) => a.name.toLowerCase().contains(q))
        .take(6)
        .toList();
    final albumResults = MockData.albums
        .where(
          (a) =>
              a.title.toLowerCase().contains(q) ||
              a.artist.toLowerCase().contains(q),
        )
        .take(6)
        .toList();
    final playlistResults = MockData.playlists
        .where((p) => p.title.toLowerCase().contains(q))
        .take(6)
        .toList();

    final noResults =
        songResults.isEmpty &&
        artistResults.isEmpty &&
        albumResults.isEmpty &&
        playlistResults.isEmpty;

    if (noResults) {
      // Fall back to a relevant mixed mock result set so the demo never looks empty.
      final fallbackSongs = MockData.songs.take(5).toList();
      final fallbackArtists = MockData.artists.take(4).toList();
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 140),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.sm,
              VSpace.md,
              4,
            ),
            child: Text(
              'No exact matches for "$query" — here\'s what\'s popular',
              style: vFont(13, color: VColors.textSecondary),
            ),
          ),
          _ResultSection(
            title: 'Songs',
            children: fallbackSongs
                .map((s) => SongTile(song: s, context_: fallbackSongs))
                .toList(),
          ),
          _ResultSection(
            title: 'Artists',
            children: [
              HorizontalRail(
                height: 140,
                children: fallbackArtists
                    .map((a) => ArtistAvatarCard(artist: a))
                    .toList(),
              ),
            ],
          ),
        ],
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 140),
      children: [
        if (songResults.isNotEmpty)
          _ResultSection(
            title: 'Songs',
            children: songResults
                .map((s) => SongTile(song: s, context_: songResults))
                .toList(),
          ),
        if (artistResults.isNotEmpty)
          _ResultSection(
            title: 'Artists',
            children: [
              HorizontalRail(
                height: 140,
                children: artistResults
                    .map((a) => ArtistAvatarCard(artist: a))
                    .toList(),
              ),
            ],
          ),
        if (albumResults.isNotEmpty)
          _ResultSection(
            title: 'Albums',
            children: [
              HorizontalRail(
                height: 210,
                children: albumResults.map((a) => AlbumCard(album: a)).toList(),
              ),
            ],
          ),
        if (playlistResults.isNotEmpty)
          _ResultSection(
            title: 'Playlists',
            children: [
              HorizontalRail(
                height: 220,
                children: playlistResults
                    .map((p) => PlaylistCard(playlist: p))
                    .toList(),
              ),
            ],
          ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _ResultSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            VSpace.md,
            VSpace.md,
            VSpace.md,
            4,
          ),
          child: Text(title, style: vFont(16, weight: FontWeight.w800)),
        ),
        ...children,
      ],
    );
  }
}

// =============================================================================
// 10. LIBRARY SCREEN
// =============================================================================

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _chip = 0;
  final _chips = const ['Playlists', 'Artists', 'Albums', 'Podcasts'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              VSpace.md,
              VSpace.md,
              VSpace.md,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Your Library',
                    style: vFont(
                      24,
                      weight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      showVibraSnack(context, 'Search your library'),
                  icon: const Icon(
                    Icons.search_rounded,
                    color: VColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => showVibraSnack(context, 'Sorted by recents'),
                  icon: const Icon(
                    Icons.swap_vert_rounded,
                    color: VColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => showVibraSnack(context, 'Create playlist'),
                  icon: const Icon(
                    Icons.add_rounded,
                    color: VColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: VSpace.md,
                vertical: 6,
              ),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = i == _chip;
                return GestureDetector(
                  onTap: () => setState(() => _chip = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? VColors.accent : VColors.card,
                      borderRadius: BorderRadius.circular(VRadius.pill),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _chips[i],
                      style: vFont(
                        13,
                        weight: FontWeight.w700,
                        color: selected ? Colors.black : VColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_chip) {
      case 0:
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 140, top: 4),
          itemCount: MockData.libraryPlaylists.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return _LikedSongsTile();
            final p = MockData.libraryPlaylists[i - 1];
            return _LibraryRow(
              imageUrl: p.artUrl,
              title: p.title,
              subtitle: 'Playlist · ${p.creator}',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: p)),
              ),
            );
          },
        );
      case 1:
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 140, top: 4),
          itemCount: MockData.libraryArtists.length,
          itemBuilder: (context, i) {
            final a = MockData.libraryArtists[i];
            return _LibraryRow(
              imageUrl: a.imageUrl,
              title: a.name,
              subtitle: 'Artist',
              circular: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ArtistScreen(artist: a)),
              ),
            );
          },
        );
      case 2:
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 140, top: 4),
          itemCount: MockData.libraryAlbums.length,
          itemBuilder: (context, i) {
            final al = MockData.libraryAlbums[i];
            return _LibraryRow(
              imageUrl: al.artUrl,
              title: al.title,
              subtitle: 'Album · ${al.artist}',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AlbumScreen(album: al)),
              ),
            );
          },
        );
      default:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.podcasts_rounded,
                size: 56,
                color: VColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                'No podcasts yet',
                style: vFont(15, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Follow a podcast to see it here',
                style: vFont(13, color: VColors.textSecondary),
              ),
            ],
          ),
        );
    }
  }
}

class _LikedSongsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final likedPlaylist = Playlist(
      id: 'liked',
      title: 'Liked Songs',
      description: 'Every song you\'ve ever liked, all in one place',
      creator: 'Amir',
      artUrl: MockData.art('liked'),
      songIds: playerController.likedSongIds.toList(),
      gradient: VColors.gradIndigo,
    );
    return _LibraryRow(
      title: 'Liked Songs',
      subtitle: 'Playlist · ${playerController.likedSongIds.length} songs',
      customLeading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: VColors.gradIndigo,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.favorite_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PlaylistScreen(playlist: likedPlaylist, isLikedSongs: true),
        ),
      ),
    );
  }
}

class _LibraryRow extends StatelessWidget {
  final String? imageUrl;
  final Widget? customLeading;
  final String title;
  final String subtitle;
  final bool circular;
  final VoidCallback onTap;
  const _LibraryRow({
    this.imageUrl,
    this.customLeading,
    required this.title,
    required this.subtitle,
    this.circular = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: VSpace.md, vertical: 8),
        child: Row(
          children: [
            customLeading ??
                (circular
                    ? ClipOval(
                        child: VImage(
                          url: imageUrl!,
                          width: 56,
                          height: 56,
                          fallbackIcon: Icons.person_rounded,
                        ),
                      )
                    : VImage(
                        url: imageUrl!,
                        width: 56,
                        height: 56,
                        radius: BorderRadius.circular(8),
                      )),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: vFont(14, weight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: vFont(12, color: VColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// =============================================================================
// 11. MINI PLAYER
// =============================================================================

class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;
  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final song = playerController.current!;
    final progress = song.duration.inMilliseconds == 0
        ? 0.0
        : (playerController.position.inMilliseconds /
                  song.duration.inMilliseconds)
              .clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) < -200) onTap();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        height: 64,
        decoration: BoxDecoration(
          color: VColors.cardHigh,
          borderRadius: BorderRadius.circular(VRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(VRadius.md),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Hero(
                      tag: 'now-playing-art',
                      child: VImage(
                        url: song.artUrl,
                        width: 48,
                        height: 48,
                        radius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: vFont(13, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: vFont(11, color: VColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => playerController.toggleLike(song.id),
                      icon: Icon(
                        playerController.isLiked(song.id)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: playerController.isLiked(song.id)
                            ? VColors.accent
                            : VColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => playerController.togglePlay(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            playerController.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            key: ValueKey(playerController.isPlaying),
                            color: VColors.textPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => playerController.next(),
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: VColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 2,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation(VColors.accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 12. NOW PLAYING SCREEN
// =============================================================================

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});
  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _artController;

  @override
  void initState() {
    super.initState();
    _artController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _artController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final song = playerController.current;
        if (song == null) return const SizedBox.shrink();
        final progress = song.duration.inMilliseconds == 0
            ? 0.0
            : (playerController.position.inMilliseconds /
                      song.duration.inMilliseconds)
                  .clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Dynamic blurred background from album art
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Stack(
                  key: ValueKey(song.id),
                  fit: StackFit.expand,
                  children: [
                    VImage(url: song.artUrl, fit: BoxFit.cover),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                      child: Container(color: VColors.bg.withOpacity(0.72)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            VColors.bg.withOpacity(0.94),
                            VColors.bg,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: VSpace.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 30,
                              color: VColors.textPrimary,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'PLAYING FROM ALBUM',
                                  style: vFont(
                                    10,
                                    weight: FontWeight.w700,
                                    color: VColors.textSecondary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  song.album,
                                  style: vFont(12, weight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                showVibraSnack(context, 'More options'),
                            icon: const Icon(
                              Icons.more_horiz_rounded,
                              color: VColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Hero(
                        tag: 'now-playing-art',
                        child: AnimatedBuilder(
                          animation: _artController,
                          builder: (context, child) {
                            final scale = playerController.isPlaying
                                ? 1.0
                                : 0.94;
                            return AnimatedScale(
                              scale: scale,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: VImage(
                                url: song.artUrl,
                                radius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  style: vFont(
                                    23,
                                    weight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ArtistScreen(
                                          artist: MockData.artistById(
                                            song.artistId,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    song.artist,
                                    style: vFont(
                                      15,
                                      color: VColors.textSecondary,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                playerController.toggleLike(song.id),
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                playerController.isLiked(song.id)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                key: ValueKey(
                                  playerController.isLiked(song.id),
                                ),
                                color: playerController.isLiked(song.id)
                                    ? VColors.accent
                                    : VColors.textPrimary,
                                size: 27,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          activeTrackColor: VColors.accent,
                          inactiveTrackColor: Colors.white.withOpacity(0.15),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (v) {
                            playerController.seek(
                              Duration(
                                milliseconds: (song.duration.inMilliseconds * v)
                                    .round(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(playerController.position),
                              style: vFont(11, color: VColors.textSecondary),
                            ),
                            Text(
                              '-${formatDuration(song.duration - playerController.position)}',
                              style: vFont(11, color: VColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => playerController.toggleShuffle(),
                            icon: Icon(
                              Icons.shuffle_rounded,
                              color: playerController.shuffle
                                  ? VColors.accent
                                  : VColors.textSecondary,
                              size: 22,
                            ),
                          ),
                          IconButton(
                            onPressed: () => playerController.previous(),
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: VColors.textPrimary,
                              size: 34,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => playerController.togglePlay(),
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Icon(
                                  playerController.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  key: ValueKey(playerController.isPlaying),
                                  color: Colors.black,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => playerController.next(),
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: VColors.textPrimary,
                              size: 34,
                            ),
                          ),
                          IconButton(
                            onPressed: () => playerController.cycleRepeat(),
                            icon: Icon(
                              playerController.repeatMode == 2
                                  ? Icons.repeat_one_rounded
                                  : Icons.repeat_rounded,
                              color: playerController.repeatMode != 0
                                  ? VColors.accent
                                  : VColors.textSecondary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.devices_rounded,
                                size: 18,
                                color: VColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'VIBRA Connect',
                                style: vFont(
                                  12,
                                  color: VColors.textSecondary,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QueueScreen(),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Queue',
                                  style: vFont(
                                    12,
                                    color: VColors.textSecondary,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.queue_music_rounded,
                                  size: 18,
                                  color: VColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// 13. ARTIST SCREEN
// =============================================================================

class ArtistScreen extends StatelessWidget {
  final Artist artist;
  const ArtistScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final topSongs = artist.topSongIds.map(MockData.songById).toList();
    final albums = MockData.albums
        .where((a) => a.artistId == artist.id)
        .toList();
    final related = MockData.artists
        .where((a) => a.id != artist.id)
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: VColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: VColors.bg,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  VImage(
                    url: artist.imageUrl,
                    fit: BoxFit.cover,
                    fallbackIcon: Icons.person_rounded,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.1), VColors.bg],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: VSpace.md,
                    right: VSpace.md,
                    bottom: VSpace.md,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              artist.name,
                              style: vFont(
                                30,
                                weight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                            ),
                            if (artist.verified) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified_rounded,
                                color: VColors.accent,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          artist.listeners,
                          style: vFont(
                            13,
                            color: VColors.textSecondary,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.md,
                VSpace.md,
                0,
              ),
              child: Row(
                children: [
                  _FollowButton(),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => showVibraSnack(context, 'Shared'),
                    icon: const Icon(
                      Icons.share_outlined,
                      color: VColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showVibraSnack(context, 'More options'),
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: VColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => playerController.playSong(
                      topSongs.first,
                      context: topSongs,
                    ),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: VColors.accent,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Popular')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => SongTile(
                song: topSongs[i],
                trackNumber: i + 1,
                context_: topSongs,
              ),
              childCount: topSongs.length,
            ),
          ),
          if (albums.isNotEmpty) ...[
            SliverToBoxAdapter(child: SectionHeader(title: 'Albums')),
            SliverToBoxAdapter(
              child: HorizontalRail(
                height: 210,
                children: albums.map((a) => AlbumCard(album: a)).toList(),
              ),
            ),
          ],
          SliverToBoxAdapter(child: SectionHeader(title: 'Fans Also Like')),
          SliverToBoxAdapter(
            child: HorizontalRail(
              height: 150,
              children: related
                  .map((a) => ArtistAvatarCard(artist: a))
                  .toList(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

class _FollowButton extends StatefulWidget {
  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => following = !following),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VRadius.pill),
          border: Border.all(
            color: following ? VColors.textTertiary : Colors.white,
            width: 1.2,
          ),
          color: following ? Colors.transparent : Colors.transparent,
        ),
        child: Text(
          following ? 'Following' : 'Follow',
          style: vFont(13, weight: FontWeight.w700),
        ),
      ),
    );
  }
}

// =============================================================================
// 14. ALBUM SCREEN
// =============================================================================

class AlbumScreen extends StatelessWidget {
  final Album album;
  const AlbumScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final songs = album.songIds.map(MockData.songById).toList();
    final totalDuration = songs.fold<Duration>(
      Duration.zero,
      (sum, s) => sum + s.duration,
    );

    return Scaffold(
      backgroundColor: VColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 420,
            backgroundColor: VColors.bg,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: VImage(url: album.artUrl, fit: BoxFit.cover),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: VColors.bg.withOpacity(0.55),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      VSpace.lg,
                      70,
                      VSpace.lg,
                      VSpace.lg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: VImage(
                              url: album.artUrl,
                              width: 190,
                              height: 190,
                              radius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          album.title,
                          style: vFont(
                            22,
                            weight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArtistScreen(
                                artist: MockData.artistById(album.artistId),
                              ),
                            ),
                          ),
                          child: Text(
                            album.artist,
                            style: vFont(
                              14,
                              weight: FontWeight.w700,
                              color: VColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.year} · ${songs.length} songs, ${formatDuration(totalDuration)}',
                          style: vFont(12, color: VColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.md,
                VSpace.md,
                VSpace.md,
                0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        showVibraSnack(context, 'Saved to Your Library'),
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: VColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showVibraSnack(
                      context,
                      'Downloading album',
                      icon: Icons.download_done_rounded,
                    ),
                    icon: const Icon(
                      Icons.download_outlined,
                      color: VColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showVibraSnack(context, 'More options'),
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: VColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () =>
                        playerController.playSong(songs.first, context: songs),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: VColors.accent,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => SongTile(
                song: songs[i],
                trackNumber: i + 1,
                context_: songs,
                showAlbumArt: false,
              ),
              childCount: songs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}

// =============================================================================
// 15. PLAYLIST SCREEN
// =============================================================================

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  final bool isLikedSongs;
  const PlaylistScreen({
    super.key,
    required this.playlist,
    this.isLikedSongs = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final ids = isLikedSongs
            ? playerController.likedSongIds.toList()
            : playlist.songIds;
        final songs = ids.map(MockData.songById).toList();
        final totalDuration = songs.fold<Duration>(
          Duration.zero,
          (sum, s) => sum + s.duration,
        );

        return Scaffold(
          backgroundColor: VColors.bg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 340,
                backgroundColor: VColors.bg,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 18),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: playlist.gradient,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, VColors.bg],
                              stops: const [0.55, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            VSpace.lg,
                            70,
                            VSpace.lg,
                            VSpace.lg,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: isLikedSongs
                                    ? Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: VColors.gradIndigo,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.white,
                                          size: 60,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: VImage(
                                          url: playlist.artUrl,
                                          width: 160,
                                          height: 160,
                                          radius: BorderRadius.circular(14),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                playlist.title,
                                style: vFont(
                                  22,
                                  weight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                playlist.description,
                                style: vFont(
                                  12,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${playlist.creator} · ${songs.length} songs, ${formatDuration(totalDuration)}',
                                style: vFont(
                                  11,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    VSpace.md,
                    VSpace.md,
                    VSpace.md,
                    0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            showVibraSnack(context, 'Saved to Your Library'),
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: VColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showVibraSnack(
                          context,
                          'Downloading playlist',
                          icon: Icons.download_done_rounded,
                        ),
                        icon: const Icon(
                          Icons.download_outlined,
                          color: VColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            showVibraSnack(context, 'More options'),
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: VColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          playerController.toggleShuffle();
                          if (songs.isNotEmpty)
                            playerController.playSong(
                              songs.first,
                              context: songs,
                            );
                        },
                        icon: Icon(
                          Icons.shuffle_rounded,
                          color: playerController.shuffle
                              ? VColors.accent
                              : VColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (songs.isNotEmpty)
                            playerController.playSong(
                              songs.first,
                              context: songs,
                            );
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: VColors.accent,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (songs.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.music_off_rounded,
                          size: 48,
                          color: VColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Songs you like will appear here',
                          style: vFont(13, color: VColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => SongTile(
                      song: songs[i],
                      trackNumber: i + 1,
                      context_: songs,
                    ),
                    childCount: songs.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// 16. QUEUE SCREEN
// =============================================================================

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});
  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final current = playerController.current;
        final upNext = playerController.upNext;

        return Scaffold(
          backgroundColor: VColors.bgElevated,
          appBar: AppBar(
            backgroundColor: VColors.bgElevated,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: VColors.textPrimary,
                size: 28,
              ),
            ),
            title: Text('Queue', style: vFont(15, weight: FontWeight.w800)),
          ),
          body: current == null
              ? Center(
                  child: Text(
                    'Nothing queued',
                    style: vFont(14, color: VColors.textSecondary),
                  ),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        VSpace.md,
                        VSpace.md,
                        VSpace.md,
                        4,
                      ),
                      child: Text(
                        'Now Playing',
                        style: vFont(15, weight: FontWeight.w800),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: VSpace.md),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: VColors.card,
                        borderRadius: BorderRadius.circular(VRadius.md),
                      ),
                      child: Row(
                        children: [
                          VImage(
                            url: current.artUrl,
                            width: 52,
                            height: 52,
                            radius: BorderRadius.circular(8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  current.title,
                                  style: vFont(
                                    14,
                                    weight: FontWeight.w700,
                                    color: VColors.accent,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  current.artist,
                                  style: vFont(
                                    12,
                                    color: VColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.equalizer_rounded,
                            color: VColors.accent,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        VSpace.md,
                        VSpace.lg,
                        VSpace.md,
                        4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next Up',
                            style: vFont(15, weight: FontWeight.w800),
                          ),
                          Text(
                            '${upNext.length} songs',
                            style: vFont(12, color: VColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (upNext.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Queue is empty',
                            style: vFont(13, color: VColors.textTertiary),
                          ),
                        ),
                      )
                    else
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: VSpace.md,
                        ),
                        itemCount: upNext.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = upNext.removeAt(oldIndex);
                            upNext.insert(newIndex, item);
                            playerController.queue.removeAt(
                              playerController.currentIndex + 1 + oldIndex,
                            );
                            playerController.queue.insert(
                              playerController.currentIndex + 1 + newIndex,
                              item,
                            );
                          });
                          showVibraSnack(context, 'Queue updated');
                        },
                        itemBuilder: (context, i) {
                          final song = upNext[i];
                          return Padding(
                            key: ValueKey('${song.id}-$i'),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                VImage(
                                  url: song.artUrl,
                                  width: 48,
                                  height: 48,
                                  radius: BorderRadius.circular(8),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        style: vFont(
                                          14,
                                          weight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        song.artist,
                                        style: vFont(
                                          12,
                                          color: VColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatDuration(song.duration),
                                  style: vFont(12, color: VColors.textTertiary),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.drag_handle_rounded,
                                  color: VColors.textTertiary,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
        );
      },
    );
  }
}
