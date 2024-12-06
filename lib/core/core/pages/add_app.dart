import 'dart:math';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/v4.dart';
import 'package:andromeda/core/_.dart';

class AndromedaAddApplicationPage extends StatefulWidget {
  const AndromedaAddApplicationPage({super.key});

  @override
  State<AndromedaAddApplicationPage> createState() => _AndromedaAddApplicationPageState();
}

class _AndromedaAddApplicationPageState extends State<AndromedaAddApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  Icon _selectedIcon = const Icon(Icons.apps);
  bool _isSecured = false;
  bool _isCustom = false;
  bool _obscureText = true;
  String? _selectedAuthMethod;
  bool _isBiometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _labelController.text = tr('addapp-new-application');
  }

  void _checkBiometrics() async {
    bool isAvailable = await AuthService().isBiometricsAvailable();
    if (mounted) { setState(() { _isBiometricsAvailable = isAvailable; }); }
  }

  List<DropdownMenuItem<String>> _getAuthMethods() {
    final List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
        value: AppSecureMethod.password,
        child: Row(
          children: [
            const Icon(Icons.lock),
            const SizedBox(width: 8),
            Text(tr('addapp-password-auth')),
          ],
        ),
      ),
    ];

    if (_isBiometricsAvailable) {
      items.add(DropdownMenuItem(
        value: AppSecureMethod.biometric,
        child: Row(
          children: [
            const Icon(Icons.fingerprint),
            const SizedBox(width: 8),
            Text(tr('addapp-biometric-auth')),
          ],
        ),
      ));
    }

    return items;
  }

  Widget _buildAuthenticationWidget() {
    switch (_selectedAuthMethod) {
      case AppSecureMethod.password:
        return Column(
          children: [
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: tr('addapp-password'),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (_isSecured && (value == null || value.length < 6)) {
                        return tr('addapp-password-too-short');
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    foregroundColor: WidgetStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ],
            )
          ],
        );
      case AppSecureMethod.biometric:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            tr('addapp-biometric-will-be-required'),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _generateSalt([int length = 32]) {
    final random = Random.secure();
    final salt = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(salt);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isSecured && _selectedAuthMethod == AppSecureMethod.biometric) {
        final authenticated = await AuthService().authenticateBiometric(
          tr('addapp-authenticate-to-add-application'),
        );

        if (!authenticated) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr('addapp-biometric-auth-failed'))),
            );
          }
          return;
        }
      }

      final appBundle = await StorableMap.from<SAppBundle>(
        storage,
        SK.applications,
        (data) => SAppBundle(data),
      );

      List<SAppConfig> applications = appBundle?.applications ?? [];
      
      var newApp = SAppConfig.from(
        id: const UuidV4().toString(),
        label: _labelController.text.isNotEmpty ? _labelController.text : tr('addapp-new-application'),
        serverUrl: _serverUrlController.text,
        apiKey: _apiKeyController.text,
        icon: _selectedIcon.icon,
        isSecured: _isSecured,
        authMethod: _selectedAuthMethod,
        isCustom: _isCustom,
      );

      if (_isSecured && _selectedAuthMethod == AppSecureMethod.password) {
        final salt = _generateSalt();
        final bytes = utf8.encode(_passwordController.text + salt);
        final digest = sha256.convert(bytes);
        newApp = newApp.copyWith(
          hashedPassword: digest.toString(),
          salt: salt,
        );
      }

      applications.add(newApp);

      await SAppBundle.from(applications: applications).to(storage, SK.applications);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _startQRScan() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('addapp-camera-required-for-qr'))),
        );
      }
      return;
    }

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScanner(),
      ),
    );

    if (result != null && mounted) {
      final RegExp regex = RegExp(r'\[LABEL\](.*?)\[URL\](.*?)\[APIKEY\](.*?)$');
      final match = regex.firstMatch(result);

      if (match != null && match.groupCount >= 2) {
        setState(() {
          _serverUrlController.text = match.group(1)!;
          _apiKeyController.text = match.group(2)!;
          if (match.groupCount >= 3) {
            _labelController.text = match.group(3)!;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('addapp-invalid-qr-format'))),
        );
      }
    }
  }

  void _showAddFromDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('addapp-add-from')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: Text(tr('addapp-qr-code')),
                onTap: () {
                  Navigator.pop(context);
                  _startQRScan();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget animateToggle({
    required bool visible,
    required Widget child,
    Duration durationSize = const Duration(milliseconds: 300),
    Duration durationOpacity = const Duration(milliseconds: 200),
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: visible ? AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: visible ? 1 : 0,
        child: child,
      ) : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('addapp-appbar-title')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: _selectedIcon.resize(48),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            IconPickerIcon? newIcon = await showIconPicker(
                              context,
                              configuration: SinglePickerConfiguration(
                                title: Text(tr('addapp-select-icon')),
                                noResultsText: tr('addapp-no-icons-found'),
                                searchHintText: tr('addapp-search-icon'),
                                closeChild: Text(tr('addapp-close')),
                              )
                            );
                            if (newIcon != null) {
                              setState(() { _selectedIcon = Icon(newIcon.data); });
                            }
                          },
                          child: Text(tr('addapp-change-icon')),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: Text(tr('addapp-is-custom')),
                    subtitle: Text(tr('addapp-is-custom-desc')),
                    value: _isCustom,
                    onChanged: (value) { setState(() { _isCustom = value; }); },
                  ),

                  const SizedBox(height: 16),
                  
                  TextFormField(
                    autofocus: false,
                    controller: _labelController,
                    decoration: InputDecoration(
                      labelText: tr('addapp-label'),
                      hintText: tr('addapp-enter-label-hint'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('addapp-please-enter-label');
                      }
                      return null;
                    },
                  ),

                  animateToggle(
                    visible: !_isCustom,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        TextFormField(
                          autofocus: false,
                          controller: _serverUrlController,
                          decoration: InputDecoration(
                            labelText: tr('addapp-server-url'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr('addapp-please-enter-server-url');
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          autofocus: false,
                          controller: _apiKeyController,
                          decoration: InputDecoration(
                            labelText: tr('addapp-api-key'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr('addapp-please-enter-api-key');
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: Text(tr('addapp-secure-instance')),
                    subtitle: Text(tr('addapp-secure-instance-desc')),
                    value: _isSecured,
                    onChanged: (value) {
                      setState(() {
                        _isSecured = value;
                        if (!value) {
                          _selectedAuthMethod = null;
                          _passwordController.clear();
                        }
                      });
                    },
                  ),

                  animateToggle(
                    visible: _isSecured,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _selectedAuthMethod,
                          decoration: InputDecoration(
                            labelText: tr('addapp-auth-method'),
                          ),
                          items: _getAuthMethods(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAuthMethod = value;
                              _passwordController.clear();
                            });
                          },
                          validator: (value) {
                            if (_isSecured && value == null) {
                              return tr('addapp-please-select-auth-method');
                            }
                            return null;
                          },
                        ),
                        
                        _buildAuthenticationWidget(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(tr('addapp-submit')),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _showAddFromDialog,
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(tr('addapp-add-from')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}