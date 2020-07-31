# code_editor

A CSS, HTML and Javascript code editor for Android.

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

## Dependencies

code_editor uses the following dependencies to work :
flutter_highlight
provider
font_awesome_flutter

## License

MIT License

## Contributing

Do not hesitate to contribute to the project, i just begin :)
