abstract class DateOps {
  static const WEEK_DAYS = ["nope", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi","Pazar"];

  static String getWeekday(DateTime t) {
    try {
      return WEEK_DAYS[t.weekday];
    }catch(e) {
      return "essek ayagi";
    }
  }

  static String formatDMY(DateTime t) {
    return "${t.day.toString().padLeft(2, "0")}.${t.month.toString().padLeft(2, "0")}.${t.year}";
}
}
