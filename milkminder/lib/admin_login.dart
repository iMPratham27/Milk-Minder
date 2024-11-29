
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/admin_signup.dart';
import 'package:milkminder/custom_snackbar.dart';
import 'package:milkminder/home_screen_admin.dart';



class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo Section
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "./assets/MilkMinderLogo1.png",
                    height: 140,
                    width: 140,
                  ),
                ],
              ),
            ),

            // Login Title
            Text(
              "Login",
              style: GoogleFonts.roboto(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 2),

            // Subtitle
            RichText(
              text: TextSpan(
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 114, 114, 114),
                  fontWeight: FontWeight.w500,
                ),
                children: const [
                  TextSpan(text: "Let's Login to "),
                  TextSpan(
                    text: "Milk Minder ",
                    style: TextStyle(
                      fontSize: 21,
                      color: Color.fromARGB(255, 91, 227, 95),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "😊"),
                ],
              ),
            ),

            // Login Illustration
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                "./assets/Mobile login via phone device.png",
                height: 260,
                width: 190,
              ),
            ]),

            // Form Fields
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  Text(
                    "Email",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 114, 114, 114),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      suffixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: Color.fromARGB(255, 114, 114, 114),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),

                  // Password Field
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
                          _showPassword = !_showPassword;
                          setState(() {});
                        },
                        child: Icon(
                          (_showPassword)
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 114, 114, 114),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Login Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_emailTextEditingController.text.trim().isNotEmpty &&
                              _passwordTextEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                            try {
                              // Authenticate the user
                              UserCredential userCredential = await _firebaseAuth
                                  .signInWithEmailAndPassword(
                                email: _emailTextEditingController.text,
                                password: _passwordTextEditingController.text,
                              );

                              // Retrieve the user's email
                              String? loggedInUserEmail =
                                  userCredential.user?.email;

                              // Navigate to HomeScreen and pass the email
                              if (loggedInUserEmail != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      // return HomeScreen(
                                      //     userEmail: loggedInUserEmail);
                                      return AdminHomeScreen(userEmail: loggedInUserEmail);
                                    },
                                  ),
                                );
                              } else {
                                CustomSnackbar.showCustomSnackbar(
                                  message: "Error retrieving user email",
                                  context: context,
                                );
                              }
                            } on FirebaseAuthException catch (error) {
                              // Show error message
                              CustomSnackbar.showCustomSnackbar(
                                message: error.code,
                                context: context,
                              );
                            }
                          } else {
                            CustomSnackbar.showCustomSnackbar(
                              message: "Please enter email and password",
                              context: context,
                            );
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
                              "Login",
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
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Sign Up Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 114, 114, 114),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const AdminSignUpPage();
                      }),
                    );
                  },
                  child: Text(
                    " Sign up",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: const Color.fromRGBO(249, 136, 102, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
