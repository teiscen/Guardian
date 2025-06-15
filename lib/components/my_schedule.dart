import 'package:flutter/material.dart';

// https://pub.dev/packages/calendar_view
import 'package:calendar_view/calendar_view.dart';


enum Day{ MON, TUE, WED, THU, FRI, SAT, SUN }

DateTime weeklyDateTime(Day day, int hour, int min){
  assert(hour > 0 && hour < 24, 'Invalid Hour!');
  assert(min  > 0 && min  < 59, 'Invalid Min!');
  return DateTime(2000, 1, day.index, hour, min);
}

class TimeBlock{
  DateTime start;
  DateTime end;

  TimeBlock({
    required this.start,
    required this.end
  }) {
    // verifying input
    if(start.compareTo(end) > 0) {
      DateTime t = start;
      this.start = end;
      this.end = t;
    }
    // rounding to 15 min intervals
    // if withing 5 min of cutoff gets rounded down otherwise rounded up.
    // ignore: prefer_function_declarations_over_variables
    // Requires Dart 3.0+
    // ignore: prefer_function_declarations_over_variables
    var rounder = (DateTime dt) {
      return switch(dt.minute) {
        <= 5  => DateTime(dt.year, dt.month, dt.day, dt.hour, 0 ),
        <= 20 => DateTime(dt.year, dt.month, dt.day, dt.hour, 15),
        <= 35 => DateTime(dt.year, dt.month, dt.day, dt.hour, 30),
        <= 50 => DateTime(dt.year, dt.month, dt.day, dt.hour, 45),
        _     => DateTime(dt.year, dt.month, dt.day, dt.hour, 0 )
                .add(const Duration(hours: 1))
      };
    };
    start = rounder(start);
    end = rounder(end);

    if(start.compareTo(end) == 0){
      throw Exception('Start and End times must have a 15 min gap.');
    }
  }
}

/// If there are overlaps it will treat it as if it is continuous. (Not Implemented)
/// 
class Activity {
  late String name;
  bool isRecuring;
  List<TimeBlock> times = new List.empty();
  
  Activity({ 
    required this.name,
    this.isRecuring = false,
    List<TimeBlock>? times
  }) : times = times ?? []; // ?? means if the LHS in null use the RHS

  void addTimeBlock(TimeBlock tb){ times.add(tb);  }
  bool removeTimeBlock(TimeBlock tb){ return times.remove(tb); }
}

class mockSchedule { 
  List<TimeBlock> workout = [
    new TimeBlock(start: weeklyDateTime(Day.MON, 11, 00), end: weeklyDateTime(Day.MON, 12, 30)),
    new TimeBlock(start: weeklyDateTime(Day.WED, 11, 00), end: weeklyDateTime(Day.WED, 12, 30)),
    new TimeBlock(start: weeklyDateTime(Day.FRI, 11, 00), end: weeklyDateTime(Day.FRI, 12, 30))
  ];
  List<TimeBlock> read = [
    new TimeBlock(start: weeklyDateTime(Day.MON, 9, 00), end: weeklyDateTime(Day.MON, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.TUE, 9, 00), end: weeklyDateTime(Day.TUE, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.WED, 9, 00), end: weeklyDateTime(Day.WED, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.THU, 9, 00), end: weeklyDateTime(Day.THU, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.FRI, 9, 00), end: weeklyDateTime(Day.FRI, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.SAT, 9, 00), end: weeklyDateTime(Day.SAT, 10, 15)),
    new TimeBlock(start: weeklyDateTime(Day.SUN, 9, 00), end: weeklyDateTime(Day.SUN, 10, 15))
  ];
  List<TimeBlock> mealPrep = [
    new TimeBlock(start: weeklyDateTime(Day.SUN, 10, 00), end: weeklyDateTime(Day.SUN, 2, 00)),
  ];

  late List<Activity> schedule;

  mockSchedule() {
    schedule = [
      new Activity(name: 'Workout' , isRecuring: true, times: workout),
      new Activity(name: 'Read'    , isRecuring: true, times: read),
      new Activity(name: 'MealPrep', isRecuring: true, times: mealPrep)
    ];
  }
}


class MySchedule extends StatelessWidget {

  const MySchedule({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeekView(),
    );
  }
}