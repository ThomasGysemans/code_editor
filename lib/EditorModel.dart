part of code_editor;

/// A file in the editor, used by EditorModel model.[code]
/// [name] is the name of the file shown in the navbar
/// [language] is the language used by the theme
/// [code] is the content of the file, the code
/// Tip: to simplify writing code in a String, write line by line your code in a list List<String> and pass as argument list.join("\n").
class FileEditor {
  String name;
  String language;
  String code;
  FileEditor({
    @required this.name,
    @required this.language,
    this.code = "",
  });
}

/// Use the EditorModel into CodeEditor
/// in order to control the editor.
/// EditorModel extends ChangeNotifier because we use the provider package
/// to simplify the work
class EditorModel extends ChangeNotifier {
  int _currentPositionInFiles;
  bool _isEditing = false;
  EditorModelStyleOptions styleOptions;
  List<String> _languages;
  List<FileEditor> _files;

  /// define the required parameters for the editor to work fine.
  /// For that, you need to define [files] wich is a List<FileEditor>
  /// You can also define your own preferences with [styleOptions]
  EditorModel(List<FileEditor> files, {this.styleOptions}) {
    if (this.styleOptions == null) {
      this.styleOptions = new EditorModelStyleOptions();
    }
    this._languages = [];
    this._currentPositionInFiles = 0;
    if (files.length == 0) {
      files.add(
        new FileEditor(
          name: "index.html",
          language: "html",
          code: "",
        ),
      );
    }
    files.forEach((FileEditor file) {
      this._languages.add(file.language);
    });
    this._files = files;
  }

  /// checks in all th given files if [language] is found,
  /// then returns a List<String> of the code of the files that uses [language]
  List<String> getCodeWithLanguage(String language) {
    List<String> listOfCode = [];
    this._files.forEach((FileEditor file) {
      if (file.language == language) {
        listOfCode.add(file.code);
      }
    });
    return listOfCode;
  }

  /// returns the code of the file where [index]
  String getCodeWithIndex(int index) {
    return this._files[index].code;
  }

  /// returns the file where [index] corresponds
  FileEditor getFileWithIndex(int index) {
    return this._files[index];
  }

  /// switch the file using [i] as index of the List<FileEditor> files
  /// the user can't change the file if he is editing another one
  void changeIndexTo(int i) {
    if (this._isEditing) {
      return;
    }
    this._currentPositionInFiles = i;
    this._notify();
  }

  /// toggle the text field
  void toggleEditing() {
    this._isEditing = !this._isEditing;
    this._notify();
  }

  /// overwite the previous code of the file where [index] corresponds by [newCode]
  void updateCodeOfIndex(int index, String newCode) {
    this._files[index].code = newCode;
  }

  void _notify() => notifyListeners();

  /// get the index of wich file is currently displayed in the editor
  int get position => this._currentPositionInFiles;

  /// which language is show on the text field
  String get currentLanguage =>
      this._files[this._currentPositionInFiles].language;

  /// get all available languages of code_editor
  List<String> get allLanguages => this._languages;

  /// is the text field shown
  bool get isEditing => this._isEditing;

  /// get the number of files
  int get numberOfFiles => this._files.length;

  /// get all the files and their content
  List<FileEditor> get files => this._files;
}
