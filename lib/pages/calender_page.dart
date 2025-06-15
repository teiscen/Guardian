import 'package:flutter/material.dart';

/*
// Required positional
class Date {
  DayOfWeek day;
  TimeOfDay time;

  Date(this.day, this.time);
}

// optional
class Date {
  DayOfWeek day;
  TimeOfDay time;

  Date(this.day, [this.time]);
}
*/

enum DayOfWeek {
  Mon, Tue, Wed, Thu, Fri, Sat, Sun,
}

class Time {
  final TimeOfDay start;
  final TimeOfDay end;

  const Time({required this.start, required this.end});
}

class Date {
  final DayOfWeek day;
  final Time time; 

  const Date({required this.day, required this.time});
}

class Activity{
  final String name;
  final List<Date> dates;

  const Activity({required this.name, required this.dates});
}

const List<Activity> mockUserActivities = [
  Activity(
    name: "Mse 112",     
    dates: [ 
      Date(day: DayOfWeek.Tue, time: Time(start: TimeOfDay(hour: 11, minute: 30), end: TimeOfDay(hour: 2,  minute: 20)))
  ]),
  Activity(
    name: "Mse 112 Lab", 
    dates: [
      Date(day: DayOfWeek.Thu, time: Time(start: TimeOfDay(hour: 11, minute: 30), end: TimeOfDay(hour: 2,  minute: 20)))
  ]),
  Activity(
    name: "Cmpt 310",    
    dates: [
      Date(day: DayOfWeek.Thu, time: Time(start: TimeOfDay(hour: 11, minute: 30), end: TimeOfDay(hour: 2,  minute: 20)))
  ]),
  Activity(
    name: "Cmpt 379",    
    dates: [
      Date(day: DayOfWeek.Mon, time: Time(start: TimeOfDay(hour: 12, minute: 30), end: TimeOfDay(hour: 2,  minute: 20))),
      Date(day: DayOfWeek.Wed, time: Time(start: TimeOfDay(hour: 12, minute: 30), end: TimeOfDay(hour: 1,  minute: 20)))
  ])
];

class WeeklySchedulePage extends StatefulWidget {
  final List<Activity> activities;

  const WeeklySchedulePage({super.key, required this.activities});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  late List<Activity> _activities;

  @override
  void initState() {
    super.initState();
    _activities = List<Activity>.from(widget.activities);
  }

  // Helper to get activities for a specific day
  List<Activity> activitiesForDay(DayOfWeek day) {
    return _activities.where((activity) =>
      activity.dates.any((date) => date.day == day)
    ).toList();
  }

  // Helper to get all times for an activity on a specific day
  List<Time> timesForActivityOnDay(Activity activity, DayOfWeek day) {
    return activity.dates
      .where((date) => date.day == day)
      .map((date) => date.time)
      .toList();
  }

  void _showAddActivitySheet() {
    String name = '';
    DayOfWeek? selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16, right: 16, top: 24
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Activity Name'),
                    onChanged: (value) => name = value,
                  ),
                  DropdownButton<DayOfWeek>(
                    value: selectedDay,
                    hint: const Text('Select Day'),
                    isExpanded: true,
                    items: DayOfWeek.values.map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text(day.name),
                      );
                    }).toList(),
                    onChanged: (day) => setModalState(() => selectedDay = day),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setModalState(() => startTime = picked);
                            }
                          },
                          child: Text(startTime == null
                              ? 'Start Time'
                              : startTime!.format(context)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setModalState(() => endTime = picked);
                            }
                          },
                          child: Text(endTime == null
                              ? 'End Time'
                              : endTime!.format(context)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (name.isNotEmpty && selectedDay != null && startTime != null && endTime != null) {
                        setState(() {
                          _activities.add(
                            Activity(
                              name: name,
                              dates: [
                                Date(
                                  day: selectedDay!,
                                  time: Time(start: startTime!, end: endTime!),
                                )
                              ],
                            ),
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add Activity'),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = DayOfWeek.values;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Schedule')),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final dayName = day.name.toUpperCase();
          final dayActivities = activitiesForDay(day);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$dayName:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                    const SizedBox(height: 8),
                    if (dayActivities.isEmpty)
                      Text('Schedule not found for ${day.name}', style: const TextStyle(fontSize: 16))
                    else
                      ...dayActivities.map((activity) {
                        final times = timesForActivityOnDay(activity, day);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: times.map((time) {
                            final start = time.start.format(context);
                            final end = time.end.format(context);
                            return Text('$start-$end ${activity.name}', style: const TextStyle(fontSize: 16));
                          }).toList(),
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivitySheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// To use this page, pass your mockUserActivities:
// Navigator.push(context, MaterialPageRoute(builder: (_) => WeeklySchedulePage(activities: mockUserActivities)));

