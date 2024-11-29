
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  final String email; // Pass user email to identify their receipts

  const CalendarScreen({super.key, required this.email});

  @override
  State createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<int, bool> _deliveryStatus = {}; // Maps day to delivery status
  bool _isLoading = true;
  DateTime _currentMonth = DateTime.now(); // Tracks the currently displayed month

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  

  String _name = "";
  String _email = "";


  Future<void> _fetchReceipts() async {
    try {
      // Fetch the document for the logged-in user
      DocumentSnapshot userDoc =
          await _firestore.collection('receipts').doc(widget.email).get();

      if (userDoc.exists) {
        List<dynamic> entries = userDoc.get('entries') ?? [];
        Map<int, bool> status = {};

        for (var entry in entries) {
          DateTime date = entry['date'].toDate();
          if (date.year == _currentMonth.year &&
              date.month == _currentMonth.month) {
            status[date.day] = true; // Mark the day as delivered
          }
        }

        setState(() {
          _deliveryStatus = status;
          _isLoading = false;
        });
      } else {
        setState(() {
          _deliveryStatus = {};
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading receipts: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
      );
      _isLoading = true;
    });
    _fetchReceipts(); // Re-fetch receipts for the updated month
  }

  void _refresh() {
    setState(() {
      _isLoading = true;
    });
    _fetchReceipts(); // Refresh the data
    _fetchUserData();
  }

  @override
  void initState() {
    super.initState();
    _fetchReceipts();
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
    String formattedMonth = DateFormat('MMMM yyyy').format(_currentMonth);

    return Scaffold(
      backgroundColor: Color.fromARGB(146, 255, 242, 215),
      //backgroundColor: const Color.fromRGBO(255, 242, 215, 1),
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is clicked
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              // Refresh the page
              _refresh();
              // setState(() {
              //   _fetchUserData(); // Re-fetch user data
              // });
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
      body: Column(
        children: [
          // Month and navigation arrows
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.teal),
                  onPressed: () => _changeMonth(-1), // Navigate to previous month
                ),
                Text(
                  formattedMonth,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.teal),
                  onPressed: () => _changeMonth(1), // Navigate to next month
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      itemCount: DateTime(_currentMonth.year,
                              _currentMonth.month + 1, 0)
                          .day, // Number of days in the current month
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isDelivered = _deliveryStatus[day] ?? false;

                        return Container(
                          decoration: BoxDecoration(
                            color: isDelivered
                                ? const Color.fromRGBO(28, 185, 14, 1)
                                : const Color.fromARGB(255, 255, 72, 58),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              day.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          // Legend for colors
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green legend
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Color.fromRGBO(28, 185, 14, 1),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Delivered',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                // Red legend
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Color.fromARGB(255, 255, 72, 58),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Not Delivered',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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