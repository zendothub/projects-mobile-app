import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_mobile/provider/provider_list.dart';
import 'package:zen_mobile/utils/constants.dart';
import 'package:zen_mobile/utils/custom_toast.dart';
import '../utils/enums.dart';
import 'custom_text.dart';

class ResendCodeButton extends ConsumerStatefulWidget {
  const ResendCodeButton({required this.signUp, required this.email, Key? key})
      : super(key: key);
  final bool signUp;
  final String email;

  @override
  ConsumerState<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends ConsumerState<ResendCodeButton> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Timer? timer;
  int start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (start == 0) {
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              start--;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final resendprov = ref.read(ProviderList.resendOtpCounterProvider);
    final themeProvider = ref.read(ProviderList.themeProvider);
    if (start == 0) {
      return Align(
        alignment: Alignment.centerRight,
        child: InkWell(
            onTap: () async {
              await ref
                  .read(ProviderList.authProvider)
                  .sendMagicCode(
                    email: widget.email,
                    resend: true,
                  )
                  .then((value) {
                CustomToast.showToast(context,
                    message: 'Code sent successfully',
                    toastType: ToastType.success);
              });
              if (mounted) {
                setState(() {
                  start = 30;
                  startTimer();
                });
              }
            },
            child: const CustomText(
              'Resend code',
              type: FontStyle.Small,
              color: primaryColor,
            )),
      );
    } else {
      return Center(
        child: CustomText(
          'Didn’t receive code? Get new code in ${start < 10 ? "0$start" : start} secs.',
          type: FontStyle.Small,
          color: themeProvider.themeManager.placeholderTextColor,
        ),
      );
    }
  }
}
