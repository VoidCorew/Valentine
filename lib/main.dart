import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Heart {
  double left;
  double size;
  double speed;
  double top = -0.1;

  Heart({
    required this.left,
    required this.size,
    required this.speed,
    required this.top,
  });
}

void main() {
  runApp(const Valentine());
}

class Valentine extends StatelessWidget {
  const Valentine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ButtonScreen(),
    );
  }
}

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => FallingHeartsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Press for surprise",
            style: TextStyle(
              fontFamily: "Playwrite",
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================================

class FallingHeartsScreen extends StatefulWidget {
  const FallingHeartsScreen({super.key});

  @override
  State<FallingHeartsScreen> createState() => _FallingHeartsScreenState();
}

class _FallingHeartsScreenState extends State<FallingHeartsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final random = Random();
  final hearts = <Heart>[];

  @override
  void initState() {
    super.initState();

    // simple animation
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 800),
    //   lowerBound: 0.8,
    //   upperBound: 1.2,
    // )..repeat(reverse: true);

    controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
          )
          ..addListener(updateHearts)
          ..repeat();

    // heartbeat animation
    animation = TweenSequence<double>([
      // первый лёгкий удар
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),

      // второй более сильный удар
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),

      // пауза
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
    ]).animate(controller);

    // jelly animation
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 500),
    // );

    // animation = TweenSequence<double>([
    //   TweenSequenceItem(
    //     tween: Tween(
    //       begin: 1.0,
    //       end: 0.75,
    //     ).chain(CurveTween(curve: Curves.easeOut)),
    //     weight: 30,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(
    //       begin: 0.75,
    //       end: 1.15,
    //     ).chain(CurveTween(curve: Curves.easeOut)),
    //     weight: 40,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(
    //       begin: 1.15,
    //       end: 1.0,
    //     ).chain(CurveTween(curve: Curves.elasticOut)),
    //     weight: 30,
    //   ),
    // ]).animate(controller);

    // ========================================
    // Timer.periodic(const Duration(milliseconds: 300), (_) {
    //   setState(() {
    //     hearts.add(
    //       Heart(
    //         left: random.nextDouble(),
    //         size: random.nextDouble() * 20 + 10,
    //         speed: random.nextDouble() * 2 + 1,
    //       ),
    //     );
    //   });
    // });

    Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (hearts.length < 40) {
        hearts.add(
          Heart(
            left: random.nextDouble(),
            top: -0.1,
            size: random.nextDouble() * 20 + 10,
            speed: random.nextDouble() * 0.01 + 0.005,
          ),
        );
      }
    });
  }

  void updateHearts() {
    setState(() {
      for (var heart in hearts) {
        heart.top += heart.speed;
      }
      hearts.removeWhere((h) => h.top > 1.2);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f1a),
      body: Stack(
        children: [
          // ...hearts.map((h) => FallingHeart(heart: h)),
          ...hearts.map(
            (h) => Positioned(
              left: h.left * MediaQuery.of(context).size.width,
              top: h.top * MediaQuery.of(context).size.height,
              child: Icon(
                Icons.favorite,
                color: Colors.pink.withValues(alpha: 0.5),
                size: h.size,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ScaleTransition(
                //   scale: controller,
                //   child: const Icon(
                //     Icons.favorite,
                //     color: Colors.pinkAccent,
                //     size: 120,
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     controller.forward(from: 0);
                //   },
                //   child: AnimatedBuilder(
                //     animation: animation,
                //     builder: (context, child) {
                //       return Transform.scale(scale: animation.value, child: child);
                //     },
                //     child: const Icon(
                //       Icons.favorite,
                //       color: Colors.pinkAccent,
                //       size: 120,
                //     ),
                //   ),
                // ),
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: animation.value,
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                    size: 120,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Happy Valentine’s Day!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Playwrite",
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FallingHeart extends StatefulWidget {
  final Heart heart;
  const FallingHeart({super.key, required this.heart});

  @override
  State<FallingHeart> createState() => _FallingHeartState();
}

class _FallingHeartState extends State<FallingHeart> {
  @override
  void initState() {
    super.initState();
    fall();
  }

  void fall() async {
    while (mounted && widget.heart.top < 1.2) {
      await Future.delayed(const Duration(milliseconds: 16));

      setState(() {
        widget.heart.top += 0.01 * widget.heart.speed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.heart.left * MediaQuery.of(context).size.width,
      top: widget.heart.top * MediaQuery.of(context).size.height,
      child: Icon(
        Icons.favorite,
        color: Colors.pink.withValues(alpha: 0.7),
        size: widget.heart.size,
      ),
    );
  }
}
