// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/utils/custom_button.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/app_color.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';
import '../../view/home/widgets/task_widget.dart';
import '../../view/tasks/task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.primaryColor,

              /// Floating Action Button
              floatingActionButton: const FAB(),

              appBar: MyAppBar(
                drawerKey: dKey,
              ),

              /// Body
              body: _buildBody(
                tasks,
                base,
                textTheme,
              ),
            ),
          );
        });
  }

  /// Main Body
  SizedBox _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          /// Top Section Of Home page : Text, Progrss Indicator
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// CircularProgressIndicator
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation(AppColor.primaryColor),
                    backgroundColor: Colors.grey,
                    value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),

                /// Texts
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(MyString.mainTitle,
                        style: TextStyle(color: Colors.white, fontSize: 28)),
                    const SizedBox(
                      height: 3,
                    ),
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22)),
                  ],
                )
              ],
            ),
          ),

          /// Divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
              color: Colors.white,
            ),
          ),

          /// Bottom ListView : Tasks
          SizedBox(
            width: double.infinity,
            height: 585,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var task = tasks[index];

                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(MyString.deletedTask,
                                style: TextStyle(
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        onDismissed: (direction) {
                          base.dataStore.dalateTask(task: task);
                        },
                        key: Key(task.id),
                        child: TaskWidget(
                          task: tasks[index],
                        ),
                      );
                    },
                  )

                /// if All Tasks Done Show this Widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Lottie
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            lottieURL,
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),

                      /// Bottom Texts
                      FadeInUp(
                        from: 30,
                        child: const Text(MyString.doneAllTask,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

/// My App Bar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({Key? key, 
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar> {

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          base.isEmpty
              ? warningNoTask(context,
                  "There is no Task For Delete!\n Try adding some and then try to delete it!")
              : warningNoTask(context,
                  "No Task Selected for Delete!\n Please select some task!");
        },
        child: Row(
          children: [
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
            // const Icon(
            //   CupertinoIcons.trash,
            //   color: Colors.white,
            //   size: 40,
            // ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: const CustomButton(
        buttonWith: 60,
      ),
    );
  }
}
