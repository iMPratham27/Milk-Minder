

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/admin_login.dart';
import 'package:milkminder/login.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  State createState() => _UserAdminState();
}

class _UserAdminState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "./assets/MilkMinderLogo1.png",
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 20),

              // Title Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to MilkMinder",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select your role to proceed",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Role Selection Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoleCard(
                    label: "User",
                    description: "Farmer",
                    imagePath: "./assets/user icon.png",
                    backgroundColor: const Color(0xFF62B6CB),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }),
                      );
                    },
                  ),
                  _buildRoleCard(
                    label: "Admin",
                    description: "Collector",
                    imagePath: "./assets/Data dashboard.png",
                    backgroundColor: const Color(0xFF80ED99),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const AdminLoginPage();
                        }),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Illustration
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  "./assets/Dm22X5QeFw6j8Eq6L8.gif",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Footer
              Text(
                "Making Milk Collection Simple and Digital",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Role Card
  Widget _buildRoleCard({
    required String label,
    required String description,
    required String imagePath,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),

            // Label
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Description
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




