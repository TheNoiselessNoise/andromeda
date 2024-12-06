import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class AndromedaAboutPage extends StatelessWidget {
  const AndromedaAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('main-about')),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // TODO: tr('app-name')
              const Text("Andromeda",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(tr('about-description').trim(), textAlign: TextAlign.justify),
              ),

              const Divider(),

              Text(tr('about-version').format(['1.0.0'])),
            ],
          ),
        ),
      ),
    );
  }
}