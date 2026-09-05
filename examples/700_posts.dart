
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// ============================== APP =================================

void main() {
  runApp(const MilestoneApp());
}

class MilestoneApp extends StatelessWidget {
  const MilestoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '700 Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _Palette.bgTop,
        useMaterial3: true,
      ),
      home: const CelebrationScreen(),
    );
  }
}

// ============================== THEME ================================

class _Palette {
  static const Color bgTop = Color(0xFF05060A);
  static const Color bgBottom = Color(0xFF0B0C18);
  static const Color accentPurple = Color(0xFF8C7BFF);
  static const Color accentCyan = Color(0xFF56D8EF);
}

TextStyle _labelStyle(Size size, {double scale = 1}) => TextStyle(
  color: Colors.white.withValues(alpha: 0.92),
  fontSize: size.width * 0.062 * scale,
  fontWeight: FontWeight.w300,
  letterSpacing: 6,
);

TextStyle _headingStyle(Size size) => TextStyle(
  color: Colors.white,
  fontSize: size.width * 0.070,
  fontWeight: FontWeight.w300,
  letterSpacing: 2,
  height: 1.3,
);

TextStyle _wordStyle(Size size) => TextStyle(
  color: Colors.white,
  fontSize: size.width * 0.115,
  fontWeight: FontWeight.w700,
  letterSpacing: 3,
);

TextStyle _subLabelStyle(Size size) => TextStyle(
  color: Colors.white.withValues(alpha: 0.85),
  fontSize: size.width * 0.052,
  fontWeight: FontWeight.w500,
  letterSpacing: 5,
);

TextStyle _messageStyle(Size size, {bool emphasis = false}) => TextStyle(
  color: Colors.white.withValues(alpha: emphasis ? 1 : 0.95),
  fontSize: size.width * (emphasis ? 0.062 : 0.072),
  fontWeight: FontWeight.w600,
  height: 1.4,
);

// ========================= CELEBRATION SCREEN =========================

class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({super.key});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen>
    with SingleTickerProviderStateMixin {
  static const double _totalSeconds = 11.0;

  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_totalSeconds * 1000).round()),
    )..forward();
    _particles = _generateParticles(26);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _restart() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final completed = _controller.status == AnimationStatus.completed;
          final seconds = _controller.value * _totalSeconds;
          final inReveal = seconds > 3.5 && seconds < 5.5;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: completed ? _restart : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _AnimatedBackground(t: _controller.value),
                CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    time: seconds,
                    boost: inReveal ? 1.0 : 0.4,
                  ),
                ),
                SafeArea(
                  child: completed
                      ? _buildFinalScreen(size)
                      : _timelineContent(seconds, size),
                ),
                if (completed)
                  Positioned(
                    bottom: size.height * 0.12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '@CodeWithFlexz',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: size.width * 0.033,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: size.height * 0.035,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: completed ? 1 : 0,
                    duration: const Duration(milliseconds: 700),
                    child: IgnorePointer(
                      ignoring: !completed,
                      child: Center(child: _ReplayButton(onTap: _restart)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ========================= TIMELINE PHASES =========================
  // Each phase owns a slice of the 0–11s timeline and fades its own
  // content in and out (see _Anim.envelope) so transitions stay clean.

  Widget _timelineContent(double seconds, Size size) {
    if (seconds < 1.0) return _buildOpening(seconds, size);
    if (seconds < 2.5) return _buildJourney(seconds, size);
    if (seconds < 3.5) return _buildAnticipation(seconds, size);
    if (seconds < 5.5) return _buildReveal(seconds, size);
    if (seconds < 7.0) return _buildMilestoneMessage(seconds, size);
    if (seconds < 9.0) return _buildGratitude(seconds, size);
    return _buildFuture(seconds, size);
  }

  // PHASE 1 — OPENING
  Widget _buildOpening(double seconds, Size size) {
    final dotScale = Curves.easeOut.transform(_Anim.local(seconds, 0, 1.0));
    final textOp = _Anim.envelope(
      _Anim.local(seconds, 0.35, 1.0),
      inFrac: 0.55,
      outFrac: 0.25,
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9 * dotScale),
              boxShadow: [
                BoxShadow(
                  color: _Palette.accentPurple.withValues(
                    alpha: 0.55 * dotScale,
                  ),
                  blurRadius: 42 * dotScale,
                  spreadRadius: 6 * dotScale,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.035),
          _fadeSlide(Text('ONE JOURNEY', style: _labelStyle(size)), textOp),
        ],
      ),
    );
  }

  // PHASE 2 — THE JOURNEY
  Widget _buildJourney(double seconds, Size size) {
    late String text;
    late double start, end;
    late bool heading;

    if (seconds < 1.5) {
      text = 'YEARS OF CREATING';
      start = 1.0;
      end = 1.5;
      heading = true;
    } else if (seconds < 1.83) {
      text = 'BUILDING';
      start = 1.5;
      end = 1.83;
      heading = false;
    } else if (seconds < 2.17) {
      text = 'LEARNING';
      start = 1.83;
      end = 2.17;
      heading = false;
    } else {
      text = 'SHARING';
      start = 2.17;
      end = 2.5;
      heading = false;
    }

    final lp = _Anim.local(seconds, start, end);
    final op = _Anim.envelope(lp, inFrac: 0.35, outFrac: 0.35);
    final blur = (1 - op) * 6;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: _fadeSlide(
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: heading ? _headingStyle(size) : _wordStyle(size),
            ),
          ),
          op,
        ),
      ),
    );
  }

  // PHASE 3 — BUILDING ANTICIPATION
  Widget _buildAnticipation(double seconds, Size size) {
    if (seconds < 3.0) {
      final lp = _Anim.local(seconds, 2.5, 3.0);
      final op = _Anim.envelope(lp, inFrac: 0.4, outFrac: 0.4);
      return Center(
        child: _fadeSlide(
          Text('AND THEN...', style: _labelStyle(size, scale: 0.9)),
          op,
        ),
      );
    }

    final lp = _Anim.local(seconds, 3.0, 3.5);
    final ringScale = 1 + lp * 3.4;
    final ringOpacity = (1 - lp).clamp(0.0, 1.0);

    return Center(
      child: Opacity(
        opacity: ringOpacity,
        child: Transform.scale(
          scale: ringScale,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _Palette.accentCyan.withValues(alpha: 0.85),
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // PHASE 4 — THE MAIN REVEAL
  Widget _buildReveal(double seconds, Size size) {
    final numLp = _Anim.local(seconds, 3.5, 4.1);
    final numScale = 0.55 + Curves.easeOutBack.transform(numLp) * 0.45;
    final numOpacity = _Anim.envelope(
      _Anim.local(seconds, 3.5, 5.5),
      inFrac: 0.14,
      outFrac: 0.18,
    );
    final subOpacity = _Anim.envelope(
      _Anim.local(seconds, 4.3, 5.5),
      inFrac: 0.3,
      outFrac: 0.25,
    );
    final pulse = 1 + 0.035 * math.sin(seconds * 6);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: numOpacity,
            child: Transform.scale(
              scale: numScale * pulse,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size.width * 0.85,
                    height: size.width * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _Palette.accentPurple.withValues(
                            alpha: 0.32 * numOpacity,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '700',
                    style: TextStyle(
                      fontSize: size.width * 0.46,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: _Palette.accentCyan.withValues(alpha: 0.55),
                          blurRadius: 46,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.018),
          _fadeSlide(
            Text('INSTAGRAM POSTS', style: _subLabelStyle(size)),
            subOpacity,
          ),
        ],
      ),
    );
  }

  // PHASE 5 — MILESTONE MESSAGE
  Widget _buildMilestoneMessage(double seconds, Size size) {
    if (seconds < 6.2) {
      final lp = _Anim.local(seconds, 5.5, 6.2);
      final op = _Anim.envelope(lp, inFrac: 0.4, outFrac: 0.3);
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
          child: _fadeSlide(
            Text(
              '700 posts.\nOne incredible journey.',
              textAlign: TextAlign.center,
              style: _messageStyle(size),
            ),
            op,
          ),
        ),
      );
    }

    final lp = _Anim.local(seconds, 6.2, 7.0);
    final op = _Anim.envelope(lp, inFrac: 0.35, outFrac: 0.35);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
        child: _fadeSlide(
          Text(
            'Thank you for being part of it.',
            textAlign: TextAlign.center,
            style: _messageStyle(size, emphasis: true),
          ),
          op,
        ),
      ),
    );
  }

  // PHASE 6 — COMMUNITY / GRATITUDE
  Widget _buildGratitude(double seconds, Size size) {
    final lp = _Anim.local(seconds, 7.0, 9.0);
    final op = _Anim.envelope(lp, inFrac: 0.25, outFrac: 0.2);
    const text =
        'To everyone who followed,\nliked, commented, shared,\nsupported, and stayed along the way —\n\nThank you.';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
        child: _fadeSlide(
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: size.width * 0.058,
              fontWeight: FontWeight.w400,
              height: 1.55,
            ),
          ),
          op,
        ),
      ),
    );
  }

  // PHASE 7 — THE FUTURE
  Widget _buildFuture(double seconds, Size size) {
    late String line;
    late double start, end;

    if (seconds < 9.5) {
      line = '700 DOWN.';
      start = 9.0;
      end = 9.5;
    } else if (seconds < 10.2) {
      line = 'MORE TO COME.';
      start = 9.5;
      end = 10.2;
    } else {
      line = "WE'RE JUST GETTING STARTED";
      start = 10.2;
      end = 11.0;
    }

    final lp = _Anim.local(seconds, start, end);
    final op = _Anim.envelope(lp, inFrac: 0.3, outFrac: 0.25);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: _fadeSlide(
          Text(
            line,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.088,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          op,
        ),
      ),
    );
  }

  // ============================ FINAL SCREEN ============================
  // Shown once the controller completes, and stays visible indefinitely.

  Widget _buildFinalScreen(Size size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 24),
          child: child,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '700',
              style: TextStyle(
                fontSize: size.width * 0.34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1,
                shadows: [
                  Shadow(
                    color: _Palette.accentPurple.withValues(alpha: 0.5),
                    blurRadius: 32,
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.012),
            Text('INSTAGRAM POSTS', style: _subLabelStyle(size)),
            SizedBox(height: size.height * 0.055),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                'Thank you for being part of the journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.016),
            Text(
              "Here's to the next chapter.",
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: _Palette.accentCyan.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================ BACKGROUND =============================

class _AnimatedBackground extends StatelessWidget {
  final double t;
  const _AnimatedBackground({required this.t});

  @override
  Widget build(BuildContext context) {
    final angle = t * 2 * math.pi;
    final align1 = Alignment(
      math.sin(angle) * 0.6,
      math.cos(angle) * 0.4 - 0.3,
    );
    final align2 = Alignment(
      -math.cos(angle * 0.8) * 0.5,
      math.sin(angle * 0.8) * 0.5 + 0.4,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_Palette.bgTop, _Palette.bgBottom],
            ),
          ),
        ),
        Align(
          alignment: align1,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _Palette.accentPurple.withValues(alpha: 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: align2,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _Palette.accentCyan.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================ PARTICLE SYSTEM =========================

class _Particle {
  final double x; // relative 0..1
  final double y; // relative 0..1
  final double radius;
  final double speed;
  final double phase;
  final double baseOpacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.baseOpacity,
  });
}

List<_Particle> _generateParticles(int count) {
  final rnd = math.Random(42);
  return List.generate(count, (_) {
    return _Particle(
      x: rnd.nextDouble(),
      y: rnd.nextDouble(),
      radius: 1.0 + rnd.nextDouble() * 2.2,
      speed: 0.15 + rnd.nextDouble() * 0.35,
      phase: rnd.nextDouble() * math.pi * 2,
      baseOpacity: 0.15 + rnd.nextDouble() * 0.35,
    );
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  final double boost;

  _ParticlePainter({
    required this.particles,
    required this.time,
    required this.boost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dy = math.sin(time * p.speed + p.phase) * 0.05;
      final dx = math.cos(time * p.speed * 0.7 + p.phase) * 0.04;
      final cx = (p.x + dx) * size.width;
      final cy = (p.y + dy) * size.height;
      final opacity = (p.baseOpacity * boost).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 1.6);

      canvas.drawCircle(Offset(cx, cy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

// ============================ REPLAY BUTTON ============================

class _ReplayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ReplayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.replay_rounded,
              size: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            Text(
              'Replay',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================ HELPERS ==============================

/// Small helpers shared by every timeline phase: mapping the global
/// "seconds" value into a phase-local 0..1 progress, and turning that
/// progress into a fade-in / hold / fade-out opacity envelope.
class _Anim {
  static double local(double seconds, double start, double end) {
    return ((seconds - start) / (end - start)).clamp(0.0, 1.0);
  }

  static double envelope(
    double lp, {
    double inFrac = 0.3,
    double outFrac = 0.3,
  }) {
    if (lp <= 0 || lp >= 1) return 0.0;
    if (lp < inFrac) return (lp / inFrac).clamp(0.0, 1.0);
    if (lp > 1 - outFrac) return ((1 - lp) / outFrac).clamp(0.0, 1.0);
    return 1.0;
  }
}

/// Wraps [child] in a fade + gentle upward slide driven by [opacity].
Widget _fadeSlide(Widget child, double opacity, {double distance = 18}) {
  final clamped = opacity.clamp(0.0, 1.0);
  return Opacity(
    opacity: clamped,
    child: Transform.translate(
      offset: Offset(0, (1 - clamped) * distance),
      child: child,
    ),
  );
}
