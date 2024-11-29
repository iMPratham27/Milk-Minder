
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/custom_snackbar.dart';

class AdminSignUpPage extends StatefulWidget {
  const AdminSignUpPage({super.key});

  @override
  State createState() => _AdminSignUpPageState();
}

class _AdminSignUpPageState extends State {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _bankTextEditingController = TextEditingController();
  final TextEditingController _phoneTextEditingController = TextEditingController();
  final TextEditingController _cityTextEditingController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "./assets/signup.jpg",
                    height: 200,
                    width: 200,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), 
                  topRight: Radius.circular(18)
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    offset: Offset(3, -4),
                    color: Color.fromRGBO(0, 0, 0, 0.125),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 114, 114, 114),
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(text: "Create a new Account at "),
                          TextSpan(
                            text: "Milk Minder ",
                            style: TextStyle(
                              fontSize: 21,
                              color: Color.fromARGB(255, 91, 227, 95),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: "😊"),
                        ]
                      )
                    ),
                    const SizedBox(height: 22),
                    
                    _buildTextField("Name", "Enter your full name", _nameTextEditingController, Icons.person),
                    const SizedBox(height: 10),
                    
                    _buildTextField("Email", "Enter your email", _emailTextEditingController, Icons.mail_outline_rounded),
                    const SizedBox(height: 10),

                    _buildPasswordField(),
                    const SizedBox(height: 10),

                    _buildTextField("Bank Account Number", "Enter your bank account number", _bankTextEditingController, Icons.assured_workload),
                    const SizedBox(height: 10),
                    
                    _buildTextField("Phone Number", "Enter your phone number", _phoneTextEditingController, Icons.phone),
                    const SizedBox(height: 10),

                    _buildTextField("City", "Enter your city", _cityTextEditingController, Icons.location_city),
                    const SizedBox(height: 18),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_isInputValid()) {
                              await _registerUser();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color.fromARGB(255, 55, 112, 235),
                            ),
                            child: Center(
                              child: Text(
                                "Sign up",
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isInputValid() {
    return _emailTextEditingController.text.trim().isNotEmpty &&
           _passwordTextEditingController.text.trim().isNotEmpty &&
           _nameTextEditingController.text.trim().isNotEmpty &&
           _bankTextEditingController.text.trim().isNotEmpty &&
           _phoneTextEditingController.text.trim().isNotEmpty &&
           _cityTextEditingController.text.trim().isNotEmpty;
  }

  Future<void> _registerUser() async {
    try {
      // Create user with email and password in Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
      );

      // Retrieve the user ID from Firebase Authentication
      String userId = userCredential.user?.uid ?? '';

      // Store additional user data in Firestore under "users" collection
      await _firestore.collection('admin').doc(userId).set({
        'name': _nameTextEditingController.text.trim(),
        'email': _emailTextEditingController.text.trim(),
        'bankAccountNumber': _bankTextEditingController.text.trim(),
        'phoneNumber': _phoneTextEditingController.text.trim(),
        'city': _cityTextEditingController.text.trim(),
        'userId': userId,
      });

      CustomSnackbar.showCustomSnackbar(
        message: "User Registered Successfully",
        context: context,
      );

      Navigator.of(context).pop();  // Navigate back after successful registration
    } on FirebaseAuthException catch (error) {
      CustomSnackbar.showCustomSnackbar(
        message: error.message ?? "An error occurred during registration",
        context: context,
      );
    }
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: const Color.fromARGB(255, 114, 114, 114),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(icon, color: const Color.fromARGB(255, 114, 114, 114)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: const Color.fromARGB(255, 114, 114, 114),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _passwordTextEditingController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            hintText: "Enter your password",
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                color: const Color.fromARGB(255, 114, 114, 114),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
