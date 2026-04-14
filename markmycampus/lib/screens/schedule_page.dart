import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../data/campus_data.dart';
import '../widgets/nav_bar.dart';
import 'set_schedule_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDay = DateTime.now();

  bool _isOngoing(Map<String, dynamic> schedule) {
    final now = DateTime.now();
    final format = DateFormat('h:mm a');
    try {
      DateTime start = format.parse(schedule['from']),
          end = format.parse(schedule['to']);
      DateTime current = format.parse(format.format(now));
      bool sameDay = schedule['date'] == DateFormat('yyyy-MM-dd').format(now);
      return sameDay && current.isAfter(start) && current.isBefore(end);
    } catch (e) {
      return false;
    }
  }

  void _confirmDelete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Delete Schedule?"),
          content: Text("Are you sure you want to remove ${item['subject']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  globalSchedules.remove(item);
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item['subject']} deleted successfully."),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(20),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String filterKey = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final dailySchedules = globalSchedules
        .where((s) => s['date'] == filterKey)
        .toList();
    final ongoing = dailySchedules.where((s) => _isOngoing(s)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello $globalUserName,",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    backgroundImage: (globalProfileImage != null)
                        ? FileImage(globalProfileImage!)
                        : null,
                    child: (globalProfileImage == null)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 14,
                itemBuilder: (ctx, i) {
                  DateTime date = DateTime.now().add(Duration(days: i));
                  bool isSelected =
                      DateFormat('dd').format(date) ==
                      DateFormat('dd').format(_selectedDay);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = date),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFD633)
                            : const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            DateFormat('dd').format(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Happening now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ongoing.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD633),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Text(
                              "No active class.",
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : _buildOngoingNowCard(ongoing.first),
                    const SizedBox(height: 30),
                    const Text(
                      "Classes for the day",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    dailySchedules.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("No classes scheduled."),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dailySchedules.length,
                            itemBuilder: (c, i) =>
                                _buildScheduleTile(dailySchedules[i]),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SetSchedulePage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD633),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Set Schedule",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildNav(context, 2),
    );
  }

  Widget _buildOngoingNowCard(Map<String, dynamic> item) => Container(
    padding: const EdgeInsets.all(20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ONGOING NOW",
          style: TextStyle(
            color: Color(0xFFFFD633),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          item['subject'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(item['location'], style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );

  Widget _buildScheduleTile(Map<String, dynamic> item) {
    Color cardColor = item['color'] ?? const Color(0xFFF2F4F7);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            Container(width: 8, height: 70, color: cardColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['subject'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${item['from']} - ${item['to']} • ${item['location']}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(item),
            ),
          ],
        ),
      ),
    );
  }
}
