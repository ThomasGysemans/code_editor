import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

EditorModel createModel({EditorModelStyleOptions? styleOptions}) {
  return EditorModel(
    files: [
      FileEditor(name: "page1.html", language: "html", code: "<p>hello</p>"),
      FileEditor(
        name: "page2.html",
        language: "html",
        code: "<a>back</a>",
        readonly: true,
      ),
      FileEditor(name: "style.css", language: "css", code: "a { color: red; }"),
    ],
    styleOptions: styleOptions,
  );
}

Future<void> pumpEditor(
  WidgetTester tester,
  EditorModel model, {
  void Function(String language, String value)? onSubmit,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: CodeEditor(
            model: model,
            formatters: const ["html"],
            onSubmit: onSubmit,
          ),
        ),
      ),
    ),
  );
}

Finder findFaIcon(FaIconData icon) => find.byWidgetPredicate(
  (widget) => widget is FaIcon && widget.icon == icon.data,
);

void main() {
  testWidgets("displays the files in the navigation bar", (tester) async {
    await pumpEditor(tester, createModel());

    expect(find.text("page1.html"), findsOneWidget);
    expect(find.text("page2.html"), findsOneWidget);
    expect(find.text("style.css"), findsOneWidget);
    expect(find.text("Edit"), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets("switches between files", (tester) async {
    final model = createModel();
    await pumpEditor(tester, model);

    await tester.tap(find.text("style.css"));
    await tester.pump();
    expect(model.position, 2);
    expect(model.currentLanguage, "css");

    // page2.html is readonly, so there is no "Edit" button
    await tester.tap(find.text("page2.html"));
    await tester.pump();
    expect(find.text("Edit"), findsNothing);
  });

  testWidgets("edits, formats and submits a file", (tester) async {
    final model = createModel();
    String? submittedLanguage;
    String? submittedValue;
    await pumpEditor(
      tester,
      model,
      onSubmit: (language, value) {
        submittedLanguage = language;
        submittedValue = value;
      },
    );

    await tester.tap(find.text("Edit"));
    await tester.pump();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("OK"), findsOneWidget);

    await tester.enterText(find.byType(TextField), "<p><span>yo</span></p>");
    await tester.tap(find.text("OK"));
    await tester.pump();

    const formatted = "<p>\n  <span>\n    yo\n  </span>\n</p>";
    expect(submittedLanguage, "html");
    expect(submittedValue, formatted);
    expect(model.getCodeWithIndex(0), formatted);
    expect(model.isEditing, isFalse);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets("inserts characters with the tool buttons", (tester) async {
    final model = createModel();
    await pumpEditor(tester, model);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.tap(find.text(";"));
    await tester.tap(find.text("()"));
    await tester.pump();

    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller!.text, "<p>hello</p>;()");
    // the cursor is placed between the parentheses
    expect(textField.controller!.selection.baseOffset, "<p>hello</p>;(".length);
  });

  testWidgets("undoes and redoes a modification", (tester) async {
    final model = createModel(
      styleOptions: EditorModelStyleOptions(showUndoRedoButtons: true),
    );
    await pumpEditor(tester, model);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "<b></b>");
    await tester.tap(find.text("OK"));
    await tester.pump();
    expect(model.getCodeWithIndex(0), "<b>\n</b>");

    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateLeft));
    await tester.pump();
    expect(model.getCodeWithIndex(0), "<p>hello</p>");

    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateRight));
    await tester.pump();
    expect(model.getCodeWithIndex(0), "<b>\n</b>");
  });

  testWidgets("hides the undo and redo buttons while editing", (tester) async {
    final model = createModel(
      styleOptions: EditorModelStyleOptions(showUndoRedoButtons: true),
    );
    await pumpEditor(tester, model);
    final undo = findFaIcon(FontAwesomeIcons.arrowRotateLeft);
    final redo = findFaIcon(FontAwesomeIcons.arrowRotateRight);
    expect(undo, findsOneWidget);
    expect(redo, findsOneWidget);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    expect(undo, findsNothing);
    expect(redo, findsNothing);

    await tester.tap(find.text("OK"));
    await tester.pump();
    expect(undo, findsOneWidget);
    expect(redo, findsOneWidget);
  });

  testWidgets("confirming without modification does not add an undo step", (
    tester,
  ) async {
    final model = createModel(
      styleOptions: EditorModelStyleOptions(showUndoRedoButtons: true),
    );
    await pumpEditor(tester, model);
    final original = model.getCodeWithIndex(0);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "<b></b>");
    await tester.tap(find.text("OK"));
    await tester.pump();

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.tap(find.text("OK"));
    await tester.pump();
    expect(model.getCodeWithIndex(0), "<b>\n</b>");

    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateLeft));
    await tester.pump();
    expect(model.getCodeWithIndex(0), original);
  });

  testWidgets("confirming without modification keeps the redo history", (
    tester,
  ) async {
    final model = createModel(
      styleOptions: EditorModelStyleOptions(showUndoRedoButtons: true),
    );
    await pumpEditor(tester, model);
    // CSS isn't auto-formatted, so confirming doesn't change the file
    await tester.tap(find.text("style.css"));
    await tester.pump();

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "b {}");
    await tester.tap(find.text("OK"));
    await tester.pump();
    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateLeft));
    await tester.pump();

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.tap(find.text("OK"));
    await tester.pump();
    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateRight));
    await tester.pump();
    expect(model.getCodeWithIndex(2), "b {}");
  });

  testWidgets("the text field shows the file's content after an undo", (
    tester,
  ) async {
    final model = createModel(
      styleOptions: EditorModelStyleOptions(showUndoRedoButtons: true),
    );
    await pumpEditor(tester, model);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "<b></b>");
    await tester.tap(find.text("OK"));
    await tester.pump();
    await tester.tap(findFaIcon(FontAwesomeIcons.arrowRotateLeft));
    await tester.pump();

    await tester.tap(find.text("Edit"));
    await tester.pump();
    final TextField textField = tester.widget(find.byType(TextField));
    expect(textField.controller!.text, "<p>hello</p>");
  });

  testWidgets("uses the custom context menu builder", (tester) async {
    bool customMenuBuilt = false;
    final model = createModel(
      styleOptions: EditorModelStyleOptions(
        contextMenuBuilder: (context, editableTextState) {
          customMenuBuilt = true;
          return const SizedBox.shrink();
        },
      ),
    );
    await pumpEditor(tester, model);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    await tester.longPress(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(customMenuBuilt, isTrue);
  });

  testWidgets("two editors can be edited at the same time", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CodeEditor(model: createModel()),
                CodeEditor(model: createModel()),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Edit").first);
    await tester.pump();
    await tester.ensureVisible(find.text("Edit").last);
    await tester.tap(find.text("Edit").last);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets("CodeEditor.empty() contains an empty file.txt", (tester) async {
    String? submittedLanguage;
    String? submittedValue;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CodeEditor.empty(
              onSubmit: (language, value) {
                submittedLanguage = language;
                submittedValue = value;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text("file.txt"), findsOneWidget);

    await tester.tap(find.text("Edit"));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      "",
    );

    await tester.enterText(find.byType(TextField), "hello");
    await tester.tap(find.text("OK"));
    await tester.pump();
    expect(submittedLanguage, "text");
    expect(submittedValue, "hello");
  });

  testWidgets("disposes the focus node", (tester) async {
    await pumpEditor(tester, createModel());
    await tester.tap(find.text("Edit"));
    await tester.pump();
    final FocusNode focusNode = tester
        .widget<TextField>(find.byType(TextField))
        .focusNode!;

    await tester.pumpWidget(const SizedBox.shrink());

    // a disposed ChangeNotifier can't be listened to anymore
    expect(() => focusNode.addListener(() {}), throwsFlutterError);
  });
}
