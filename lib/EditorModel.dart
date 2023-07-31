part of code_editor;

/// Use the EditorModel into CodeEditor in order to control the files.
class EditorModel extends ChangeNotifier {
  late EditorModelStyleOptions styleOptions;
  late List<FileEditor> allFiles;

  int _currentPositionInFiles = 0;
  bool _isEditing = false;

  /// Define the required parameters for the editor to work properly.
  /// For that, you need to define [files] which is a `List<FileEditor>`.
  ///
  /// You can also define your own preferences with [styleOptions] (instance of `EditorModelStyleOptions`).
  EditorModel({
    List<FileEditor>? files,
    EditorModelStyleOptions? styleOptions,
  }) {
    this.styleOptions = styleOptions ?? EditorModelStyleOptions();
    this.allFiles = files ?? [];
  }

  /// Checks in all the given files if [language] is found,
  /// then returns a List<String> of the files' content that uses [language].
  List<String?> getCodeWithLanguage(String language) {
    List<String?> listOfCode = [];
    this.allFiles.forEach((FileEditor file) {
      if (file.language == language) {
        listOfCode.add(file.code);
      }
    });
    return listOfCode;
  }

  /// Returns the code of the file where [index] corresponds.
  String getCodeWithIndex(int index) {
    return this.allFiles[index].code;
  }

  /// Returns the file where [index] corresponds.
  FileEditor? getFileWithIndex(int index) {
    if (index >= this.allFiles.length || index < 0) {
      return null;
    }
    return this.allFiles[index];
  }

  /// Switch the file using [i] as index of the List<FileEditor> files.
  ///
  /// The user can't change the file if he is editing another one.
  void changeIndexTo(int i) {
    if (this._isEditing) {
      return;
    }
    this._currentPositionInFiles = i;
    this.notify();
  }

  /// Toggle the text field.
  void toggleEditing() {
    this._isEditing = !this._isEditing;
    this.notify();
  }

  /// Overwrite the current code of the file where [index] corresponds by [newCode].
  void updateCodeOfIndex(int index, String? newCode) {
    this.allFiles[index].code = newCode ?? "";
  }

  void notify() => notifyListeners();

  /// Gets the index of which file is currently displayed in the editor.
  int get position => this._currentPositionInFiles;

  /// Gets which language is currently shown.
  String get currentLanguage => this.allFiles[this._currentPositionInFiles].language;

  /// Is the text field shown?
  bool get isEditing => this._isEditing;

  /// Gets the number of files.
  int get numberOfFiles => this.allFiles.length;
}
