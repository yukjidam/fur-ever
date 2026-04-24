import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'feed_screen.dart';

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

  final List<Map<String, String>> likedUsers = [
    {
      "user": "Mosang",
      "pet": "Golden Retriever",
      "image": "assets/images/golden-retriever.webp",
    },
    {
      "user": "Choco",
      "pet": "Shih Tzu",
      "image": "assets/images/shih-tzu.webp",
    },
    {"user": "Bingo", "pet": "Husky", "image": "assets/images/husky.jpg"},
  ];

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Milo",
      "breed": "Golden Retriever",
      "bio": "Loves running and fetch 🐶",
      "desc":
          "Friendly, gentle, and playful. Milo enjoys outdoor adventures and meeting new friends.",
      "location": "Pasig City",
      "images": [
        "assets/images/golden-retriever.webp",
        "assets/images/golden-retriever-2.webp",
        "assets/images/golden-retriever-3.webp",
      ],
    },
    {
      "name": "Luna",
      "breed": "Shih Tzu",
      "bio": "Calm and cuddly 💤",
      "desc":
          "Luna enjoys soft blankets, naps, and staying close to her humans.",
      "location": "Makati City",
      "images": ["assets/images/shih-tzu.webp"],
    },
    {
      "name": "Rocky",
      "breed": "Husky",
      "bio": "Energetic explorer ❄️",
      "desc":
          "Rocky loves running, exploring, and outdoor adventures in open spaces.",
      "location": "Taguig City",
      "images": ["assets/images/husky.jpg", "assets/images/husky-2.jpg"],
    },
  ];

  int swipeIndex = 0;
  int imageIndex = 0;

  double x = 0;
  double rotation = 0;

  bool isAnimating = false;

  double swipeDirection = 1;

  double startX = 0; // ✅ FIX

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
          imageIndex = 0; // reset image when card changes
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
      swipeDirection = direction;

      startX = x; // ✅ FIX: capture current position

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
    final progress = Curves.easeOutCubic.transform(_anim.value);
    final target = direction * 500;

    // ✅ FIX: smooth interpolation from current drag position
    return startX + (target - startX) * progress;
  }

  void _showLikesPanel() {
    final currentPet = pets[swipeIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pets who liked ${currentPet["name"]} ❤️",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // 🐶 CLEAN PET-SOCIAL FORMAT
              for (int i = 0; i < likedUsers.length; i++)
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      likedUsers[i]["image"]!,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "${likedUsers[i]["user"]} liked ${currentPet["name"]}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
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

    double liveScale;
    double liveOpacity;

    if (isAnimating) {
      // ✅ FIX: freeze second card during swipe → no bounce/jitter
      liveScale = 0.95;
      liveOpacity = 0.8;
    } else {
      // idle state (when dragging normally)
      liveScale = 0.92 + (0.04 * (x.abs() / 150).clamp(0, 1));
      liveOpacity = 0.65 + (0.25 * (x.abs() / 150).clamp(0, 1));
    }

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
        title: currentIndex == 1
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Newsfeed 📰",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "See what’s happening in the pet world",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )
            : const Column(
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
            onPressed: _showLikesPanel,
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
        child: IndexedStack(
          index: currentIndex,
          children: [
            Column(
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
                        final direction = swipeDirection;
                        final exitX = isAnimating ? _exitX(direction) : x;

                        final currentPet = pets[swipeIndex];
                        final nextPet = pets[(swipeIndex + 1) % pets.length];

                        double liveScale = isAnimating
                            ? 0.95
                            : 0.92 + (0.04 * (x.abs() / 150).clamp(0, 1));

                        double liveOpacity = isAnimating
                            ? 0.8
                            : 0.65 + (0.25 * (x.abs() / 150).clamp(0, 1));

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

                            // ❤️ HEART PARTICLES (PUT BACK HERE)
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

                            // 😭 CRY PARTICLES (PUT BACK HERE)
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

            const FeedScreen(), // 👈 THIS IS YOUR NEWSFEED TAB

            const Center(child: Text("Chat Page")),
            const Center(child: Text("Profile Page")),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> pet, Size size) {
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      (pet["images"] as List<String>)[imageIndex.clamp(
                        0,
                        (pet["images"] as List<String>).length - 1,
                      )],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Builder(
                        builder: (context) {
                          final images = pet["images"] as List<String>;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(images.length, (i) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: i == imageIndex ? 14 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == imageIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    left: 6,
                    top: 0,
                    bottom: 0,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Colors.white24,
                        onTap: () {
                          final images = pet["images"] as List<String>;

                          if (images.length <= 1) return;

                          setState(() {
                            imageIndex =
                                (imageIndex - 1 + images.length) %
                                images.length;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 6,
                    top: 0,
                    bottom: 0,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Colors.white24,
                        onTap: () {
                          final images = pet["images"] as List<String>;

                          if (images.length <= 1) return;

                          setState(() {
                            imageIndex = (imageIndex + 1) % images.length;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet["name"]!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  pet["location"] ?? "Unknown",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
