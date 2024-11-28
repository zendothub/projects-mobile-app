import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:zen_mobile/routers/routes_path.dart';
import 'package:zen_mobile/screens/MainScreens/Activity/activity.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/ProjectDetail/CyclesTab/create_cycle.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/ProjectDetail/IssuesTab/CreateIssue/create_issue.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/ProjectDetail/ModulesTab/create_module.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/create_project_screen.dart';
import 'package:zen_mobile/screens/create_state.dart';
import 'package:zen_mobile/screens/home_screen.dart';
import 'package:zen_mobile/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:zen_mobile/screens/on_boarding/auth/setup_workspace.dart';
import 'package:zen_mobile/screens/on_boarding/auth/sign_in.dart';
import 'package:zen_mobile/screens/on_boarding/on_boarding_screen.dart';
import 'package:zen_mobile/utils/page_route_builder.dart';

class GeneratedRoutes {
  bool isAutheticated() {
    return true;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPaths.home:
        return PageRoutesBuilder.sharedAxis(
          const HomeScreen(
            fromSignUp: false,
          ),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createCycle:
        return PageRoutesBuilder.sharedAxis(
          const CreateCycle(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createIssue:
        return PageRoutesBuilder.sharedAxis(
          const CreateIssue(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createProject:
        return PageRoutesBuilder.sharedAxis(
          const CreateProject(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createModule:
        return PageRoutesBuilder.sharedAxis(
          const CreateModule(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.activity:
        return PageRoutesBuilder.sharedAxis(
          const Activity(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createState:
        return PageRoutesBuilder.sharedAxis(
          const CreateState(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.onboarding:
        return PageRoutesBuilder.sharedAxis(
          const OnBoardingScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.signin:
        return PageRoutesBuilder.sharedAxis(
          const SignInScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.setupProfile:
        return PageRoutesBuilder.sharedAxis(
          const SetupProfileScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.setupWorkspace:
        return PageRoutesBuilder.sharedAxis(
          const SetupWorkspace(),
          SharedAxisTransitionType.horizontal,
        );

      default:
        return PageRoutesBuilder.sharedAxis(
          const HomeScreen(
            fromSignUp: false,
          ),
          SharedAxisTransitionType.horizontal,
        );
    }
  }
}
