import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
        title: const Text("Editor"),
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
              border: InputBorder.none,
            ),
            onChanged: (String text) {
              setState(() {
                this.text = text;
              });
            },
          ),
        ),
        Markdown(data: text),
      ]),
    );
  }
}
