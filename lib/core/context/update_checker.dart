import 'dart:async';
import 'package:flutter/material.dart';
import '../api/_.dart';
import 'script.dart';

class UpdateChecker extends ChangeNotifier {
  final FScriptApiService apiService;
  final String scriptPath;
  final Duration checkInterval;
  Timer? _timer;
  int? _lastVersion;
  bool _updateAvailable = false;
  bool get updateAvailable => _updateAvailable;

  UpdateChecker({
    required this.apiService,
    required this.scriptPath,
    this.checkInterval = const Duration(seconds: 10),
  });

  void startChecking() {
    _timer?.cancel();
    _timer = Timer.periodic(checkInterval, (_) => checkForUpdates());
  }

  void stopChecking() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> checkForUpdates() async {
    try {
      final version = await apiService.getScriptVersion();
      if (version == null) return;
      
      if (_lastVersion == null || version > _lastVersion!) {
        _updateAvailable = true;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail on check errors
      print('Update check failed: $e');
    }
  }

  Future<String?> fetchUpdate() async {
    try {
      final content = await apiService.fetchScript(scriptPath);
      _lastVersion = await apiService.getScriptVersion();
      _updateAvailable = false;
      notifyListeners();
      
      return content.source;
    } catch (e) {
      print('Update fetch failed: $e');
      return null;
    }
  }

  @override
  void dispose() {
    stopChecking();
    super.dispose();
  }
}

class UpdateNotifier extends StatelessWidget {
  final Widget child;
  final void Function() onUpdate;

  const UpdateNotifier({
    super.key,
    required this.child,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final checker = context.findAncestorStateOfType<FScriptWidgetState>()?.updateChecker;
    
    return Stack(
      children: [
        child,
        if (checker != null)
          ListenableBuilder(
            listenable: checker,
            builder: (context, _) {
              if (!checker.updateAvailable) return const SizedBox.shrink();
              
              return Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.system_update),
                  label: const Text('Update Available'),
                ),
              );
            },
          ),
      ],
    );
  }
}