import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_card.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/widgets/empty.dart';
import 'package:zen_mobile/widgets/loading_widget.dart';

class PageScreen extends ConsumerStatefulWidget {
  const PageScreen({super.key});

  @override
  ConsumerState<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends ConsumerState<PageScreen> {
  @override
  Widget build(BuildContext context) {
    final pageProvider = ref.watch(ProviderList.pageProvider);
    return LoadingWidget(
      loading: pageProvider.pagesListState == StateEnum.loading,
      widgetClass: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: pageProvider.pages[pageProvider.selectedFilter]!.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pageProvider
                          .pages[pageProvider.selectedFilter]!.length,
                      itemBuilder: (context, index) {
                        return PageCard(index: index);
                      },
                    ),
                  ],
                ),
              )
            : EmptyPlaceholder.emptyPages(context, ref),
      ),
    );
  }
}
