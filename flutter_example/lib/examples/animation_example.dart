import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(AppLy());
}

/// Tutorial:
// https://medium.com/flutter-community/flutter-animations-comprehensive-guide-cb93b246ca5d#371a

class AppLy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double listContainerHeight = MediaQuery.of(context).size.height - 150;

    return PageWrapper(
      containerHeight: listContainerHeight,
      body: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              BlurContainer(
                containerHeight: listContainerHeight,
                child: ItemPicker(containerHeight: listContainerHeight),
              ),
              const SizedBox(height: 20),
              const BlurSlider(),
              const SizedBox(height: 20),
              const ExplicitAnimations(),
              const SizedBox(height: 20),
              const AnimatedBuilderExample(),
              const SizedBox(height: 20),
              const AnimatedWidgetExample(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ExplicitAnimations extends StatefulWidget {
  const ExplicitAnimations({Key? key}) : super(key: key);

  @override
  State<ExplicitAnimations> createState() => _ExplicitAnimationsState();
}

class _ExplicitAnimationsState extends State<ExplicitAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<AlignmentGeometry> _alignAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurContainer(
      containerHeight: 200,
      child: AlignTransition(
        alignment: _alignAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: const Rectangle(
            color1: pink,
            color2: pinkDark,
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }
}

class Rectangle extends StatelessWidget {
  const Rectangle({
    Key? key,
    this.width = 60,
    this.height = 40,
    required this.color1,
    required this.color2,
    this.top,
    this.bottom,
    this.left,
    this.right,
  }) : super(key: key);

  final double width;
  final double height;
  final Color color1;
  final Color color2;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class BlurSlider extends StatefulWidget {
  const BlurSlider({Key? key}) : super(key: key);

  @override
  State<BlurSlider> createState() => _BlurSliderState();
}

class _BlurSliderState extends State<BlurSlider> {
  double _sliderValue = 0.01;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 0.01, end: _sliderValue),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Slider(
          value: _sliderValue,
          min: 0.01,
          onChanged: (value) {
            setState(() => _sliderValue = value);
          },
        ),
      ),
      builder: (BuildContext context, double? value, Widget? child) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 40 * (value ?? 0.01),
              sigmaY: 40 * (value ?? 0.01),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class ItemPicker extends StatefulWidget {
  const ItemPicker({
    Key? key,
    required this.containerHeight,
  }) : super(key: key);

  final double containerHeight;

  @override
  State<ItemPicker> createState() => _ItemPickerState();
}

class _ItemPickerState extends State<ItemPicker> {
  int selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double listContainerBorderWidth = 1.5;
    const int itemsCount = 8;
    double itemHeight =
        (widget.containerHeight - listContainerBorderWidth * 2) / itemsCount;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          AnimatedPositioned(
            top: selectedItemIndex * itemHeight,
            left: 0,
            right: 0,
            height: itemHeight,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                8,
                (i) => Expanded(
                  child: InkWell(
                    onTap: () => setState(() => selectedItemIndex = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'List Item ${i + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            if (i == 3)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: selectedItemIndex == i ? yellow : pink,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedItemIndex == i
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedItemIndex == i
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  child: const Text('Featured!'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    Key? key,
    this.containerHeight = 120,
    this.child,
  }) : super(key: key);

  final double containerHeight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          clipBehavior: Clip.none,
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({Key? key}) : super(key: key);

  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [purple, pink, yellow],
              stops: [0, _controller.value, 1],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white),
          ),
        );
      },
    );
  }
}

class AnimatedWidgetExample extends StatefulWidget {
  const AnimatedWidgetExample({Key? key}) : super(key: key);

  @override
  State<AnimatedWidgetExample> createState() => _AnimatedWidgetExampleState();
}

class _AnimatedWidgetExampleState extends State<AnimatedWidgetExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [purple, pink, yellow],
          stops: [0, _controller.value, 1],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GradientTransition(gradientEnd: _controller),
      ),
    );
  }
}

class GradientTransition extends AnimatedWidget {
  final Animation<double> gradientEnd;

  const GradientTransition({
    Key? key,
    required this.gradientEnd,
  }) : super(key: key, listenable: gradientEnd);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [purple, pink, yellow],
          stops: [0, gradientEnd.value, 1],
        ),
      ),
    );
  }
}

const Color pink = Color(0xffEC6283);
const Color pinkDark = Color(0xffD64265);
const Color yellow = Color(0xffE7F18F);
const Color yellowDark = Color(0xffB8C72B);
const Color purple = Color(0xff323AE9);

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    Key? key,
    this.body,
    this.containerHeight = 500,
    this.hasContainer = true,
  }) : super(key: key);

  final Widget? body;
  final double containerHeight;
  final bool hasContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff323AE9), Color(0xff4D59D1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            ..._backgroundCircles,
            Positioned.fill(
              child: Center(
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _backgroundCircles => const [
        Circle(
          color1: pink,
          color2: pinkDark,
          radius: 350,
          left: -120,
          top: -100,
        ),
        Circle(
          color1: pink,
          color2: pinkDark,
          radius: 280,
          right: -120,
          bottom: 200,
        ),
        Circle(
          color1: yellow,
          color2: yellowDark,
          radius: 180,
          right: -60,
          top: -40,
        ),
        Circle(
          color1: yellow,
          color2: yellowDark,
          radius: 400,
          left: -160,
          bottom: -120,
        ),
      ];
}

class Circle extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double? radius;
  final bool isPositioned;

  const Circle({
    required this.color1,
    required this.color2,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.radius,
    this.isPositioned = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color1, color2],
          end: Alignment.topLeft,
          begin: Alignment.bottomRight,
        ),
      ),
    );

    return isPositioned
        ? Positioned(
            bottom: bottom,
            right: right,
            top: top,
            left: left,
            height: radius,
            width: radius,
            child: circle,
          )
        : circle;
  }
}
