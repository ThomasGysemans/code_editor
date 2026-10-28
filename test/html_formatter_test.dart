import 'package:code_editor/formatters/html.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("one unique empty tag", () {
    expect(formatHTML("<p></p>"), "<p>\n</p>");
  });
  test("one tag inside another", () {
    expect(
      formatHTML("<p><span>yo</span></p>"),
      "<p>\n  <span>\n    yo\n  </span>\n</p>",
    );
  });
  test("three nested tags", () {
    expect(
      formatHTML("<p><span><span>yo</span></span></p>"),
      "<p>\n  <span>\n    <span>\n      yo\n    </span>\n  </span>\n</p>",
    );
  });
  test("one pair inside one common tag", () {
    expect(
      formatHTML("<p><span>first</span><span>second</span></p>"),
      "<p>\n  <span>\n    first\n  </span>\n  <span>\n    second\n  </span>\n</p>",
    );
  });
  test("three tags inside one common tag", () {
    expect(
      formatHTML("<p><u>first</u><u>second</u><u>third</u></p>"),
      "<p>\n  <u>\n    first\n  </u>\n  <u>\n    second\n  </u>\n  <u>\n    third\n  </u>\n</p>",
    );
  });
  test("complex tree", () {
    expect(
      formatHTML("<p><u>first</u><u><span>second</span></u><u>third</u></p>"),
      "<p>\n  <u>\n    first\n  </u>\n  <u>\n    <span>\n      second\n    </span>\n  </u>\n  <u>\n    third\n  </u>\n</p>",
    );
  });
  test("simple tree with spaces", () {
    expect(formatHTML("<p>             first</p>"), "<p>\n  first\n</p>");
  });
  test("spaces between text and at the beginning of tag", () {
    expect(formatHTML("<p>  fi     rst</p>"), "<p>\n  fi rst\n</p>");
  });
  test("special escaped characters", () {
    expect(
      formatHTML("<p>\nhi how are you</p>"),
      "<p>\n  hi how are you\n</p>",
    );
  });
  test("simple tag with attributes", () {
    expect(formatHTML("<html lang='fr'></html>"), "<html lang='fr'>\n</html>");
  });
  test("correct architecture", () {
    expect(
      formatHTML("""
    <html lang="fr">
      <head>
        <title>Hello</title>
      </head>
      <body>
        <p>
          Hello
        </p>
      </body>
    </html>
  """),
      "<html lang=\"fr\">\n  <head>\n    <title>\n      Hello\n    </title>\n  </head>\n  <body>\n    <p>\n      Hello \n    </p>\n  </body>\n</html>",
    );
  });
  test("incorrect architecture", () {
    expect(
      formatHTML("""
    <html lang="fr">
    <head>
    <title>
    Hello
    </title>
    </head>
    <body>
    <p>
    Hello
    </p>
    </body>
    </html>
  """),
      "<html lang=\"fr\">\n  <head>\n    <title>\n      Hello \n    </title>\n  </head>\n  <body>\n    <p>\n      Hello \n    </p>\n  </body>\n</html>",
    );
  });
  test("with missing closing tag", () {
    expect(formatHTML("<p><span></p>"), "<p>\n  <span>\n  </p>");
  });
  test("with DOCTYPE", () {
    expect(
      formatHTML("<!DOCTYPE html><html><p></p></html>"),
      "<!DOCTYPE html>\n<html>\n  <p>\n  </p>\n</html>",
    );
  });
  test("with comment", () {
    expect(
      formatHTML("<p><!-- hello -->Hello</p>"),
      "<p>\n  <!-- hello -->\n  Hello\n</p>",
    );
  });
  test("with attribute", () {
    expect(
      formatHTML("<body><a href='page2.html'>go to page 2</a></body>"),
      "<body>\n  <a href='page2.html'>\n    go to page 2\n  </a>\n</body>",
    );
  });
}
