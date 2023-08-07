import 'package:flutter/material.dart';
import 'package:code_editor/code_editor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  late EditorModel model;

  @override
  void initState() {
    super.initState();
    // example of a easier way to write code instead of writing it in a single string
    List<String> contentOfPage1 = [
      "<!DOCTYPE html>",
      "<html lang='fr'>",
      "\t<body>",
      "\t\t<a href='page2.html'>go to page 2</a>",
      "\t</body>",
      "</html>",
    ];

    // The files displayed in the navigation bar of the editor.
    // You are not limited.
    // By default, [name] = "file.${language ?? 'txt'}", [language] = "text" and [code] = "",
    List<FileEditor> files = [
      FileEditor(
        name: "page1.html",
        language: "html",
        code: contentOfPage1.join("\n"), // [code] needs a string
      ),
      FileEditor(
        name: "page2.html",
        language: "html",
        code: "<a href='page1.html'>go back</a>",
        readonly: true, // this file won't be editable
      ),
      FileEditor(
        name: "style.css",
        language: "css",
        code: "a { color: red; }",
      ),
    ];

    // The model used by the CodeEditor widget, you need it in order to control it.
    // But, since 1.0.0, the model is not required inside the CodeEditor Widget.
    // To start without a model, you need to use `CodeEditor.empty()`.
    model = EditorModel(
      files: files, // the files created above
      // you can customize the editor as you want
      styleOptions: EditorModelStyleOptions(
        showUndoRedoButtons: true,
        reverseEditAndUndoRedoButtons: true,
      )..defineEditButtonPosition(
          bottom: 10,
          left: 15,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("code_editor example")),
      // /!\ The SingleChildScrollView is important because of the phone's keypad which causes a "RenderFlex overflowed by x pixels on the bottom" error
      body: SingleChildScrollView(
        child: Column(
          children: [
            CodeEditor(
              model: model,
              formatters: const ["html"],
            ),

            // Just to show you how to add elements below the editor (or above),
            // here simple widgets you can remove.
            // It also shows how to manipulate state on the same page as an editor.

            ElevatedButton(
              onPressed: () {
                setState(() {
                  count++;
                });
              },
              child: const Text("click"),
            ),
            Text("count = $count")
          ],
        ),
      ),
    );
  }
}
