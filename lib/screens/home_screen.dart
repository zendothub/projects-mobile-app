import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/screens/MainScreens/My_issues/my_issues_screen.dart';
import 'package:zen_mobile/screens/MainScreens/Notification/notification.dart';
import 'package:zen_mobile/screens/MainScreens/Profile/ProfileSettings/profile_screen.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/custom_text.dart';
import 'package:zen_mobile/widgets/error_state.dart';
import 'MainScreens/Home/Dashboard/dash_board_screen.dart';
import 'MainScreens/Projects/project_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({required this.fromSignUp, super.key});
  final bool fromSignUp;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List navBarItems = [
    {'icon': 'assets/svg_images/home.svg', 'label': 'Home'},
    {'icon': 'assets/svg_images/projects.svg', 'label': 'Projects'},
    {'icon': 'assets/svg_images/issues.svg', 'label': 'My Issues'},
    {'icon': 'assets/svg_images/notification.svg', 'label': 'Notifications'},
    {'icon': 'assets/svg_images/settings.svg', 'label': 'Settings'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final bottomNavProvider = ref.watch(ProviderList.bottomNavProvider);
    themeProvider.context = context;
    final screens = [
      DashBoardScreen(
        fromSignUp: widget.fromSignUp,
      ),
      const ProjectScreen(),
      const MyIssuesScreen(),
      const NotifiactionScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: profileProvider.getProfileState == StateEnum.success
            ? IndexedStack(
                index: bottomNavProvider.selectedIndex,
                children: screens,
              )
            // screens[currentIndex] 
            : profileProvider.getProfileState == StateEnum.error
                ? errorState(context: context)
                : Container(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color:
                themeProvider.theme == THEME.custom ? customNavBarColor : null,
            border: Border(
              top: BorderSide(
                  color: themeProvider.themeManager.borderSubtle01Color,
                  width: 1),
            ),
          ),
          // padding: const EdgeInsets.only(
          //   top: 15,
          // ),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: navBarItems
                    .asMap()
                    .map(
                      (i, e) => MapEntry(
                        i,
                        InkWell(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (i == 0) {
                              ref
                                  .read(ProviderList.dashboardProvider)
                                  .getDashboard();
                            } else if (i == 2) {
                              ref
                                  .read(ProviderList.myIssuesProvider)
                                  .setState();
                            }
                            bottomNavProvider.setIndex(i);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 7,
                                width: 50,
                                color: bottomNavProvider.selectedIndex == i
                                    ? themeProvider.themeManager.primaryColour
                                    : Colors.transparent,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SvgPicture.asset(e['icon'],
                                  // height: 20,
                                  // width: 20,
                                  colorFilter: ColorFilter.mode(
                                      bottomNavProvider.selectedIndex == i
                                          ? themeProvider
                                              .themeManager.primaryColour
                                          : themeProvider.theme == THEME.custom
                                              ? customNavBarTextColor
                                              : (themeProvider.themeManager
                                                  .placeholderTextColor),
                                      BlendMode.srcIn)),
                              const Spacer(),
                              CustomText(
                                e['label'],
                                overrride: true,
                                type: FontStyle.Small,
                                color: bottomNavProvider.selectedIndex == i
                                    ? themeProvider.themeManager.primaryColour
                                    : themeProvider.theme == THEME.custom
                                        ? customNavBarTextColor
                                        : (themeProvider
                                            .themeManager.placeholderTextColor),
                                fontWeight: bottomNavProvider.selectedIndex == i
                                    ? FontWeightt.Bold
                                    : FontWeightt.Medium,
                                fontSize: 11,
                                letterSpacing: 0.2,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList()),
          ),
        ),
      ),
    );
  }
}
