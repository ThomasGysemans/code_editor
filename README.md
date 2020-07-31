# code_editor

A CSS, HTML and Javascript code editor for Android (Flutter).

## Description

With this code editor, you can, for the moment, allow your users to edit three files: "index.html", "style.css" and "app.js". You can switch between these three files to edit their content with tools that make writing easier. Once editing is complete, the code is highlighted according to the imposed theme (by default a custom one).
You can choose your theme of create your own by : import 'package:flutter_highlight/themes/github.dart';

## Installation

It's very easy to install :

* Add in the pubspec.yaml file

```
dependencies:
  code_editor: ^0.0.1
```

* Don't forget to update the modifications of the pubspec.yaml file

```
$ flutter pub get
```

* Finally, use code_editor in your flutter project

```
import 'package:code_editor/code_editor.dart';
```

## Usage

After importing the package into your project, you can initiliaze an EditorModel to control the editor :

```
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // the code to display for the wanted language.
    // code_editor creates a "file" for each language.
    // example : for html, it creates "index.html" in the navbar of the editor
    Map<String, String> code = {
      "html": "<!DOCTYPE html>\n\t<html lang='fr'>",
      "css": "span {}",
      "js": "console.log('Hello, World!')",
    };

    EditorModel model = new EditorModel(
      code: code, // if not specified, the html, css and js files will be empty
      styleOptions: EditorModelStyleOptions(), // to control the styles of the editor, not required because the editor have default styles
    );

    return Scaffold(
      appBar: AppBar(title: Text("code_editor example")),
      body: SingleChildScrollView( // /!\ important because of the telephone keypad which causes a "RenderFlex overflowed by x pixels on the bottom" error
        CodeEditor(
          model: model, // the model created above
          onSubmit: (String language, String value) {}, // when the user confirms changes in one of the files.
        ),
      ),
    );
  }
}
```


## Internal dependencies

code_editor uses the following dependencies to work :
1. flutter_highlight
2. provider
3. font_awesome_flutter


## Contributing

Do not hesitate to contribute to the project, i just begin :)

## License

MIT License
