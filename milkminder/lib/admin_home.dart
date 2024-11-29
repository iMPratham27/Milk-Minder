import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? userName;
  double totalMilkCollected = 0.0;
  double totalRevenue = 0.0;
  String connectedPeople = "0";
  String rewardsDistributed = "0";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, double> dataMap = {
    "Best": 380,
    "Above Average": 150,
    "Average": 100,
    "Under Average": 80,
    "Bad": 40,
  };

  List<Color> colorList = [
    const Color(0xff6A0DAD),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _calculateDynamicStats();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('admin').doc(user.uid).get();
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

  Future<void> _calculateDynamicStats() async {
    try {
      // Fetch totals data from the 'totals' collection
      final totalsSnapshot = await _firestore.collection('totals').get();
      double totalMilk = 0.0;
      double totalRev = 0.0;

      // Iterate over the totals collection to sum the quantities and amounts
      for (var doc in totalsSnapshot.docs) {
        totalMilk += (doc['total_quantity'] ?? 0.0);
        totalRev += (doc['total_amount'] ?? 0.0);
      }

      // Fetch the total number of users from the 'users' collection
      final usersSnapshot = await _firestore.collection('users').get();
      int totalUsers = usersSnapshot.docs.length;

      final rewardsSnapshot = await _firestore.collection('rewards').get();
      int totalRewards = rewardsSnapshot.docs.length;

      setState(() {
        totalMilkCollected = totalMilk;
        totalRevenue = totalRev;
        connectedPeople = totalUsers.toString();
        rewardsDistributed = totalRewards.toString();
      });
    } catch (e) {
      print("Error fetching totals: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58, 123, 213, 1),
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
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _fetchUserName();
                _calculateDynamicStats();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back,",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userName ?? "Loading...",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Milk Quality Breakdown",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PieChart(
                        dataMap: dataMap,
                        colorList: colorList,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        centerText: "Quality",
                        ringStrokeWidth: 20,
                        animationDuration: const Duration(seconds: 2),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: false,
                        ),
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(fontSize: 14),
                          legendPosition: LegendPosition.bottom,
                          showLegendsInRow: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    title: "Milk Collected",
                    value: totalMilkCollected,
                    unit: " L", // Add Litres suffix
                    color: Colors.blueAccent,
                  ),
                  _buildStatCard(
                    title: "Total Revenue",
                    value: totalRevenue,
                    unit: "₹ ",
                    isSuffix: false, // Add Rupees prefix
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: "Connected People",
                    value: double.parse(connectedPeople),
                    unit: "", // No unit for people count
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: "Total Rewards Distributed",
                    value: double.parse(rewardsDistributed),
                    unit: "", // No unit for rewards count
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildStatCard({
  required String title,
  required double value,
  required Color color,
  String unit = "", // Add a parameter for the unit (prefix/suffix)
  bool isSuffix = true, // Flag to control whether the unit is a prefix or suffix
}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(seconds: 2),
            builder: (context, double animatedValue, child) {
              final formattedValue = isSuffix
                  ? "${animatedValue.toStringAsFixed(0)}$unit" // Suffix
                  : "$unit${animatedValue.toStringAsFixed(0)}"; // Prefix
              return Text(
                formattedValue,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    ),
  );
}
}
