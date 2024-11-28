import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/screens/MainScreens/Notification/notifications_list.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/custom_app_bar.dart';
import 'package:zen_mobile/widgets/loading_widget.dart';

class ExtraNotifications extends ConsumerStatefulWidget {
  const ExtraNotifications({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExtraNotificationsState();
}

class _ExtraNotificationsState extends ConsumerState<ExtraNotifications> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = ref.watch(ProviderList.notificationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        text: widget.title,
        centerTitle: true,
      ),
      body: LoadingWidget(
        loading: widget.type == 'archived'
            ? notificationProvider.getArchivedState == StateEnum.loading
            : widget.type == 'snoozed'
                ? notificationProvider.getSnoozedState == StateEnum.loading
                : notificationProvider.getUnreadState == StateEnum.loading,
        widgetClass: NotificationsList(
          data: widget.type == 'archived'
              ? notificationProvider.archived
              : widget.type == 'snoozed'
                  ? notificationProvider.snoozed
                  : notificationProvider.unread,
          type: widget.type,
        ),
      ),
    );
  }
}
