import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/custom_text.dart';
import 'package:zen_mobile/widgets/member_logo_widget.dart';


class LeadSheet extends ConsumerStatefulWidget {
  const LeadSheet({
    super.key,
    this.fromModuleDetail = false,
    this.fromCycleDetail = false,
  });
  final bool fromModuleDetail;
  final bool fromCycleDetail;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeadSheetState();
}

class _LeadSheetState extends ConsumerState<LeadSheet> {
  @override
  Widget build(BuildContext context) {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeManager.primaryBackgroundDefaultColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      width: double.infinity,
      //height: height * 0.5,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Wrap(
              children: [
                Row(
                  children: [
                    CustomText(
                      'Lead',
                      type: FontStyle.H4,
                      fontWeight: FontWeightt.Semibold,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 27,
                        color: themeProvider.themeManager.placeholderTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: ListView.builder(
                    padding:
                        EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
                    itemCount: projectProvider.projectMembers.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (widget.fromCycleDetail) {
                            ref
                                .read(ProviderList.cyclesProvider)
                                .cycleDetailsCrud(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace
                                  .workspaceSlug,
                              projectId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject["id"],
                              method: CRUD.update,
                              cycleId: ref
                                  .read(ProviderList.cyclesProvider)
                                  .currentCycle["id"],
                              data: {
                                'owned_by': projectProvider
                                    .projectMembers[index]['member']
                              },
                            );

                            return;
                          }

                          if (widget.fromModuleDetail) {
                            modulesProvider.updateModules(
                                slug: ref
                                    .read(ProviderList.workspaceProvider)
                                    .selectedWorkspace
                                    .workspaceSlug,
                                projId: ref
                                    .read(ProviderList.projectProvider)
                                    .currentProject["id"],
                                moduleId: ref
                                    .read(ProviderList.modulesProvider)
                                    .currentModule["id"],
                                data: {
                                  'lead': projectProvider.projectMembers[index]
                                      ['member']['id']
                                },
                                ref: ref);
                            Navigator.pop(context);
                            return;
                          }

                          modulesProvider.createModule['lead'] = projectProvider
                              .projectMembers[index]['member']['id'];
                          modulesProvider.setState();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          decoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: MemberLogoWidget(
                                      size: 30,
                                      boarderRadius: 50,
                                      padding: EdgeInsets.zero,
                                      imageUrl:
                                          projectProvider.projectMembers[index]
                                              ['member']['avatar'],
                                      colorForErrorWidget:
                                          const Color.fromRGBO(55, 65, 81, 1),
                                      memberNameFirstLetterForErrorWidget:
                                          projectProvider.projectMembers[index]
                                                  ['member']['first_name'][0]
                                              .toString())),
                              Container(
                                width: 10,
                              ),
                              CustomText(
                                projectProvider.projectMembers[index]['member']
                                        ['first_name'] +
                                    " " +
                                    projectProvider.projectMembers[index]
                                        ['member']['last_name'],
                                type: FontStyle.Small,
                              ),
                              const Spacer(),
                              modulesProvider.currentModule['lead_detail'] !=
                                      null
                                  ? createIsseuSelectedMembersWidget(index)
                                  : Container(),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createIsseuSelectedMembersWidget(int idx) {
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return (widget.fromCycleDetail
            ? (ref.read(ProviderList.cyclesProvider).currentCycle['owned_by']
                    ['id'] ==
                projectProvider.projectMembers[idx]['member']['id'])
            : widget.fromModuleDetail
                ? (modulesProvider.currentModule['lead_detail']['id'] ==
                    projectProvider.projectMembers[idx]['member']['id'])
                : modulesProvider.createModule['lead'] != null &&
                    modulesProvider.createModule['lead'] ==
                        projectProvider.projectMembers[idx]['member']['id'])
        ? const Icon(
            Icons.done,
            color: Color.fromRGBO(8, 171, 34, 1),
          )
        : const SizedBox();
  }
}
