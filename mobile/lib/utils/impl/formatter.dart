abstract class Formatter {
  //+90 532 123 00 00
  //532 664 42 02
  static String gsm(String s, {String countryCode = "+90"}) {
    if (s == null || s.length < 10) {
      return "";
    }
    s = s.replaceAll(" ", "");
    if (s.substring(0, 3) == countryCode) {
      s = s.substring(3);
    }
    if (s.substring(0, 1) == "0") {
      s = s.substring(1);
    }
    if (s.length < 10) {
      return "";
    }
    return countryCode + "-" + s.substring(0, 3) + "-" + s.substring(3, 6) + "-" + s.substring(6, 8) + "-" + s.substring(8, 10);
  }
}
