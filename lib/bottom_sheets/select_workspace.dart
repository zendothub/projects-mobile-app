// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/screens/on_boarding/auth/setup_workspace.dart';
import 'package:zen_mobile/utils/color_manager.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/custom_text.dart';
import 'package:zen_mobile/widgets/workspace_logo_for_diffrent_extensions.dart';
import '../mixins/widget_state_mixin.dart';

class SelectWorkspace extends ConsumerStatefulWidget {
  const SelectWorkspace({super.key});

  @override
  ConsumerState<SelectWorkspace> createState() => _SelectWorkspaceState();
}

class _SelectWorkspaceState extends ConsumerState<SelectWorkspace>
    with WidgetStateMixin {
  double height = 0;

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState([
      ref.read(ProviderList.workspaceProvider).selectWorkspaceState,
      ref.read(ProviderList.myIssuesProvider).myIssuesViewState
    ], loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    final prov = ref.watch(ProviderList.workspaceProvider);
    final profileProvider = ref.watch(ProviderList.profileProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Workspace',
                type: FontStyle.H4,
                fontWeight: FontWeightt.Semibold,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: themeProvider.themeManager.placeholderTextColor,
                ),
              ),
            ],
          ),
          Container(
            height: 15,
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prov.workspaces.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () async {
                    await prov
                        .selectWorkspace(
                      id: prov.workspaces[index]["id"],
                      context: context,
                    )
                        .then(
                      (value) async {
                        ref.read(ProviderList.projectProvider).currentProject =
                            {};
                        ref.read(ProviderList.cyclesProvider).clearData();
                        ref.read(ProviderList.modulesProvider).clearData();
                        ref.read(ProviderList.myIssuesProvider).clear();
                        ref.read(ProviderList.activityProvider).clear();
                        ref.read(ProviderList.projectProvider).getProjects(
                            slug: ref
                                .read(ProviderList.workspaceProvider)
                                .workspaces
                                .where((element) =>
                                    element['id'] ==
                                    profileProvider.userProfile.lastWorkspaceId)
                                .first['slug']);
                        // ref
                        //     .read(ProviderList.projectProvider)
                        //     .favouriteProjects(
                        //       index: 0,
                        //       slug: ref
                        //           .read(ProviderList.workspaceProvider)
                        //           .workspaces
                        //           .where((element) =>
                        //               element['id'] ==
                        //               profileProvider
                        //                   .userProfile.lastWorkspaceId)
                        //           .first['slug'],
                        //       method: HttpMethod.get,
                        //       projectID: "",
                        //     );
                        await ref
                            .read(ProviderList.myIssuesProvider)
                            .getMyIssuesView();
                        ref
                            .read(ProviderList.myIssuesProvider)
                            .filterIssues(assigned: true);
                        ref.watch(ProviderList.myIssuesProvider).getLabels();

                        ref
                            .read(ProviderList.notificationProvider)
                            .getUnreadCount();

                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(type: 'assigned');
                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(type: 'created');
                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(type: 'watching');
                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(type: 'unread', getUnread: true);
                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(
                                type: 'archived', getArchived: true);
                        ref
                            .read(ProviderList.notificationProvider)
                            .getNotifications(
                                type: 'snoozed', getSnoozed: true);
                      },
                    );
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            prov.workspaces[index]['logo'] == null ||
                                    prov.workspaces[index]['logo'] == ''
                                ? Container(
                                    height: 35,
                                    width: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: ColorManager.getColorWithIndex(
                                            index),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: CustomText(
                                      prov.workspaces[index]['name']
                                          .toString()
                                          .toUpperCase()[0],
                                      type: FontStyle.Medium,
                                      fontWeight: FontWeightt.Semibold,
                                      // fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      overrride: true,
                                    ))
                                : WorkspaceLogoForDiffrentExtensions(
                                    imageUrl: prov.workspaces[index]['logo']
                                        .toString(),
                                    themeProvider: themeProvider,
                                    workspaceName: prov.workspaces[index]
                                            ['name']
                                        .toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              prov.workspaces[index]['name'],
                              type: FontStyle.H5,
                              color:
                                  themeProvider.themeManager.tertiaryTextColor,
                            ),
                            const Spacer(),
                            ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
                                        .workspaceId ==
                                    prov.workspaces[index]['id']
                                ? const Icon(
                                    Icons.done,
                                    color: Color.fromRGBO(9, 169, 83, 1),
                                  )
                                : Container(),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 15),
                        color: themeProvider.themeManager.borderDisabledColor,
                      )
                    ],
                  ),
                );
              }),
          Container(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SetupWorkspace(
                        fromHomeScreen: true,
                      )));
            },
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: themeProvider.themeManager.primaryColour,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  'Create Workspace',
                  type: FontStyle.H5,
                  color: themeProvider.themeManager.primaryColour,
                ),
              ],
            ),
          ),
          Container(
            height: bottomSheetConstBottomPadding,
          ),
        ],
      ),
    );
  }
}
