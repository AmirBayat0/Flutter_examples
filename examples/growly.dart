// Growly — Social Growth Studio (SIMULATED DEMO)
// Single-file Flutter app. No backend, no external services, no real accounts.
// Everything here runs on local in-memory mock data.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: C.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GrowlyApp());
}

// ════════════════════════════════════════════════════════════════════════════
// THEME & DESIGN TOKENS
// ════════════════════════════════════════════════════════════════════════════

class C {
  static const bg = Color(0xFF0B0B12);
  static const surface = Color(0xFF151521);
  static const surface2 = Color(0xFF1C1C2B);
  static const border = Color(0x1AFFFFFF);
  static const violet = Color(0xFF8B5CF6);
  static const purple = Color(0xFFA855F7);
  static const cyan = Color(0xFF22D3EE);
  static const pink = Color(0xFFF472B6);
  static const green = Color(0xFF34D399);
  static const amber = Color(0xFFFBBF24);
  static const text = Color(0xFFF4F4F8);
  static const muted = Color(0xFF9A9AB0);
}

class T {
  static const h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: C.text,
    height: 1.15,
  );
  static const h2 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: C.text,
  );
  static const h3 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: C.text,
  );
  static const body = TextStyle(fontSize: 14, color: C.text, height: 1.4);
  static const muted = TextStyle(fontSize: 14, color: C.muted, height: 1.4);
  static const small = TextStyle(fontSize: 12, color: C.muted, height: 1.3);
  static const big = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    color: C.text,
    height: 1.05,
  );
}

extension ColorX on Color {
  Color op(double o) => withValues(alpha: o);
}

LinearGradient accentGradient(Color a) => LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [a, Color.lerp(a, C.pink, 0.45)!],
);

double c01(double v) => math.max(0.0, math.min(1.0, v));

String fmtInt(int n) {
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return (n < 0 ? '-' : '') + b.toString();
}

String compact(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 10000) return '${(n / 1000).toStringAsFixed(1)}K';
  return fmtInt(n);
}

OutlineInputBorder _ob(Color c) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: BorderSide(color: c),
);

ThemeData buildTheme(Color accent) {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
      ).copyWith(
        primary: accent,
        onPrimary: Colors.white,
        surface: C.surface,
        onSurface: C.text,
        surfaceContainerHigh: C.surface2,
        surfaceContainerHighest: C.surface2,
        outline: C.border,
      );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: C.bg,
    canvasColor: C.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: C.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: C.text,
      ),
      iconTheme: IconThemeData(color: C.text),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: C.surface,
      indicatorColor: accent.op(0.2),
      height: 68,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (st) => TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: st.contains(WidgetState.selected) ? C.text : C.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (st) => IconThemeData(
          color: st.contains(WidgetState.selected) ? accent : C.muted,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.surface2,
      hintStyle: const TextStyle(color: C.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _ob(Colors.transparent),
      enabledBorder: _ob(C.border),
      focusedBorder: _ob(accent),
      errorBorder: _ob(C.pink),
      focusedErrorBorder: _ob(C.pink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 50),
        shape: shape,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 50),
        foregroundColor: C.text,
        side: const BorderSide(color: C.border),
        shape: shape,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.surface2,
      contentTextStyle: const TextStyle(color: C.text, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// MODELS & MOCK DATA
// ════════════════════════════════════════════════════════════════════════════

const kXpPerLevel = 500;
const kTaskXp = 20;
const kFinishBonus = 50;

class Profile {
  final String id, username, name, category, bio;
  final int followers;
  final double engagement;
  final int joinedDaysAgo;
  const Profile(
    this.id,
    this.username,
    this.name,
    this.category,
    this.followers,
    this.engagement,
    this.bio,
    this.joinedDaysAgo,
  );
}

const kCategories = [
  'All',
  'Creators',
  'Tech',
  'Gaming',
  'Lifestyle',
  'Photography',
];

Color categoryColor(String c) {
  switch (c) {
    case 'Creators':
      return C.pink;
    case 'Tech':
      return C.cyan;
    case 'Gaming':
      return C.purple;
    case 'Lifestyle':
      return C.green;
    case 'Photography':
      return C.amber;
    default:
      return C.violet;
  }
}

const kProfiles = <Profile>[
  Profile(
    'p1',
    'pixelpilot',
    'Maya Okafor',
    'Tech',
    48200,
    6.4,
    'Shipping Flutter UI experiments every week. Animations, shaders and clean architecture.',
    12,
  ),
  Profile(
    'p2',
    'devnotes.daily',
    'Arjun Mehta',
    'Tech',
    31850,
    5.1,
    'Bite-sized dev tips for mobile engineers. Dart, Kotlin and Swift.',
    45,
  ),
  Profile(
    'p3',
    'lumenframe',
    'Sofia Lindgren',
    'Photography',
    92400,
    4.2,
    'Golden-hour landscapes and quiet city studies, shot on mirrorless.',
    30,
  ),
  Profile(
    'p4',
    'quest.nova',
    'Kai Tanaka',
    'Gaming',
    156300,
    7.8,
    'Indie game reviews, speedrun clips and cozy co-op nights.',
    8,
  ),
  Profile(
    'p5',
    'thecreatorlab',
    'Zuri Mensah',
    'Creators',
    67500,
    8.2,
    'Behind the scenes of building a creator business from scratch.',
    21,
  ),
  Profile(
    'p6',
    'slowmornings',
    'Elena Rossi',
    'Lifestyle',
    24300,
    5.9,
    'Calm routines, minimalist home and mindful productivity.',
    60,
  ),
  Profile(
    'p7',
    'byte.bard',
    'Leo Brandt',
    'Tech',
    18700,
    6.9,
    'Explaining AI and open source with humor and diagrams.',
    5,
  ),
  Profile(
    'p8',
    'framefable',
    'Ines Duarte',
    'Photography',
    41200,
    5.5,
    'Street portraits and visual storytelling in film tones.',
    90,
  ),
  Profile(
    'p9',
    'controller.cafe',
    'Omar Haddad',
    'Gaming',
    73900,
    6.1,
    'Retro console deep-dives and weekly community streams.',
    15,
  ),
  Profile(
    'p10',
    'nomad.notes',
    'Pia Lindqvist',
    'Lifestyle',
    58100,
    4.8,
    'Slow-travel guides and remote-work essentials.',
    40,
  ),
  Profile(
    'p11',
    'reelcraft.studio',
    'Theo Marsh',
    'Creators',
    112500,
    5.3,
    'Editing breakdowns, transitions and storytelling frameworks.',
    3,
  ),
  Profile(
    'p12',
    'widget.whisper',
    'Nadia Kowalski',
    'Tech',
    9800,
    9.1,
    'Tiny Flutter widgets, big ideas. Sharing code snippets daily.',
    18,
  ),
  Profile(
    'p13',
    'dawnchaser',
    'Marco Silva',
    'Photography',
    28400,
    6.6,
    'Sunrise hikes and astro-photography tips for beginners.',
    70,
  ),
  Profile(
    'p14',
    'plantandplay',
    'Hana Park',
    'Lifestyle',
    36700,
    7.2,
    'Houseplants, cozy gaming corners and cheerful DIY.',
    27,
  ),
];

enum CampaignStatus { active, paused, completed, archived }

enum CampaignType {
  contentEngagement,
  commentInspiration,
  profileDiscovery,
  hashtagResearch,
}

extension CampaignTypeX on CampaignType {
  String get label {
    switch (this) {
      case CampaignType.contentEngagement:
        return 'Content engagement';
      case CampaignType.commentInspiration:
        return 'Comment inspiration';
      case CampaignType.profileDiscovery:
        return 'Profile discovery';
      case CampaignType.hashtagResearch:
        return 'Hashtag research';
    }
  }

  String get blurb {
    switch (this) {
      case CampaignType.contentEngagement:
        return 'Study a creator\'s content and capture ideas worth learning from.';
      case CampaignType.commentInspiration:
        return 'Draft thoughtful, human comments with local templates.';
      case CampaignType.profileDiscovery:
        return 'Explore public profiles and note collaboration ideas.';
      case CampaignType.hashtagResearch:
        return 'Shortlist sample hashtag groups for your niche.';
    }
  }

  IconData get icon {
    switch (this) {
      case CampaignType.contentEngagement:
        return Icons.auto_awesome_rounded;
      case CampaignType.commentInspiration:
        return Icons.forum_rounded;
      case CampaignType.profileDiscovery:
        return Icons.travel_explore_rounded;
      case CampaignType.hashtagResearch:
        return Icons.tag_rounded;
    }
  }

  Color get color {
    switch (this) {
      case CampaignType.contentEngagement:
        return C.violet;
      case CampaignType.commentInspiration:
        return C.pink;
      case CampaignType.profileDiscovery:
        return C.cyan;
      case CampaignType.hashtagResearch:
        return C.green;
    }
  }

  List<String> get templates {
    switch (this) {
      case CampaignType.contentEngagement:
        return [
          'Review {t}\'s latest post',
          'Note what makes the caption work',
          'Save one idea for your next post',
          'Draft a reaction to their carousel',
          'Explore their story highlights',
          'Summarize the key takeaway',
        ];
      case CampaignType.commentInspiration:
        return [
          'Read {t}\'s newest caption',
          'Draft a thoughtful comment',
          'Refine your draft\'s tone',
          'Preview the comment locally',
          'Save the best draft to favorites',
        ];
      case CampaignType.profileDiscovery:
        return [
          'Explore {t}\'s public profile',
          'Check their content themes',
          'Note their posting rhythm',
          'List 3 collaboration ideas',
        ];
      case CampaignType.hashtagResearch:
        return [
          'Browse hashtag groups for {t}\'s niche',
          'Compare 3 sample tag sets',
          'Shortlist 5 tags',
          'Copy your favorite set',
        ];
    }
  }
}

class TaskItem {
  final String title;
  bool done;
  TaskItem(this.title, {this.done = false});
}

class Campaign {
  final String id, name, targetName, targetUsername, category, description;
  final CampaignType type;
  final List<TaskItem> tasks;
  CampaignStatus status;
  Campaign({
    required this.id,
    required this.name,
    required this.type,
    required this.targetName,
    required this.targetUsername,
    required this.category,
    required this.description,
    required this.tasks,
    this.status = CampaignStatus.active,
  });
  int get done => tasks.where((t) => t.done).length;
  double get progress => tasks.isEmpty ? 0 : done / tasks.length;
}

List<TaskItem> buildTasks(
  CampaignType t,
  String target,
  int count, {
  int done = 0,
}) {
  final tpl = t.templates;
  return List.generate(count, (i) {
    final base = tpl[i % tpl.length].replaceAll('{t}', '@$target');
    final round = i ~/ tpl.length;
    return TaskItem(
      round == 0 ? base : '$base (round ${round + 1})',
      done: i < done,
    );
  });
}

class Challenge {
  final String id, title, desc;
  final int target, xp;
  final bool weekly;
  const Challenge(
    this.id,
    this.title,
    this.desc,
    this.target,
    this.xp, {
    this.weekly = false,
  });
}

const kChallenges = <Challenge>[
  Challenge('d_tasks', 'Task trio', 'Complete 3 campaign tasks today', 3, 60),
  Challenge('d_launch', 'Launch pad', 'Launch 1 campaign today', 1, 80),
  Challenge('d_save', 'Curator', 'Save 2 creators in Discover', 2, 40),
  Challenge(
    'w_tasks',
    'Steady hands',
    'Complete 15 tasks this week',
    15,
    200,
    weekly: true,
  ),
  Challenge(
    'w_copy',
    'Inspiration loop',
    'Copy 5 comments or hashtag sets',
    5,
    120,
    weekly: true,
  ),
  Challenge(
    'w_finish',
    'Finisher',
    'Finish 2 campaigns this week',
    2,
    250,
    weekly: true,
  ),
];

class Achievement {
  final String id, title, desc;
  final IconData icon;
  final Color color;
  final int target;
  const Achievement(
    this.id,
    this.title,
    this.desc,
    this.icon,
    this.color,
    this.target,
  );
}

const kAchievements = <Achievement>[
  Achievement(
    'explorer',
    'Demo Explorer',
    'Open Growly for the first time.',
    Icons.explore_rounded,
    C.cyan,
    1,
  ),
  Achievement(
    'first_launch',
    'Liftoff',
    'Launch your first campaign.',
    Icons.rocket_launch_rounded,
    C.violet,
    1,
  ),
  Achievement(
    'task_10',
    'Getting Going',
    'Complete 10 campaign tasks.',
    Icons.task_alt_rounded,
    C.green,
    10,
  ),
  Achievement(
    'task_25',
    'Task Master',
    'Complete 25 campaign tasks.',
    Icons.military_tech_rounded,
    C.amber,
    25,
  ),
  Achievement(
    'collector',
    'Collector',
    'Save 3 creators from Discover.',
    Icons.collections_bookmark_rounded,
    C.pink,
    3,
  ),
  Achievement(
    'streak_7',
    'On Fire',
    'Reach a 7-day streak.',
    Icons.local_fire_department_rounded,
    Color(0xFFFB923C),
    7,
  ),
  Achievement(
    'level_5',
    'Rising Star',
    'Reach level 5.',
    Icons.workspace_premium_rounded,
    C.purple,
    5,
  ),
  Achievement(
    'finisher',
    'Closer',
    'Finish 3 campaigns.',
    Icons.flag_rounded,
    C.green,
    3,
  ),
  Achievement(
    'copywriter',
    'Wordsmith',
    'Copy 10 comments or hashtag sets.',
    Icons.edit_note_rounded,
    C.cyan,
    10,
  ),
];

enum ActType { follow, like, comment, save, system }

class ActivityItem {
  final String who, text, time;
  final ActType type;
  ActivityItem(this.who, this.text, this.time, this.type);
}

class AppNotification {
  final String id, title, body, time;
  final IconData icon;
  final Color color;
  bool read;
  AppNotification(
    this.id,
    this.title,
    this.body,
    this.time,
    this.icon,
    this.color, {
    this.read = false,
  });
}

class RewardEntry {
  final String title, time;
  final int xp;
  RewardEntry(this.title, this.xp, this.time);
}

class ProgressEvent {
  final bool ok;
  final int xp;
  final List<String> challenges;
  final bool finished;
  const ProgressEvent({
    this.ok = true,
    this.xp = 0,
    this.challenges = const [],
    this.finished = false,
  });
}

class Comment {
  final String tone, text;
  const Comment(this.tone, this.text);
}

const kTones = ['Supportive', 'Educational', 'Creative', 'Conversational'];

const kComments = <Comment>[
  Comment(
    'Supportive',
    'This is such a clear breakdown. Thanks for making it feel approachable.',
  ),
  Comment(
    'Supportive',
    'Love the consistency you bring to every post. It really shows.',
  ),
  Comment(
    'Supportive',
    'Needed this today. Saving it for the next time I get stuck.',
  ),
  Comment(
    'Educational',
    'Great point on state management. Have you compared it with Riverpod for larger apps?',
  ),
  Comment(
    'Educational',
    'The part about widget rebuilds finally clicked for me. Thanks for explaining it so simply.',
  ),
  Comment(
    'Educational',
    'Handy tip! I\'d add that const constructors help here too.',
  ),
  Comment(
    'Creative',
    'That gradient work is gorgeous. The glow on the cards ties the whole screen together.',
  ),
  Comment(
    'Creative',
    'If this UI were a soundtrack it would be synthwave. Absolutely love the vibe.',
  ),
  Comment(
    'Creative',
    'The motion design here is so smooth. It feels like a native product launch.',
  ),
  Comment(
    'Conversational',
    'Curious: what was the hardest part to get right in this build?',
  ),
  Comment(
    'Conversational',
    'Which package would you reach for first if you started this over?',
  ),
  Comment(
    'Conversational',
    'Would love to see a follow-up on how you structured the folders!',
  ),
];

const kHashtagGroups = <String, List<String>>{
  'Flutter': [
    '#flutter',
    '#flutterdev',
    '#dart',
    '#fluttercommunity',
    '#flutterui',
    '#buildwithflutter',
  ],
  'Mobile': [
    '#mobiledev',
    '#appdevelopment',
    '#androiddev',
    '#iosdev',
    '#uiuxdesign',
    '#appdesign',
  ],
  'Tech': [
    '#technology',
    '#coding',
    '#programming',
    '#developerlife',
    '#techcreator',
    '#softwaredevelopment',
  ],
  'Creators': [
    '#contentcreator',
    '#creatortips',
    '#digitalcreator',
    '#socialmediatips',
    '#reelstips',
    '#creatorlife',
  ],
};

double simulatedUsage(String tag) {
  var h = 0;
  for (final u in tag.codeUnits) {
    h = (h * 31 + u) & 0x7fffffff;
  }
  return 0.3 + (h % 66) / 100.0;
}

const kWeeklyBoard = <MapEntry<String, int>>[
  MapEntry('Nova Reyes', 1180),
  MapEntry('Kai Tanaka', 1040),
  MapEntry('Zuri Mensah', 905),
  MapEntry('Leo Brandt', 820),
  MapEntry('Ines Duarte', 735),
  MapEntry('Omar Haddad', 610),
  MapEntry('Pia Lindqvist', 488),
  MapEntry('Theo Marsh', 352),
];

const kAllTimeBoard = <MapEntry<String, int>>[
  MapEntry('Nova Reyes', 7420),
  MapEntry('Zuri Mensah', 6890),
  MapEntry('Kai Tanaka', 6310),
  MapEntry('Ines Duarte', 5480),
  MapEntry('Leo Brandt', 4975),
  MapEntry('Omar Haddad', 4120),
  MapEntry('Pia Lindqvist', 3390),
  MapEntry('Theo Marsh', 2660),
];

const kTips = <List<String>>[
  [
    'Pull down to refresh the demo dashboard.',
    'Tap the chart to scrub through simulated data points.',
    'Tap any metric card for a detailed breakdown.',
  ],
  [
    'Search by name or username, then combine with chips.',
    'Bookmark creators to unlock the Curator challenge.',
    'Open a profile and select it as your campaign target.',
  ],
  [
    'Create a campaign in four quick steps.',
    'Complete tasks to earn XP. Paused campaigns lock tasks.',
    'Use the Comment Studio and Hashtag Lab as writing aids.',
  ],
  [
    'Finish challenges, then press Claim to collect XP once.',
    'Check in daily to keep your streak alive.',
    'Tap a badge to see what unlocks it.',
  ],
  [
    'Edit your profile to raise the completion meter.',
    'Reset demo data any time to start fresh.',
    'No external accounts are ever connected.',
  ],
];

// ════════════════════════════════════════════════════════════════════════════
// APP STATE (single source of truth)
// ════════════════════════════════════════════════════════════════════════════

class AppState extends ChangeNotifier {
  AppState() {
    _init();
  }

  bool onboarded = false;
  int tab = 0;
  bool notificationsOn = true;
  bool haptics = true;
  Color accent = C.violet;

  late String displayName, username, bio, niche, link;
  late int xp, weeklyXp, streak, tasksToday, tasksWeek, copies, launched;
  late bool checkedIn;
  late Set<String> bookmarks, claimed;
  late List<Campaign> campaigns;
  late List<ActivityItem> activity;
  late List<AppNotification> notifications;
  late List<RewardEntry> history;
  late List<String> favoriteDrafts;
  Profile? selectedTarget;
  int _seq = 10;

  void _init() {
    displayName = 'Alex Morgan';
    username = 'alexmorgan.demo';
    bio = 'Tech creator sharing app builds, design breakdowns and growth experiments.';
    niche = 'Technology';
    link = '';
    xp = 1240;
    weeklyXp = 460;
    streak = 6;
    checkedIn = false;
    tasksToday = 2;
    tasksWeek = 8;
    copies = 2;
    launched = 0;
    bookmarks = <String>{};
    claimed = <String>{};
    selectedTarget = null;
    tab = 0;
    _seq = 10;
    campaigns = [
      Campaign(
        id: 'c1',
        name: 'Flutter creators sweep',
        type: CampaignType.contentEngagement,
        targetName: 'Maya Okafor',
        targetUsername: 'pixelpilot',
        category: 'Tech',
        description: 'Study what top Flutter creators post and capture ideas.',
        tasks: buildTasks(
          CampaignType.contentEngagement,
          'pixelpilot',
          6,
          done: 3,
        ),
      ),
      Campaign(
        id: 'c2',
        name: 'Hashtag set refresh',
        type: CampaignType.hashtagResearch,
        targetName: 'Nadia Kowalski',
        targetUsername: 'widget.whisper',
        category: 'Tech',
        description: 'Build a fresh sample hashtag shortlist.',
        tasks: buildTasks(
          CampaignType.hashtagResearch,
          'widget.whisper',
          5,
          done: 5,
        ),
        status: CampaignStatus.completed,
      ),
      Campaign(
        id: 'c3',
        name: 'Weekend inspiration',
        type: CampaignType.profileDiscovery,
        targetName: 'Elena Rossi',
        targetUsername: 'slowmornings',
        category: 'Lifestyle',
        description: 'Explore calm lifestyle creators for collaboration ideas.',
        tasks: buildTasks(
          CampaignType.profileDiscovery,
          'slowmornings',
          4,
          done: 1,
        ),
        status: CampaignStatus.paused,
      ),
    ];
    activity = [
      ActivityItem(
        'pixelpilot',
        'started following your demo profile',
        '2m',
        ActType.follow,
      ),
      ActivityItem(
        'Maya Okafor',
        'liked your carousel (simulated)',
        '14m',
        ActType.like,
      ),
      ActivityItem(
        'devnotes.daily',
        'commented: "This layout is so clean!"',
        '32m',
        ActType.comment,
      ),
      ActivityItem('lumenframe', 'saved your latest post', '1h', ActType.save),
      ActivityItem(
        'Growly',
        'Your weekly summary is ready',
        '3h',
        ActType.system,
      ),
    ];
    notifications = [
      AppNotification(
        'n1',
        'Welcome to Growly',
        'Everything here is simulated. No accounts are connected.',
        '1h',
        Icons.waving_hand_rounded,
        C.violet,
      ),
      AppNotification(
        'n2',
        'Campaign progress',
        'Flutter creators sweep is halfway done.',
        '3h',
        Icons.rocket_launch_rounded,
        C.cyan,
      ),
      AppNotification(
        'n3',
        'Streak almost there',
        'Check in today to reach a 7-day streak.',
        '5h',
        Icons.local_fire_department_rounded,
        C.amber,
        read: true,
      ),
    ];
    history = [
      RewardEntry('Weekly challenge claimed', 120, 'Yesterday'),
      RewardEntry('Daily check-in', 25, 'Yesterday'),
      RewardEntry('Campaign finished: Hashtag set refresh', 50, '2 days ago'),
    ];
    favoriteDrafts = [];
  }

  // ── Derived values ──
  int get level => xp ~/ kXpPerLevel + 1;
  double get levelProgress => (xp % kXpPerLevel) / kXpPerLevel;
  int get xpToNext => kXpPerLevel - xp % kXpPerLevel;
  int get totalTasksDone => campaigns.fold(0, (a, c) => a + c.done);
  int get activeCount =>
      campaigns.where((c) => c.status == CampaignStatus.active).length;
  int get completedCount =>
      campaigns.where((c) => c.status == CampaignStatus.completed).length;
  int get followers => 12480 + totalTasksDone * 4;
  int get unread => notifications.where((n) => !n.read).length;
  int get engagementScore => math.min(98, 70 + totalTasksDone);
  double get profileCompletion {
    final fields = [displayName, username, bio, niche, link];
    return fields.where((f) => f.trim().isNotEmpty).length / fields.length;
  }

  int progressOf(Challenge c) {
    switch (c.id) {
      case 'd_tasks':
        return tasksToday;
      case 'd_launch':
        return launched;
      case 'd_save':
        return bookmarks.length;
      case 'w_tasks':
        return tasksWeek;
      case 'w_copy':
        return copies;
      case 'w_finish':
        return completedCount;
    }
    return 0;
  }

  bool isComplete(Challenge c) => progressOf(c) >= c.target;

  int achievementValue(Achievement a) {
    switch (a.id) {
      case 'explorer':
        return 1;
      case 'first_launch':
        return launched;
      case 'task_10':
      case 'task_25':
        return totalTasksDone;
      case 'collector':
        return bookmarks.length;
      case 'streak_7':
        return streak;
      case 'level_5':
        return level;
      case 'finisher':
        return completedCount;
      case 'copywriter':
        return copies;
    }
    return 0;
  }

  bool isUnlocked(Achievement a) => achievementValue(a) >= a.target;

  Set<String> _readyIds() => kChallenges
      .where((c) => isComplete(c) && !claimed.contains(c.id))
      .map((c) => c.id)
      .toSet();

  List<String> _newTitles(Set<String> before) {
    final now = _readyIds()..removeAll(before);
    return kChallenges
        .where((c) => now.contains(c.id))
        .map((c) => c.title)
        .toList();
  }

  // ── Helpers ──
  void tap() {
    if (haptics) HapticFeedback.selectionClick();
  }

  void _log(String who, String text, ActType type) {
    activity.insert(0, ActivityItem(who, text, 'Just now', type));
    if (activity.length > 20) activity.removeLast();
  }

  void _notify(String title, String body, IconData icon, Color color) {
    if (!notificationsOn) return;
    notifications.insert(
      0,
      AppNotification('n${_seq++}', title, body, 'Just now', icon, color),
    );
    if (notifications.length > 30) notifications.removeLast();
  }

  void _addXp(int amount, String title) {
    if (amount <= 0) return;
    final before = level;
    xp += amount;
    weeklyXp += amount;
    history.insert(0, RewardEntry(title, amount, 'Just now'));
    if (history.length > 30) history.removeLast();
    if (level > before) {
      _notify(
        'Level up!',
        'You reached level $level in the demo.',
        Icons.workspace_premium_rounded,
        C.amber,
      );
      _log('Growly', 'You reached level $level', ActType.system);
    }
  }

  // ── Navigation / settings ──
  void setTab(int i) {
    tab = i;
    notifyListeners();
  }

  void finishOnboarding() {
    onboarded = true;
    notifyListeners();
  }

  void setHaptics(bool v) {
    haptics = v;
    notifyListeners();
  }

  void setNotifications(bool v) {
    notificationsOn = v;
    notifyListeners();
  }

  void setAccent(Color c) {
    accent = c;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String user,
    required String bioText,
    required String nicheText,
    required String linkText,
  }) {
    displayName = name.trim();
    username = user.trim();
    bio = bioText.trim();
    niche = nicheText.trim();
    link = linkText.trim();
    notifyListeners();
  }

  void reset() {
    final keep = onboarded;
    _init();
    onboarded = keep;
    notifyListeners();
  }

  // ── Notifications ──
  void toggleRead(String id) {
    final n = notifications.firstWhere((e) => e.id == id);
    n.read = !n.read;
    notifyListeners();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  // ── Discover ──
  ProgressEvent toggleBookmark(Profile p) {
    final before = _readyIds();
    final saved = !bookmarks.contains(p.id);
    if (saved) {
      bookmarks.add(p.id);
    } else {
      bookmarks.remove(p.id);
    }
    final titles = _newTitles(before);
    notifyListeners();
    return ProgressEvent(ok: saved, challenges: titles);
  }

  void selectTarget(Profile? p) {
    selectedTarget = p;
    notifyListeners();
  }

  // ── Campaigns ──
  Campaign launchCampaign({
    required CampaignType type,
    required String name,
    required String targetName,
    required String targetUsername,
    required String category,
    required String description,
    required int count,
  }) {
    final c = Campaign(
      id: 'c${_seq++}',
      name: name.trim(),
      type: type,
      targetName: targetName,
      targetUsername: targetUsername,
      category: category,
      description: description.trim(),
      tasks: buildTasks(type, targetUsername, count),
    );
    campaigns.insert(0, c);
    launched++;
    _notify(
      'Campaign launched',
      '${c.name} is live (simulated).',
      Icons.rocket_launch_rounded,
      C.violet,
    );
    _log('You', 'launched "${c.name}"', ActType.system);
    notifyListeners();
    return c;
  }

  ProgressEvent completeTask(Campaign c, int i) {
    if (c.status != CampaignStatus.active ||
        i < 0 ||
        i >= c.tasks.length ||
        c.tasks[i].done) {
      return const ProgressEvent(ok: false);
    }
    final before = _readyIds();
    c.tasks[i].done = true;
    tasksToday++;
    tasksWeek++;
    var gained = kTaskXp;
    _addXp(kTaskXp, 'Task completed');
    _log('You', 'completed a task in ${c.name}', ActType.system);
    var finished = false;
    if (c.done == c.tasks.length) {
      c.status = CampaignStatus.completed;
      finished = true;
      gained += kFinishBonus;
      _addXp(kFinishBonus, 'Campaign finished: ${c.name}');
      _notify(
        'Campaign complete',
        '${c.name} finished. +$kFinishBonus bonus XP.',
        Icons.flag_rounded,
        C.green,
      );
    }
    final titles = _newTitles(before);
    notifyListeners();
    return ProgressEvent(xp: gained, challenges: titles, finished: finished);
  }

  void setStatus(Campaign c, CampaignStatus s) {
    c.status = s;
    notifyListeners();
  }

  // ── Rewards ──
  bool claim(Challenge ch) {
    if (claimed.contains(ch.id) || !isComplete(ch)) return false;
    claimed.add(ch.id);
    _addXp(ch.xp, 'Claimed: ${ch.title}');
    notifyListeners();
    return true;
  }

  bool checkIn() {
    if (checkedIn) return false;
    checkedIn = true;
    streak++;
    _addXp(25, 'Daily check-in');
    notifyListeners();
    return true;
  }

  ProgressEvent registerCopy() {
    final before = _readyIds();
    copies++;
    final titles = _newTitles(before);
    notifyListeners();
    return ProgressEvent(challenges: titles);
  }

  // ── Drafts ──
  bool addFavorite(String text) {
    final t = text.trim();
    if (t.isEmpty || favoriteDrafts.contains(t)) return false;
    favoriteDrafts.insert(0, t);
    notifyListeners();
    return true;
  }

  void removeFavorite(String text) {
    favoriteDrafts.remove(text);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

// ════════════════════════════════════════════════════════════════════════════
// SHARED HELPERS & REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════════════════════

void toast(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
  Color? color,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          Icon(icon, color: color ?? C.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
      action: actionLabel == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              textColor: Theme.of(context).colorScheme.primary,
              onPressed: onAction ?? () {},
            ),
    ),
  );
}

Future<bool> showConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: T.h2),
      content: Text(message, style: T.muted),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 44),
            backgroundColor: destructive ? C.pink : null,
            foregroundColor: destructive ? C.bg : null,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return r ?? false;
}

Route<T> slideRoute<T>(Widget page) => PageRouteBuilder<T>(
  transitionDuration: const Duration(milliseconds: 350),
  reverseTransitionDuration: const Duration(milliseconds: 250),
  pageBuilder: (_, __, ___) => page,
  transitionsBuilder: (context, a, sa, child) {
    final curved = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  },
);

Widget sheetHandle() => Center(
  child: Container(
    width: 42,
    height: 4,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(4),
    ),
  ),
);

Future<T?> showAppSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: builder,
    );

void celebrate(BuildContext context, ProgressEvent e) {
  if (e.finished) {
    showCelebration(
      context,
      'Campaign complete!',
      'Bonus +$kFinishBonus XP (simulated)',
    );
  } else if (e.challenges.isNotEmpty) {
    showCelebration(
      context,
      'Challenge complete!',
      '${e.challenges.join(', ')} is ready to claim in Rewards.',
    );
  }
}

Future<void> copyText(
  BuildContext context,
  String text, {
  String label = 'Copied to clipboard',
}) async {
  final s = AppScope.read(context);
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  s.tap();
  final ev = s.registerCopy();
  toast(
    context,
    '$label. Demo only, nothing is posted anywhere.',
    icon: Icons.copy_rounded,
    color: C.cyan,
  );
  celebrate(context, ev);
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final double radius;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.gradient,
    this.color,
    this.borderColor,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? C.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? C.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {
                  AppScope.read(context).tap();
                  onTap!();
                },
                child: content,
              ),
            ),
    );
  }
}

class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const PressScale({super.key, required this.child, this.onTap});
  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap == null
          ? null
          : () {
              AppScope.read(context).tap();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return PressScale(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: accentGradient(accent),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accent.op(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _avatarPalettes = <List<Color>>[
  [Color(0xFF8B5CF6), Color(0xFFEC4899)],
  [Color(0xFF22D3EE), Color(0xFF6366F1)],
  [Color(0xFF34D399), Color(0xFF22D3EE)],
  [Color(0xFFF472B6), Color(0xFFFBBF24)],
  [Color(0xFFA855F7), Color(0xFF3B82F6)],
  [Color(0xFFFB923C), Color(0xFFEF4444)],
];

class ProfileAvatar extends StatelessWidget {
  final String seed, label;
  final double size;
  final bool ring;
  const ProfileAvatar({
    super.key,
    required this.seed,
    required this.label,
    this.size = 44,
    this.ring = false,
  });

  @override
  Widget build(BuildContext context) {
    var h = 0;
    for (final u in seed.codeUnits) {
      h = (h * 31 + u) & 0x7fffffff;
    }
    final pal = _avatarPalettes[h % _avatarPalettes.length];
    final initials = label
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: pal,
        ),
        border: ring ? Border.all(color: Colors.white30, width: 2) : null,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}

class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: C.amber.op(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.amber.op(0.4)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science_rounded, size: 12, color: C.amber),
          SizedBox(width: 4),
          Text(
            'DEMO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: C.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class SimNotice extends StatelessWidget {
  final String text;
  const SimNotice(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.cyan.op(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.cyan.op(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, size: 18, color: C.cyan),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                color: C.muted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppScope.read(context).tap();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? accent.op(0.2) : C.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? accent : C.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: selected ? accent : C.muted),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? C.text : C.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final CampaignStatus status;
  const StatusChip(this.status, {super.key});
  @override
  Widget build(BuildContext context) {
    late final Color c;
    late final String l;
    switch (status) {
      case CampaignStatus.active:
        c = C.green;
        l = 'Active';
      case CampaignStatus.paused:
        c = C.amber;
        l = 'Paused';
      case CampaignStatus.completed:
        c = C.cyan;
        l = 'Completed';
      case CampaignStatus.archived:
        c = C.muted;
        l = 'Archived';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.op(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            l,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

class AppProgress extends StatelessWidget {
  final double value;
  final Color? color;
  final double height;
  const AppProgress({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final col = color ?? Theme.of(context).colorScheme.primary;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: c01(value)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Stack(
          children: [
            Container(height: height, color: Colors.white.op(0.08)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: v,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [col, Color.lerp(col, C.pink, 0.5)!],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedNumber extends StatelessWidget {
  final double value;
  final int decimals;
  final String prefix, suffix;
  final TextStyle style;
  const AnimatedNumber(
    this.value, {
    super.key,
    this.decimals = 0,
    this.prefix = '',
    this.suffix = '',
    this.style = T.h2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final t = decimals == 0
            ? fmtInt(v.round())
            : v.toStringAsFixed(decimals);
        return Text('$prefix$t$suffix', style: style);
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(text, style: T.h2)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: accent.op(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: accent),
          ),
          const SizedBox(height: 16),
          Text(title, style: T.h2, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message, style: T.muted, textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: 220,
              child: GradientButton(label: actionLabel!, onPressed: onAction),
            ),
          ],
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: C.surface2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            FittedBox(child: Text(value, style: T.h2)),
            const SizedBox(height: 2),
            Text(
              label,
              style: T.small,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Painters ──

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final Color color;
  final int? selected;
  LineChartPainter(this.values, this.progress, this.color, this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = math.max(maxV - minV, 1.0);
    const pad = 14.0;
    final n = values.length;
    final pts = List.generate(n, (i) {
      final x = i / (n - 1) * size.width;
      final y =
          size.height -
          pad -
          (values[i] - minV) / range * (size.height - pad * 2);
      return Offset(x, y);
    });
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < n - 1; i++) {
      final a = pts[i], b = pts[i + 1];
      final mx = (a.dx + b.dx) / 2;
      line.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
    }
    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final grid = Paint()
      ..color = Colors.white.op(0.06)
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.op(0.35), color.op(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..color = color.op(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
    canvas.restore();

    if (selected != null && selected! < n) {
      final p = pts[selected!];
      canvas.drawLine(
        Offset(p.dx, 0),
        Offset(p.dx, size.height),
        Paint()
          ..color = Colors.white.op(0.25)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(p, 8, Paint()..color = color.op(0.3));
      canvas.drawCircle(p, 5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter old) =>
      old.progress != progress ||
      old.selected != selected ||
      old.values != values ||
      old.color != color;
}

class RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double stroke;
  RingPainter(this.progress, this.color, {this.stroke = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.white.op(0.08),
    );
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * c01(progress),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: math.pi * 2,
          colors: [color, C.pink],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter old) =>
      old.progress != progress || old.color != color;
}

class ConfettiPainter extends CustomPainter {
  final double t;
  final List<_Particle> parts;
  ConfettiPainter(this.t, this.parts);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.4);
    for (final p in parts) {
      final d = p.speed * t * 260;
      final pos =
          center +
          Offset(math.cos(p.angle) * d, math.sin(p.angle) * d + 340 * t * t);
      final paint = Paint()..color = p.color.op(c01(1.4 - t));
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.spin * t * 8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter old) => old.t != t;
}

class _Particle {
  final double angle, speed, size, spin;
  final Color color;
  _Particle(this.angle, this.speed, this.size, this.spin, this.color);
}

// ── Celebration dialog ──

Future<void> showCelebration(
  BuildContext context,
  String title,
  String subtitle,
) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Celebration',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (c, _, __) =>
        _CelebrationDialog(title: title, subtitle: subtitle),
    transitionBuilder: (c, a, _, child) => FadeTransition(
      opacity: a,
      child: ScaleTransition(
        scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
        child: child,
      ),
    ),
  );
}

class _CelebrationDialog extends StatefulWidget {
  final String title, subtitle;
  const _CelebrationDialog({required this.title, required this.subtitle});
  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();
  late final List<_Particle> _parts;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final r = math.Random(7);
    const cols = [C.violet, C.pink, C.cyan, C.green, C.amber];
    _parts = List.generate(
      40,
      (i) => _Particle(
        r.nextDouble() * math.pi * 2,
        0.4 + r.nextDouble() * 0.9,
        8 + r.nextDouble() * 8,
        r.nextDouble() * 2 - 1,
        cols[i % cols.length],
      ),
    );
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted && (ModalRoute.of(context)?.isCurrent ?? false))
        Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, __) =>
                    CustomPaint(painter: ConfettiPainter(_c.value, _parts)),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: accent.op(0.5)),
                  boxShadow: [BoxShadow(color: accent.op(0.4), blurRadius: 40)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: accentGradient(accent),
                      ),
                      child: const Icon(
                        Icons.celebration_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: T.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: T.muted,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// APP ROOT, ONBOARDING, SHELL
// ════════════════════════════════════════════════════════════════════════════

class GrowlyApp extends StatefulWidget {
  const GrowlyApp({super.key});
  @override
  State<GrowlyApp> createState() => _GrowlyAppState();
}

class _GrowlyAppState extends State<GrowlyApp> {
  final AppState _state = AppState();
  Color? _lastAccent;
  ThemeData? _theme;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          if (_lastAccent != _state.accent || _theme == null) {
            _lastAccent = _state.accent;
            _theme = buildTheme(_state.accent);
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Growly',
            theme: _theme,
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: _state.onboarded
                  ? const RootShell(key: ValueKey('shell'))
                  : const OnboardingScreen(key: ValueKey('onboarding')),
            ),
          );
        },
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _page = 0;

  static const _pages = [
    (
      Icons.insights_rounded,
      C.violet,
      'See your growth',
      'A beautiful dashboard with simulated analytics, charts and daily goals.',
    ),
    (
      Icons.travel_explore_rounded,
      C.cyan,
      'Discover creators',
      'Browse fictional profiles, save favorites and pick campaign targets.',
    ),
    (
      Icons.emoji_events_rounded,
      C.pink,
      'Play with campaigns',
      'Complete simulated tasks, earn XP and unlock badges. Everything is local and demo-only.',
    ),
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final last = _page == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: accentGradient(accent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Growly', style: T.h2),
                  const Spacer(),
                  const DemoBadge(),
                  TextButton(
                    onPressed: s.finishOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pc,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final p = _pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [p.$2.op(0.35), p.$2.op(0.04)],
                            ),
                            border: Border.all(color: p.$2.op(0.4)),
                          ),
                          child: Icon(p.$1, size: 64, color: p.$2),
                        ),
                        const SizedBox(height: 36),
                        Text(p.$3, style: T.h1, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(p.$4, style: T.muted, textAlign: TextAlign.center),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? accent : Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: last ? 'Get started' : 'Next',
                  icon: last
                      ? Icons.rocket_launch_rounded
                      : Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (last) {
                      s.finishOnboarding();
                    } else {
                      _pc.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Simulated demo. No accounts are connected.',
                style: T.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeC = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..value = 1;
  late final Animation<double> _fade = Tween<double>(
    begin: 0.2,
    end: 1,
  ).animate(CurvedAnimation(parent: _fadeC, curve: Curves.easeOut));
  AppState? _s;
  int _last = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_s == null) {
      _s = AppScope.read(context);
      _last = _s!.tab;
      _s!.addListener(_onState);
    }
  }

  void _onState() {
    if (_s != null && _s!.tab != _last) {
      _last = _s!.tab;
      if (mounted) _fadeC.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _s?.removeListener(_onState);
    _fadeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fade,
              child: IndexedStack(
                index: s.tab,
                children: const [
                  HomeScreen(),
                  DiscoverScreen(),
                  CampaignsScreen(),
                  RewardsScreen(),
                  ProfileScreen(),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: PressScale(
                onTap: () => showHelpSheet(context, s.tab),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: C.surface2,
                    shape: BoxShape.circle,
                    border: Border.all(color: C.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: C.amber,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: s.tab == 0
          ? FloatingActionButton.extended(
              onPressed: () => openWizard(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'New campaign',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: s.tab,
        onDestinationSelected: (i) {
          s.tap();
          s.setTab(i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_outlined),
            selectedIcon: Icon(Icons.rocket_launch_rounded),
            label: 'Campaigns',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

void showHelpSheet(BuildContext context, int tab) {
  const titles = [
    'Home tips',
    'Discover tips',
    'Campaign tips',
    'Rewards tips',
    'Profile tips',
  ];
  showAppSheet<void>(
    context,
    (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sheetHandle(),
            Row(
              children: [
                const Icon(Icons.lightbulb_rounded, color: C.amber),
                const SizedBox(width: 10),
                Text(titles[tab], style: T.h2),
              ],
            ),
            const SizedBox(height: 14),
            for (final t in kTips[tab])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: C.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t, style: T.body)),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            const SimNotice(
              'Growly is a local simulation. Nothing connects to Instagram, TikTok or any real account.',
            ),
          ],
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATIONS
// ════════════════════════════════════════════════════════════════════════════

void showNotifications(BuildContext context) {
  showAppSheet<void>(context, (_) => const _NotificationSheet());
}

class _NotificationSheet extends StatelessWidget {
  const _NotificationSheet();
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sheetHandle(),
              Row(
                children: [
                  const Expanded(child: Text('Notifications', style: T.h2)),
                  TextButton(
                    onPressed: s.unread == 0 ? null : s.markAllRead,
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
              if (!s.notificationsOn)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SimNotice(
                    'Notifications are turned off in Profile settings. New events will not be added.',
                  ),
                ),
              Flexible(
                child: s.notifications.isEmpty
                    ? const EmptyState(
                        icon: Icons.notifications_none_rounded,
                        title: 'All quiet',
                        message: 'New demo events will show up here.',
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: s.notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final n = s.notifications[i];
                          return AppCard(
                            padding: const EdgeInsets.all(12),
                            radius: 18,
                            color: n.read ? C.surface : C.surface2,
                            onTap: () => s.toggleRead(n.id),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: n.color.op(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(n.icon, color: n.color, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: n.read
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                          color: C.text,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(n.body, style: T.small),
                                      const SizedBox(height: 4),
                                      Text(
                                        n.time,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: C.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!n.read)
                                  Container(
                                    width: 9,
                                    height: 9,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — HOME
// ════════════════════════════════════════════════════════════════════════════

class _Metric {
  final String label, delta, detail, suffix;
  final IconData icon;
  final Color color;
  final double value;
  final int decimals;
  final bool positive;
  final List<MapEntry<String, double>> breakdown;
  const _Metric(
    this.label,
    this.icon,
    this.color,
    this.value,
    this.decimals,
    this.suffix,
    this.delta,
    this.positive,
    this.detail,
    this.breakdown,
  );
  String get valueText =>
      (decimals == 0
          ? fmtInt(value.round())
          : value.toStringAsFixed(decimals)) +
      suffix;
}

class GrowthChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  const GrowthChart({
    super.key,
    required this.values,
    required this.labels,
    required this.color,
  });
  @override
  State<GrowthChart> createState() => _GrowthChartState();
}

class _GrowthChartState extends State<GrowthChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();
  int? _sel;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _pick(double dx, double w) {
    final n = widget.values.length;
    final i = math.min(math.max(((dx / w) * (n - 1)).round(), 0), n - 1);
    if (i != _sel) setState(() => _sel = i);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _pick(d.localPosition.dx, w),
          onHorizontalDragUpdate: (d) => _pick(d.localPosition.dx, w),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (_, __) => CustomPaint(
                    painter: LineChartPainter(
                      widget.values,
                      Curves.easeOutCubic.transform(_c.value),
                      widget.color,
                      _sel,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: C.bg.op(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _sel == null
                        ? 'Tap or drag to explore'
                        : '${widget.labels[_sel!]} · ${fmtInt(widget.values[_sel!].round())}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: C.text,
                      fontWeight: FontWeight.w600,
                    ),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _period = 0;
  int _tick = 0;
  int? _bar;

  static const _labels = ['7D', '30D', '90D'];
  static const _growth = [0.018, 0.064, 0.182];
  static const _points = [7, 30, 45];
  static const _visits = [2340, 9870, 28450];
  static const _inter = [5120, 21300, 61900];
  static const _eng = [5.2, 4.9, 4.6];
  static const _weekly = [620, 740, 690, 910, 780, 1030, 350];
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<double> _series(double cur) {
    final n = _points[_period];
    final start = cur / (1 + _growth[_period]);
    return List.generate(n, (i) {
      final t = i / (n - 1);
      final base =
          start + (cur - start) * (t * t * (3 - 2 * t) * 0.55 + t * 0.45);
      final wig =
          math.sin(i * 1.7 + _period) *
          (cur - start) *
          0.12 *
          math.sin(t * math.pi);
      return base + wig;
    });
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _tick++);
    toast(
      context,
      'Demo data refreshed. Nothing was fetched from any account.',
      icon: Icons.sync_rounded,
      color: C.cyan,
    );
  }

  List<_Metric> _metrics(AppState s, double growth) {
    final p = _period;
    return [
      _Metric(
        'Followers',
        Icons.people_alt_rounded,
        C.violet,
        s.followers.toDouble(),
        0,
        '',
        '+${growth.toStringAsFixed(1)}%',
        true,
        'Simulated follower total for your demo profile. It grows slightly as you complete demo tasks.',
        const [
          MapEntry('Reels', 46),
          MapEntry('Carousels', 33),
          MapEntry('Stories', 21),
        ],
      ),
      _Metric(
        'Engagement rate',
        Icons.bolt_rounded,
        C.pink,
        _eng[p],
        1,
        '%',
        ['+0.4 pt', '+0.3 pt', '-0.1 pt'][p],
        p != 2,
        'Simulated interactions divided by reach over the selected period.',
        const [
          MapEntry('Likes', 62),
          MapEntry('Comments', 21),
          MapEntry('Shares', 10),
          MapEntry('Saves', 7),
        ],
      ),
      _Metric(
        'Profile visits',
        Icons.visibility_rounded,
        C.cyan,
        _visits[p].toDouble(),
        0,
        '',
        ['+12.4%', '+18.1%', '+31.5%'][p],
        true,
        'Simulated number of times your demo profile page was opened.',
        const [
          MapEntry('Search', 38),
          MapEntry('Hashtags', 34),
          MapEntry('Profile links', 28),
        ],
      ),
      _Metric(
        'Interactions',
        Icons.touch_app_rounded,
        C.green,
        _inter[p].toDouble(),
        0,
        '',
        ['+9.8%', '+14.2%', '+27.3%'][p],
        true,
        'Simulated total of likes, comments, shares and saves.',
        const [
          MapEntry('Reels', 49),
          MapEntry('Carousels', 31),
          MapEntry('Stories', 20),
        ],
      ),
    ];
  }

  void _showMetric(_Metric m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(m.icon, color: m.color),
            const SizedBox(width: 10),
            Expanded(child: Text(m.label, style: T.h2)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.valueText, style: T.h1),
              const SizedBox(height: 2),
              Text(
                '${m.delta} vs previous ${_labels[_period]} period',
                style: TextStyle(
                  fontSize: 12.5,
                  color: m.positive ? C.green : C.pink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(m.detail, style: T.muted),
              const SizedBox(height: 14),
              for (final e in m.breakdown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(e.key, style: T.body),
                          const Spacer(),
                          Text('${e.value.round()}%', style: T.small),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppProgress(
                        value: e.value / 100,
                        color: m.color,
                        height: 6,
                      ),
                    ],
                  ),
                ),
              const Text('Simulated sample data', style: T.small),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnalytics(List<_Metric> ms) {
    showAppSheet<void>(
      context,
      (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sheetHandle(),
              Text('Analytics · ${_labels[_period]}', style: T.h2),
              const SizedBox(height: 4),
              const Text(
                'Simulated metrics for the selected period.',
                style: T.small,
              ),
              const SizedBox(height: 14),
              for (final m in ms)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    radius: 16,
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showMetric(m);
                    },
                    child: Row(
                      children: [
                        Icon(m.icon, color: m.color),
                        const SizedBox(width: 12),
                        Expanded(child: Text(m.label, style: T.body)),
                        Text(m.valueText, style: T.h3),
                        const SizedBox(width: 8),
                        Text(
                          m.delta,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: m.positive ? C.green : C.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final series = _series(s.followers.toDouble());
    final growth = (series.last - series.first) / series.first * 100;
    final labels = List.generate(
      series.length,
      (i) => _period == 2 ? 'Day ${i * 2 + 1}' : 'Day ${i + 1}',
    );
    final metrics = _metrics(s, growth);
    final score = s.engagementScore;
    final goalValue = s.tasksToday / 5;

    return RefreshIndicator(
      color: accent,
      backgroundColor: C.surface2,
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: accentGradient(accent),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: accent.op(0.4), blurRadius: 16)],
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Growly', style: T.h2),
                    Text(
                      'Ready to grow, ${s.displayName.split(' ').first}?',
                      style: T.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Refresh demo data',
                onPressed: _refresh,
                icon: AnimatedRotation(
                  turns: _tick.toDouble(),
                  duration: const Duration(milliseconds: 600),
                  child: const Icon(Icons.refresh_rounded),
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () => showNotifications(context),
                    icon: const Icon(Icons.notifications_rounded),
                  ),
                  if (s.unread > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: C.pink,
                          shape: BoxShape.circle,
                          border: Border.all(color: C.bg, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              GestureDetector(
                onTap: () => s.setTab(4),
                child: ProfileAvatar(
                  seed: s.username,
                  label: s.displayName,
                  size: 38,
                  ring: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Hero card
          AppCard(
            radius: 28,
            padding: const EdgeInsets.all(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.op(0.3), C.surface],
            ),
            borderColor: accent.op(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(child: Text('Your growth overview', style: T.h3)),
                    DemoBadge(),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedNumber(s.followers.toDouble(), style: T.big),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text('followers', style: T.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: C.green.op(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            size: 14,
                            color: C.green,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${growth.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: C.green,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'last ${_labels[_period]} · simulated',
                      style: T.small,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: C.bg.op(0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              s.tap();
                              setState(() {
                                _period = i;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _period == i
                                    ? accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                _labels[i],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _period == i ? Colors.white : C.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 170,
                  child: GrowthChart(
                    key: ValueKey('chart$_period$_tick${s.followers}'),
                    values: series,
                    labels: labels,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),

          // Quick actions
          const SectionTitle('Quick actions'),
          Row(
            children: [
              _QuickAction(
                icon: Icons.explore_rounded,
                label: 'Discover',
                color: C.cyan,
                onTap: () => s.setTab(1),
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.rocket_launch_rounded,
                label: 'Campaigns',
                color: C.violet,
                onTap: () => s.setTab(2),
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.insights_rounded,
                label: 'Analytics',
                color: C.pink,
                onTap: () => _showAnalytics(metrics),
              ),
            ],
          ),

          // Metrics
          const SectionTitle('Performance'),
          Row(
            children: [
              Expanded(child: _metricCard(metrics[0])),
              const SizedBox(width: 12),
              Expanded(child: _metricCard(metrics[1])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _metricCard(metrics[2])),
              const SizedBox(width: 12),
              Expanded(child: _metricCard(metrics[3])),
            ],
          ),

          // Score
          const SectionTitle('Engagement score'),
          AppCard(
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  height: 92,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        key: ValueKey('ring$_tick'),
                        tween: Tween<double>(begin: 0, end: score / 100),
                        duration: const Duration(milliseconds: 1100),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, __) => CustomPaint(
                          size: const Size.square(92),
                          painter: RingPainter(v, accent),
                        ),
                      ),
                      Text('$score', style: T.h2),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score >= 85
                            ? 'Excellent'
                            : score >= 75
                            ? 'Strong'
                            : 'Building',
                        style: T.h3,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Rises as you complete campaign tasks. Simulated score out of 100.',
                        style: T.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daily goal
          const SectionTitle('Daily goal'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flag_rounded, color: C.amber, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Complete 5 campaign tasks', style: T.h3),
                    ),
                    Text('${math.min(s.tasksToday, 5)}/5', style: T.h3),
                  ],
                ),
                const SizedBox(height: 12),
                AppProgress(
                  value: goalValue,
                  color: goalValue >= 1 ? C.green : accent,
                  height: 10,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.tasksToday >= 5
                            ? 'Goal reached. Nice work today!'
                            : '${5 - s.tasksToday} more to go. Open an active campaign to continue.',
                        style: T.small,
                      ),
                    ),
                    TextButton(
                      onPressed: () => s.setTab(2),
                      child: const Text('Campaigns'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Weekly chart
          const SectionTitle('Weekly performance'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bar == null
                      ? 'Tap a bar for details'
                      : '${_days[_bar!]} · ${fmtInt(_weekly[_bar!])} interactions',
                  style: T.small,
                ),
                const SizedBox(height: 4),
                Text(
                  '${fmtInt(_weekly.fold(0, (a, b) => a + b))} interactions this week',
                  style: T.h3,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (var i = 0; i < 7; i++)
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              s.tap();
                              setState(() => _bar = i);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TweenAnimationBuilder<double>(
                                  key: ValueKey('bar$i$_tick'),
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: _weekly[i] / 1030,
                                  ),
                                  duration: Duration(
                                    milliseconds: 600 + i * 80,
                                  ),
                                  curve: Curves.easeOutCubic,
                                  builder: (_, v, __) => Container(
                                    height: 100 * v,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient:
                                          _bar == i || _bar == null && i == 5
                                          ? accentGradient(accent)
                                          : LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                accent.op(0.45),
                                                accent.op(0.2),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _days[i],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _bar == i ? C.text : C.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Activity
          const SectionTitle('Recent activity'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            child: Column(
              children: [
                for (var i = 0; i < math.min(6, s.activity.length); i++) ...[
                  _ActivityRow(item: s.activity[i]),
                  if (i < math.min(6, s.activity.length) - 1)
                    const Divider(height: 1, color: C.border),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'All activity shown is simulated for demo purposes.',
            style: T.small,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _metricCard(_Metric m) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      radius: 20,
      onTap: () => _showMetric(m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: m.color.op(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(m.icon, size: 18, color: m.color),
              ),
              const Spacer(),
              Text(
                m.delta,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: m.positive ? C.green : C.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedNumber(
              m.value,
              decimals: m.decimals,
              suffix: m.suffix,
              style: T.h1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            m.label,
            style: T.small,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PressScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.border),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.op(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: C.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;
  const _ActivityRow({required this.item});
  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final Color color;
    switch (item.type) {
      case ActType.follow:
        icon = Icons.person_add_alt_1_rounded;
        color = C.violet;
      case ActType.like:
        icon = Icons.favorite_rounded;
        color = C.pink;
      case ActType.comment:
        icon = Icons.chat_bubble_rounded;
        color = C.cyan;
      case ActType.save:
        icon = Icons.bookmark_rounded;
        color = C.amber;
      case ActType.system:
        icon = Icons.auto_awesome_rounded;
        color = C.green;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileAvatar(seed: item.who, label: item.who, size: 40),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: C.surface, width: 2),
                  ),
                  child: Icon(icon, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: T.body.copyWith(fontSize: 13.5),
                children: [
                  TextSpan(
                    text: item.who,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ' ${item.text}',
                    style: const TextStyle(color: C.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(item.time, style: const TextStyle(fontSize: 11, color: C.muted)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — DISCOVER
// ════════════════════════════════════════════════════════════════════════════

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _search = TextEditingController();
  String _category = 'All';
  int _sort = 0;
  bool _grid = true;
  bool _savedOnly = false;
  static const _sorts = ['Popular', 'Engagement', 'Recent'];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Profile> _results(AppState s) {
    final q = _search.text.trim().toLowerCase();
    final list = kProfiles.where((p) {
      final m =
          q.isEmpty ||
          p.username.toLowerCase().contains(q) ||
          p.name.toLowerCase().contains(q);
      final c = _category == 'All' || p.category == _category;
      final sv = !_savedOnly || s.bookmarks.contains(p.id);
      return m && c && sv;
    }).toList();
    switch (_sort) {
      case 0:
        list.sort((a, b) => b.followers.compareTo(a.followers));
      case 1:
        list.sort((a, b) => b.engagement.compareTo(a.engagement));
      case 2:
        list.sort((a, b) => a.joinedDaysAgo.compareTo(b.joinedDaysAgo));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final results = _results(s);
    final showFeatured =
        _search.text.isEmpty && _category == 'All' && !_savedOnly;
    final featured = kProfiles.reduce(
      (a, b) => a.engagement >= b.engagement ? a : b,
    );
    final saved = kProfiles.where((p) => s.bookmarks.contains(p.id)).toList();

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Discover', style: T.h1)),
                    const DemoBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore ${kProfiles.length} fictional creators',
                  style: T.muted,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search names or usernames',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: C.muted,
                    ),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(
                              Icons.close_rounded,
                              color: C.muted,
                            ),
                            onPressed: () {
                              _search.clear();
                              setState(() {});
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => AppChip(
                      label: kCategories[i],
                      selected: _category == kCategories[i],
                      onTap: () => setState(() => _category = kCategories[i]),
                    ),
                  ),
                ),
                if (showFeatured) ...[
                  const SectionTitle('Featured creator'),
                  AppCard(
                    radius: 26,
                    padding: const EdgeInsets.all(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent.op(0.35), C.surface],
                    ),
                    borderColor: accent.op(0.35),
                    onTap: () => showProfileSheet(context, featured),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(
                              seed: featured.username,
                              label: featured.name,
                              size: 58,
                              ring: true,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: C.amber,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'TOP ENGAGEMENT',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                          color: C.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    featured.name,
                                    style: T.h2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '@${featured.username}',
                                    style: T.small,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          featured.bio,
                          style: T.muted,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${compact(featured.followers)} followers · ${featured.engagement}% engagement',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: C.text,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (saved.isNotEmpty && !_savedOnly) ...[
                  const SectionTitle('Saved profiles'),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: saved.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, i) => GestureDetector(
                        onTap: () => showProfileSheet(context, saved[i]),
                        child: SizedBox(
                          width: 64,
                          child: Column(
                            children: [
                              ProfileAvatar(
                                seed: saved[i].username,
                                label: saved[i].name,
                                size: 54,
                                ring: true,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                saved[i].name.split(' ').first,
                                style: T.small,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var i = 0; i < _sorts.length; i++) ...[
                              AppChip(
                                label: _sorts[i],
                                selected: _sort == i,
                                onTap: () => setState(() => _sort = i),
                              ),
                              const SizedBox(width: 8),
                            ],
                            AppChip(
                              label: 'Saved',
                              icon: Icons.bookmark_rounded,
                              selected: _savedOnly,
                              onTap: () =>
                                  setState(() => _savedOnly = !_savedOnly),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: C.border),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Grid view',
                            onPressed: () => setState(() => _grid = true),
                            icon: Icon(
                              Icons.grid_view_rounded,
                              color: _grid ? accent : C.muted,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            tooltip: 'List view',
                            onPressed: () => setState(() => _grid = false),
                            icon: Icon(
                              Icons.view_list_rounded,
                              color: !_grid ? accent : C.muted,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
        if (results.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EmptyState(
                icon: _savedOnly
                    ? Icons.bookmark_border_rounded
                    : Icons.search_off_rounded,
                title: _savedOnly
                    ? 'No saved profiles yet'
                    : 'No creators found',
                message: _savedOnly
                    ? 'Tap the bookmark on any profile to save it here.'
                    : 'Try a different keyword or category.',
                actionLabel: 'Reset filters',
                onAction: () => setState(() {
                  _search.clear();
                  _category = 'All';
                  _savedOnly = false;
                }),
              ),
            ),
          )
        else if (_grid)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 182,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ProfileCard(profile: results[i], grid: true),
                childCount: results.length,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProfileCard(profile: results[i], grid: false),
                ),
                childCount: results.length,
              ),
            ),
          ),
      ],
    );
  }
}

void toggleSave(BuildContext context, Profile p) {
  final s = AppScope.read(context);
  final ev = s.toggleBookmark(p);
  toast(
    context,
    ev.ok ? 'Saved @${p.username}' : 'Removed @${p.username} from saved',
    icon: ev.ok ? Icons.bookmark_rounded : Icons.bookmark_remove_rounded,
    color: C.amber,
  );
  celebrate(context, ev);
}

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool grid;
  const ProfileCard({super.key, required this.profile, required this.grid});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final p = profile;
    final saved = s.bookmarks.contains(p.id);
    final cc = categoryColor(p.category);
    final bookmark = IconButton(
      tooltip: saved ? 'Remove bookmark' : 'Bookmark',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: Icon(
        saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: saved ? accent : C.muted,
      ),
      onPressed: () => toggleSave(context, p),
    );
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cc.op(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        p.category,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cc),
      ),
    );

    if (grid) {
      return AppCard(
        padding: const EdgeInsets.all(12),
        radius: 20,
        onTap: () => showProfileSheet(context, p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(seed: p.username, label: p.name, size: 44),
                const Spacer(),
                bookmark,
              ],
            ),
            const SizedBox(height: 6),
            Text(
              p.name,
              style: T.h3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '@${p.username}',
              style: T.small,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            pill,
            const Spacer(),
            Text(
              '${compact(p.followers)} · ${p.engagement}% eng.',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: C.text,
              ),
            ),
          ],
        ),
      );
    }
    return AppCard(
      padding: const EdgeInsets.all(14),
      radius: 20,
      onTap: () => showProfileSheet(context, p),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(seed: p.username, label: p.name, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        p.name,
                        style: T.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    pill,
                  ],
                ),
                Text(
                  '@${p.username}',
                  style: T.small,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  p.bio,
                  style: T.muted.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${compact(p.followers)} followers · ${p.engagement}% engagement',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: C.text,
                  ),
                ),
              ],
            ),
          ),
          bookmark,
        ],
      ),
    );
  }
}

void showProfileSheet(BuildContext context, Profile p) {
  showAppSheet<void>(context, (_) => _ProfileSheet(profile: p));
}

class _ProfileSheet extends StatelessWidget {
  final Profile profile;
  const _ProfileSheet({required this.profile});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final p = profile;
    final saved = s.bookmarks.contains(p.id);
    final selected = s.selectedTarget?.id == p.id;
    final avgLikes = (p.followers * p.engagement / 100).round();
    final cc = categoryColor(p.category);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sheetHandle(),
            ProfileAvatar(
              seed: p.username,
              label: p.name,
              size: 84,
              ring: true,
            ),
            const SizedBox(height: 12),
            Text(p.name, style: T.h1, textAlign: TextAlign.center),
            Text('@${p.username}', style: T.muted),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: cc.op(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                p.category,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cc,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatTile(
                  label: 'Followers',
                  value: compact(p.followers),
                  icon: Icons.people_alt_rounded,
                  color: C.violet,
                ),
                const SizedBox(width: 10),
                StatTile(
                  label: 'Engagement',
                  value: '${p.engagement}%',
                  icon: Icons.bolt_rounded,
                  color: C.pink,
                ),
                const SizedBox(width: 10),
                StatTile(
                  label: 'Avg. reactions',
                  value: compact(avgLikes),
                  icon: Icons.favorite_rounded,
                  color: C.cyan,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(p.bio, style: T.body, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const SimNotice(
              'Fictional demo profile. It is not a real or verified account.',
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => toggleSave(context, p),
                    icon: Icon(
                      saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: saved ? accent : C.text,
                    ),
                    label: Text(saved ? 'Saved' : 'Save'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    label: selected ? 'Selected' : 'Use as target',
                    icon: selected
                        ? Icons.check_rounded
                        : Icons.rocket_launch_rounded,
                    onPressed: () {
                      s.selectTarget(p);
                      final nav = Navigator.of(context);
                      toast(
                        context,
                        '@${p.username} selected as campaign target',
                        icon: Icons.rocket_launch_rounded,
                        color: accent,
                        actionLabel: 'Create',
                        onAction: () => openWizard(nav.context),
                      );
                      nav.pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 3 — CAMPAIGNS
// ════════════════════════════════════════════════════════════════════════════

void openWizard(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => const CampaignWizardPage(),
    ),
  );
}

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});
  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  int _filter = 0;
  static const _filters = ['All', 'Active', 'Paused', 'Completed', 'Archived'];

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final list = s.campaigns.where((c) {
      switch (_filter) {
        case 0:
          return c.status != CampaignStatus.archived;
        case 1:
          return c.status == CampaignStatus.active;
        case 2:
          return c.status == CampaignStatus.paused;
        case 3:
          return c.status == CampaignStatus.completed;
        default:
          return c.status == CampaignStatus.archived;
      }
    }).toList();
    final totalTasks = s.campaigns.fold(0, (a, c) => a + c.tasks.length);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const Row(
          children: [
            Expanded(child: Text('Campaigns', style: T.h1)),
            DemoBadge(),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Engagement studio · simulated locally', style: T.muted),
        const SizedBox(height: 16),
        GradientButton(
          label: 'Create campaign',
          icon: Icons.add_rounded,
          onPressed: () => openWizard(context),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            StatTile(
              label: 'Active',
              value: '${s.activeCount}',
              icon: Icons.play_circle_rounded,
              color: C.green,
            ),
            const SizedBox(width: 10),
            StatTile(
              label: 'Completed',
              value: '${s.completedCount}',
              icon: Icons.flag_rounded,
              color: C.cyan,
            ),
            const SizedBox(width: 10),
            StatTile(
              label: 'Tasks done',
              value: '${s.totalTasksDone}/$totalTasks',
              icon: Icons.task_alt_rounded,
              color: accent,
            ),
          ],
        ),
        const SizedBox(height: 14),
        const SimNotice(
          'Campaigns, tasks and results are simulated on this device. Nothing is posted, followed or sent to any real account.',
        ),
        const SectionTitle('Studio tools'),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                icon: Icons.forum_rounded,
                color: C.pink,
                title: 'Comment Studio',
                subtitle: '12 ideas · drafts',
                onTap: () => Navigator.push(
                  context,
                  slideRoute(const InspirationPage(initialTab: 0)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToolCard(
                icon: Icons.tag_rounded,
                color: C.green,
                title: 'Hashtag Lab',
                subtitle: 'Sample tag sets',
                onTap: () => Navigator.push(
                  context,
                  slideRoute(const InspirationPage(initialTab: 1)),
                ),
              ),
            ),
          ],
        ),
        const SectionTitle('Your campaigns'),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => AppChip(
              label: _filters[i],
              selected: _filter == i,
              onTap: () => setState(() => _filter = i),
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          EmptyState(
            icon: Icons.rocket_launch_rounded,
            title: _filter == 0
                ? 'No campaigns yet'
                : 'Nothing in ${_filters[_filter]}',
            message: _filter == 0
                ? 'Create your first simulated campaign to start earning XP.'
                : 'Campaigns with this status will appear here.',
            actionLabel: 'Create campaign',
            onAction: () => openWizard(context),
          )
        else
          for (final c in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CampaignCard(campaign: c),
            ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  const _ToolCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      radius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.op(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: T.h3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: T.small,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  const CampaignCard({super.key, required this.campaign});
  @override
  Widget build(BuildContext context) {
    final c = campaign;
    return AppCard(
      onTap: () =>
          Navigator.push(context, slideRoute(CampaignDetailPage(id: c.id))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.type.color.op(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(c.type.icon, color: c.type.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: T.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '@${c.targetUsername} · ${c.type.label}',
                      style: T.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(c.status),
            ],
          ),
          const SizedBox(height: 14),
          AppProgress(value: c.progress, color: c.type.color),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${c.done}/${c.tasks.length} tasks', style: T.small),
              const Spacer(),
              Text(
                '+${c.done * kTaskXp} XP',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: C.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Campaign detail ──

class CampaignDetailPage extends StatelessWidget {
  final String id;
  const CampaignDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final matches = s.campaigns.where((c) => c.id == id);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Campaign not found', style: T.muted)),
      );
    }
    final c = matches.first;
    final accent = Theme.of(context).colorScheme.primary;
    final active = c.status == CampaignStatus.active;

    Future<void> complete(int i) async {
      if (!active) {
        toast(
          context,
          c.status == CampaignStatus.paused
              ? 'Resume the campaign to complete tasks.'
              : 'Tasks are locked for this campaign.',
          icon: Icons.lock_rounded,
          color: C.amber,
        );
        return;
      }
      final ev = s.completeTask(c, i);
      if (!ev.ok) return;
      s.tap();
      toast(
        context,
        '+${ev.xp} XP · task completed (simulated)',
        icon: Icons.bolt_rounded,
        color: C.amber,
      );
      celebrate(context, ev);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (c.status == CampaignStatus.active ||
              c.status == CampaignStatus.paused)
            IconButton(
              tooltip: active ? 'Pause' : 'Resume',
              icon: Icon(
                active ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
              ),
              onPressed: () {
                s.setStatus(
                  c,
                  active ? CampaignStatus.paused : CampaignStatus.active,
                );
                toast(
                  context,
                  active ? 'Campaign paused' : 'Campaign resumed',
                  icon: active
                      ? Icons.pause_circle_rounded
                      : Icons.play_circle_rounded,
                  color: C.amber,
                );
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          AppCard(
            radius: 26,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.type.color.op(0.28), C.surface],
            ),
            borderColor: c.type.color.op(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(c.type.icon, color: c.type.color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(c.type.label, style: T.h3)),
                    StatusChip(c.status),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    AnimatedNumber(
                      c.progress * 100,
                      suffix: '%',
                      style: T.big.copyWith(fontSize: 34),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${c.done} of ${c.tasks.length} tasks done',
                        style: T.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppProgress(value: c.progress, color: c.type.color, height: 10),
                if (c.description.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(c.description, style: T.body),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    ProfileAvatar(
                      seed: c.targetUsername,
                      label: c.targetName,
                      size: 36,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.targetName,
                            style: T.h3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@${c.targetUsername} · ${c.category}',
                            style: T.small,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const SimNotice(
            'Task completion and XP are simulated locally. No real interaction happens on any platform.',
          ),
          if (!active)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: C.amber.op(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_rounded, color: C.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        c.status == CampaignStatus.paused
                            ? 'Paused. Resume to complete tasks.'
                            : c.status == CampaignStatus.completed
                            ? 'Completed. All tasks are done.'
                            : 'Archived. Restore it to continue.',
                        style: const TextStyle(color: C.amber, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SectionTitle('Tasks'),
          for (var i = 0; i < c.tasks.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                radius: 18,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                color: c.tasks[i].done ? C.surface2 : C.surface,
                onTap: c.tasks[i].done ? null : () => complete(i),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        c.tasks[i].done
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        key: ValueKey(c.tasks[i].done),
                        color: c.tasks[i].done
                            ? C.green
                            : (active ? accent : C.muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        c.tasks[i].title,
                        style: TextStyle(
                          fontSize: 14,
                          color: c.tasks[i].done ? C.muted : C.text,
                          decoration: c.tasks[i].done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Text(
                      '+$kTaskXp XP',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: c.tasks[i].done ? C.muted : C.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SectionTitle('Tools for this campaign'),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    slideRoute(const InspirationPage(initialTab: 0)),
                  ),
                  icon: const Icon(Icons.forum_rounded, size: 18),
                  label: const Text('Comments'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    slideRoute(const InspirationPage(initialTab: 1)),
                  ),
                  icon: const Icon(Icons.tag_rounded, size: 18),
                  label: const Text('Hashtags'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (c.status == CampaignStatus.archived)
            OutlinedButton.icon(
              onPressed: () {
                s.setStatus(
                  c,
                  c.done == c.tasks.length
                      ? CampaignStatus.completed
                      : CampaignStatus.paused,
                );
                toast(
                  context,
                  'Campaign restored',
                  icon: Icons.unarchive_rounded,
                  color: C.cyan,
                );
              },
              icon: const Icon(Icons.unarchive_rounded),
              label: const Text('Restore campaign'),
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: C.pink,
                side: BorderSide(color: C.pink.op(0.4)),
              ),
              onPressed: () async {
                final ok = await showConfirm(
                  context,
                  title: 'Archive campaign?',
                  message:
                      '"${c.name}" will move to the Archived filter. You can restore it later.',
                  confirmLabel: 'Archive',
                  destructive: true,
                );
                if (!ok || !context.mounted) return;
                s.setStatus(c, CampaignStatus.archived);
                toast(
                  context,
                  'Campaign archived',
                  icon: Icons.archive_rounded,
                  color: C.muted,
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.archive_rounded),
              label: const Text('Archive campaign'),
            ),
        ],
      ),
    );
  }
}

// ── Campaign wizard ──

class CampaignWizardPage extends StatefulWidget {
  const CampaignWizardPage({super.key});
  @override
  State<CampaignWizardPage> createState() => _CampaignWizardPageState();
}

class _CampaignWizardPageState extends State<CampaignWizardPage> {
  int _step = 0;
  CampaignType? _type;
  Profile? _profile;
  bool _manualMode = false;
  double _count = 5;
  String _category = 'Tech';
  bool _launching = false;
  bool _launched = false;
  final _manual = TextEditingController();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _manualKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  static final _userRe = RegExp(r'^[A-Za-z0-9_.]{2,30}$');
  static const _stepTitles = [
    'Choose a type',
    'Select a target',
    'Configure',
    'Review & launch',
  ];

  @override
  void initState() {
    super.initState();
    _profile = AppScope.read(context).selectedTarget;
    if (_profile != null) _category = _profile!.category;
  }

  @override
  void dispose() {
    _manual.dispose();
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  String get _cleanManual => _manual.text.trim().replaceFirst('@', '');
  String get _targetUsername =>
      _manualMode ? _cleanManual : (_profile?.username ?? '');
  String get _targetName =>
      _manualMode ? '@$_cleanManual' : (_profile?.name ?? '');

  void _snack(String m) =>
      toast(context, m, icon: Icons.error_rounded, color: C.pink);

  void _next() {
    FocusScope.of(context).unfocus();
    switch (_step) {
      case 0:
        if (_type == null) return _snack('Choose a campaign type to continue.');
      case 1:
        if (_manualMode) {
          if (!(_manualKey.currentState?.validate() ?? false)) return;
        } else if (_profile == null) {
          return _snack('Select a profile or enter a sample username.');
        }
        if (_name.text.trim().isEmpty && _type != null) {
          _name.text = '${_type!.label} · @$_targetUsername';
        }
      case 2:
        if (!(_nameKey.currentState?.validate() ?? false)) return;
      case 3:
        _launch();
        return;
    }
    setState(() => _step++);
  }

  Future<void> _launch() async {
    if (_launching) return;
    setState(() => _launching = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppScope.read(context).launchCampaign(
      type: _type!,
      name: _name.text,
      targetName: _targetName,
      targetUsername: _targetUsername,
      category: _category,
      description: _desc.text,
      count: _count.round(),
    );
    setState(() {
      _launching = false;
      _launched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    if (_launched) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.elasticOut,
                  builder: (_, v, __) => Transform.scale(
                    scale: v,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: accentGradient(accent),
                        boxShadow: [
                          BoxShadow(color: accent.op(0.5), blurRadius: 40),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Campaign launched', style: T.h1),
                const SizedBox(height: 8),
                const Text(
                  'Your simulated campaign is live. Complete its tasks to earn XP.',
                  style: T.muted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: 'View campaigns',
                    icon: Icons.rocket_launch_rounded,
                    onPressed: () {
                      final s = AppScope.read(context);
                      s.selectTarget(null);
                      s.setTab(2);
                      Navigator.of(context).pop();
                      toast(
                        context,
                        '"${_name.text.trim()}" added to Campaigns',
                        icon: Icons.rocket_launch_rounded,
                        color: accent,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: !_launching,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _launching ? null : () => Navigator.of(context).pop(),
          ),
          title: Text(_stepTitles[_step]),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  for (var i = 0; i < 4; i++)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 5,
                        margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: i <= _step ? accent : Colors.white12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(a),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _stepBody(context),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: C.surface,
                border: Border(top: BorderSide(color: C.border)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    if (_step > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _launching
                              ? null
                              : () => setState(() => _step--),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        label: _launching
                            ? 'Launching…'
                            : (_step == 3 ? 'Launch campaign' : 'Continue'),
                        icon: _step == 3
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: _launching ? null : _next,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context) {
    switch (_step) {
      case 0:
        return _typeStep();
      case 1:
        return _targetStep();
      case 2:
        return _configStep();
      default:
        return _reviewStep();
    }
  }

  Widget _typeStep() {
    final accent = Theme.of(context).colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('What do you want to explore?', style: T.h2),
        const SizedBox(height: 4),
        const Text(
          'All campaign types are simulated learning exercises.',
          style: T.muted,
        ),
        const SizedBox(height: 16),
        for (final t in CampaignType.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              radius: 20,
              borderColor: _type == t ? t.color : C.border,
              color: _type == t ? t.color.op(0.1) : C.surface,
              onTap: () => setState(() => _type = t),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: t.color.op(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(t.icon, color: t.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.label, style: T.h3),
                        const SizedBox(height: 2),
                        Text(t.blurb, style: T.small),
                      ],
                    ),
                  ),
                  Icon(
                    _type == t
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: _type == t ? accent : C.muted,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _targetStep() {
    final accent = Theme.of(context).colorScheme.primary;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: AppChip(
                label: 'Pick from Discover',
                selected: !_manualMode,
                onTap: () => setState(() => _manualMode = false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppChip(
                label: 'Enter username',
                selected: _manualMode,
                onTap: () => setState(() => _manualMode = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_manualMode) ...[
          Form(
            key: _manualKey,
            child: TextFormField(
              controller: _manual,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'sample_username',
                prefixText: '@ ',
              ),
              validator: (v) {
                final t = (v ?? '').trim().replaceFirst('@', '');
                if (t.isEmpty) return 'Enter a sample username';
                if (!_userRe.hasMatch(t))
                  return '2–30 characters: letters, numbers, _ or .';
                return null;
              },
            ),
          ),
          const SizedBox(height: 14),
          if (_userRe.hasMatch(_cleanManual))
            AppCard(
              radius: 18,
              child: Row(
                children: [
                  ProfileAvatar(
                    seed: _cleanManual,
                    label: _cleanManual,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@$_cleanManual',
                          style: T.h3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          'Sample username · no real account lookup',
                          style: T.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ] else ...[
          if (_profile != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AppCard(
                radius: 22,
                borderColor: accent,
                gradient: LinearGradient(colors: [accent.op(0.2), C.surface]),
                child: Row(
                  children: [
                    ProfileAvatar(
                      seed: _profile!.username,
                      label: _profile!.name,
                      size: 52,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profile!.name,
                            style: T.h3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@${_profile!.username} · ${_profile!.category}',
                            style: T.small,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${compact(_profile!.followers)} followers · ${_profile!.engagement}% eng.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: C.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: C.green),
                  ],
                ),
              ),
            ),
          for (final p in kProfiles)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                radius: 16,
                padding: const EdgeInsets.all(10),
                borderColor: _profile?.id == p.id ? accent : C.border,
                onTap: () => setState(() {
                  _profile = p;
                  _category = p.category;
                }),
                child: Row(
                  children: [
                    ProfileAvatar(seed: p.username, label: p.name, size: 38),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: T.h3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@${p.username}',
                            style: T.small,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(compact(p.followers), style: T.small),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _configStep() {
    final accent = Theme.of(context).colorScheme.primary;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom * 0,
      ),
      children: [
        Form(
          key: _nameKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Campaign name', style: T.h3),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                maxLength: 40,
                onChanged: (_) => setState(() {}),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. Flutter creators sweep',
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Give your campaign a name';
                  if (t.length < 3) return 'Use at least 3 characters';
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: Text('Simulated tasks', style: T.h3)),
            Text('${_count.round()}', style: T.h2),
          ],
        ),
        Slider(
          value: _count,
          min: 3,
          max: 10,
          divisions: 7,
          label: '${_count.round()}',
          onChanged: (v) => setState(() => _count = v),
        ),
        const SizedBox(height: 8),
        const Text('Category', style: T.h3),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in kCategories.skip(1))
              AppChip(
                label: c,
                selected: _category == c,
                onTap: () => setState(() => _category = c),
              ),
          ],
        ),
        const SizedBox(height: 18),
        const Text('Description (optional)', style: T.h3),
        const SizedBox(height: 8),
        TextField(
          controller: _desc,
          maxLength: 140,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'What do you want to learn?',
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          radius: 18,
          borderColor: accent.op(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIVE SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: C.muted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _name.text.trim().isEmpty
                    ? 'Untitled campaign'
                    : _name.text.trim(),
                style: T.h3,
              ),
              const SizedBox(height: 4),
              Text(
                '${_type?.label ?? ''} · @$_targetUsername · ${_count.round()} tasks · $_category',
                style: T.small,
              ),
              const SizedBox(height: 4),
              Text(
                'Potential: ${_count.round() * kTaskXp + kFinishBonus} XP (simulated)',
                style: const TextStyle(
                  color: C.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewStep() {
    Widget row(String l, String v, int step) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 92, child: Text(l, style: T.small)),
          Expanded(child: Text(v, style: T.body)),
          GestureDetector(
            onTap: () => setState(() => _step = step),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.edit_rounded, size: 16, color: C.muted),
            ),
          ),
        ],
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Everything look right?', style: T.h2),
        const SizedBox(height: 14),
        AppCard(
          radius: 22,
          child: Column(
            children: [
              row('Type', _type?.label ?? '', 0),
              const Divider(height: 1, color: C.border),
              row(
                'Target',
                _manualMode
                    ? '@$_cleanManual (sample username)'
                    : '${_profile?.name} (@${_profile?.username})',
                1,
              ),
              const Divider(height: 1, color: C.border),
              row('Name', _name.text.trim(), 2),
              const Divider(height: 1, color: C.border),
              row('Tasks', '${_count.round()} simulated tasks', 2),
              const Divider(height: 1, color: C.border),
              row('Category', _category, 2),
              if (_desc.text.trim().isNotEmpty) ...[
                const Divider(height: 1, color: C.border),
                row('Notes', _desc.text.trim(), 2),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SimNotice(
          'Launching creates a local, simulated campaign. It will not follow, comment on, or contact any real account.',
        ),
      ],
    );
  }
}

// ── Comment Studio & Hashtag Lab ──

class InspirationPage extends StatefulWidget {
  final int initialTab;
  const InspirationPage({super.key, this.initialTab = 0});
  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.initialTab,
  );
  final TextEditingController _draft = TextEditingController();
  String _tone = 'All';
  int _regen = 0;
  String _tagGroup = 'All';

  @override
  void dispose() {
    _tabs.dispose();
    _draft.dispose();
    super.dispose();
  }

  List<Comment> get _pool =>
      kComments.where((c) => _tone == 'All' || c.tone == _tone).toList();

  void _regenerate() {
    final pool = _pool;
    if (pool.isEmpty) return;
    setState(() {
      _draft.text = pool[_regen % pool.length].text;
      _regen++;
    });
    AppScope.read(context).tap();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspiration Lab'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: C.text,
          unselectedLabelColor: C.muted,
          dividerColor: C.border,
          tabs: [
            const Tab(text: 'Comments'),
            const Tab(text: 'Hashtags'),
            Tab(text: 'Favorites (${s.favoriteDrafts.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [_commentsTab(s), _hashtagsTab(), _favoritesTab(s)],
      ),
    );
  }

  Widget _commentsTab(AppState s) {
    final accent = Theme.of(context).colorScheme.primary;
    final list = _pool;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        const SimNotice(
          'These are writing prompts only. Edit them into your own voice. Nothing is posted anywhere, and copying is local.',
        ),
        const SizedBox(height: 14),
        AppCard(
          radius: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your draft', style: T.h3),
              const SizedBox(height: 10),
              TextField(
                controller: _draft,
                maxLines: 3,
                maxLength: 220,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Write or generate a comment…',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'PREVIEW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: C.muted,
                ),
              ),
              const SizedBox(height: 8),
              ListenableBuilder(
                listenable: _draft,
                builder: (context, _) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: C.bg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileAvatar(
                        seed: s.username,
                        label: s.displayName,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: C.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _draft.text.trim().isEmpty
                                  ? 'Your draft preview appears here (local only).'
                                  : _draft.text.trim(),
                              style: TextStyle(
                                fontSize: 13.5,
                                color: _draft.text.trim().isEmpty
                                    ? C.muted
                                    : C.text,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _regenerate,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Regenerate'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    tooltip: 'Add to favorites',
                    onPressed: () {
                      if (_draft.text.trim().isEmpty)
                        return toast(
                          context,
                          'Write a draft first.',
                          icon: Icons.edit_rounded,
                          color: C.amber,
                        );
                      final added = s.addFavorite(_draft.text);
                      toast(
                        context,
                        added
                            ? 'Draft added to favorites'
                            : 'Already in favorites',
                        icon: Icons.star_rounded,
                        color: C.amber,
                      );
                    },
                    icon: const Icon(Icons.star_border_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Copy draft',
                    style: IconButton.styleFrom(backgroundColor: accent),
                    onPressed: () {
                      if (_draft.text.trim().isEmpty)
                        return toast(
                          context,
                          'Nothing to copy yet.',
                          icon: Icons.edit_rounded,
                          color: C.amber,
                        );
                      copyText(
                        context,
                        _draft.text.trim(),
                        label: 'Draft copied',
                      );
                    },
                    icon: const Icon(Icons.copy_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SectionTitle('Ideas by tone'),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kTones.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final t = i == 0 ? 'All' : kTones[i - 1];
              return AppChip(
                label: t,
                selected: _tone == t,
                onTap: () => setState(() {
                  _tone = t;
                  _regen = 0;
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        for (final c in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              radius: 18,
              padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.tone.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: _toneColor(c.tone),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(c.text, style: T.body),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() => _draft.text = c.text);
                            toast(
                              context,
                              'Loaded into your draft',
                              icon: Icons.edit_rounded,
                              color: accent,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'Use as draft',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: () => copyText(context, c.text),
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 20,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Color _toneColor(String t) {
    switch (t) {
      case 'Supportive':
        return C.green;
      case 'Educational':
        return C.cyan;
      case 'Creative':
        return C.pink;
      default:
        return C.amber;
    }
  }

  Widget _hashtagsTab() {
    final groups = kHashtagGroups.entries
        .where((e) => _tagGroup == 'All' || e.key == _tagGroup)
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        const SimNotice(
          'Usage bars are simulated sample values, not live hashtag statistics. Always check current trends yourself.',
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kHashtagGroups.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final g = i == 0 ? 'All' : kHashtagGroups.keys.elementAt(i - 1);
              return AppChip(
                label: g,
                selected: _tagGroup == g,
                onTap: () => setState(() => _tagGroup = g),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        for (final g in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AppCard(
              radius: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('${g.key} set', style: T.h3)),
                      TextButton.icon(
                        onPressed: () => copyText(
                          context,
                          g.value.join(' '),
                          label: '${g.key} set copied',
                        ),
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('Copy all'),
                      ),
                    ],
                  ),
                  for (final tag in g.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              tag,
                              style: T.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: AppProgress(
                              value: simulatedUsage(tag),
                              color: C.green,
                              height: 6,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Copy $tag',
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                copyText(context, tag, label: '$tag copied'),
                            icon: const Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _favoritesTab(AppState s) {
    if (s.favoriteDrafts.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          EmptyState(
            icon: Icons.star_border_rounded,
            title: 'No favorite drafts',
            message: 'Write a comment draft and tap the star to keep it here.',
            actionLabel: 'Write a draft',
            onAction: () => _tabs.animateTo(0),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        for (final f in s.favoriteDrafts)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              radius: 18,
              padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.star_rounded, color: C.amber, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(f, style: T.body)),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: () => copyText(context, f),
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 20,
                      color: C.muted,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove',
                    onPressed: () {
                      s.removeFavorite(f);
                      toast(
                        context,
                        'Removed from favorites',
                        icon: Icons.delete_outline_rounded,
                        color: C.muted,
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 4 — REWARDS
// ════════════════════════════════════════════════════════════════════════════

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _board = 0;

  void _showBadge(AppState s, Achievement a) {
    final v = s.achievementValue(a);
    final unlocked = s.isUnlocked(a);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked ? a.color.op(0.2) : Colors.white10,
                border: Border.all(
                  color: unlocked ? a.color : C.border,
                  width: 2,
                ),
              ),
              child: Icon(
                unlocked ? a.icon : Icons.lock_rounded,
                size: 36,
                color: unlocked ? a.color : C.muted,
              ),
            ),
            const SizedBox(height: 14),
            Text(a.title, style: T.h2),
            const SizedBox(height: 6),
            Text(a.desc, style: T.muted, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            AppProgress(value: v / a.target, color: a.color),
            const SizedBox(height: 6),
            Text(
              unlocked
                  ? 'Unlocked'
                  : 'Progress ${math.min(v, a.target)}/${a.target}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: unlocked ? C.green : C.muted,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final base = _board == 0 ? kWeeklyBoard : kAllTimeBoard;
    final rows = <MapEntry<String, int>>[
      ...base,
      MapEntry('You', _board == 0 ? s.weeklyXp : s.xp),
    ]..sort((a, b) => b.value.compareTo(a.value));
    final unlockedCount = kAchievements.where(s.isUnlocked).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const Row(
          children: [
            Expanded(child: Text('Rewards', style: T.h1)),
            DemoBadge(),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          radius: 28,
          padding: const EdgeInsets.all(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent.op(0.3), C.surface],
          ),
          borderColor: accent.op(0.3),
          child: Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: s.levelProgress),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, __) => CustomPaint(
                        size: const Size.square(96),
                        painter: RingPainter(v, accent, stroke: 9),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'LVL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: C.muted,
                            letterSpacing: 1,
                          ),
                        ),
                        Text('${s.level}', style: T.h1),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedNumber(s.xp.toDouble(), suffix: ' XP', style: T.h1),
                    const SizedBox(height: 4),
                    Text(
                      '${s.xpToNext} XP to level ${s.level + 1}',
                      style: T.muted,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$unlockedCount/${kAchievements.length} badges unlocked',
                      style: T.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFB923C),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${s.streak}-day streak', style: T.h3)),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: s.checkedIn
                        ? null
                        : () {
                            s.checkIn();
                            s.tap();
                            toast(
                              context,
                              'Checked in · +25 XP',
                              icon: Icons.local_fire_department_rounded,
                              color: const Color(0xFFFB923C),
                            );
                            showCelebration(
                              context,
                              '${s.streak}-day streak!',
                              'Daily check-in +25 XP',
                            );
                          },
                    child: Text(s.checkedIn ? 'Checked in' : 'Check in'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < math.min(s.streak, 7)
                                  ? const Color(0xFFFB923C)
                                  : Colors.white10,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: i < math.min(s.streak, 7)
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                            style: T.small,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SectionTitle('Daily challenges'),
        for (final c in kChallenges.where((c) => !c.weekly))
          _challengeTile(s, c),
        const SectionTitle('Weekly challenges'),
        for (final c in kChallenges.where((c) => c.weekly))
          _challengeTile(s, c),
        SectionTitle(
          'Badges',
          trailing: Text(
            '$unlockedCount/${kAchievements.length}',
            style: T.small,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kAchievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 122,
          ),
          itemBuilder: (context, i) {
            final a = kAchievements[i];
            final u = s.isUnlocked(a);
            return AppCard(
              radius: 18,
              padding: const EdgeInsets.all(10),
              borderColor: u ? a.color.op(0.5) : C.border,
              onTap: () => _showBadge(s, a),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: u ? a.color.op(0.18) : Colors.white10,
                    ),
                    child: Icon(
                      u ? a.icon : Icons.lock_rounded,
                      color: u ? a.color : C.muted,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.title,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: u ? C.text : C.muted,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
        SectionTitle(
          'Leaderboard',
          trailing: const Text('Fictional users', style: T.small),
        ),
        Row(
          children: [
            Expanded(
              child: AppChip(
                label: 'Weekly',
                selected: _board == 0,
                onTap: () => setState(() => _board = 0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppChip(
                label: 'All-time',
                selected: _board == 1,
                onTap: () => setState(() => _board = 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                _boardRow(i + 1, rows[i], rows[i].key == 'You', accent),
                if (i < rows.length - 1)
                  const Divider(height: 1, color: C.border),
              ],
            ],
          ),
        ),
        const SectionTitle('Rewards history'),
        if (s.history.isEmpty)
          const EmptyState(
            icon: Icons.history_rounded,
            title: 'No rewards yet',
            message: 'Complete tasks and challenges to earn XP.',
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            child: Column(
              children: [
                for (var i = 0; i < math.min(8, s.history.length); i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: C.amber.op(0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            size: 18,
                            color: C.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.history[i].title,
                                style: T.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(s.history[i].time, style: T.small),
                            ],
                          ),
                        ),
                        Text(
                          '+${s.history[i].xp} XP',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: C.amber,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < math.min(8, s.history.length) - 1)
                    const Divider(height: 1, color: C.border),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _challengeTile(AppState s, Challenge c) {
    final prog = math.min(s.progressOf(c), c.target);
    final done = s.isComplete(c);
    final claimed = s.claimed.contains(c.id);
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        borderColor: done && !claimed ? C.green.op(0.6) : C.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title, style: T.h3),
                      const SizedBox(height: 2),
                      Text(c.desc, style: T.small),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (claimed)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: C.green,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Claimed',
                        style: TextStyle(
                          color: C.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                else if (done)
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      backgroundColor: C.green,
                      foregroundColor: C.bg,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onPressed: () {
                      if (s.claim(c)) {
                        s.tap();
                        toast(
                          context,
                          '+${c.xp} XP claimed',
                          icon: Icons.bolt_rounded,
                          color: C.amber,
                        );
                        showCelebration(
                          context,
                          'Reward claimed!',
                          '${c.title} · +${c.xp} XP',
                        );
                      }
                    },
                    child: const Text('Claim'),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: C.amber.op(0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '+${c.xp} XP',
                      style: const TextStyle(
                        color: C.amber,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppProgress(
                    value: prog / c.target,
                    color: done ? C.green : accent,
                    height: 7,
                  ),
                ),
                const SizedBox(width: 10),
                Text('$prog/${c.target}', style: T.small),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _boardRow(int rank, MapEntry<String, int> e, bool you, Color accent) {
    final medal = rank == 1
        ? C.amber
        : rank == 2
        ? const Color(0xFFCBD5E1)
        : rank == 3
        ? const Color(0xFFFB923C)
        : null;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: you ? accent.op(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: medal != null
                ? Icon(Icons.workspace_premium_rounded, color: medal, size: 22)
                : Text('$rank', style: T.small, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 8),
          ProfileAvatar(
            seed: e.key,
            label: you ? AppScope.read(context).displayName : e.key,
            size: 34,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              you ? 'You' : e.key,
              style: TextStyle(
                fontWeight: you ? FontWeight.w800 : FontWeight.w600,
                color: C.text,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${fmtInt(e.value)} XP',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: C.text,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 5 — PROFILE & SETTINGS
// ════════════════════════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    final pct = (s.profileCompletion * 100).round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const Row(
          children: [
            Expanded(child: Text('Profile', style: T.h1)),
            DemoBadge(),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          radius: 28,
          padding: const EdgeInsets.all(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent.op(0.3), C.surface],
          ),
          borderColor: accent.op(0.3),
          child: Column(
            children: [
              ProfileAvatar(
                seed: s.username,
                label: s.displayName,
                size: 88,
                ring: true,
              ),
              const SizedBox(height: 12),
              Text(s.displayName, style: T.h1, textAlign: TextAlign.center),
              GestureDetector(
                onTap: () => showEditProfile(context),
                child: Text(
                  '@${s.username}',
                  style: TextStyle(
                    fontSize: 14,
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: C.amber.op(0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: C.amber.op(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.science_rounded, size: 14, color: C.amber),
                    SizedBox(width: 6),
                    Text(
                      'Demo account',
                      style: TextStyle(
                        color: C.amber,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (s.bio.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(s.bio, style: T.muted, textAlign: TextAlign.center),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  StatTile(
                    label: 'Followers',
                    value: compact(s.followers),
                    icon: Icons.people_alt_rounded,
                    color: C.violet,
                  ),
                  const SizedBox(width: 10),
                  StatTile(
                    label: 'Engagement',
                    value: '4.9%',
                    icon: Icons.bolt_rounded,
                    color: C.pink,
                  ),
                  const SizedBox(width: 10),
                  StatTile(
                    label: 'Campaigns',
                    value: '${s.campaigns.length}',
                    icon: Icons.rocket_launch_rounded,
                    color: C.cyan,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showEditProfile(context),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Edit profile'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Profile completion', style: T.h3),
                  ),
                  Text('$pct%', style: T.h3),
                ],
              ),
              const SizedBox(height: 10),
              AppProgress(
                value: s.profileCompletion,
                color: pct == 100 ? C.green : accent,
                height: 9,
              ),
              const SizedBox(height: 8),
              Text(
                pct == 100
                    ? 'Your profile is complete.'
                    : 'Add the missing details (like a link) to reach 100%.',
                style: T.small,
              ),
            ],
          ),
        ),
        const SectionTitle('Preferences'),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                secondary: const Icon(
                  Icons.notifications_rounded,
                  color: C.cyan,
                ),
                title: const Text('Notifications', style: T.body),
                subtitle: const Text(
                  'Add new demo events to the notification center',
                  style: T.small,
                ),
                value: s.notificationsOn,
                onChanged: (v) {
                  s.setNotifications(v);
                  toast(
                    context,
                    v ? 'Notifications on' : 'Notifications off',
                    icon: Icons.notifications_rounded,
                    color: C.cyan,
                  );
                },
              ),
              const Divider(height: 1, color: C.border),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                secondary: const Icon(Icons.vibration_rounded, color: C.pink),
                title: const Text('Haptic feedback', style: T.body),
                subtitle: const Text(
                  'Subtle vibration on taps',
                  style: T.small,
                ),
                value: s.haptics,
                onChanged: (v) {
                  s.setHaptics(v);
                  if (v) HapticFeedback.mediumImpact();
                },
              ),
              const Divider(height: 1, color: C.border),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    const Icon(Icons.palette_rounded, color: C.amber),
                    const SizedBox(width: 16),
                    const Expanded(child: Text('Accent color', style: T.body)),
                    for (final c in const [C.violet, C.cyan, C.pink, C.green])
                      GestureDetector(
                        onTap: () {
                          s.tap();
                          s.setAccent(c);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: s.accent == c
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('About & privacy'),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.info_rounded,
                color: C.violet,
                title: 'About Growly',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Growly',
                  applicationVersion: '1.0.0 (demo)',
                  applicationIcon: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: accentGradient(accent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                    ),
                  ),
                  children: const [
                    SizedBox(height: 12),
                    Text(
                      'Growly is a Flutter showcase of a social growth studio. All data, campaigns and metrics are simulated locally.',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: C.border),
              _SettingsTile(
                icon: Icons.link_off_rounded,
                color: C.cyan,
                title: 'No external accounts connected',
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    icon: const Icon(
                      Icons.link_off_rounded,
                      color: C.cyan,
                      size: 32,
                    ),
                    title: const Text('No accounts connected', style: T.h2),
                    content: const Text(
                      'Growly never connects to Instagram, TikTok or any other service. It cannot log in, follow, comment, exchange followers, or create real followers. Everything you see is mock data stored in memory.',
                      style: T.muted,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: C.border),
              _SettingsTile(
                icon: Icons.privacy_tip_rounded,
                color: C.green,
                title: 'Privacy & demo data',
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    icon: const Icon(
                      Icons.privacy_tip_rounded,
                      color: C.green,
                      size: 32,
                    ),
                    title: const Text('Privacy & demo data', style: T.h2),
                    content: const Text(
                      'Nothing is saved to a server or database. All profiles are fictional. Metrics, campaigns and rewards live in memory and disappear when the app closes or you reset demo data.',
                      style: T.muted,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('Data'),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: C.pink,
            side: BorderSide(color: C.pink.op(0.4)),
          ),
          onPressed: () async {
            final ok = await showConfirm(
              context,
              title: 'Reset demo data?',
              message: 'This restores profile details, campaigns, XP, bookmarks and notifications to their initial demo values.',
              confirmLabel: 'Reset',
              destructive: true,
            );
            if (!ok || !context.mounted) return;
            s.reset();
            toast(
              context,
              'Demo data reset to initial values',
              icon: Icons.restart_alt_rounded,
              color: C.cyan,
            );
          },
          icon: const Icon(Icons.restart_alt_rounded),
          label: const Text('Reset demo data'),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: color),
      title: Text(title, style: T.body),
      trailing: const Icon(Icons.chevron_right_rounded, color: C.muted),
      onTap: () {
        AppScope.read(context).tap();
        onTap();
      },
    );
  }
}

void showEditProfile(BuildContext context) {
  showAppSheet<void>(context, (_) => const _EditProfileSheet());
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();
  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _user;
  late final TextEditingController _bio;
  late final TextEditingController _niche;
  late final TextEditingController _link;
  static final _userRe = RegExp(r'^[A-Za-z0-9_.]{3,24}$');

  @override
  void initState() {
    super.initState();
    final s = AppScope.read(context);
    _name = TextEditingController(text: s.displayName);
    _user = TextEditingController(text: s.username);
    _bio = TextEditingController(text: s.bio);
    _niche = TextEditingController(text: s.niche);
    _link = TextEditingController(text: s.link);
  }

  @override
  void dispose() {
    _name.dispose();
    _user.dispose();
    _bio.dispose();
    _niche.dispose();
    _link.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_key.currentState?.validate() ?? false)) return;
    AppScope.read(context).updateProfile(
      name: _name.text,
      user: _user.text,
      bioText: _bio.text,
      nicheText: _niche.text,
      linkText: _link.text,
    );
    toast(context, 'Profile updated', icon: Icons.check_circle_rounded);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sheetHandle(),
                const Text('Edit profile', style: T.h2),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Display name'),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.length < 2) return 'Enter at least 2 characters';
                    if (t.length > 30) return 'Keep it under 30 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _user,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixText: '@ ',
                  ),
                  validator: (v) => _userRe.hasMatch((v ?? '').trim())
                      ? null
                      : '3–24 characters: letters, numbers, _ or .',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bio,
                  maxLines: 3,
                  maxLength: 120,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                TextFormField(
                  controller: _niche,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Niche'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _link,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Link (optional)',
                    hintText: 'example.com',
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return null;
                    if (t.contains(' ') || !t.contains('.'))
                      return 'Enter a valid link like example.com';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: 'Save changes',
                    icon: Icons.check_rounded,
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
