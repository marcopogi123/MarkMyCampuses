import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../widgets/nav_bar.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});
  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen>
    with TickerProviderStateMixin {
  bool _isPanelVisible = false;
  bool _showHintOverlay = false;
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();

  String _selectedBuilding = "Select Building";
  String _selectedFloor = "Select Floor";
  String _selectedRoom = "Select Room Number";

  String? _startPoint = "Entrance";
  String? _highlightedBuilding;
  String? _navigationTarget;

  final Map<String, List<double>> buildingCoords = {
    "Entrance": [0.40, 0.93, 0.05, 0.05],
    "Building 1": [0.63, 0.38, 0.18, 0.05],
    "Building 2": [0.32, 0.22, 0.06, 0.13],
    "Building 3": [0.32, 0.05, 0.08, 0.17],
    "Building 4": [0.25, 0.30, 0.06, 0.06],
    "Building 5": [0.10, 0.52, 0.07, 0.31],
    "Building 6": [0.45, 0.73, 0.06, 0.21],
    "Building 8": [0.42, 0.22, 0.06, 0.12],
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
    final List<String> results = [];
    campusData.forEach((bldg, bldgData) {
      Map floors = bldgData["floors"];
      floors.forEach((floor, rooms) {
        (rooms as Map).forEach((roomName, hint) {
          if (roomName.toLowerCase().contains(query.toLowerCase())) {
            results.add("$roomName ($bldg - $floor)");
          }
        });
      });
    });
    setState(() => _filteredResults = results);
  }

  String _getLocationHint() {
    try {
      if (campusData.containsKey(_selectedBuilding)) {
        var floors = campusData[_selectedBuilding]["floors"];
        if (floors.containsKey(_selectedFloor)) {
          return floors[_selectedFloor][_selectedRoom] ?? "No hint available.";
        }
      }
    } catch (e) {
      return "";
    }
    return "";
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
      _selectedFloor = campusData[name]["floors"].keys.first;
      _selectedRoom = campusData[name]["floors"][_selectedFloor].keys.first;
      _isPanelVisible = true;
      _startPoint = "Entrance";
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
    _transformationController.value = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale);
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
        _startPoint = _startPoint ?? "Entrance";
        FocusScope.of(context).unfocus();
      });
      _animateTo(
        (coords[0] + (coords[2] / 2)) * 400,
        (coords[1] + (coords[3] / 2)) * 600,
      );
    }
  }

  void _clearNavigation() {
    setState(() {
      _navigationTarget = null;
      _highlightedBuilding = null;
      _startPoint = null;
      _searchController.clear();
      _selectedBuilding = "Select Building";
      _transformationController.value = Matrix4.identity();
      _showHintOverlay = false;
    });
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
                      suffixIcon:
                          _searchController.text.isNotEmpty ||
                              _navigationTarget != null
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                              ),
                              onPressed: _clearNavigation,
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

            if (_selectedBuilding != "Select Building")
              Positioned(
                top: 175,
                right: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _showHintOverlay = !_showHintOverlay),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD633),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Icon(
                          _showHintOverlay ? Icons.close : Icons.info_outline,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (_showHintOverlay)
                      Container(
                        width: 220,
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BUILDING HINT",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              campusData[_selectedBuilding]["bldgHint"] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                            const Divider(height: 20),
                            Text(
                              "ROOM HINT",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getLocationHint(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            if (_isPanelVisible) _buildSearchPanel(),

            if (_navigationTarget != null)
              Positioned(
                bottom: 110,
                right: 25,
                child: SizedBox(
                  height: 38,
                  child: FloatingActionButton.extended(
                    onPressed: _clearNavigation,
                    backgroundColor: Colors.redAccent,
                    elevation: 3,
                    label: const Text(
                      "Clear",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: buildNav(context, 1),
    );
  }

  Widget _buildSearchPanel() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.50,
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
                  Flexible(
                    child: Text(
                      _selectedBuilding == "Select Building"
                          ? "Navigation"
                          : _selectedBuilding,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _filteredResults.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (ctx, idx) => ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: const Icon(
                      Icons.location_on,
                      color: Color(0xFFFFD633),
                    ),
                    title: Text(
                      _filteredResults[idx],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      final String res = _filteredResults[idx];
                      final String bldg = res.split('(')[1].split(' - ')[0];
                      final String floor = res.split(' - ')[1].split(')')[0];
                      final String room = res.split(' (')[0];
                      setState(() {
                        _selectedBuilding = (bldg == "Other Areas")
                            ? room
                            : bldg;
                        _selectedFloor = floor;
                        _selectedRoom = room;
                        _searchController.text = room;
                        _highlightedBuilding = _selectedBuilding;
                        _filteredResults = [];
                        _startPoint = "Entrance";
                      });
                    },
                  ),
                ),
              ),
            _buildDetailRow(
              Icons.my_location,
              "From",
              _startPoint ?? "Select Start",
              () {
                _showOptionPicker([
                  "Entrance",
                  ...buildingCoords.keys.where((k) => k != "Entrance").toList(),
                ], (val) => setState(() => _startPoint = val));
              },
            ),
            _buildDetailRow(
              Icons.apartment,
              "To Building",
              _selectedBuilding,
              () {
                _showOptionPicker(
                  campusData.keys.toList(),
                  (val) => setState(() {
                    _selectedBuilding = val;
                    _selectedFloor = campusData[val]["floors"].keys.first;
                    _selectedRoom =
                        campusData[val]["floors"][_selectedFloor].keys.first;
                  }),
                );
              },
            ),
            _buildDetailRow(Icons.layers, "To Floor", _selectedFloor, () {
              if (campusData.containsKey(_selectedBuilding)) {
                _showOptionPicker(
                  campusData[_selectedBuilding]["floors"].keys.toList(),
                  (val) => setState(() {
                    _selectedFloor = val;
                    _selectedRoom =
                        campusData[_selectedBuilding]["floors"][val].keys.first;
                  }),
                );
              }
            }),
            _buildDetailRow(Icons.meeting_room, "To Room", _selectedRoom, () {
              if (campusData.containsKey(_selectedBuilding)) {
                _showOptionPicker(
                  campusData[_selectedBuilding]["floors"][_selectedFloor].keys
                      .toList(),
                  (val) => setState(() => _selectedRoom = val),
                );
              }
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
      leading: Icon(icon, size: 20, color: Colors.black87),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.keyboard_arrow_down, size: 16),
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
}

class CustomMapPainter extends CustomPainter {
  final String? highlightedBuilding;
  final String? navigationTarget;
  final String? startPoint;
  final Map<String, List<double>> buildingCoords;

  CustomMapPainter({
    this.highlightedBuilding,
    this.navigationTarget,
    this.startPoint,
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

    if (buildingCoords.containsKey("Entrance")) {
      var ent = buildingCoords["Entrance"]!;
      Offset entPos = Offset(
        (ent[0] + ent[2] / 2) * size.width,
        (ent[1] + ent[3] / 2) * size.height,
      );
      canvas.drawCircle(entPos, 5, Paint()..color = Colors.green);
      TextPainter(
          text: const TextSpan(
            text: "ENTRANCE",
            style: TextStyle(
              color: Colors.green,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )
        ..layout()
        ..paint(canvas, Offset(entPos.dx - 20, entPos.dy + 10));
    }

    buildingCoords.forEach((name, coords) {
      if (name == "Entrance") return;
      final Rect r = Rect.fromLTWH(
        coords[0] * size.width,
        coords[1] * size.height,
        coords[2] * size.width,
        coords[3] * size.height,
      );
      canvas.drawRect(r, (name == highlightedBuilding) ? active : fill);
      canvas.drawRect(r, border);
    });

    if (startPoint != null && buildingCoords.containsKey(startPoint!)) {
      var origin = buildingCoords[startPoint!]!;
      Offset currentPos = Offset(
        (origin[0] + origin[2] / 2) * size.width,
        (origin[1] + origin[3] / 2) * size.height,
      );
      canvas.drawCircle(
        currentPos,
        10,
        Paint()..color = Colors.blue.withOpacity(0.3),
      );
      canvas.drawCircle(currentPos, 6, Paint()..color = Colors.blue);
      canvas.drawCircle(currentPos, 2, Paint()..color = Colors.white);
    }

    if (navigationTarget != null &&
        buildingCoords.containsKey(navigationTarget!) &&
        startPoint != null &&
        buildingCoords.containsKey(startPoint!)) {
      var originData = buildingCoords[startPoint!]!;
      var targetData = buildingCoords[navigationTarget!]!;
      Offset start = Offset(
        (originData[0] + originData[2] / 2) * size.width,
        (originData[1] + originData[3] / 2) * size.height,
      );
      Offset end = Offset(
        (targetData[0] + targetData[2] / 2) * size.width,
        (targetData[1] + targetData[3] / 2) * size.height,
      );

      Path path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx, end.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(end, 6, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(CustomMapPainter old) => true;
}
