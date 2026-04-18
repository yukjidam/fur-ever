import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HeartParticle {
  double x;
  double y;
  double opacity;
  double size;
  double speed;

  _HeartParticle({
    required this.x,
    required this.y,
    required this.opacity,
    required this.size,
    required this.speed,
  });
}

class _CryParticle {
  double x;
  double y;
  double opacity;
  double size;
  double speed;

  _CryParticle({
    required this.x,
    required this.y,
    required this.opacity,
    required this.size,
    required this.speed,
  });
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  final List<Map<String, String>> pets = [
    {
      "name": "Milo",
      "breed": "Golden Retriever",
      "bio": "Loves running and fetch 🐶",
      "desc":
          "Friendly, gentle, and playful. Milo enjoys outdoor adventures and meeting new friends.",
      "image": "assets/images/golden-retriever.webp",
    },
    {
      "name": "Luna",
      "breed": "Shih Tzu",
      "bio": "Calm and cuddly 💤",
      "desc":
          "Luna enjoys soft blankets, naps, and staying close to her humans.",
      "image": "assets/images/shih-tzu.webp",
    },
    {
      "name": "Rocky",
      "breed": "Husky",
      "bio": "Energetic explorer ❄️",
      "desc":
          "Rocky loves running, exploring, and outdoor adventures in open spaces.",
      "image": "assets/images/husky.jpg",
    },
  ];

  int swipeIndex = 0;

  double x = 0;
  double rotation = 0;

  bool isAnimating = false;

  double swipeDirection = 1; // ✅ FIX: lock direction

  final List<_HeartParticle> hearts = [];
  final List<_CryParticle> cries = [];

  final Random random = Random();

  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          swipeIndex = (swipeIndex + 1) % pets.length;
          x = 0;
          rotation = 0;
          isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void swipeCard(double direction) {
    if (isAnimating) return;

    setState(() {
      isAnimating = true;
      swipeDirection = direction; // ✅ FIX
      rotation = direction * 0.35;
    });

    if (direction > 0) {
      spawnHearts();
    } else {
      spawnCry();
    }

    _controller.forward(from: 0);
  }

  double _exitX(double direction) {
    final progress = _anim.value;
    final target = direction * 500;
    return target * Curves.easeOutCubic.transform(progress);
  }

  void spawnHearts() {
    hearts.clear();

    for (int i = 0; i < 14; i++) {
      hearts.add(
        _HeartParticle(
          x: random.nextDouble() * 140 - 70,
          y: 0,
          opacity: 1,
          size: random.nextDouble() * 14 + 16,
          speed: random.nextDouble() * 1.8 + 0.6,
        ),
      );
    }

    animateHearts();
  }

  void animateHearts() async {
    for (int i = 0; i < 45; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;

      setState(() {
        for (var h in hearts) {
          h.y -= h.speed * 2;
          h.opacity -= 0.04;
        }
        hearts.removeWhere((h) => h.opacity <= 0);
      });
    }

    hearts.clear();
  }

  void spawnCry() {
    cries.clear();

    for (int i = 0; i < 12; i++) {
      cries.add(
        _CryParticle(
          x: random.nextDouble() * 140 - 70,
          y: 0,
          opacity: 1,
          size: random.nextDouble() * 18 + 18,
          speed: random.nextDouble() * 1.6 + 0.8,
        ),
      );
    }

    animateCry();
  }

  void animateCry() async {
    for (int i = 0; i < 45; i++) {
      await Future.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;

      setState(() {
        for (var c in cries) {
          c.y -= c.speed * 2;
          c.opacity -= 0.04;
        }
        cries.removeWhere((c) => c.opacity <= 0);
      });
    }

    cries.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final currentPet = pets[swipeIndex];
    final nextPet = pets[(swipeIndex + 1) % pets.length];

    final progress = _anim.value;

    final liveScale = 0.9 + (0.08 * progress);
    final liveOpacity = 0.55 + (0.3 * progress);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi there, Dagol 🐶",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              "Let’s find your playmate",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
            onPressed: () {},
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFFFF8A65),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: "Newsfeed",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Profile"),
        ],
        onTap: (i) => setState(() => currentIndex = i),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("‹ Pass"), Text("Like ›")],
              ),
            ),

            const SizedBox(height: 2),

            Expanded(
              child: GestureDetector(
                onPanUpdate: (d) {
                  if (isAnimating) return;
                  setState(() {
                    x += d.delta.dx;
                    rotation = x / 380;
                  });
                },
                onPanEnd: (d) {
                  if (x > 120) {
                    swipeCard(1);
                  } else if (x < -120) {
                    swipeCard(-1);
                  } else {
                    setState(() {
                      x = 0;
                      rotation = 0;
                    });
                  }
                },

                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (context, child) {
                    final direction = swipeDirection; // ✅ FIX

                    final exitX = isAnimating ? _exitX(direction) : x;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: liveScale,
                          child: Opacity(
                            opacity: liveOpacity,
                            child: _buildCard(nextPet, size),
                          ),
                        ),

                        Transform.translate(
                          offset: Offset(exitX, 0),
                          child: Transform.rotate(
                            angle: rotation,
                            child: _buildCard(currentPet, size),
                          ),
                        ),

                        ...hearts.map(
                          (h) => Positioned(
                            left: size.width / 2 + h.x,
                            top: size.height / 2 + h.y - 80,
                            child: Opacity(
                              opacity: h.opacity.clamp(0, 1),
                              child: Icon(
                                Icons.favorite,
                                size: h.size,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ),
                        ),

                        ...cries.map(
                          (c) => Positioned(
                            left: size.width / 2 + c.x,
                            top: size.height / 2 + c.y - 80,
                            child: Opacity(
                              opacity: c.opacity.clamp(0, 1),
                              child: Text(
                                "😭",
                                style: TextStyle(fontSize: c.size),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "nope",
                    backgroundColor: Colors.redAccent,
                    onPressed: () => swipeCard(-1),
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: "like",
                    backgroundColor: Colors.pinkAccent,
                    onPressed: () => swipeCard(1),
                    child: const Icon(Icons.favorite),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, String> pet, Size size) {
    return Container(
      width: size.width * 0.93,
      height: size.height * 0.65,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.asset(
                pet["image"]!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet["name"]!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(pet["breed"]!),
                  const SizedBox(height: 6),
                  Text(pet["bio"]!),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      pet["desc"]!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
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
