part of code_editor;

/// A file in the editor, used by EditorModel [model.code].
///
/// - [name] is the name of the file shown in the navbar.
/// - [language] is the language used by the theme
/// - [code] is the content of the file, the code
/// - [readonly] is a boolean that says if the file shall be editable or not
///
/// Tip: to simplify writing code in a String,
/// write line by line your code in a list List<String> and pass as argument list.join("\n").
class FileEditor {
  /// The name of the file.
  /// By default is will be called "file"
  /// and its extension will be the given [language], or 'txt'.
  late String name;

  /// The name of the language.
  /// By default: "text".
  late String language;

  /// Its content.
  /// By default an empty string.
  late String code;

  /// If the file shall not be edited,
  /// then set this to `true`.
  /// By default it is `false`.
  late bool readonly;

  FileEditor({String? name, String? language, String? code, bool? readonly}) {
    this.name = name ?? "file.${language ?? 'txt'}";
    this.language = language ?? "text";
    this.code = code ?? "";
    this.readonly = readonly ?? false;
  }
}
