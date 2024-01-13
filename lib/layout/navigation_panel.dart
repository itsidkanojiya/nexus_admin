import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/enums/navigation_items.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';
import 'package:lexus_admin/responsive.dart';
import 'package:lexus_admin/widgets/navigation_button.dart';

class NavigationPanel extends StatefulWidget {
  final Axis axis;
  const NavigationPanel({Key? key, required this.axis}) : super(key: key);

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 80, minHeight: Get.height - 100),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: Responsive.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
          : const EdgeInsets.all(10),
      child: widget.axis == Axis.vertical
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset("assets/logo.png", height: 100),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            NavigationButton(
                              index: 0,
                            ),
                            NavigationButton(
                              index: 1,
                              widget: AuthService.indexValue.value == 1
                                  ? Obx(
                                      () => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subTeacherIndex
                                                            .value ==
                                                        0
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                  onTap: (() {
                                                    AuthService.subTeacherIndex
                                                        .value = 0;
                                                  }),
                                                  child: Text(
                                                    '➢ Pending',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subTeacherIndex
                                                                  .value ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subTeacherIndex
                                                            .value ==
                                                        1
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subTeacherIndex
                                                      .value = 1;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ Active',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subTeacherIndex
                                                                  .value ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                            NavigationButton(
                              index: 2,
                            ),
                            NavigationButton(
                              index: 3,
                            ),
                            NavigationButton(
                              index: 4,
                              widget: AuthService.indexValue.value == 4
                                  ? Obx(
                                      () => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        0
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                  onTap: (() {
                                                    AuthService.subQuetionIndex
                                                        .value = 0;
                                                  }),
                                                  child: Text(
                                                    '➢ MCQ',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        1
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subQuetionIndex
                                                      .value = 1;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ Blank',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        2
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subQuetionIndex
                                                      .value = 2;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ T & F',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              2
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        3
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subQuetionIndex
                                                      .value = 3;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ One two',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              3
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        4
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subQuetionIndex
                                                      .value = 4;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ Short',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              4
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AuthService
                                                            .subQuetionIndex
                                                            .value ==
                                                        5
                                                    ? Colors.deepOrangeAccent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  AuthService.subQuetionIndex
                                                      .value = 5;
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '➢ Long',
                                                    style: TextStyle(
                                                      color: AuthService
                                                                  .subQuetionIndex
                                                                  .value ==
                                                              5
                                                          ? Colors.white
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ]),
                  Container()
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset("assets/logo.png", height: 20),
                ),
                Row(
                  children: NavigationItems.values
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: NavigationButton(
                            index: e.index,
                          ),
                        ),
                      )
                      .toList(),
                ),
                Container()
              ],
            ),
    );
  }
}
