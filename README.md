# code_editor

A CSS, HTML and Javascript code editor for Flutter with syntax highlighting and custom theme.

## Description

The editor displays the contents of fictitious "files" that correspond to a FileEditor, each file has properties such as its name (index.html), its content and the language this file uses.

In other words, with this code editor, you can edit files, wich contain code. You can switch between the files in the navigation bar to edit their content with tools that make writing easier. Once editing is complete, the code is highlighted according to the imposed theme (by default a custom one).
You can choose your theme or create your own by checking at "import 'package:flutter_highlight/themes/github.dart';"

![example-1](https://learnweb.sciencesky.fr/code_editor_example-1.png)
![example-2](https://learnweb.sciencesky.fr/code_editor_example-2.png)
![example-3](https://learnweb.sciencesky.fr/code_editor_example-3.png)

## Installation

It's very easy to install :

* Add in the pubspec.yaml file

```
dependencies:
  code_editor: ^0.1.0
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
    // example of a easier way to write code instead of writing it in a single string
    List<String> contentOfPage1 = [
      "<!DOCTYPE html>",
      "<html lang='fr'>",
      "\t<body>",
      "\t\t<a href='page2.html'>go to page 2</a>",
      "\t</body>",
      "</html>",
    ];

    // the files displayed in the navigation bar of the editor
    // you are not limited
    // name and language are @required, by default code = ""
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
    
    // the model used by the CodeEditor widget, you need it in order to control it
    EditorModel model = new EditorModel(
      files,
      // you can customize the editor as you want
      styleOptions: new EditorModelStyleOptions(
        fontSize: 13,
      ),
    );
    
    return Scaffold(
      appBar: AppBar(title: Text("code_editor example")),
      body: SingleChildScrollView( // /!\ important because of the telephone keypad which causes a "RenderFlex overflowed by x pixels on the bottom" error
        // display the CodeEditor widget
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
