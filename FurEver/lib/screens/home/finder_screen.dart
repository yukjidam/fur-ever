import 'package:flutter/material.dart';

class FinderScreen extends StatelessWidget {
  const FinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Playmate Finder", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
