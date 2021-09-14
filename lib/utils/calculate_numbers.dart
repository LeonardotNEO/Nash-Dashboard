class CalculateNumbers {
  static String doubleInRightFormat(String string, {bool comma}) {
    String newString = "";
    List<String> strings = [];
    int length1 = 3;
    int length2 = 0;
    bool withComma = true;

    if (string.length < 3) {
      return string;
    }

    while (length1 <= string.length) {
      if (length1 == string.length) {
        strings.add(
            string.substring(string.length - length1, string.length - length2));
      } else {
        if (comma != null && withComma) {
          strings.add("" +
              string.substring(
                  string.length - length1, string.length - length2));
          withComma = false;
        } else {
          strings.add("," +
              string.substring(
                  string.length - length1, string.length - length2));
        }
      }

      length1 += 3;
      length2 += 3;

      if (length1 > string.length) {
        strings.add(string.substring(0, (string.length - length2)));

        strings = new List.from(strings.reversed);
        strings.forEach((element) {
          newString += element;
        });
      }
    }

    return newString;
  }

  static String removeTrailingZeros(String string, int date) {
    String newString;
    //bool runLoop = true;
    //int index = string.length - 1;
/*
    while (runLoop) {
      if (index == 0) {
        break;
      }
      if (string[index] != "0") {
        newString = string.substring(0, index + 1);

        runLoop = false;
      }

      index--;
    }*/

    // using this to fix fucked up timestamp by dora explorer
    if (date < 1586701845000) {
      newString = string.substring(0, 7);
    } else {
      newString = string.substring(0, 8);
    }

    //print(newString);

    return newString;
  }
}
