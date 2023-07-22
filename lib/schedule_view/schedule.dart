import 'dart:ui';



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

  ScheduleItem._(String name, int dayOfWeek, int startMin, int endMin)
      : name = name, dayOfWeek = dayOfWeek, startMin = startMin, endMin = endMin{}

  static ScheduleItem fromPreview(String name, int startRow, int endRow, int dayOfWeek, int startHour, int subCellMin) {
    int startMin = ((startHour*60 + startRow*subCellMin)).toInt();
    int endMin = ((startHour*60 + endRow*subCellMin)).toInt();
    return ScheduleItem._(name, dayOfWeek, startMin, endMin);
  }

/*
  Rect getRect(SchedulePainter painter) {
    return Rect.fromLTWH(painter.hourAxisWidth+dayOfWeek*painter.cellWidth, (startMin/60-painter.startHour)*painter.cellHeight,
        painter.cellWidth, (endMin-startMin)/60*painter.cellHeight);
  }*/

}