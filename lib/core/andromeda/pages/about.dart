import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class AndromedaAboutPage extends StatefulWidget {
  const AndromedaAboutPage({super.key});

  @override
  State<AndromedaAboutPage> createState() => _AndromedaAboutPageState();
}

class _AndromedaAboutPageState extends State<AndromedaAboutPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('main-about')),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Andromeda",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  tr('about-description'),
                  textAlign: TextAlign.justify
                ),
              ),

              Text(
                tr('about-description-2'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ScaleTransition(
                  scale: _animation,
                  child: Image.asset('assets/images/andromeda256.png', width: 168, height: 168),
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(tr('about-version').format(['1.0.0']))
              ),
            ],
          ),
        ),
      ),
    );
  }
}