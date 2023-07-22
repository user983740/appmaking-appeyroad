import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum WeekArrangement {
  startTail, numOfFullWeeks, numOfWeeks, endTail;
}

class WeekChip extends StatelessWidget {

  static const double textSize = 25;
  static const double epsilon = 5;
  static const double smallTextFactor = 0.75;
  static const double edgeRadius = 12;

  int _year, _month, _highlightedWeek;
  List<int> _weekArrangement;

  WeekChip(this._year, this._month, this._weekArrangement, this._highlightedWeek) {

  }
  @override
  Widget build(BuildContext context) {
    List<_WeekDash> weekDashes = [];

    for (int i = 1; i <= _weekArrangement[WeekArrangement.numOfWeeks.index]; i++) {
      if (i == 1 && _weekArrangement[WeekArrangement.startTail.index] > 0) {
        weekDashes.add(_WeekDash(_highlightedWeek == i, false, _weekArrangement[WeekArrangement.startTail.index]));
        continue;
      }
      if (i == _weekArrangement[WeekArrangement.numOfWeeks.index] && _weekArrangement[WeekArrangement.endTail.index] > 0) {
        weekDashes.add(_WeekDash(_highlightedWeek == i, true, _weekArrangement[WeekArrangement.endTail.index]));
        continue;
      }
      weekDashes.add(_WeekDash(_highlightedWeek == i, false, 7));
    }

    return Container(decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(edgeRadius)),
      color: Theme.of(context).colorScheme.background,
    ), child: Row(children:
    [
      //1. Text (month, and word that means month)
      Padding(padding: EdgeInsets.only(left: 5, right: 5), child:
      RichText(text: TextSpan(
          text: _month.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSize, color: Theme.of(context).colorScheme.primary),
          children: const<TextSpan>[
            TextSpan(text: "M", style: TextStyle(fontSize:textSize*smallTextFactor))
          ]
      ))),
      //2. black pebble with calendar symbol in it
      Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(edgeRadius)),
        color: Theme.of(context).colorScheme.primary,
      ), height: textSize+epsilon, width: textSize+epsilon,
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekDashes
            ),
          )
      )

    ]));
  }


}

class _WeekDash extends StatelessWidget {

  bool _isHighlighted, _alignLeft;
  late double _length;
  static const dashThickness = 1.5;

  _WeekDash(bool isHighlighted, bool alignLeft, int days): _isHighlighted = isHighlighted, _alignLeft = alignLeft {
    _length = days / 7;
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, height: dashThickness, child: FractionallySizedBox(
      widthFactor: _length,
      heightFactor: 1,
        alignment: _alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.5)),
            color: _isHighlighted ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.background,)
      )
    ),);
  }

}