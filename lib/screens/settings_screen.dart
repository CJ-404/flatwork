import 'package:flatwork/config/config.dart';
import 'package:flatwork/data/data.dart';
import 'package:flatwork/providers/providers.dart';
import 'package:flatwork/utils/utils.dart';
import 'package:flatwork/widgets/main_scaffold.dart';
import 'package:flatwork/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static SettingsScreen builder(BuildContext context, GoRouterState state)
  => const SettingsScreen();
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

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
      child: Scaffold(
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  height: deviceSize.height*0.3,
                  width: deviceSize.width,
                  color: colors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.logout, color: colors.onPrimary,size: 30,),
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                              context.pushNamed(RouteLocation.login);
                            },
                          ),
                        ],
                      ),
                      const DisplayWhiteText(
                          text: 'Settings',
                          fontSize: 40
                      ),
                      const Gap(50),
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: (){
                      // TODO: go to change profile settings screen
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 0,
                        bottom: 10,
                        right: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Settings",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            "change user profile & preferences",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.pushNamed(RouteLocation.login);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 10,
                        bottom: 10,
                        right: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Log Out",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            "",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
