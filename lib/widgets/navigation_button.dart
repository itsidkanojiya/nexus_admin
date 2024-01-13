import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/models/enums/navigation_items.dart';
import 'package:lexus_admin/module/auth/auth_service.dart';

class NavigationButton extends StatelessWidget {
  NavigationButton({
    Key? key,
    required this.index,
    this.widget,
  }) : super(key: key);

  final int index;
  Widget? widget;
  List<String> menuName = [
    'Dashboard',
    'Teachers',
    'Students',
    'Books',
    'Quetions'
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          AuthService.indexValue.value = index;
        },
        child: Container(
          width: 170,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AuthService.indexValue.value == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                NavigationItems.values[index].icon,
                                size: 20,
                                color: AuthService.indexValue.value == index
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                menuName[index],
                                style: TextStyle(
                                  color: AuthService.indexValue.value == index
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          widget ?? const SizedBox()
                          // AuthService.indexValue.value == index
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(left: 40),
                          //         child: Text(
                          //           menuName,
                          //           style: TextStyle(
                          //             color:
                          //                 AuthService.indexValue.value == index
                          //                     ? Colors.white
                          //                     : Colors.grey,
                          //           ),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
