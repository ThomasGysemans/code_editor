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
          onSubmit: (String language, String value) {}, // when the user confirms changes in one of the files
        ),
      ),
    );
  }
}
```

For the style options, you have a lot of possibilites : 

```
// the class, to show you what you can change
class EditorModelStyleOptions {
  final EdgeInsets padding;
  final double heightOfContainer;
  final Map<String, TextStyle> theme;
  final String fontFamily;
  final double letterSpacing;
  final double fontSize;
  final double lineHeight;
  final int tabSize;
  final Color editorColor;
  final Color editorBorderColor;
  final Color editorFilenameColor;
  final Color editorToolButtonColor;
  final Color editorToolButtonTextColor;
}
```

In order to modify the edit button, use :

```
// into EditorModelStyleOptions : 
(void) defineEditButtonProperties(color: Colors.red, textColor: Colors.white, text: "Edit")
```

You can also change the position of the edit button

```
// into EditorModelStyleOptions :
(void) defineEditButtonPosition(bottom: 10, right: 15) // default values

// WARNING
// if top < 50 => top = 50
// minimum value of top is 50 because of the height of the navbar
```

The default values of EditorModelStyleOptions are :

```
padding = const EdgeInsets.all(15.0),
heightOfContainer = 300,
theme: myTheme, // the custom theme
fontFamily: "monospace", // "Poppins" is a good font family too
fontSize: 15,
lineHeight: 1.6,
tabSize: 2, // do not use a to high number
editorColor: Color(0xff2E3152),
editorBorderColor: Color(0xFF3E416E), // the color of the borders between elements in the editor
editorFilenameColor: Color(0xFF6CD07A), // the color of the file's name
editorToolButtonColor:  Color(0xFF4650c7), // the tool's buttons
editorToolButtonTextColor: Colors.white

// with defineEditButtonProperties()
editButtonTextColor: Colors.black,
editButtonName: "Edit"

// with defineEditButtonPosition()
editButtonPosBottom: 10,
editButtonPosRight: 15
```

## Notable issue

For the moment, I haven't been able to fix a slight bug that occurs when there is a lot of code. Indeed, when the code goes out of the text field, and the user clicks on it to be able to write in it, he can't go all the way down because of the phone keypad.

## Internal dependencies

code_editor uses the following dependencies to work :
1. flutter_highlight
2. provider
3. font_awesome_flutter

## Contributing

Do not hesitate to contribute to the project, i just begin :)

## License

MIT License
