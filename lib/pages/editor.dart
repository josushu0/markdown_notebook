import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with SingleTickerProviderStateMixin {
  String text = "";
  late TabController tabController;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor Markdown"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Nuevo"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Guardar"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.save_as,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Guardar como..."),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.file_open,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text("Abrir"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(controller: tabController, tabs: const [
          Tab(
            child: Icon(Icons.edit),
          ),
          Tab(
            child: Icon(Icons.visibility),
          )
        ]),
      ),
      body: TabBarView(controller: tabController, children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: TextField(
            expands: true,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: textEditingController,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: "Escriba algo..."),
            onChanged: (String text) {
              setState(() {
                this.text = text;
              });
            },
          ),
        ),
        Markdown(
          data: text,
          extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubFlavored.blockSyntaxes, [
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
          ]),
        ),
      ]),
    );
  }
}
