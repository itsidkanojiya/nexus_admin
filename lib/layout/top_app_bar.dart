import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lexus_admin/module/auth/login_view.dart';
import 'package:lexus_admin/responsive.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Search something...",
                  icon: Icon(CupertinoIcons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.dialog(AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.to(LoginView());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("Yes"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("No"),
                      ),
                    ),
                  ],
                ));
              },
              child: _nameAndProfilePicture(
                context,
                "Krunal Patel",
                "assets/admin_pic.png",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameAndProfilePicture(
      BuildContext context, String username, String imageUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 6.0),
          child: Icon(
            CupertinoIcons.chevron_down,
            size: 14,
          ),
        ),
        Visibility(
          visible: !Responsive.isMobile(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
            ),
          ),
        ),
      ],
    );
  }
}
