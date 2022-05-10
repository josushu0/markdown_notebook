import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
        bottom: TabBar(
            controller: TabController(
              length: 2,
              vsync: this,
            ),
            tabs: const [
              Tab(
                child: Icon(Icons.edit),
              ),
              Tab(
                child: Icon(Icons.visibility),
              )
            ]),
      ),
    );
  }
}
