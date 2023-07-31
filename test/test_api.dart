import 'dart:io';

void test(String name, String result, String expected) {
  if (result == expected) {
    print("Passed : " + name);
  } else {
    print("X Test failed : " + name);
    print("We got : ");
    print(result);
    print("But were expecting to get : ");
    print(expected);
    exit(0);
  }
}
