// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:zen_mobile/bottom_sheets/delete_state_sheet.dart';
import 'package:zen_mobile/provider/issues_provider.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/custom_toast.dart';
import 'package:zen_mobile/utils/enums.dart';
import 'package:zen_mobile/utils/extensions/string_extensions.dart';
import 'package:zen_mobile/widgets/custom_button.dart';
import 'package:zen_mobile/widgets/custom_text.dart';

List states = ['backlog', 'unstarted', 'started', 'completed', 'cancelled'];

class StatesPage extends ConsumerStatefulWidget {
  const StatesPage({super.key});

  @override
  ConsumerState<StatesPage> createState() => _StatesPageState();
}

class _StatesPageState extends ConsumerState<StatesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    return Container(
      color: themeProvider.themeManager.primaryBackgroundDefaultColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: states.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    states[index].toString().replaceFirst(states[index][0],
                        states[index][0].toString().toUpperCase()),
                    // values['group'].replaceFirst(values['group'][0], values['group'][0].toUpperCase()),
                    type: FontStyle.H5,
                    fontWeight: FontWeightt.Medium,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.8),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddUpdateState(
                              groupIndex: index,
                              stateKey: states[index].toString().replaceFirst(
                                  states[index][0],
                                  states[index][0].toString().toUpperCase()),
                              method: CRUD.create,
                              stateId: '',
                              name: '',
                              color: '',
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  )
                ],
              ),
              issuesProvider.statesData[states[index]] == null
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      itemCount:
                          issuesProvider.statesData[states[index]].length,
                      itemBuilder: (context, idx) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.only(
                            left: 14,
                          ),
                          decoration: BoxDecoration(
                              color: themeProvider
                                  .themeManager.primaryBackgroundDefaultColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: themeProvider
                                      .themeManager.borderSubtle01Color)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    states[index] == 'backlog'
                                        ? 'assets/svg_images/circle.svg'
                                        : states[index] == 'cancelled'
                                            ? 'assets/svg_images/cancelled.svg'
                                            : states[index] == 'completed'
                                                ? 'assets/svg_images/done.svg'
                                                : states[index] == 'started'
                                                    ? 'assets/svg_images/in_progress.svg'
                                                    : 'assets/svg_images/circle.svg',
                                    colorFilter: ColorFilter.mode(
                                        getColorFromIssueProvider(
                                            issuesProvider, index, idx),
                                        BlendMode.srcIn),
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: width * 0.6,
                                    child: CustomText(
                                      issuesProvider.statesData[states[index]]
                                          [idx]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      type: FontStyle.Medium,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        constraints: BoxConstraints(
                                            maxHeight: height * 0.8),
                                        enableDrag: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: AddUpdateState(
                                              groupIndex: index,
                                              stateKey: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]["group"],
                                              method: CRUD.update,
                                              stateId: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]['id'],
                                              name: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]['name'],
                                              color: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]['color'],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: themeProvider
                                          .themeManager.placeholderTextColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (issuesProvider
                                                  .statesData[states[index]]
                                              [idx]['default'] ==
                                          true) {
                                        CustomToast.showToast(
                                          context,
                                          message:
                                              'Cannot delete the default state',
                                          toastType: ToastType.failure,
                                        );
                                      } else if (issuesProvider
                                              .statesData[states[index]]
                                              .length ==
                                          1) {
                                        CustomToast.showToast(
                                          context,
                                          message: 'Cannot have an empty group',
                                          toastType: ToastType.failure,
                                        );
                                      } else {
                                        showModalBottomSheet(
                                          constraints: const BoxConstraints(
                                              maxHeight: 345),
                                          enableDrag: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          context: context,
                                          builder: (context) {
                                            return DeleteStateSheet(
                                              stateName: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]['name'],
                                              stateId: issuesProvider
                                                      .statesData[states[index]]
                                                  [idx]['id'],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg_images/delete_icon.svg',
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                          themeProvider
                                              .themeManager.textErrorColor,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }

  Color getColorFromIssueProvider(
      IssuesProvider issuesProvider, int index, int idx) {
    const Color colorToReturnOnApiError = Color.fromARGB(255, 200, 80, 80);
    final String? colorData =
        issuesProvider.statesData[states[index]][idx]['color'];

    return (colorData == null || colorData[0] != '#')
        ? colorToReturnOnApiError
        : Color(int.parse("FF${colorData.replaceAll('#', '')}", radix: 16));
  }
}

// ignore: must_be_immutable
class AddUpdateState extends ConsumerStatefulWidget {
  AddUpdateState(
      {required this.stateKey,
      required this.method,
      required this.groupIndex,
      required this.stateId,
      required this.name,
      required this.color,
      super.key});
  final String stateKey;
  final CRUD method;
  final String stateId;
  final String name;
  int groupIndex;
  final String color;

  @override
  ConsumerState<AddUpdateState> createState() => _AddUpdateStateState();
}

class _AddUpdateStateState extends ConsumerState<AddUpdateState> {
  TextEditingController nameController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final colorController = TextEditingController();
  bool showColoredBox = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name.isNotEmpty ? widget.name : '';
    stateController.text = states[widget.groupIndex];

    if (widget.color.isNotEmpty) {
      colorController.text = widget.color.replaceAll('#', '');
    } else {
      colorController.text =
          colorsForLabel[Random().nextInt(colorsForLabel.length)]
              .replaceAll('#', '');
    }

    // log(widget.stateKey);
  }

  double height = 0.0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              children: [
                Wrap(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      color: themeProvider
                          .themeManager.primaryBackgroundDefaultColor,
                    ),
                    const CustomText(
                      'Color',
                      type: FontStyle.Small,
                    ),
                    Container(
                      height: 10,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: colorsForLabel
                          .map(
                            (e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  colorController.text = e
                                      .toString()
                                      .replaceAll('#', '')
                                      .toUpperCase();
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: e.toString().toColor(),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 1.0, color: greyColor),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLength: 6,
                              controller: colorController,
                              onChanged: (value) {
                                if (value.length == 6 &&
                                    value.contains(RegExp("[^0-9a-fA-F]"))) {
                                  CustomToast.showToast(context,
                                      message: 'HexCode is not valid',
                                      toastType: ToastType.warning);
                                }

                                setState(() {});
                              },
                              decoration: themeProvider
                                  .themeManager.textFieldDecoration
                                  .copyWith(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: themeProvider.themeManager
                                          .primaryBackgroundSelectedColour),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3,
                                      color: themeProvider.themeManager
                                          .primaryBackgroundSelectedColour),
                                ),
                                filled: true,
                                fillColor: themeProvider.themeManager
                                    .secondaryBackgroundDefaultColor,
                                prefixIcon: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 55,
                                  height: 55,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          '#${colorController.text}'.toColor(),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5))),
                                  child: CustomText(
                                    '#',
                                    color: themeProvider
                                        .themeManager.placeholderTextColor,
                                    fontWeight: FontWeightt.Semibold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    const CustomText(
                      'Name *',
                      type: FontStyle.Small,
                    ),
                    Container(
                      height: 5,
                    ),
                    TextField(
                      controller: nameController,
                      decoration:
                          themeProvider.themeManager.textFieldDecoration,
                    ),
                    Container(
                      height: 20,
                    ),
                    widget.method == CRUD.create
                        ? Container()
                        : const CustomText(
                            'State *',
                            type: FontStyle.Small,
                          ),
                    widget.method == CRUD.create
                        ? Container()
                        : GestureDetector(
                            onTap:
                                issuesProvider
                                            .statesData[
                                                states[widget.groupIndex]]
                                            .length ==
                                        1
                                    ? null
                                    : () {
                                        showModalBottomSheet(
                                          enableDrag: true,
                                          constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5),
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: Container(
                                                padding:
                                                    bottomSheetConstPadding,
                                                decoration: BoxDecoration(
                                                  color: themeProvider
                                                      .themeManager
                                                      .secondaryBackgroundDefaultColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          topRight:
                                                              Radius.circular(
                                                                  30)),
                                                ),
                                                width: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 50,
                                                          ),
                                                          for (int i = 0;
                                                              i < states.length;
                                                              i++)
                                                            GestureDetector(
                                                              onTap: () async {
                                                                setState(() {
                                                                  stateController
                                                                          .text =
                                                                      states[i];
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        2),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Radio(
                                                                          activeColor: stateController.text == states[i]
                                                                              ? null
                                                                              : themeProvider.themeManager.primaryColour,
                                                                          fillColor: stateController.text != states[i]
                                                                              ? MaterialStateProperty.all<Color>(themeProvider.themeManager.borderSubtle01Color)
                                                                              : null,
                                                                          visualDensity:
                                                                              VisualDensity.compact,
                                                                          value:
                                                                              states[i],
                                                                          groupValue:
                                                                              stateController.text,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              stateController.text = states[i];
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.7,
                                                                          child:
                                                                              CustomText(
                                                                            states[i],
                                                                            type:
                                                                                FontStyle.Medium,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontWeight:
                                                                                FontWeightt.Regular,
                                                                            color:
                                                                                themeProvider.themeManager.primaryTextColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                        width:
                                                                            width,
                                                                        height:
                                                                            1,
                                                                        color: themeProvider
                                                                            .themeManager
                                                                            .borderDisabledColor),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          // : Container(),

                                                          SizedBox(
                                                              height:
                                                                  bottomSheetConstBottomPadding),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryBackgroundDefaultColor,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            child:
                                                                const CustomText(
                                                              'Select State',
                                                              type:
                                                                  FontStyle.H4,
                                                              fontWeight:
                                                                  FontWeightt
                                                                      .Semibold,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              size: 27,
                                                              color: themeProvider
                                                                  .themeManager
                                                                  .placeholderTextColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                            child: Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 20),
                              child: TextField(
                                controller: stateController,
                                style: TextStyle(
                                    color: themeProvider
                                        .themeManager.primaryTextColor),
                                decoration: themeProvider
                                    .themeManager.textFieldDecoration
                                    .copyWith(
                                        suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                )),
                                enabled: false,
                              ),
                            ),
                          ),
                  ],
                ),
                Button(
                  text: widget.method == CRUD.create
                      ? 'Add State'
                      : 'Update State',
                  ontap: () async {
                    if (nameController.text.isNotEmpty) {
                      await projectProvider.stateCrud(
                          slug: ref
                              .watch(ProviderList.workspaceProvider)
                              .selectedWorkspace
                              .workspaceSlug,
                          projId: ref
                              .watch(ProviderList.projectProvider)
                              .currentProject['id'],
                          stateId: widget.stateId.isEmpty ? '' : widget.stateId,
                          method: widget.method,
                          context: context,
                          data: {
                            "name": nameController.text,
                            "color": '#${colorController.text}',
                            "group": stateController.text.toLowerCase(),
                            "description": ""
                          },
                          ref: ref);
                      issuesProvider.getStates(
                        slug: ref
                            .watch(ProviderList.workspaceProvider)
                            .selectedWorkspace
                            .workspaceSlug,
                        projID: ref
                            .watch(ProviderList.projectProvider)
                            .currentProject['id'],
                      );
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          projectProvider.stateCrudState == StateEnum.loading
              ? Container(
                  height: height - 32,
                  alignment: Alignment.center,
                  color:
                      themeProvider.themeManager.primaryBackgroundDefaultColor,
                  // height: 25,
                  // width: 25,
                  child: Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [themeProvider.themeManager.primaryTextColor],
                        strokeWidth: 1.0,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Container(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: CustomText(
                    widget.method == CRUD.update
                        ? 'Update ${widget.name} state'
                        : 'Add ${widget.name} state',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                    maxLines: 1,
                    fontSize: 22,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: themeProvider.themeManager.primaryTextColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
