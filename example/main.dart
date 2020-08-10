import 'package:flutter/material.dart';
import 'package:code_editor/code_editor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'code_editor tests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("code_editor tests"), elevation: 0),
        body: MyEditor(),
      ),
    );
  }
}

class MyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> contentOfPage1 = [
      "<!DOCTYPE html>",
      "<html lang='fr'>",
      "\t<body>",
      "\t\t<a href='page2.html'>go to page 2</a>",
      "\t</body>",
      "</html>",
    ];

    List<FileEditor> files = [
      new FileEditor(
        name: "page1.html",
        language: "html",
        code: contentOfPage1.join("\n"),
      ),
      new FileEditor(
        name: "page2.html",
        language: "html",
        code: "<a href='page1.html'>go back</a>",
      ),
      new FileEditor(
        name: "style.css",
        language: "css",
        code: "a { color: red; }",
      ),
    ];

    EditorModel model = new EditorModel(
      files: files,
      styleOptions: new EditorModelStyleOptions(
        fontSize: 13,
      ),
    );

    return SingleChildScrollView(
      child: CodeEditor(
        model: model,
        onSubmit: (String language, String value) {
          print("language = $language");
          print("value = '$value'");
        },
      ),
    );
  }
}
