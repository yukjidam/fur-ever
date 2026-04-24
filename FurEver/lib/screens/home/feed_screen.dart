import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController postController = TextEditingController();

  final List<Map<String, dynamic>> posts = [
    {
      "user": "Milo",
      "breed": "Golden Retriever",
      "userImage": "assets/images/golden-retriever.webp",
      "postImage": "assets/images/golden-retriever.webp",
      "caption": "Morning run done! 🐶💨",
      "likes": 12,
      "liked": false,
      "comments": ["Good boy Milo!", "So active!"],
    },
    {
      "user": "Luna",
      "breed": "Shih Tzu",
      "userImage": "assets/images/shih-tzu.webp",
      "postImage": "assets/images/shih-tzu.webp",
      "caption": "Nap time is sacred 💤",
      "likes": 8,
      "liked": false,
      "comments": ["Same energy 😂"],
    },
    {
      "user": "Rocky",
      "breed": "Husky",
      "userImage": "assets/images/husky.jpg",
      "postImage": "assets/images/husky.jpg",
      "caption": "Cold weather = happiness ❄️",
      "likes": 20,
      "liked": false,
      "comments": ["Beautiful dog!", "Husky vibes 🔥"],
    },

    // 🟢 NEW: text-only demo post
    {
      "user": "Bella",
      "breed": "Pomeranian",
      "userImage": "assets/images/shih-tzu.webp",
      "postImage": null,
      "caption": "Just chilling today 🐾 no photos, just vibes.",
      "likes": 0,
      "liked": false,
      "comments": [],
    },
  ];

  void createPost() {
    if (postController.text.trim().isEmpty) return;

    setState(() {
      posts.insert(0, {
        "user": "You",
        "breed": "Pet Owner",
        "userImage": "assets/images/shih-tzu.webp",
        "postImage": null,
        "caption": postController.text,
        "likes": 0,
        "liked": false,
        "comments": [],
      });

      postController.clear();
    });

    Navigator.pop(context);
  }

  // 🟢 UPDATED POST MODAL ONLY
  void openCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create Post 🐶",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/shih-tzu.webp"),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: postController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "What is your pet doing?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 🟢 IMAGE UPLOAD OPTION (UI ONLY)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // placeholder only
                    },
                    icon: const Icon(Icons.image, color: Colors.pinkAccent),
                  ),
                  const Text("Add Photo"),
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(onPressed: createPost, child: const Text("Post")),
            ],
          ),
        );
      },
    );
  }

  void toggleLike(int index) {
    setState(() {
      posts[index]["liked"] = !posts[index]["liked"];
      posts[index]["likes"] += posts[index]["liked"] ? 1 : -1;
    });
  }

  void openComments(int index) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final comments = posts[index]["comments"] as List<String>;

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // handle bar
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Comments 💬",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // COMMENTS LIST
                  SizedBox(
                    height: 250,
                    child: comments.isEmpty
                        ? const Center(
                            child: Text(
                              "No comments yet 🐶",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundImage: AssetImage(
                                        "assets/images/shih-tzu.webp",
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(comments[i]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 10),

                  // INPUT ROW (IMPROVED)
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(
                          "assets/images/shih-tzu.webp",
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: "Write a comment...",
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      GestureDetector(
                        onTap: () {
                          if (commentController.text.trim().isEmpty) return;

                          setState(() {
                            posts[index]["comments"].add(
                              commentController.text,
                            );
                          });

                          setModalState(() {});
                          commentController.clear();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void sharePost() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Post shared 🔁")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: openCreatePost,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(post["userImage"]),
                  ),
                  title: Text(post["user"]),
                  subtitle: Text(post["breed"]),
                ),

                // 🟢 IMAGE CHECK (supports text-only post)
                if (post["postImage"] != null)
                  Image.asset(
                    post["postImage"],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(post["caption"]),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () => toggleLike(index),
                      icon: Icon(
                        post["liked"] ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pinkAccent,
                      ),
                      label: Text("${post["likes"]}"),
                    ),

                    TextButton.icon(
                      onPressed: () => openComments(index),
                      icon: const Icon(Icons.comment),
                      label: Text("${post["comments"].length}"),
                    ),

                    TextButton.icon(
                      onPressed: sharePost,
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
