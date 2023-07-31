import '../lib/formatters/html.dart';
import 'test_api.dart';

void main() {
  test("one unique empty tag", formatHTML("<p></p>"), "<p>\n</p>");
  test("one tag inside another", formatHTML("<p><span>yo</span></p>"), "<p>\n  <span>\n    yo\n  </span>\n</p>");
  test("three nested tags", formatHTML("<p><span><span>yo</span></span></p>"), "<p>\n  <span>\n    <span>\n      yo\n    </span>\n  </span>\n</p>");
  test("one pair inside one common tag", formatHTML("<p><span>first</span><span>second</span></p>"), "<p>\n  <span>\n    first\n  </span>\n  <span>\n    second\n  </span>\n</p>");
  test("three tags inside one common tag", formatHTML("<p><u>first</u><u>second</u><u>third</u></p>"), "<p>\n  <u>\n    first\n  </u>\n  <u>\n    second\n  </u>\n  <u>\n    third\n  </u>\n</p>");
  test("complex tree", formatHTML("<p><u>first</u><u><span>second</span></u><u>third</u></p>"), "<p>\n  <u>\n    first\n  </u>\n  <u>\n    <span>\n      second\n    </span>\n  </u>\n  <u>\n    third\n  </u>\n</p>");
  test("simple tree with spaces", formatHTML("<p>             first</p>"), "<p>\n  first\n</p>");
  test("spaces between text and at the beginning of tag", formatHTML("<p>  fi     rst</p>"), "<p>\n  fi rst\n</p>");
  test("special escaped characters", formatHTML("<p>\nhi how are you</p>"), "<p>\n  hi how are you\n</p>");
  test("simple tag with attributes", formatHTML("<html lang='fr'></html>"), "<html lang='fr'>\n</html>");
  test("correct architecture", formatHTML("""
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
  """), "<html lang=\"fr\">\n  <head>\n    <title>\n      Hello\n    </title>\n  </head>\n  <body>\n    <p>\n      Hello \n    </p>\n  </body>\n</html>");
  test("incorrect architecture", formatHTML("""
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
  """), "<html lang=\"fr\">\n  <head>\n    <title>\n      Hello \n    </title>\n  </head>\n  <body>\n    <p>\n      Hello \n    </p>\n  </body>\n</html>");
  test("with missing closing tag", formatHTML("<p><span></p>"), "<p>\n  <span>\n  </p>");
  test("with DOCTYPE", formatHTML("<!DOCTYPE html><html><p></p></html>"), "<!DOCTYPE html>\n<html>\n  <p>\n  </p>\n</html>");
  test("with comment", formatHTML("<p><!-- hello -->Hello</p>"), "<p>\n  <!-- hello -->\n  Hello\n</p>");
  test("with attribute", formatHTML("<body><a href='page2.html'>go to page 2</a></body>"), "<body>\n  <a href='page2.html'>\n    go to page 2\n  </a>\n</body>");
}
