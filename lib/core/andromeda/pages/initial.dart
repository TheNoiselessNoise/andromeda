import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class AndromedaInitialPage extends StatefulWidget {
  const AndromedaInitialPage({super.key});

  @override
  State<AndromedaInitialPage> createState() => _AndromedaInitialPageState();
}

class _AndromedaInitialPageState extends State<AndromedaInitialPage> {
  SAppBundle appBundle = const SAppBundle();

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  Future<void> loadApplications() async {
    final storedAppBundle = await Storage.load<SAppBundle>(
      SK.applications,
      (data) => SAppBundle(data),
    );

    if (storedAppBundle != null) {
      setState(() { appBundle = storedAppBundle; });
    }
  }

  Future<void> showApplicationMenu(SAppConfig app) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.zero),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(app.label),
              leading: Icon(app.icon),
              subtitle: !app.isCustom ? Text(app.serverUrl) : null,
            ),

            const Divider(),

            if (app.isCustom) ...[
              ListTile(
                title: Text(tr('main-designer-app')),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AndromedaDesigner(app: app)),
                  );
                  await loadApplications();
                  if (context.mounted) Navigator.pop(context);
                }
              )
            ],

            ListTile(
              title: Text(tr('main-edit-app')),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AndromedaEditAppPage(app: app)),
                );
                await loadApplications();
                if (context.mounted) Navigator.pop(context);
              }
            ),

            ListTile(
              title: Text(tr('main-remove-app')),
              onTap: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(app.label),
                      content: Text(tr('main-remove-app-confirm').format([app.label])),
                      actions: [
                        TextButton(
                          child: Text(tr('main-remove-app-cancel')),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        TextButton(
                          child: Text(tr('main-remove-app-remove')),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirm) {
                  final newBundle = appBundle.removeApplication(app);
                  await Storage.save(SK.applications, newBundle);
                  await loadApplications();
                }

                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildApplicationsList({
    required String title,
    required List<SAppConfig> applications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...applications.map((app) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(app.label),
              subtitle: !app.isCustom ? Text(app.serverUrl) : null,
              leading: Icon(app.icon),
              trailing: app.appiconWidget,
              onLongPress: () { showApplicationMenu(app); },
            ),
            if (app != applications.last) const Divider(),
          ],
        )),
      ],
    );
  }

  Widget buildApplications() {
    if (appBundle.appList.isEmpty) {
      return Center(
        child: Text(tr('main-no-applications')),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (appBundle.hasRemoteApps) ...[
            buildApplicationsList(
              title: tr('main-remote-applications'),
              applications: appBundle.remoteAppList,
            ),
          ],

          if (appBundle.hasCustomApps) ...[
            buildApplicationsList(
              title: tr('main-custom-applications'),
              applications: appBundle.customAppList,
            ),
          ],

          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AndromedaCoder(app: appBundle.appList.first)),
                  // builder: (context) => AndromedaDesigner(app: appBundle.appList.first)),
              );
            },
            child: const Text('[DEV] Design First App'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('main-applications')),
      ),
      drawer: Consumer<TranslationManager>(
        builder:(context, translations, child) {
          return Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  const Text('Andromeda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(tr('main-settings')),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AndromedaSettingsPage()),
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(tr('main-about')),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AndromedaAboutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AndromedaAddAppPage()),
          );
          if (result == true) {
            await loadApplications();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(child: buildApplications()),
    );
  }
}