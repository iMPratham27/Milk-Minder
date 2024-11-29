
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkminder/landingpage.dart';
import 'package:milkminder/session_data.dart';
import 'package:scratcher/scratcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsPage extends StatefulWidget {
  final String email;

  const RewardsPage({super.key, required this.email});

  @override
  State createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late ConfettiController _confettiController;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    // Initialize the confetti controller for full-screen celebrations
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
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
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchRewards(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rewards')
          .where('email', isEqualTo: email)
          .get();

      // Handle case where no rewards are found
      if (snapshot.docs.isEmpty) {
        return [
          {"id": null, "reward": "Better luck next time!", "isScratched": false}
        ];
      }

      // Parse rewards data
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          "reward": data['reward'] ?? "Better luck next time!",
          "isScratched": data['isScratched'] ?? false,
        };
      }).toList();
    } catch (error) {
      // Return default in case of errors
      return [
        {"id": null, "reward": "Better luck next time!", "isScratched": false}
      ];
    }
  }

  void _triggerCelebration() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(146, 255, 242, 215),
      //backgroundColor: const Color.fromRGBO(240, 255, 240, 1), // Light greenish background
      appBar: AppBar(
        //backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
        backgroundColor: const Color(0xFF56AB2F), // Green gradient
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/MilkMinderLogo2.png',
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
                decoration:  const BoxDecoration(
                  color:  Color.fromRGBO(28, 185, 14, 1),
                  //borderRadius: BorderRadius.circular(16),
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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(  // The rewards functionality
            future: _fetchRewards(widget.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error loading rewards"),
                );
              }

              final rewards = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Scratch to reveal your rewards!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rewards.length,
                        itemBuilder: (context, index) {
                          final reward = rewards[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: reward['isScratched']
                                ? ScratchedCard(
                                    rewardText: reward['reward'],
                                  )
                                : ScratchableCard(
                                    rewardText: reward['reward'],
                                    rewardId: reward['id'],
                                    onScratchComplete: _triggerCelebration,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Full-screen confetti widget
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality:
                BlastDirectionality.explosive, // Spread in all directions
            shouldLoop: false, // Confetti stops after the duration
            numberOfParticles:
                50, // Increase the number of particles for higher intensity
            emissionFrequency: 0.2, // Emit particles more frequently
            gravity:
                0.5, // Reduce gravity for slower, more dramatic falling effect
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.red,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }
}

class ScratchableCard extends StatelessWidget {
  final String rewardText;
  final String? rewardId;
  final VoidCallback onScratchComplete;

  const ScratchableCard({
    super.key,
    required this.rewardText,
    required this.rewardId,
    required this.onScratchComplete,
  });

  Future<void> _markAsScratched(String? rewardId) async {
    if (rewardId != null) {
      await FirebaseFirestore.instance
          .collection('rewards')
          .doc(rewardId)
          .update({'isScratched': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Scratcher(
        brushSize: 50,
        threshold: 50,
        color: const Color(0xFF56AB2F),
        onThreshold: () async {
          await _markAsScratched(rewardId);

          // Trigger confetti and snackbar
          onScratchComplete();
        },
        child: Container(
          height: 140,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            rewardText, // Display the reward text on the card
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ScratchedCard extends StatelessWidget {
  final String rewardText;

  const ScratchedCard({super.key, required this.rewardText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 140,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          rewardText,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
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






