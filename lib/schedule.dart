class Schedule {

  List<List<ScheduleItem>> schListSorted = <List<ScheduleItem>>[];
  List<ScheduleItem> schList = <ScheduleItem>[];

  Schedule() {
    for (int i = 0; i < 7; i++) {
      schListSorted.add(<ScheduleItem>[]);
    }
  }
}

class ScheduleItem {
  String name;
  int dayOfWeek;
  int startMin, endMin;

  ScheduleItem(String name, int dayOfWeek, int startMin, int endMin)
      : name = name, dayOfWeek = dayOfWeek, startMin = startMin, endMin = endMin {}
}