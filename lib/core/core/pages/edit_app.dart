import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:andromeda/core/_.dart';

class AndromedaEditApplicationPage extends StatefulWidget {
  final SAppConfig app;

  const AndromedaEditApplicationPage({
    super.key,
    required this.app,
  });

  @override
  State<AndromedaEditApplicationPage> createState() => _AndromedaEditApplicationPageState();
}

class _AndromedaEditApplicationPageState extends State<AndromedaEditApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final storage = const FlutterSecureStorage();

  late Icon _selectedIcon;

  @override
  void initState() {
    super.initState();
    // Prefill the form with existing data
    _selectedIcon = Icon(widget.app.icon);
    _labelController.text = widget.app.label;
    _serverUrlController.text = widget.app.serverUrl;
  }

  Icon resizeIcon(Icon icon) {
    return Icon(
      icon.icon,
      size: 48,
      color: icon.color,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final appBundle = await StorableMap.from<SAppBundle>(
        storage,
        SK.applications,
        (data) => SAppBundle(data),
      );

      List<SAppConfig> applications = appBundle?.applications ?? [];
      
      final index = applications.indexWhere((app) => app.id == widget.app.id);

      if (index != -1) {
        var updatedApp = applications[index].copyWith(
          label: _labelController.text,
          serverUrl: _serverUrlController.text,
          apiKey: _apiKeyController.text.isNotEmpty ? _apiKeyController.text : widget.app.apiKey,
          icon: _selectedIcon.icon,
        );

        applications[index] = updatedApp;
        await SAppBundle.from(applications: applications).to(storage, SK.applications);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('editapp-application-not-found'))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('editapp-appbar-title')),
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
                        child: resizeIcon(_selectedIcon),
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
                                title: Text(tr('editapp-select-icon')),
                                noResultsText: tr('editapp-no-icons-found'),
                                searchHintText: tr('editapp-search-icon'),
                                closeChild: Text(tr('editapp-close')),
                              )
                            );
                            if (newIcon != null) {
                              setState(() { _selectedIcon = Icon(newIcon.data); });
                            }
                          },
                          child: Text(tr('editapp-change-icon')),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                    
                  TextFormField(
                    autofocus: false,
                    controller: _labelController,
                    decoration: InputDecoration(
                      labelText: tr('editapp-label'),
                      hintText: tr('editapp-enter-label-hint'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('editapp-please-enter-label');
                      }
                      return null;
                    },
                  ),

                  if (!widget.app.isCustom) ...[
                    const SizedBox(height: 16),

                    TextFormField(
                      autofocus: false,
                      controller: _serverUrlController,
                      decoration: InputDecoration(
                        labelText: tr('editapp-server-url'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr('editapp-please-enter-server-url');
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      autofocus: false,
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        labelText: tr('editapp-api-key'),
                        hintText: tr('editapp-enter-new-api-key-optional'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: Text(tr('editapp-save-changes')),
                    ),
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