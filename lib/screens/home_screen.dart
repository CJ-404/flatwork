import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/notification_tile.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state)
  => const HomeScreen();
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  // TODO: fetch tasks from backend
  List<Task> dummyTasks = [
    Task(
      id: '1',
      title: 'Task 1',
      description: 'Complete initial design',
      endDate: DateTime(2024, 4, 2),
      isCompleted: false,
      progress: 12.0,
    ),
    Task(
      id: '2',
      title: 'Task 2',
      description: 'Submit project proposal',
      endDate: DateTime(2024, 4, 10),
      isCompleted: false,
      progress: 12.0,
    ),
    Task(
      id: '3',
      title: 'Task 3',
      description: 'Develop feature X',
      endDate: DateTime(2024, 11, 5),
      isCompleted: false,
      progress: 12.0,
    ),
    Task(
      id: '4',
      title: 'Task 4',
      description: 'Review design documents',
      endDate: DateTime(2024, 5, 15),
      isCompleted: true,
      progress: 100.0,
    ),
    Task(
      id: '5',
      title: 'Task 5',
      description: 'Team meeting',
      endDate: DateTime(2024, 11, 25),
      isCompleted: false,
      progress: 12.0,
    ),
    Task(
      id: '6',
      title: 'Task 6',
      description: 'Finalize budget Finalize budget Finalize budget Finalize budget Finalize budget',
      endDate: DateTime(2024, 6, 1),
      isCompleted: false,
      progress: 12.0,
    ),
    Task(
      id: '6',
      title: 'Task 7',
      description: 'Finalize budget Finalize budget Finalize budget Finalize budget Finalize budget',
      endDate: DateTime(2024, 6, 1),
      isCompleted: true,
      progress: 100.0,
    ),
  ];

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<Task>> tasksByDate = {};

  @override
  void initState() {
    for (var task in dummyTasks) {

      DateTime dateKey = DateTime(task.endDate!.year, task.endDate!.month, task.endDate!.day);

      if (tasksByDate.containsKey(dateKey)) {
        tasksByDate[dateKey]!.add(task);
      } else {
        tasksByDate[dateKey] = [task];
      }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final futureRef = projectProvider.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    return MainScaffold(
      child: CustomScrollView(
        slivers: [
          // Collapsible Notifications section
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 300.0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background : Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Notifications",
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Icon(Icons.notifications,size: 30,),
                          ],
                        ),
                        Divider(thickness: 2),
                        //notifications
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NotificationTile(message: "New project invitation!",),
                                  NotificationTile(message: "New project invitation!",),
                                  NotificationTile(message: "New project invitation!",),
                                ]

                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Calendar section that takes the remaining space
            SliverToBoxAdapter (
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Calendar",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Icon(Icons.calendar_today,size: 30,),
                        ],
                      ),
                      Divider(thickness: 2),
                      // calender
                      TableCalendar(
                          focusedDay: focusedDay,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              this.selectedDay = selectedDay;
                              this.focusedDay = focusedDay;
                            });
                          },
                          onPageChanged: (newFocusedDay) {
                            setState(() => focusedDay = newFocusedDay);
                          },
                          headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, day, _) {
                              final taskCount = tasksByDate[DateTime(day.year, day.month, day.day)]?.length ?? 0;
                              return taskCount > 0
                                  ? Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: Center(child: Text('${day.day}', style: const TextStyle(fontSize: 16, color: Colors.black))),
                                ),
                              )
                                  : null;
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Calendar Events section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row with Icon for Calendar Events
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Calendar Events',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.event),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Calendar Events Content
                    // TODO: LOADING
                    Container(
                      height: 300, // Adjust as needed for demo purposes
                      child: SingleChildScrollView(
                        child: Column(
                          children: tasksByDate[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)]?.
                          map((task) => ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(task.title),
                                      Text(DateFormat('MMMM d').format(task.endDate!), style: TextStyle(color: Colors.grey, fontSize: 14),),
                                    ],
                                  ),
                                  Text(
                                      (task.isCompleted)? "completed" : (task.endDate!.isBefore(DateTime.now()))? "expired" : "onGoing",
                                      style: TextStyle(color: (task.isCompleted)? Colors.green :(task.endDate!.isBefore(DateTime.now()))? Colors.red : Colors.blue,)
                                  ),
                                ],
                              ),
                              onTap: () =>  _showEventDetailsOverlay(context, task),
                            )
                          ).toList() ?? [Center(child: Text("No tasks for the selected day."))]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  void _showEventDetailsOverlay(BuildContext context, Task task) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(),
            ],
          ),
          content: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.description, style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: 8),
                  Text("Due Date: ${task.endDate?.year}-${task.endDate?.month}-${task.endDate?.day}", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 8),
                  Text("Status: ${task.isCompleted ? "Completed" : "Pending"}", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                // TODO: set user role according to the project referring to
                Navigator.pop(context);
                ref
                    .read(taskIdProvider.notifier)
                    .state = "4ff22e99-b7";
                ref.read(taskProgressProvider.notifier).state = task.progress!;
                context.pushNamed(
                  RouteLocation.editTask,
                  pathParameters: {'taskId': "4ff22e99-b7"},
                );
              },
              child: const Text('Go to'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

          ],
        );
      },
    );
  }

}
