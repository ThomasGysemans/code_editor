## [1.3.0] - June 26, 2021

- Ability to pass in custom `TextEditingController` to the `CodeEditor`.

## [1.2.0] - June 15, 2021

+ null-safety thanks to contributors
+ Updates the dependencies to their latest version.

## [1.1.1] - April 24, 2021

+ dartfmt
+ See [https://dart.dev/tools/dart-format]()

## [1.1.0] - April 24, 2021

+ Bug fixes.
+ Fix typo.
+ Better compatibility with the latest version of Flutter (the deprecated widgets have been removed).
+ Reorganisation of `EditorModelStyleOptions.dart`.
+ Updates the dependencies to their latest version.

## [1.0.1] - Aug 10, 2020

Fix typo.

## [1.0.0] - Aug 10, 2020

This is a big version !
Here are all the updates : 

+ There was a bug before : you could'nt change the content of a file outside the CodeEditor Widget, I mean in a SetState() function. Now, it's possible.

+ You can choose to disable the navigation bar with the new parameter : disableNavigationbar (by default set to false). If you hide the navigation bar, only the first file will be displayed.

+ WARNING : if you move your project to this version, you will need to modify a little thing : EditorModel has no positional arguments anymore, so to define your files, you will have to name the parameter to "files". Check the Readme section.

+ Now, there is no required parameters anymore. Everything has a default value to bring more flexibility to developers. Check the Readme section for more info.

+ code_editor does not use Provider package anymore.

+ The Readme section is more readable and more accurate.

Enjoy Coding !

## [0.2.0] - Aug 7, 2020

From now on, when the code overflows the editor, the scroll is better.

+ New parameter inside EditorModelStyleOptions : TextStyle textStyleOfTextField, the style of the text inside the text field.

code_editor is much better since its initial release :)

## [0.1.3] - Aug 7, 2020

The CodeEditor Widget doesn't have margin property anymore.

## [0.1.2] - Aug 6, 2020

onSubmit parameter is not required anynome inside the CodeEditor Widget.

+ A new parameter : bool edit, by default its value is true. Set it to false if you want to disable file editing. Use it inside the CodeEditor Widget.

+ New parameter inside EditorModelStyleOptions : double fontSizeOfFilename, the font size of the files' names.

+ The documentation in the source code is much better !

## [0.1.1] - Aug 1, 2020

Minor changes

## [0.1.0] - Aug 1, 2020

Complete change of the files implementation method : you can now define the name of the files in the navbar, define which language you want among dozens and define the content of each file. Moreover, you are no longer limited by a maximum number of files, you can put as many as you want!

+ Minor bug fixes.

See all the available languages at :
https://github.com/git-touch/highlight/tree/master/highlight/lib/languages

## [0.0.1] - Aug 1, 2020

Initial release
