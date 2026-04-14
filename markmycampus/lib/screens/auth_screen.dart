import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import 'campus_map_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = globalUserName != "User" && globalUserName != "Guest";
  bool _obscurePassword = true;

  String? _selectedProgram;
  String? _selectedYear;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _passController.addListener(() => setState(() {}));
  }

  bool get _isValid {
    if (_isLoginMode) {
      return _passController.text.isNotEmpty;
    } else {
      bool baseFields =
          _nameController.text.isNotEmpty &&
          _passController.text.isNotEmpty &&
          _selectedProgram != null;

      if (_selectedProgram == "Senior High School") {
        return baseFields;
      } else {
        return baseFields && _selectedYear != null;
      }
    }
  }

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

  void _showFeedback(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submit() {
    if (_isLoginMode) {
      if (_passController.text == globalPassword) {
        _showFeedback("Login successful! Welcome back, $globalUserName.");
        _navigateToMap();
      } else {
        _showFeedback("Incorrect password, Please try again.", isError: true);
      }
    } else {
      if (_nameController.text.isNotEmpty && _passController.text.isNotEmpty) {
        globalUserName = _nameController.text;
        globalPassword = _passController.text;
        if (_selectedProgram != null) globalUserProgram = _selectedProgram!;
        globalYearLevel = _selectedYear ?? "N/A";

        _showFeedback("Registration successful! Account created.");
        _navigateToMap();
      }
    }
  }

  void _navigateToMap() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const CampusMapScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          _isLoginMode ? 'Welcome Back' : 'Register',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isLoginMode
                              ? 'Enter password for $globalUserName'
                              : 'Create your account to start.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 40),

                        if (!_isLoginMode) ...[
                          _buildTextField(
                            _nameController,
                            'Name',
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            _selectedProgram,
                            'Choose program',
                            _programs,
                            (v) => setState(() {
                              _selectedProgram = v;
                              if (v == "Senior High School")
                                _selectedYear = null;
                            }),
                          ),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            _selectedYear,
                            _selectedProgram == "Senior High School"
                                ? 'Year level (Optional for SHS)'
                                : 'Choose year level',
                            _years,
                            (v) => setState(() => _selectedYear = v),
                          ),
                          const SizedBox(height: 15),
                        ],

                        TextField(
                          controller: _passController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF4F5F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isValid ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD633),
                              disabledBackgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              _isLoginMode ? 'Login' : 'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isValid ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: () => setState(() {
                            _isLoginMode = !_isLoginMode;
                            _passController.clear();
                          }),
                          child: Text(
                            _isLoginMode
                                ? "New here? Register account"
                                : "Already have an account? Login",
                            style: const TextStyle(
                              color: Color(0xFF2D3142),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Pushes the anonymous button to the bottom
                        const Spacer(),

                        if (!_isLoginMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 20),
                            child: GestureDetector(
                              onTap: () {
                                globalUserName = "Guest";
                                _showFeedback("Entering as Guest...");
                                _navigateToMap();
                              },
                              child: const Text(
                                'Enter as anonymous? Click here',
                                style: TextStyle(
                                  color: Color(0xFF9BA2AE),
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF4F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (val) {
            onChanged(val);
            setState(() {});
          },
        ),
      ),
    );
  }
}
