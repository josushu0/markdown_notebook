import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.storage}) : super(key: key);
  final EditorStorage storage;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class EditorStorage {
  Future<String?> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory?.path;
  }

  Future<String> readFile(String fileName) async {
    try {
      final path = await _localPath;
      final file = File('$path/$fileName');

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<File> writeFile(String fileName, String text) async {
    final path = await _localPath;
    final file = File('$path/$fileName');

    // Write the file
    return file.writeAsString(text);
  }
}

class _EditorPageState extends State<EditorPage>
    with SingleTickerProviderStateMixin {
  String text = "";
  String fileName = "NuevoArchivo.md";
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

  void _pickFile() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result == null) {
        setState(() {
          fileName = "NuevoArchivo.md";
        });
        return;
      }
      setState(() {
        fileName = result.files.first.name;
      });
      widget.storage.readFile(fileName).then((String content) {
        setState(() {
          text = content;
          textEditingController.text = text;
        });
      });
      return;
    }
    if (await Permission.speech.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _saveFile() {
    widget.storage.writeFile(fileName, text);
  }

  void _newFile() {
    setState(() {
      text = "";
      fileName = "NuevoArchivo.md";
      textEditingController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _newFile(),
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
                onTap: () => _saveFile(),
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
              // PopupMenuItem(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: const [
              //       Icon(
              //         Icons.save_as,
              //         color: Colors.black,
              //       ),
              //       Padding(
              //         padding: EdgeInsets.only(left: 8),
              //         child: Text("Guardar como..."),
              //       ),
              //     ],
              //   ),
              // ),
              PopupMenuItem(
                onTap: () => _pickFile(),
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
