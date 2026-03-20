import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/campus_data.dart';

class SetSchedulePage extends StatefulWidget {
  const SetSchedulePage({super.key});
  @override
  State<SetSchedulePage> createState() => _SetSchedulePageState();
}

class _SetSchedulePageState extends State<SetSchedulePage> {
  List<DateTime> selectedDates = [];
  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay toTime = const TimeOfDay(hour: 11, minute: 30);
  String? _selectedLocation;
  Color _selectedColor = const Color(0xFF4A90E2);

  final TextEditingController _sub = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  final List<String> _tipLocations = campusData.keys.toList();

  final List<Color> _colorOptions = [
    const Color(0xFF4A90E2),
    const Color(0xFFE94E77),
    const Color(0xFF50E3C2),
    const Color(0xFFF5A623),
    const Color(0xFF9013FE),
    const Color(0xFF7ED321),
  ];

  Future<void> _pickTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isFrom ? fromTime : toTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFFD633),
            onPrimary: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null)
      setState(() => isFrom ? fromTime = picked : toTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Schedule",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              _buildSectionHeader("Course Details"),
              _buildCustomTextField(
                controller: _sub,
                hint: "Subject Name",
                icon: Icons.book_outlined,
              ),
              const SizedBox(height: 20),
              _buildSectionHeader("Schedule"),
              _buildClickableTile(
                onTap: () async {
                  final List<DateTime>? results = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    builder: (context) =>
                        _CalendarPicker(initialDates: selectedDates),
                  );
                  if (results != null) setState(() => selectedDates = results);
                },
                icon: Icons.calendar_today_rounded,
                title: "Dates",
                subtitle: selectedDates.isEmpty
                    ? "Select dates"
                    : "${selectedDates.length} selected",
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildClickableTile(
                      onTap: () => _pickTime(context, true),
                      icon: Icons.access_time_filled,
                      title: "Start",
                      subtitle: fromTime.format(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildClickableTile(
                      onTap: () => _pickTime(context, false),
                      icon: Icons.access_time,
                      title: "End",
                      subtitle: toTime.format(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionHeader("Location"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLocation,
                    isExpanded: true,
                    hint: const Text(
                      "Select Building",
                      style: TextStyle(fontSize: 14),
                    ),
                    items: _tipLocations
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedLocation = val),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildCustomTextField(
                controller: _notes,
                hint: "Room / Lab Number",
                icon: Icons.meeting_room_outlined,
              ),
              const SizedBox(height: 20),
              _buildSectionHeader("Category Color"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _colorOptions
                    .map(
                      (color) => GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                          child: _selectedColor == color
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
        child: ElevatedButton(
          onPressed: () {
            if (_sub.text.isNotEmpty &&
                _selectedLocation != null &&
                selectedDates.isNotEmpty) {
              for (var date in selectedDates) {
                globalSchedules.add({
                  'subject': _sub.text,
                  'from': fromTime.format(context),
                  'to': toTime.format(context),
                  'date': DateFormat('yyyy-MM-dd').format(date),
                  'location': _selectedLocation,
                  'notes': _notes.text,
                  'color': _selectedColor,
                });
              }
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD633),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Text(
            "Save Schedule",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    ),
  );
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54, size: 20),
        border: InputBorder.none,
      ),
    ),
  );
  Widget _buildClickableTile({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFD633), size: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ),
  );
}

class _CalendarPicker extends StatefulWidget {
  final List<DateTime> initialDates;
  const _CalendarPicker({required this.initialDates});
  @override
  State<_CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<_CalendarPicker> {
  late List<DateTime> tempDates;
  @override
  void initState() {
    super.initState();
    tempDates = List.from(widget.initialDates);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Text(
            "Select Class Dates",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              onDateChanged: (date) {
                setState(() {
                  bool exists = tempDates.any(
                    (d) =>
                        d.year == date.year &&
                        d.month == date.month &&
                        d.day == date.day,
                  );
                  if (exists) {
                    tempDates.removeWhere(
                      (d) =>
                          d.year == date.year &&
                          d.month == date.month &&
                          d.day == date.day,
                    );
                  } else {
                    tempDates.add(date);
                  }
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tempDates),
            child: const Text("Confirm Selection"),
          ),
        ],
      ),
    );
  }
}
