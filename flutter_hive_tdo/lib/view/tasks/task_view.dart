// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hive_tdo/utils/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/app_color.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  TaskView({
    Key? key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  }) : super(key: key);

  TextEditingController? taskControllerForTitle;
  TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: const MyAppBar(),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// new / update Task Text
                    _buildTopText(textTheme),

                    /// Middle Two TextFileds, Time And Date Selection Box
                    _buildMiddleTextFieldsANDTimeAndDateSelection(
                        context, textTheme),

                    /// All Bottom Buttons
                    _buildBottomButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container()

              /// Delete Task Button
              : InkWell(
                onTap: () {
                  deleteTask();
                  Navigator.pop(context);
                },
                child: const CustomButton(buttonText: MyString.deleteTask, textColor: Colors.red,)
              ),

          /// Add or Update Task Button
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isTaskAlreadyExistUpdateTask();
            },
            child: CustomButton(buttonText:  isTaskAlreadyExistBool()
                ? MyString.addTaskString
                : MyString.updateTaskString, textColor: Colors.white,),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 535,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(MyString.titleOfTitleTextField,
                style: textTheme.headline4),
          ),

          /// Title TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 6,
                cursorHeight: 60,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// Note TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.bookmark_border, color: Colors.white),
                    border: InputBorder.none,
                    counter: Container(),
                    hintText: MyString.addNote,
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 22)),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),

          /// Time Picker
          GestureDetector(
            onTap: () {
              DatePicker.showTimePicker(context,
                  showTitleActions: true,
                  showSecondsColumn: false,
                  onChanged: (_) {}, onConfirm: (selectedTime) {
                setState(() {
                  if (widget.task?.createdAtTime == null) {
                    time = selectedTime;
                  } else {
                    widget.task!.createdAtTime = selectedTime;
                  }
                });

                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showTimeAsDateTime(time));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(MyString.timeString,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showTime(time),
                        style: textTheme.subtitle2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /// Date Picker
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 3, 5),
                  onChanged: (_) {}, onConfirm: (selectedDate) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    date = selectedDate;
                  } else {
                    widget.task!.createdAtDate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showDateAsDateTime(date));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(MyString.dateString,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showDate(date),
                        style: textTheme.subtitle2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// new / update Task Text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? MyString.addNewTask
                    : MyString.updateCurrentTask,
                style: const TextStyle(color: Colors.white, fontSize: 32),
                children: const [
                  TextSpan(
                    text: MyString.taskStrnig,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          SvgPicture.asset(
            "assets/img/topolo-logo-light.svg",
            semanticsLabel: 'Acme Logo',
            width: 80,
          ),
          Expanded(child: Container()),
          SvgPicture.asset(
            "assets/img/topolo-icon-single-light.svg",
            semanticsLabel: 'Acme Logo',
            width: 60,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
