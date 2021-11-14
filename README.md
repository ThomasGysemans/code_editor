# code_editor

A code editor (dart, js, html, ...) for Flutter with syntax highlighting and custom theme.

* null-safety enabled since **1.2.0** thanks to contributors.

## Description

The editor displays the contents of fictitious "files" that correspond to a FileEditor, each file has properties such as its name (index.html), its content and the language this file uses.

In other words, with this code editor, you can edit files which contain code. You can switch between the files in the navigation bar to edit their content with tools that make writing easier. Once editing is complete, the code is highlighted according to the imposed theme (by default a custom one).
You can choose your theme or create your own by checking at "import 'package:flutter_highlight/themes/github.dart';"

![example-1](https://learnweb.sciencesky.fr/code_editor_example-1.png)
![example-2](https://learnweb.sciencesky.fr/code_editor_example-2.png)
![example-3](https://learnweb.sciencesky.fr/code_editor_example-3.png)

## Installation

It's very easy to install :

* Add in the pubspec.yaml file

```yaml
dependencies:
  code_editor: ^1.3.1
```

* Don't forget to update the modifications of the pubspec.yaml file

```
$ flutter pub get
```

* Finally, use code_editor in your flutter project

```dart
import 'package:code_editor/code_editor.dart';
```

## Usage

After importing the package into your project, you can initiliaze an EditorModel to control the editor :

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      new FileEditor(
        name: "page1.html",
        language: "html",
        code: contentOfPage1.join("\n"), // [code] needs a string
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
    
    // The model used by the CodeEditor widget, you need it in order to control it.
    // But, since 1.0.0, the model is not required inside the CodeEditor Widget.
    EditorModel model = new EditorModel(
      files: files, // the files created above
      // you can customize the editor as you want
      styleOptions: new EditorModelStyleOptions(
        fontSize: 13,
      ),
    );
    
    // A custom TextEditingController.
    final myController = TextEditingController(text: 'hello!');

    return Scaffold(
      appBar: AppBar(title: Text("code_editor example")),
      body: SingleChildScrollView( // /!\ important because of the telephone keypad which causes a "RenderFlex overflowed by x pixels on the bottom" error
        // display the CodeEditor widget
        child: CodeEditor(
          model: model, // the model created above, not required since 1.0.0
          edit: false, // can edit the files ? by default true
          disableNavigationbar: false, // hide the navigation bar ? by default false
          onSubmit: (String? language, String? value) {}, // when the user confirms changes in one of the files
          textEditingController: myController, // Provide an optional, custom TextEditingController.
        ),
      ),
    );
  }
}
```

For the style options, you have a lot of possibilites : 

```dart
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
  final Color editButtonBackgroundColor;
  final Color editButtonTextColor;
  final String editButtonName;
  final double fontSizeOfFilename;
  final TextStyle textStyleOfTextField;
  final ToolbarOptions toolbarOptions;
  final bool placeCursorAtTheEndOnEdit;
}
```

Change the position of the edit button ("Edit") with :

```dart
// into EditorModelStyleOptions :
(void) defineEditButtonPosition(bottom: 10, right: 15) // default values

// WARNING
// if top < 50 => top = 50
// minimum value of top is 50 because of the height of the navbar
```

The default values of EditorModelStyleOptions are :

```dart
padding = const EdgeInsets.all(15.0),
heightOfContainer = 300,
theme = myTheme, // the custom Theme
fontFamily = "monospace",
letterSpacing,
fontSize = 15,
lineHeight = 1.6,
tabSize = 2, // do not use a to high number
editorColor = defaultColorEditor, // Color(0xff2E3152)
editorBorderColor = defaultColorBorder, // Color(0xFF3E416E), the color of the borders between elements in the editor
editorFilenameColor = defaultColorFileName, // Color(0xFF6CD07A) the color of the file's name
editorToolButtonColor = defaultToolButtonColor, // Color(0xFF4650c7) the tool's buttons
editorToolButtonTextColor = Colors.white,
editButtonBackgroundColor = defaultEditBackgroundColor, // Color(0xFFEEEEEE)
editButtonTextColor = Colors.black,
editButtonName = "Edit",
fontSizeOfFilename,
textStyleOfTextField = const TextStyle(
  color: Colors.black87,
  fontSize: 16,
  letterSpacing: 1.25,
  fontWeight: FontWeight.w500,
),
toolbarOptions = const ToolbarOptions(),
placeCursorAtTheEndOnEdit = true

// with defineEditButtonPosition()
editButtonPosBottom: 10,
editButtonPosRight: 15
```

## Internal dependencies

code_editor uses the following dependencies to work :
1. flutter_highlight
2. font_awesome_flutter

## Contributing

Do not hesitate to contribute to the project, I just begin :)

## License

MIT License
