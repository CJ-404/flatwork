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
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state)
  => const HomeScreen();
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final futureRef = projectProvider.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    final today = DateTime.now();

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
                                  NotificationTile(message: "You have a task due on nov 2",),
                                  NotificationTile(message: "You have a task due on nov 4",),
                                  NotificationTile(message: "New project invitation!",),
                                  // NotificationTile(message: "New messages - project flatpack ",),
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
                          focusedDay: today,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
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
                    Container(
                      height: 300, // Adjust as needed for demo purposes
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              10,
                                  (index) => ListTile(
                                title: Text('Event $index'),
                              )),
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
}
