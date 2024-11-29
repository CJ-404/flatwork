import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/data/models/calendarTask.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/services/auth_services.dart';
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

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
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

    final fetchedCalendarTasks = ref.watch(userCalendarTasksProvider);
    final invitations = ref.watch(invitationProvider);
    print(invitations);

    return MainScaffold(
      child: fetchedCalendarTasks.when(
        loading: () => Scaffold(
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (err, stack) => Text("Error: $err"),
        data: (fetchedCalendarTasks) {

          Map<DateTime, List<CalendarTask>> tasksByDate2 = {};
          for (var calendarTask in fetchedCalendarTasks) {

            DateTime dateKey = DateTime(calendarTask.deadline.year, calendarTask.deadline.month, calendarTask.deadline.day);

            if (tasksByDate2.containsKey(dateKey)) {
              tasksByDate2[dateKey]!.add(calendarTask);
            } else {
              tasksByDate2[dateKey] = [calendarTask];
            }
          }

          return CustomScrollView(
          slivers: [
            // Collapsible Notifications section
                invitations.when(
                  loading: () => Scaffold(
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, stack) => Text("Error: $err"),
                  data: (invitations) {

                  return SliverAppBar(
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
                              child: (invitations.isEmpty)?
                              Text("No messages")
                              :
                              SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: invitations.map((invitation) {
                                      return NotificationTile(
                                        message: invitation.message,
                                        projectId: invitation.projectId,
                                        id: invitation.id.toString(),
                                        role: invitation.role,
                                      );
                                    }).toList(),

                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                }
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
                                final taskCount = tasksByDate2[DateTime(day.year, day.month, day.day)]?.length ?? 0;
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
                            children: tasksByDate2[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)]?.
                            map((calendarTask) {
                              final bool isCompleted = calendarTask.progress == 100.0;

                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(calendarTask.taskName),
                                        Text(DateFormat('MMMM d').format(calendarTask.deadline), style: TextStyle(color: Colors.grey, fontSize: 14),),
                                      ],
                                    ),
                                    Text(
                                        (isCompleted)? "completed" : (calendarTask.deadline.isBefore(DateTime.now()))? "expired" : "onGoing",
                                        style: TextStyle(color: (isCompleted)? Colors.green :(calendarTask.deadline.isBefore(DateTime.now()))? Colors.red : Colors.blue,)
                                    ),
                                  ],
                                ),
                                onTap: () =>  _showEventDetailsOverlay(context, calendarTask),
                              );}
                            ).toList() ?? [Center(child: Text("No tasks for the selected day."))]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
      );
  }

  void _showEventDetailsOverlay(BuildContext context, CalendarTask task) {
    final bool isCompleted = task.progress == 1000.0;

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
                task.taskName,
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
                  Text(task.taskDescription, style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: 8),
                  Text("Due Date: ${task.deadline.year}-${task.deadline.month}-${task.deadline.day}", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 8),
                  Text("Status: ${isCompleted ? "Completed" : "Pending"}", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: ()
              async {
                await AuthServices().setProjectRole(task.userRole);
                Navigator.pop(context);
                ref
                    .read(taskIdProvider.notifier)
                    .state = task.taskId;
                ref.read(taskProgressProvider.notifier).state = task.progress;
                ref.invalidate(userCalendarTasksProvider);
                context.pushNamed(
                  RouteLocation.editTask,
                  pathParameters: {'taskId': task.taskId},
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
