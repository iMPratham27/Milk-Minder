
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "";
  String _email = "";
  String _phoneNumber = "";
  String _bankAccount = "";
  String _city = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return;

      String userId = user.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('admin').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? "";
          _email = userDoc['email'] ?? "";
          _phoneNumber = userDoc['phoneNumber'] ?? "";
          _bankAccount = userDoc['bankAccountNumber'] ?? "";
          _city = userDoc['city'] ?? "";
        });
      }
    } catch (e) {
      //print("Error fetching user data: $e");
    }
  }

  Future<void> _signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signOut();
      await prefs.clear();
      SessionData.resetSessionData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58,123,213,1),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            './assets/MilkMinderLogo2.png',
            height: 200,
            width: 180,
          ),
        ),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  _name.isNotEmpty ? _name : "Loading...",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
                accountEmail: Text(
                  _email.isNotEmpty ? _email : "Loading...",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("./assets/user-avatar-male-5.png"),
                  backgroundColor: Colors.white,
                ),
                decoration: const BoxDecoration(
                  color:  Color.fromRGBO(58,123,213,1),
                  //borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(58,123,213,1), Color.fromRGBO(58,123,213,1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.black),
                title: Text(
                  'About',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.black),
                title: Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: _email.isNotEmpty ? _email : "Loading...",
                  ),
                  _buildInfoCard(
                    icon: Icons.phone,
                    label: "Phone Number",
                    value: _phoneNumber.isNotEmpty ? "+91-$_phoneNumber" : "Loading...",
                  ),
                  _buildInfoCard(
                    icon: Icons.account_balance,
                    label: "Bank Account",
                    value: _bankAccount.isNotEmpty
                        ? "XXXX XXXX ${_bankAccount.substring(_bankAccount.length - 4)}"
                        : "Loading...",
                  ),
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    label: "City",
                    value: _city.isNotEmpty ? _city : "Loading...",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromRGBO(58,123,213,1), Color.fromRGBO(58,123,213,1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("./assets/user-avatar-male-5.png"),
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 15),
          Text(
            _name.isNotEmpty ? _name : "Loading...",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "User Profile",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: const Color.fromRGBO(58,123,213,1),),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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



class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: const Color.fromRGBO(58, 123, 213, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Us - Milk Minder Project",
                style: GoogleFonts.robotoSlab(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(58, 123, 213, 1),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Welcome to Milk Minder, where transparency meets technology, and trust is the cornerstone of every transaction. "
                "We are committed to revolutionizing the dairy industry by empowering farmers and buyers to foster fair, transparent, and efficient dairy operations.",
                style: GoogleFonts.robotoSlab(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Text(
                "Why Milk Minder Matters",
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "The dairy industry is the lifeline for millions of farmers worldwide. Yet, challenges like:",
                style: GoogleFonts.robotoSlab(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- *Unfair pricing*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Adulteration*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Lack of transparency*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "often hold back its true potential. At Milk Minder, we believe in creating a sustainable and fair ecosystem where every drop of milk reflects the hard work of farmers and the trust of buyers.",
                style: GoogleFonts.robotoSlab(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Text(
                "Our Project Motto",
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "\"Fairness. Quality. Innovation.\"",
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(58, 123, 213, 1),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Our Mission",
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "To revolutionize the dairy industry by:",
                style: GoogleFonts.robotoSlab(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- *Empowering farmers* with technology and fair pricing mechanisms.",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Ensuring quality* by eliminating adulteration and promoting transparency.",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Strengthening connections* between farmers and buyers, fostering long-term relationships based on trust.",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Meet the Faces Behind Milk Minder",
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Our team consists of passionate individuals dedicated to reshaping the dairy sector. Here’s a quick look at the team behind the magic:",
                style: GoogleFonts.robotoSlab(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "- *Prathamesh Dhadankar*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Prajwal desai*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Parth Patil*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                    Text(
                      "- *Onkar Pawar*",
                      style: GoogleFonts.robotoSlab(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Join us today at milkminder.com!",
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(58, 123, 213, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

