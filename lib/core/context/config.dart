import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../api/_.dart';

class FScriptConfig {
  final FlutterSecureStorage _storage;
  static const String _serverKey = 'fscript_server';
  static const String _apiKey = 'fscript_api_key';

  FScriptConfig() : _storage = const FlutterSecureStorage();

  Future<bool> hasConfig() async {
    final server = await _storage.read(key: _serverKey);
    final apiKey = await _storage.read(key: _apiKey);
    return server != null && apiKey != null;
  }

  Future<void> saveConfig({
    required String server,
    required String apiKey,
  }) async {
    await _storage.write(key: _serverKey, value: server);
    await _storage.write(key: _apiKey, value: apiKey);
  }

  Future<void> clearConfig() async {
    await _storage.delete(key: _serverKey);
    await _storage.delete(key: _apiKey);
  }

  Future<(String, String)?> getConfig() async {
    final server = await _storage.read(key: _serverKey);
    final apiKey = await _storage.read(key: _apiKey);
    if (server != null && apiKey != null) {
      return (server, apiKey);
    }
    return null;
  }
}

// Configuration screen widget
class FScriptConfigScreen extends StatefulWidget {
  final void Function(String server, String apiKey) onConfigured;

  const FScriptConfigScreen({
    super.key,
    required this.onConfigured,
  });

  @override
  State<FScriptConfigScreen> createState() => _FScriptConfigScreenState();
}

class _FScriptConfigScreenState extends State<FScriptConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Test the connection before saving
      final apiService = FScriptApiService(
        baseUrl: _serverController.text,
        apiKey: _apiKeyController.text,
      );

      // TODO: define this somewhere
      await apiService.fetchScript('main.andromeda');

      // If successful, save the config
      await FScriptConfig().saveConfig(
        server: _serverController.text,
        apiKey: _apiKeyController.text,
      );

      widget.onConfigured(
        _serverController.text,
        _apiKeyController.text,
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Configure FScript',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _serverController,
                      decoration: const InputDecoration(
                        labelText: 'Server URL',
                        hintText: 'https://api.example.com',
                        prefixIcon: Icon(Icons.dns),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Server URL is required';
                        }
                        try {
                          final uri = Uri.parse(value!);
                          if (!uri.isScheme('http') && !uri.isScheme('https')) {
                            return 'Invalid URL scheme';
                          }
                        } catch (_) {
                          return 'Invalid URL format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _apiKeyController,
                      decoration: const InputDecoration(
                        labelText: 'API Key',
                        hintText: 'Enter your API key',
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'API key is required';
                        }
                        return null;
                      },
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Connect'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _serverController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }
}