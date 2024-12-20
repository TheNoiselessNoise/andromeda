import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:andromeda/core/_.dart';

class AndromedaEditAppPage extends StatefulWidget {
  final SAppConfig app;

  const AndromedaEditAppPage({
    super.key,
    required this.app,
  });

  @override
  State<AndromedaEditAppPage> createState() => _AndromedaEditAppPageState();
}

class _AndromedaEditAppPageState extends State<AndromedaEditAppPage> {
  SAppConfig get app => widget.app;

  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();

  late Icon _selectedIcon;

  @override
  void initState() {
    super.initState();
    // Prefill the form with existing data
    _selectedIcon = Icon(app.icon);
    _labelController.text = app.label;
    _serverUrlController.text = app.serverUrl;
  }

  Icon resizeIcon(Icon icon, [double size = 48]) {
    return Icon(
      icon.icon,
      size: size,
      color: icon.color,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final appBundle = await Storage.load<SAppBundle>(
        SK.applications,
        (data) => SAppBundle(data),
      );

      final applications = appBundle?.appMap ?? {};
      
      if (applications.containsKey(app.id)) {
        var updatedApp = applications[app.id]!.copyWith(
          label: _labelController.text,
          serverUrl: _serverUrlController.text,
          apiKey: _apiKeyController.text.isNotEmpty ? _apiKeyController.text : app.apiKey,
          icon: _selectedIcon.icon,
        );

        applications[app.id] = updatedApp;
        final newBundle = SAppBundle.fromAppMap(applications);
        await Storage.save(SK.applications, newBundle);

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

  Form buildForm(BuildContext context) {
    return Form(
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

          if (!app.isCustom) ...[
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('editapp-appbar-title')),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 80,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildForm(context),
                ),
              ),
            ),
          ),
          
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
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
          ),
        ],
      ),
    );
  }
}