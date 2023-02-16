import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/utils/app_color.dart';
import 'package:flutter_hive_tdo/utils/custom_button.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

///
import '../utils/strings.dart';
import '../../main.dart';

/// Empty Title & Subtite TextFields Warning
emptyFieldsWarning(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must fill all Fields!",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing Enter When user try to edit the current tesk
nothingEnterOnUpdateTaskMode(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must edit the tasks then try to update it!",
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task Warning Dialog
dynamic warningNoTask(BuildContext context) {
  // return PanaraInfoDialog.showAnimatedGrow(
  //   context,
  //   title: MyString.oopsMsg,
  //   message:
  //       "There is no Task For Delete!\n Try adding some and then try to delete it!",
  //   buttonText: "Okay",
  //   onTapDismiss: () {
  //     Navigator.pop(context);
  //   },
  //   panaraDialogType: PanaraDialogType.warning,
  // );
  showDialog(context: context,
      builder: (context){
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 260,
            decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: AppColor.neoBoxShadow),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.info_outlined, color: Colors.white, size: 40,),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  MyString.oopsMsg,
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "There is no Task For Delete!\n Try adding some and then try to delete it!",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16),
                ),
                Expanded(child: Container()),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        // close dialog
                        BaseWidget.of(context).dataStore.box.clear();
                        Navigator.pop(context);
                      },
                      child: const CustomButton(
                        buttonText: "OK",
                        textColor: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        );
      });
}

/// Delete All Task Dialog
dynamic deleteAllTask(BuildContext context) {
  showDialog(context: context,
      builder: (context){
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 260,
        decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            boxShadow: AppColor.neoBoxShadow),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.question_mark, color: Colors.white, size: 40,),
            const SizedBox(
              height: 16,
            ),
            const Text(
              MyString.areYouSure,
              style: TextStyle(
                  color: Colors.white, fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Do You really want to delete all tasks? You will no be able to undo this action!",
              style: TextStyle(
                  color: Colors.white, fontSize: 16),
            ),
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        // close dialog
                            BaseWidget.of(context).dataStore.box.clear();
                            Navigator.pop(context);
                      },
                      child: const CustomButton(
                        buttonText: "Yes",
                        textColor: Colors.red,
                      )),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        // close dialog
                            BaseWidget.of(context).dataStore.box.clear();
                            Navigator.pop(context);
                      },
                      child: const CustomButton(
                        buttonText: "No",
                        textColor: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
      });
}

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';
