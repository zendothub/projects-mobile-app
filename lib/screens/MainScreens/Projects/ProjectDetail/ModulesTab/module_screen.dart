import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/ProjectDetail/ModulesTab/simple_module_card.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/custom_text.dart';
import 'package:zen_mobile/widgets/empty.dart';
import 'package:zen_mobile/widgets/loading_widget.dart';


class ModuleScreen extends ConsumerStatefulWidget {
  const ModuleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends ConsumerState<ModuleScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
    return LoadingWidget(
      loading: modulesProvider.moduleState == StateEnum.loading,
      widgetClass: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: (modulesProvider.favModules.isEmpty &&
                modulesProvider.modules.isEmpty)
            ? EmptyPlaceholder.emptyModules(context, ref)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    modulesProvider.favModules.isNotEmpty &&
                            modulesProvider.modules.isNotEmpty
                        ? CustomText(
                            'Favourite',
                            type: FontStyle.Medium,
                            fontWeight: FontWeightt.Medium,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          )
                        : Container(),
                    modulesProvider.favModules.isNotEmpty
                        ? Container(
                            color: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: modulesProvider.favModules.length,
                              itemBuilder: (context, index) {
                                return SimpleModuleCard(
                                  index: index,
                                  isFav: true,
                                );
                              },
                            ),
                          )
                        : Container(),
                    modulesProvider.favModules.isNotEmpty
                        ? const SizedBox(height: 20)
                        : Container(),
                    modulesProvider.modules.isNotEmpty &&
                            modulesProvider.favModules.isNotEmpty
                        ? CustomText(
                            'All Modules',
                            type: FontStyle.Medium,
                            fontWeight: FontWeightt.Medium,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          )
                        : Container(),
                    Container(
                        color: themeProvider
                            .themeManager.primaryBackgroundDefaultColor,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: modulesProvider.modules.length,
                          itemBuilder: (context, index) {
                            return SimpleModuleCard(
                              index: index,
                              isFav: false,
                            );
                          },
                        )),
                    const SizedBox(height: 15)
                  ],
                ),
              ),
      ),
    );
  }
}
