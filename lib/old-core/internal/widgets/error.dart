import 'package:flutter/material.dart';

class CoreErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  
  const CoreErrorWidget({super.key, required this.errorDetails});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50.0,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Error Occurred!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                errorDetails.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        )
      ),
    );
  }
}
