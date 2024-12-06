// 1. First, create a dart file named 'analyze_deps.dart'
import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';

void main() async {
  // Read pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = await pubspecFile.readAsString();
  final pubspec = loadYaml(pubspecContent);
  
  // Get dependencies
  final Map dependencies = {...pubspec['dependencies'] ?? {}, ...pubspec['dev_dependencies'] ?? {}};
  
  // Initialize results map
  final Map<String, bool> usageResults = {};
  
  // Recursively search through lib directory
  await searchDirectory(Directory('lib'), dependencies, usageResults);
  await searchDirectory(Directory('test'), dependencies, usageResults);
  
  // Print results
  print('\nDependency Analysis Results:');
  print('==========================');
  
  dependencies.forEach((package, version) {
    if (!usageResults.containsKey(package)) {
      print('⚠️  $package: Potentially unused');
    } else {
      print('✅ $package: In use');
    }
  });
}

Future<void> searchDirectory(Directory dir, Map dependencies, Map<String, bool> results) async {
  if (!await dir.exists()) return;
  
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      
      // Check for imports
      for (final package in dependencies.keys) {
        if (content.contains("import 'package:$package/") ||
            content.contains('import "package:$package/')) {
          results[package] = true;
        }
      }
    }
  }
}