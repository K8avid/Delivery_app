import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour la sélection de date

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  DateTime? _selectedDate;

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stepper Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Stepper(
                  margin: const EdgeInsets.only(top: 20),
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _nextStep,
                  onStepCancel: _previousStep,
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: details.onStepCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Previous"),
                          ),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_currentStep < 2 ? "Next" : "Submit"),
                        ),
                      ],
                    );
                  },
                  steps: [
                    // Step 1: Personal Details
                    Step(
                      title: const Text(
                        "Personal Details",
                        style: TextStyle(fontSize: 18),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          _buildCustomInputField(
                            controller: _firstNameController,
                            hintText: "Enter your first name",
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "First name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCustomInputField(
                            controller: _lastNameController,
                            hintText: "Enter your last name",
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Last name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCustomInputField(
                            controller: _emailController,
                            hintText: "Enter your email address",
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                      .hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Step 2: Account Details
                    Step(
                      title: const Text(
                        "Account Details",
                        style: TextStyle(fontSize: 18),
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                      content: Column(
                        children: [
                          _buildCustomInputField(
                            controller: _passwordController,
                            hintText: "Enter your password",
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCustomInputField(
                            controller: _phoneNumberController,
                            hintText: "Enter your phone number",
                            icon: Icons.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCustomInputField(
                            controller: _addressController,
                            hintText: "Enter your address",
                            icon: Icons.location_on,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Address is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedDate == null
                                        ? "Select your birthday"
                                        : DateFormat.yMMMd()
                                            .format(_selectedDate!),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today,
                                      color: Colors.blue),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Step 3: Confirmation
                    Step(
                      title: const Text(
                        "Confirmation",
                        style: TextStyle(fontSize: 18),
                      ),
                      isActive: _currentStep >= 2,
                      state: StepState.indexed,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Please confirm your details:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow("First Name", _firstNameController.text),
                          _buildSummaryRow("Last Name", _lastNameController.text),
                          _buildSummaryRow("Email", _emailController.text),
                          _buildSummaryRow(
                            "Birthday",
                            _selectedDate == null
                                ? "Not provided"
                                : DateFormat.yMMMd().format(_selectedDate!),
                          ),
                          _buildSummaryRow(
                              "Phone", _phoneNumberController.text),
                          _buildSummaryRow("Address", _addressController.text),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.isEmpty ? "Not provided" : value),
        ],
      ),
    );
  }
}
