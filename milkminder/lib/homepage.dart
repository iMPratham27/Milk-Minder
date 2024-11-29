// import 'package:card_swiper/card_swiper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:milkminder/landingpage.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? userName;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> _recentActivities = [];
//   bool _isLoading = true;

//   double totalMilk = 0.0;
//   double totalRevenue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserName();
//     _fetchRecentActivities();
//   }

//   Future<void> _fetchUserName() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final userData =
//             await _firestore.collection('users').doc(user.uid).get();
//         setState(() {
//           userName = userData['name'] ?? 'Guest';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         userName = 'Guest';
//       });
//     }
//   }

//   Future<void> _fetchRecentActivities() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc =
//             await _firestore.collection('receipts').doc(user.email).get();

//         if (userDoc.exists) {
//           List<dynamic> entries = userDoc.get('entries') ?? [];
//           double milk = 0.0;
//           double revenue = 0.0;

//           List<Map<String, dynamic>> recentActivities =
//               entries.map((e) => Map<String, dynamic>.from(e)).toList();

//           for (var activity in recentActivities) {
//             milk += activity['quantity'] ?? 0.0;
//             revenue += activity['amount'] ?? 0.0;
//           }

//           setState(() {
//             _recentActivities = recentActivities;
//             totalMilk = milk;
//             totalRevenue = revenue;
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching receipts: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LandingPage()),
//       );
//     } catch (e) {
//       print("Error signing out: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> swiperData = [
//       {
//         'color': Colors.blueAccent,
//         'title': "Total Milk",
//         'description': "${totalMilk.toStringAsFixed(1)}L",
//         'image': 'assets/MilkCan.png',
//       },
//       {
//         'color': Colors.greenAccent,
//         'title': "Total Revenue",
//         'description': "₹${totalRevenue.toStringAsFixed(2)}",
//         'image': 'assets/cash.png',
//       },
//     ];

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 242, 215, 1),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
//         elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             'assets/MilkMinderLogo2.png',
//             height: 200,
//             width: 180,
//           ),
//         ),
//         centerTitle: true,
//         toolbarHeight: 70,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.black),
//             onPressed: () {
//               setState(() {
//                 _fetchUserName();
//                 _fetchRecentActivities();
//               });
//             },
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(
//                 userName ?? 'Guest',
//                 style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
//               ),
//               accountEmail: Text(
//                 FirebaseAuth.instance.currentUser?.email ?? 'No Email',
//                 style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
//               ),
//               currentAccountPicture: const CircleAvatar(
//                 backgroundImage: AssetImage("assets/user-avatar-male-5.png"),
//                 backgroundColor: Colors.white,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.info_outline, color: Colors.black),
//               title: Text('About', style: GoogleFonts.poppins(color: Colors.black)),
//               onTap: () {
//                 Navigator.pop(context);
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('About'),
//                     content: const Text('This is an app for milk collection and management.'),
//                     actions: [
//                       TextButton(
//                         child: const Text('Close'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.exit_to_app, color: Colors.black),
//               title: Text('Sign Out', style: GoogleFonts.poppins(color: Colors.black)),
//               onTap: _signOut,
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Welcome Back,",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//                 fontFamily: 'Roboto',
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               userName ?? "Loading...",
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w400,
//                 color: Color(0xFF959595),
//                 fontFamily: 'Roboto',
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               height: 200,
//               child: Swiper(
//                 itemBuilder: (BuildContext context, int index) {
//                   final item = swiperData[index];
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Container(
//                       color: item['color'],
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               item['image'],
//                               height: 180,
//                               width: 130,
//                             ),
//                             const SizedBox(width: 16),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['title'],
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   item['description'],
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 itemCount: swiperData.length,
//                 autoplay: true,
//                 autoplayDelay: 5000,
//                 viewportFraction: 0.9,
//                 scale: 0.95,
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Recent Activity",
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 25),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _recentActivities.isEmpty
//                       ? const Center(child: Text('No recent activities'))
//                       : ListView.builder(
//                           itemCount: _recentActivities.length,
//                           padding: const EdgeInsets.all(8),
//                           itemBuilder: (context, index) {
//                             final activity = _recentActivities[index];
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 16.0),
//                               child: Container(
//                                 height: 158,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       spreadRadius: 3,
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 3),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             DateFormat('yyyy-MM-dd')
//                                                 .format(activity['date'].toDate()),
//                                             style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             '₹${activity['amount']}',
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.green,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const Divider(),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           _buildActivityColumn("Quantity",
//                                               '${activity['quantity']}L', Icons.water_drop),
//                                           _buildActivityColumn("Fats",
//                                               activity['fats'].toString(), Icons.opacity),
//                                           _buildActivityColumn("SNF",
//                                               activity['snf'].toString(), Icons.science),
//                                           _buildActivityColumn(
//                                               "Type", activity['type'], Icons.pets),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActivityColumn(String title, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.grey[600]),
//         const SizedBox(height: 4),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 14, color: Colors.grey),
//         ),
//         Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }



import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:milkminder/landingpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _recentActivities = [];
  bool _isLoading = true;

  double totalMilk = 0.0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchRecentActivities();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userName = userData['name'] ?? 'Guest';
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Guest';
      });
    }
  }

  Future<void> _fetchRecentActivities() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('receipts').doc(user.email).get();

        if (userDoc.exists) {
          List<dynamic> entries = userDoc.get('entries') ?? [];
          double milk = 0.0;
          double revenue = 0.0;

          List<Map<String, dynamic>> recentActivities =
              entries.map((e) => Map<String, dynamic>.from(e)).toList();

          for (var activity in recentActivities) {
            milk += activity['quantity'] ?? 0.0;
            revenue += activity['amount'] ?? 0.0;
          }

          setState(() {
            _recentActivities = recentActivities;
            totalMilk = milk;
            totalRevenue = revenue;
          });
        }
      }
    } catch (e) {
      print('Error fetching receipts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> swiperData = [
      {
        'color': Colors.blueAccent,
        'title': "Total Milk",
        'description': "${totalMilk.toStringAsFixed(1)}L",
        'image': 'assets/MilkCan.png',
      },
      {
        'color': Colors.greenAccent,
        'title': "Total Revenue",
        'description': "₹${totalRevenue.toStringAsFixed(2)}",
        'image': 'assets/cash.png',
      },
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(146, 255, 242, 215),
      //backgroundColor: const Color.fromRGBO(240, 255, 240, 1), // Light greenish background
      appBar: AppBar(
        backgroundColor: const Color(0xFF56AB2F), // Green gradient
        elevation: 2,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/MilkMinderLogo2.png',
            height: 200,
            width: 180,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _fetchUserName();
                _fetchRecentActivities();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName ?? 'Guest',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? 'No Email',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/user-avatar-male-5.png"),
                backgroundColor: Colors.white,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF388E3C)),
              title: Text('About',
                  style: GoogleFonts.poppins(color: const Color(0xFF388E3C))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF388E3C)),
              title: Text('Sign Out',
                  style: GoogleFonts.poppins(color: const Color(0xFF388E3C))),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome Back,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                //color: Color(0xFF2E7D32), // Dark green
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userName ?? "Loading...",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                //color: Color(0xFF66BB6A), // Lighter green
                color: Colors.grey,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  final item = swiperData[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: item['color'], // Use existing color logic
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.asset(
                              item['image'],
                              height: 180,
                              width: 130,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item['description'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: swiperData.length,
                autoplay: true,
                autoplayDelay: 5000,
                viewportFraction: 0.9,
                scale: 0.95,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                //color: Color(0xFF2E7D32), // Dark green
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recentActivities.isEmpty
                      ? const Center(
                          child: Text(
                            'No recent activities',
                            style: TextStyle(color: Color(0xFF2E7D32)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _recentActivities.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final activity = _recentActivities[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                height: 158,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4F3), // Pale green
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                activity['date'].toDate()),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(
                                                  0xFF2E7D32), // Dark green
                                            ),
                                          ),
                                          Text(
                                            '₹${activity['amount']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF388E3C), // Green
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildActivityColumn(
                                              "Quantity",
                                              '${activity['quantity']}L',
                                              Icons.water_drop),
                                          _buildActivityColumn(
                                              "Fats",
                                              activity['fats'].toString(),
                                              Icons.opacity),
                                          _buildActivityColumn(
                                              "SNF",
                                              activity['snf'].toString(),
                                              Icons.science),
                                          _buildActivityColumn("Type",
                                              activity['type'], Icons.pets),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityColumn(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
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