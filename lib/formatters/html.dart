/// Formats HTML.
/// Takes [content] as input and a precise tab size.
String formatHTML(String content, {int tabSize = 2}) {
  content = content.trim();
  String newContent = "";
  int counter = 0;
  bool text = false;
  bool tag = false;
  bool enteringTag = false;
  String previousCharacter = "";
  bool isXMLTag = false;
  for (int i = 0; i < content.length; i++) {
    String currentChar = content[i];
    if (currentChar == '<') {
      i++;
      if (i == content.length) break;
      bool isClosingTag = content[i] == '/';
      isXMLTag = content[i] == '!';
      if (counter > 0) {
        newContent += '\n';
        if ((isClosingTag ? counter - 1 > 0 : counter > 0)) {
          newContent += (' ' * tabSize * (isClosingTag ? counter - 1 : counter));
        }
      }
      if (!isXMLTag) {
        if (isClosingTag) {
          counter--;
        } else {
          counter++;
        }
      }
      newContent += currentChar + content[i];
      text = false;
      tag = true;
    } else {
      bool isControlledCharacter = currentChar == '\n' || currentChar == "\t" || currentChar == "\r";
      bool isWhiteSpace = currentChar == " ";
      if (currentChar == '>') {
        tag = false;
      } else if (!tag && !text) {
        if (!isControlledCharacter && !isWhiteSpace) {
          text = true;
          newContent += (isXMLTag ? '' : '\n') + (' ' * tabSize * counter);
        }
        enteringTag = true;
        isXMLTag = false;
      }
      // We want to ignore the cases when:
      // - having white space
      // - entering a tag with white space
      // - having special escaped characters such as \n, \t or \r
      if ((previousCharacter == " " && isWhiteSpace) || (!tag && enteringTag && isWhiteSpace) || isControlledCharacter) {
        continue;
      }
      previousCharacter = currentChar;
      newContent += currentChar == '>' && isXMLTag ? '>\n' : currentChar;
      enteringTag = false;
    }
  }
  return newContent;
}
