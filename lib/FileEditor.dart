part of code_editor;

/// A file in the editor, used by EditorModel [model.code].
///
/// * [name] is the name of the file shown in the navbar.
/// * [language] is the language used by the theme
/// * [code] is the content of the file, the code
///
/// Tip: to simplify writing code in a String,
/// write line by line your code in a list List<String> and pass as argument list.join("\n").
class FileEditor {
  String name;
  String language;
  String code;
  FileEditor({String name, String language, String code}) {
    this.name = name ?? "file.${language ?? 'txt'}";
    this.language = language ?? "text";
    this.code = code ?? "";
  }
}
