import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/widgets/custom_text.dart';
import '../utils/enums.dart';

class SelectEmails extends ConsumerStatefulWidget {
  const SelectEmails({required this.email, super.key});
  final Map email;
  @override
  ConsumerState<SelectEmails> createState() => _SelectEmailsState();
}

class _SelectEmailsState extends ConsumerState<SelectEmails> {
  List emails = [];
  @override
  void initState() {
    final workspaceProvider = ref.read(ProviderList.workspaceProvider);
    workspaceProvider.invitingMembersRole.text = 'Viewer';
    for (final element in workspaceProvider.workspaceMembers) {
      emails.add(
          {"email": element['member']['email'], "id": element["member"]["id"]});
    }
    super.initState();
  }

  int selectedEmail = -1;

  @override
  Widget build(BuildContext context) {
    final themeProv = ref.watch(ProviderList.themeProvider);
    final profProv = ref.watch(ProviderList.profileProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(top: 5),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  emails.length == 1
                      ? Container()
                      : ListView.builder(
                          itemCount: emails.length,
                          padding: EdgeInsets.only(
                              bottom: bottomSheetConstBottomPadding),
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return emails[index]["email"] ==
                                    profProv.userProfile.email
                                ? Container()
                                : Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.email["email"] =
                                                emails[index]["email"];
                                            widget.email["id"] =
                                                emails[index]["id"];

                                            selectedEmail = index;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      themeProv.themeManager
                                                          .borderStrong01Color),
                                              activeColor: primaryColor,
                                              value: index,
                                              groupValue: selectedEmail,
                                              onChanged: (value) {
                                                setState(() {
                                                  widget.email["email"] =
                                                      emails[index]["email"];
                                                  widget.email["id"] =
                                                      emails[index]["id"];

                                                  selectedEmail = index;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 15, 15, 15),
                                              child: CustomText(
                                                emails[index]["email"],
                                                type: FontStyle.Small,
                                                color: themeProv.themeManager
                                                    .primaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 1,
                                        width: double.infinity,
                                        color: themeProv
                                            .themeManager.borderDisabledColor,
                                      ),
                                    ],
                                  );
                          }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: themeProv.themeManager.primaryBackgroundDefaultColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 25, bottom: 20),
              child: Row(
                children: [
                  const CustomText(
                    'Select Member',
                    type: FontStyle.H6,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: themeProv.themeManager.placeholderTextColor,
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
