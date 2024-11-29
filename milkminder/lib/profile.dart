
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          await _firestore.collection('users').doc(userId).get();

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
      backgroundColor: const Color.fromARGB(146, 255, 242, 215),
      //backgroundColor: const Color(0xFFF4F8FB),
      //backgroundColor: const Color.fromRGBO(240, 255, 240, 1), // Light greenish background
      appBar: AppBar(
        //backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
        backgroundColor: const Color(0xFF56AB2F), // Green gradient
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              // Refresh the page
              setState(() {
                _fetchUserData(); // Re-fetch user data
              });
            },
            tooltip: 'Refresh',
          ),
        ],
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
                  color:  Color.fromRGBO(28, 185, 14, 1),
                  //borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
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
          colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
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
              child: Icon(icon, size: 30, color: Colors.green.shade700),
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


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF56AB2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Milk Minder!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Milk Minder simplifies milk collection and revenue tracking with state-of-the-art features tailored for dairy professionals and farmers alike.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Our Motto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '“To revolutionize dairy management with smart, efficient, and user-friendly technology.”',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'The Face of Our Business',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Our app is the go-to solution for managing dairy operations, boosting profitability, and improving milk quality assessment.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'To empower farmers and businesses by delivering innovative tools that streamline operations and improve quality across the dairy supply chain.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Meet Our Team',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Our team comprises passionate developers, dairy experts, and technology enthusiasts committed to making dairy management hassle-free for everyone.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF56AB2F),
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}