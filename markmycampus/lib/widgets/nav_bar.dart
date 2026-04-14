import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../screens/campus_map_screen.dart';
import '../screens/schedule_page.dart';
import '../screens/profile_page.dart';

Route _createInstantRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

Widget buildNav(BuildContext context, int activeIndex) {
  return Container(
    height: 90,
    decoration: const BoxDecoration(
      color: Color(0xFFFFD633),
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Home Button
        IconButton(
          icon: const Icon(Icons.home, size: 30),
          onPressed: () {
            if (globalUserName != "User") {
              Navigator.pushAndRemoveUntil(
                context,
                _createInstantRoute(const CampusMapScreen()), // Line Updated
                (route) => false,
              );
            } else {
              Navigator.popUntil(context, (r) => r.isFirst);
            }
          },
        ),
        // Map Button
        IconButton(
          icon: Icon(
            Icons.near_me,
            size: 30,
            color: activeIndex == 1 ? Colors.black : Colors.black45,
          ),
          onPressed: () {
            if (activeIndex != 1)
              Navigator.pushReplacement(
                context,
                _createInstantRoute(const CampusMapScreen()), // Line Updated
              );
          },
        ),
        // Schedule Button
        IconButton(
          icon: Icon(
            Icons.calendar_month,
            size: 30,
            color: activeIndex == 2 ? Colors.black : Colors.black45,
          ),
          onPressed: () {
            if (activeIndex != 2)
              Navigator.pushReplacement(
                context,
                _createInstantRoute(const SchedulePage()), // Line Updated
              );
          },
        ),
        // Profile Button
        IconButton(
          icon: Icon(
            Icons.person_pin,
            size: 30,
            color: activeIndex == 3 ? Colors.black : Colors.black45,
          ),
          onPressed: () {
            if (activeIndex != 3)
              Navigator.pushReplacement(
                context,
                _createInstantRoute(const ProfilePage()), // Line Updated
              );
          },
        ),
      ],
    ),
  );
}
