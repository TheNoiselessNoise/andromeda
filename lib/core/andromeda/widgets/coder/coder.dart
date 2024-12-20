import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class AndromedaCoder extends StatefulWidget {
  final SAppConfig app;

  const AndromedaCoder({
    super.key,
    required this.app,
  });

  @override
  State<AndromedaCoder> createState() => _AndromedaCoderState();
}

class _AndromedaCoderState extends State<AndromedaCoder> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  void _showToolbox(BuildContext context) async {
    final state = Provider.of<AndromedaCoderState>(context, listen: false);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.widgets)),
                  Tab(icon: Icon(Icons.settings)),
                  Tab(icon: Icon(Icons.format_list_bulleted)),
                ],
              ),
              ChangeNotifierProvider.value(
                value: state,
                child: Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ToolboxTabWidgets(tabController: _tabController),
                      ToolboxTabProperties(tabController: _tabController),
                      ToolboxTabViews(tabController: _tabController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openLog() async {
    // TODO: this
  }

  void _preview() async {
    // TODO: this
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AndromedaCoderState(app: widget.app),
      child: Consumer<AndromedaCoderState>(
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.app.label,
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            body: Column(
              children: [
                // TODO: code editor with custom highlighting for custom DSL
                Expanded(
                  child: CodeEditor(
                    initialCode: '',
                    onChanged: (code) {

                    },
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      height: 1,
                    ),
                  )
                ),

                // TODO: available clickable autocomplete suggestions
                // Row(
                //   children: [
                //     Text('Suggestions'),
                //   ],
                // ),

                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.subject),
                        onPressed: _openLog, // TODO: Open log
                        tooltip: 'Open Log',
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.build),
                        onPressed: () { _showToolbox(context); },
                        tooltip: 'Toolbox',
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _preview, // TODO: Preview
                        tooltip: 'Preview',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}