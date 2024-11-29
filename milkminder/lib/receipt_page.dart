
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:milkminder/generate_invoice.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptPage extends StatefulWidget {
  final String email;

  const ReceiptPage({super.key, required this.email});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;
  String _name = "";
  String _email = "";

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

  // Create a GlobalKey for Scaffold to open the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _fetchReceipts(String email) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('receipts').doc(email).get();

      if (userDoc.exists) {
        List<dynamic> entries = userDoc.get('entries') ?? [];
        setState(() {
          _activities =
              entries.map((e) => Map<String, dynamic>.from(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _activities = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching receipts: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReceipts(widget.email);
    _fetchUserData();
  }

  void _refreshReceipts() {
    setState(() {
      _isLoading = true;
    });
    _fetchReceipts(widget.email);
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key here
      backgroundColor: Color.fromARGB(146, 255, 242, 215),
      //backgroundColor: const Color.fromRGBO(240, 255, 240, 1), // Light greenish background
      appBar: AppBar(
        //backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
        backgroundColor: const Color(0xFF56AB2F), // Green gradient
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/MilkMinderLogo2.png',
            height: 200,
            width: 180,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshReceipts, // Refresh receipts
          ),
        ],
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activities.isEmpty
              ? const Center(child: Text('No receipts available'))
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      final activity = _activities[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ExpansionTileCard(
                          baseColor: Colors.white,
                          expandedColor: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          elevation: 4,
                          key: GlobalKey(),
                          leading: const Icon(Icons.receipt_long,
                              color: Colors.green),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(activity['date'].toDate()),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                height: 32,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4CAF50),
                                      Color(0xFF66BB6A)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '₹${activity['amount']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black54),
                          children: <Widget>[
                            const Divider(thickness: 1.0, height: 1.0),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildActivityColumn(
                                    "Quantity",
                                    '${activity['quantity']}L',
                                    icon: Icons.local_drink,
                                    iconColor: Colors.blue,
                                  ),
                                  _buildActivityColumn(
                                    "Fats",
                                    activity['fats'].toString(),
                                    icon: Icons.opacity,
                                    iconColor: Colors.orange,
                                  ),
                                  _buildActivityColumn(
                                    "SNF",
                                    activity['snf'].toString(),
                                    icon: Icons.science,
                                    iconColor: Colors.purple,
                                  ),
                                  _buildActivityColumn(
                                    "Type",
                                    activity['type'],
                                    icon: Icons.pets,
                                    iconColor: Colors.brown,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: InkWell(
                                onTap: () {
                                  generateInvoice(
                                      activity, widget.email); // Pass the email to generateInvoice
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF81C784),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(2, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Get Invoice",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildActivityColumn(String title, String value,
      {required IconData icon, required Color iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
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

