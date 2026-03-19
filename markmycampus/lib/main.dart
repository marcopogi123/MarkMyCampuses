import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

List<Map<String, dynamic>> globalSchedules = [];
String globalUserName = "User";
String globalUserProgram = "Program";
String globalYearLevel = "Year";
File? globalProfileImage;

final Map<String, Map<String, List<String>>> campusData = {
  "Building 1": {
    "1st Floor": ["Seminar Room A", "Seminar Room B", "Alumni", "Telering"],
    "2nd Floor": ["AVR"],
    "3rd Floor": ["AVR", "Library"],
  },
  "Building 2": {
    "1st Floor": ["SAO", "Mechanical engineering department"],
    "2nd Floor": [
      "College of business education department",
      "Environmental and sanitary engineering department",
    ],
    "3rd Floor": ["Architecture department"],
  },
  "Building 3": {
    "1st Floor": ["No listed rooms"],
    "2nd Floor": ["No listed rooms"],
    "3rd Floor": ["No listed rooms"],
    "4th Floor": ["No listed rooms"],
    "5th Floor": ["No listed rooms"],
  },
  "Building 5": {
    "1st Floor": ["Canteen"],
    "2nd Floor": [
      "ITSO",
      "Room 5201",
      "Room 5202",
      "Room 5203",
      "Room 5204",
      "Room 5205",
      "Room 5206",
      "Room 5207",
      "Room 5208",
      "Room 5209",
      "Room 5210",
      "Room 5211",
      "Room 5212",
      "Room 5213",
      "Room 5214",
      "Room 5215",
      "Comfort Room",
      "College of computer studies department",
    ],
    "3rd Floor": [
      "Room 5301",
      "Room 5302",
      "Room 5303",
      "Room 5304",
      "Room 5305",
      "Room 5306",
      "Room 5307",
      "Room 5308",
      "Room 5309",
      "Room 5310",
      "Room 5311",
      "Room 5312",
      "Room 5313",
      "Room 5314",
      "Room 5315",
      "Comfort Room",
      "Electrical engineering department",
      "Electronics engineering department",
    ],
    "4th Floor": [
      "Room 5401",
      "Room 5402",
      "Room 5403",
      "Room 5404",
      "Room 5405",
      "Room 5406",
      "Room 5407",
      "Room 5408",
      "Room 5409",
      "Room 5410",
      "Room 5411",
      "Room 5412",
      "Room 5413",
      "Room 5414",
      "Room 5415",
      "Comfort Room",
      "Industrial engineering department",
      "Computer engineering department",
    ],
  },
  "Building 6": {
    "1st Floor": ["Clinic", "Prayer Room"],
    "2nd Floor": ["No listed rooms"],
    "3rd Floor": ["No listed rooms"],
    "4th Floor": ["No listed rooms"],
  },
  "Building 8": {
    "2nd Floor": ["Library"],
    "3rd Floor": ["Library"],
  },
  "Building 9": {
    "1st Floor": [
      "Seminar Room 9",
      "College of Arts department",
      "Comfort Room",
      "Senior high school department",
    ],
    "2nd Floor": [
      "Room 9201",
      "Room 9202",
      "Room 9203",
      "Room 9204",
      "Room 9205",
      "Room 9206",
      "Room 9207",
      "Room 9208",
      "Room 9209",
      "Comfort Room",
      "Math and physics department",
    ],
    "3rd Floor": [
      "Room 9301",
      "Room 9302",
      "Room 9303",
      "Room 9304",
      "Room 9305",
      "Room 9306",
      "Room 9307",
      "Room 9308",
      "Room 9309",
      "Comfort Room",
      "College of education department",
    ],
    "4th Floor": [
      "Room 9401",
      "Room 9402",
      "Room 9403",
      "Room 9404",
      "Room 9405",
      "Room 9406",
      "Room 9407",
      "Room 9408",
      "Room 9409",
      "Comfort Room",
    ],
    "5th Floor": [
      "Room 9501",
      "Room 9502",
      "Room 9503",
      "Room 9504",
      "Room 9505",
      "Room 9506",
      "Room 9507",
      "Room 9508",
      "Room 9509",
      "Comfort Room",
    ],
  },
  "Technocore": {
    "1st Floor": ["No listed rooms"],
    "2nd Floor": ["No listed rooms"],
    "3rd Floor": ["No listed rooms"],
    "4th Floor": ["No listed rooms"],
    "5th Floor": ["No listed rooms"],
  },
  "Other Areas": {
    "Ground": [
      "Entrance",
      "PE Center 1",
      "PE Center 2",
      "Innovation Hall",
      "Congregating Area",
      "Garden",
      "Anniversary Hall",
      "Parking Area",
      "Study Hall",
      "Seminar Room A&B",
      "PE Hall 1",
      "PE Hall 2",
    ],
  },
};

void main() {
  runApp(
    const MaterialApp(
      home: MySplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

// --- SCREEN: SPLASH SCREEN ---
class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with TickerProviderStateMixin {
  bool _isWhitePhase = false;
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoController.forward();
    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _isWhitePhase = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isWhitePhase ? Colors.white : Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset('assets/logo.png', width: 140),
          ),
        ),
      ),
    );
  }
}

// --- SCREEN: ONBOARDING SCREEN ---
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _data = [
    {
      "title": "Are you lost?",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding1.png",
    },
    {
      "title": "Navigate with ease",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding2.png",
    },
    {
      "title": "Find your way around",
      "desc":
          "This learning app is designed to help locate your rooms, buildings and labs.",
      "image": "assets/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _data.length,
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.asset(
                      _data[index]["image"]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    _data[index]["title"]!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 20,
                    ),
                    child: Text(
                      _data[index]["desc"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 60),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _data.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFFFD54F)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _data.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const MarkMyCampusScreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutQuart,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _currentPage == _data.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN 1: LANDING ---
class MarkMyCampusScreen extends StatelessWidget {
  const MarkMyCampusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Center(child: Image.asset('logo.png', fit: BoxFit.fill)),
              ),
              const Text(
                'MarkMyCampus',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Locate your room, labs and buildings with ease in \nTIP Quezon City.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4F5D75),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const AuthScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD633),
                    foregroundColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SCREEN: REGISTER (AuthScreen) ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? _selectedProgram;
  String? _selectedYear;
  final TextEditingController _nameController = TextEditingController();
  final List<String> _programs = [
    "BSIT",
    "BSIS",
    "BSDSA",
    "BSCS",
    "BSCPE",
    "BSECE",
    "BSCE",
    "BSARCH",
    "BSIE",
    "BSA",
    "BSBA",
    "BSAIS",
    "BSME",
    "BSEE",
    "BSESE",
    "BSED",
    "BAEL",
    "BAPS",
    "Senior High School",
  ];
  final List<String> _years = [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
    "5th Year",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: const Color(0xFFF4F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                _selectedProgram,
                'Choose your program',
                _programs,
                (val) => setState(() => _selectedProgram = val),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                _selectedYear,
                'Choose your year level',
                _years,
                (val) => setState(() => _selectedYear = val),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 220,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty)
                      globalUserName = _nameController.text;
                    if (_selectedProgram != null)
                      globalUserProgram = _selectedProgram!;
                    if (_selectedYear != null) globalYearLevel = _selectedYear!;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const CampusMapScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD633),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  globalUserName = "Guest";

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (c) => const CampusMapScreen()),
                  );
                },
                child: const Text(
                  'Enter as anonymous? Click here',
                  style: TextStyle(color: Color(0xFF9BA2AE)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String? value,
    String hint,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// --- SCREEN 2: INTERACTIVE MAP & SEARCH ---
class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});
  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen>
    with TickerProviderStateMixin {
  bool _isPanelVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();

  String _selectedBuilding = "Select Building";
  String _selectedFloor = "Select Floor";
  String _selectedRoom = "Select Room Number";

  // Directions state
  String _startPoint = "Entrance";
  String? _highlightedBuilding;
  String? _navigationTarget;

  final Map<String, List<double>> buildingCoords = {
    "Entrance": [0.40, 0.93, 0.05, 0.05],
    "Building 1": [0.63, 0.38, 0.18, 0.05],
    "Building 2": [0.32, 0.22, 0.06, 0.13],
    "Building 3": [0.32, 0.05, 0.08, 0.17],
    "Building 4": [0.27, 0.30, 0.04, 0.06],
    "Building 5": [0.10, 0.52, 0.07, 0.31],
    "Building 6": [0.45, 0.73, 0.06, 0.21],
    "Building 8": [0.42, 0.22, 0.06, 0.1],
    "Building 9": [0.17, 0.68, 0.27, 0.07],
    "Technocore": [0.10, 0.38, 0.10, 0.14],
    "Congregating Area": [0.22, 0.35, 0.18, 0.09],
    "Study Hall": [0.40, 0.36, 0.12, 0.07],
    "Seminar Room A&B": [0.52, 0.37, 0.11, 0.06],
    "Garden": [0.21, 0.48, 0.23, 0.06],
    "Anniversary Hall": [0.20, 0.54, 0.24, 0.12],
    "PE Center 1": [0.52, 0.52, 0.12, 0.14],
    "PE Center 2": [0.64, 0.65, 0.22, 0.08],
    "Seminar Room 9": [0.38, 0.68, 0.06, 0.03],
    "Parking Area": [0.64, 0.44, 0.22, 0.20],
    "PE Hall 1": [0.53, 0.46, 0.11, 0.06],
    "PE Hall 2": [0.53, 0.66, 0.11, 0.06],
  };

  List<String> _filteredResults = [];

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() => _filteredResults = []);
      return;
    }

    List<String> results = [];
    campusData.forEach((bldg, floors) {
      floors.forEach((floor, rooms) {
        for (var room in rooms) {
          if (room.toLowerCase().contains(query.toLowerCase())) {
            results.add("$room ($bldg - $floor)");
          }
        }
      });
    });

    setState(() {
      _filteredResults = results;
      _isPanelVisible = true;
    });
  }

  void _onBuildingClick(
    String name,
    double x,
    double y,
    double w,
    double h,
    BoxConstraints constraints,
  ) {
    if (name == "Entrance") return;
    setState(() {
      _selectedBuilding = name;
      _highlightedBuilding = name;
      _searchController.text = name;
      _selectedFloor = campusData[name]?.keys.first ?? "Select Floor";
      _selectedRoom = campusData[name]?[_selectedFloor]?.first ?? "Select Room";
    });
    _animateTo(
      (x + (w / 2)) * constraints.maxWidth,
      (y + (h / 2)) * constraints.maxHeight,
    );
  }

  void _animateTo(double x, double y) {
    const double scale = 2.5;
    final double tx = -x * scale + (MediaQuery.of(context).size.width / 2);
    final double ty = -y * scale + (MediaQuery.of(context).size.height / 3);
    final Matrix4 newMatrix = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale);

    _transformationController.value = newMatrix;
  }

  void _onShowDirections() {
    String target = (buildingCoords.containsKey(_selectedRoom))
        ? _selectedRoom
        : _selectedBuilding;

    if (buildingCoords.containsKey(target)) {
      var coords = buildingCoords[target]!;
      setState(() {
        _highlightedBuilding = target;
        _navigationTarget = target;
        _isPanelVisible = false;
      });
      _animateTo(
        (coords[0] + (coords[2] / 2)) * 400,
        (coords[1] + (coords[3] / 2)) * 600,
      );
    }
  }

  Widget _buildInteractiveZone(
    String name,
    double x,
    double y,
    double w,
    double h,
    BoxConstraints constraints,
  ) {
    return Positioned(
      left: x * constraints.maxWidth,
      top: y * constraints.maxHeight,
      child: GestureDetector(
        onTap: () => _onBuildingClick(name, x, y, w, h, constraints),
        child: Container(
          width: w * constraints.maxWidth,
          height: h * constraints.maxHeight,
          color: Colors.transparent,
          child: Center(
            child: Text(
              name == "Entrance" ? "" : name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 40, 25, 10),
                  child: Text(
                    'TIP Quezon City',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onTap: () => setState(() => _isPanelVisible = true),
                    decoration: InputDecoration(
                      hintText: 'Search building or room...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged("");
                                setState(() {
                                  _selectedBuilding = "Select Building";
                                  _highlightedBuilding = null;
                                  _navigationTarget = null;
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF0F0F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        return InteractiveViewer(
                          transformationController: _transformationController,
                          boundaryMargin: const EdgeInsets.all(100),
                          minScale: 1.0,
                          maxScale: 10.0,
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                                painter: CustomMapPainter(
                                  highlightedBuilding: _highlightedBuilding,
                                  navigationTarget: _navigationTarget,
                                  startPoint: _startPoint,
                                  buildingCoords: buildingCoords,
                                ),
                              ),
                              ...buildingCoords.entries.map(
                                (e) => _buildInteractiveZone(
                                  e.key,
                                  e.value[0],
                                  e.value[1],
                                  e.value[2],
                                  e.value[3],
                                  constraints,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
            if (_isPanelVisible) _buildSearchPanel(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNav(context, 1),
    );
  }

  Widget _buildSearchPanel() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBuilding == "Select Building"
                        ? "Navigation"
                        : _selectedBuilding,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _isPanelVisible = false;
                      _filteredResults = [];
                    }),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (_filteredResults.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _filteredResults.length,
                  itemBuilder: (ctx, idx) => ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Color(0xFFFFD633),
                    ),
                    title: Text(_filteredResults[idx]),
                    onTap: () {
                      String res = _filteredResults[idx];
                      String bldg = res.split('(')[1].split(' - ')[0];
                      String floor = res.split(' - ')[1].split(')')[0];
                      String room = res.split(' (')[0];

                      setState(() {
                        if (bldg == "Other Areas") {
                          _selectedBuilding = room;
                        } else {
                          _selectedBuilding = bldg;
                        }
                        _selectedFloor = floor;
                        _selectedRoom = room;
                        _searchController.text = room;
                        _highlightedBuilding = _selectedBuilding;
                        _filteredResults = [];
                      });
                    },
                  ),
                ),
              ),
            const Divider(height: 1),
            _buildDetailRow(
              Icons.my_location,
              "Start Point (From)",
              _startPoint,
              () {
                _showOptionPicker([
                  "Entrance",
                  ...buildingCoords.keys.where((k) => k != "Entrance").toList(),
                ], (val) => setState(() => _startPoint = val));
              },
            ),
            _buildDetailRow(
              Icons.apartment,
              "Building Selection (To)",
              _selectedBuilding,
              () {
                _showOptionPicker(
                  campusData.keys.toList(),
                  (val) => setState(() {
                    _selectedBuilding = val;
                    if (campusData[val] != null) {
                      _selectedFloor = campusData[val]!.keys.first;
                      _selectedRoom = campusData[val]![_selectedFloor]!.first;
                    }
                  }),
                );
              },
            ),
            _buildDetailRow(Icons.layers, "Floor (To)", _selectedFloor, () {
              if (campusData.containsKey(_selectedBuilding)) {
                _showOptionPicker(
                  campusData[_selectedBuilding]!.keys.toList(),
                  (val) => setState(() {
                    _selectedFloor = val;
                    _selectedRoom = campusData[_selectedBuilding]![val]!.first;
                  }),
                );
              }
            }),
            _buildDetailRow(
              Icons.meeting_room,
              "Room Number (To)",
              _selectedRoom,
              () {
                if (campusData.containsKey(_selectedBuilding) &&
                    campusData[_selectedBuilding]!.containsKey(
                      _selectedFloor,
                    )) {
                  _showOptionPicker(
                    campusData[_selectedBuilding]![_selectedFloor]!,
                    (val) => setState(() => _selectedRoom = val),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _onShowDirections,
                child: const Text(
                  "Show Directions",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22, color: Colors.black87),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: onTap,
    );
  }

  void _showOptionPicker(List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => ListView(
        shrinkWrap: true,
        children: options
            .map(
              (opt) => ListTile(
                title: Text(opt),
                onTap: () {
                  onSelect(opt);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class CustomMapPainter extends CustomPainter {
  final String? highlightedBuilding;
  final String? navigationTarget;
  final String startPoint;
  final Map<String, List<double>> buildingCoords;

  CustomMapPainter({
    this.highlightedBuilding,
    this.navigationTarget,
    required this.startPoint,
    required this.buildingCoords,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()
      ..color = const Color(0xFFDED9B1)
      ..style = PaintingStyle.fill;
    final Paint active = Paint()
      ..color = const Color(0xFFFFD633)
      ..style = PaintingStyle.fill;
    final Paint border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    buildingCoords.forEach((name, coords) {
      if (name == "Entrance") return;
      final Paint p = (name == highlightedBuilding) ? active : fill;
      final Rect r = Rect.fromLTWH(
        coords[0] * size.width,
        coords[1] * size.height,
        coords[2] * size.width,
        coords[3] * size.height,
      );
      canvas.drawRect(r, p);
      canvas.drawRect(r, border);
    });

    if (navigationTarget != null &&
        buildingCoords.containsKey(navigationTarget) &&
        buildingCoords.containsKey(startPoint)) {
      final Paint pathPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      var originData = buildingCoords[startPoint]!;
      var targetData = buildingCoords[navigationTarget]!;

      Offset start = Offset(
        (originData[0] + originData[2] / 2) * size.width,
        (originData[1] + originData[3] / 2) * size.height,
      );
      Offset end = Offset(
        (targetData[0] + targetData[2] / 2) * size.width,
        (targetData[1] + targetData[3] / 2) * size.height,
      );

      Path path = Path();
      path.moveTo(start.dx, start.dy);
      path.lineTo(start.dx, end.dy);
      path.lineTo(end.dx, end.dy);

      double dashWidth = 10.0, dashSpace = 5.0, distance = 0.0;
      for (var pathMetric in path.computeMetrics()) {
        while (distance < pathMetric.length) {
          canvas.drawPath(
            pathMetric.extractPath(distance, distance + dashWidth),
            pathPaint,
          );
          distance += dashWidth + dashSpace;
        }
      }

      canvas.drawCircle(end, 6, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomMapPainter old) => true;
}

// --- SCREEN 3: SCHEDULE PAGE ---
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
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
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
                        ? const Center(child: Text("No classes scheduled."))
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
                      MaterialPageRoute(
                        builder: (c) => const SetSchedulePage(),
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
      bottomNavigationBar: _buildNav(context, 2),
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
              onPressed: () => setState(() => globalSchedules.remove(item)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 4: SET SCHEDULE PAGE ---
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

// --- SCREEN 5: PROFILE PAGE s ---
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => globalProfileImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedSchedules = List<Map<String, dynamic>>.from(globalSchedules);
    sortedSchedules.sort((a, b) => a['date'].compareTo(b['date']));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              // 1. Reset Global Variables to default
              globalUserName = "User";
              globalUserProgram = "Program";
              globalYearLevel = "Year";
              globalProfileImage = null;
              globalSchedules.clear();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Class Schedule",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "${globalSchedules.length} Classes",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            sortedSchedules.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedSchedules.length,
                    itemBuilder: (context, index) =>
                        _buildScheduleCard(sortedSchedules[index]),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildNav(context, 3),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD633), width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFF2F4F7),
                  backgroundImage: globalProfileImage != null
                      ? FileImage(globalProfileImage!)
                      : null,
                  child: globalProfileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            globalUserName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            "$globalUserProgram • $globalYearLevel",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> s) {
    Color accent = s['color'] ?? Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  s['from'].split(' ')[0],
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                Text(
                  s['from'].split(' ')[1],
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['subject'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${s['from']} - ${s['to']}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      s['location'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('MMM d').format(DateTime.parse(s['date'])),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 50,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          const Text(
            "No classes scheduled yet.",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// --- NAVIGATION  ---
Widget _buildNav(BuildContext context, int activeIndex) {
  return Container(
    height: 90,
    decoration: const BoxDecoration(
      color: Color(0xFFFFD633),
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.home, size: 30),
          onPressed: () {
            if (globalUserName != "User") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => const CampusMapScreen()),
                (route) => false,
              );
            } else {
              Navigator.popUntil(context, (r) => r.isFirst);
            }
          },
        ),
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
                MaterialPageRoute(builder: (c) => const CampusMapScreen()),
              );
          },
        ),
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
                MaterialPageRoute(builder: (c) => const SchedulePage()),
              );
          },
        ),
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
                MaterialPageRoute(builder: (c) => const ProfilePage()),
              );
          },
        ),
      ],
    ),
  );
}
