part of code_editor;

/// Use the EditorModel into CodeEditor
/// in order to control the editor.
/// EditorModel extends ChangeNotifier because we use the provider package
/// to simplify the work
class EditorModel extends ChangeNotifier {
  int _index = 1;
  bool _isEditing = false;
  EditorModelStyleOptions styleOptions = EditorModelStyleOptions();
  // there is just 3 available languages for the moment
  List<String> _languages = ["html", "css", "js"];
  Map<String, String> code = {
    "html": "",
    "css": "",
    "js": "",
  };

  EditorModel({this.code, this.styleOptions});
  EditorModel.withIndex(this._index, {this.code, this.styleOptions});

  /// change the file with [i], 1 = html, 2 = css, 3 = js
  void changeIndexTo(int i) {
    if (this._isEditing) {
      return;
    }
    this._index = i;
    this._notify();
  }

  /// toggle the text field
  void toggleEditing() {
    this._isEditing = !this._isEditing;
    this._notify();
  }

  /// update a file
  void changeCodeOfLanguage(String language, String newCode) {
    this.code[language] = newCode;
    this._notify();
  }

  void _notify() => notifyListeners();

  /// get the file, 1 = html, 2 = css, 3 = js
  int get index => this._index;

  /// which language is show on the text field
  String get currentLanguage => this._languages[this.index - 1];

  /// get all available languages of code_editor
  List<String> get availabeLanguages => this._languages;

  /// is the text field shown
  bool get isEditing => this._isEditing;
}
