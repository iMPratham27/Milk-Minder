// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:milkminder/custom_snackbar.dart';

// class AdminRewardsPage extends StatefulWidget {
//   const AdminRewardsPage({super.key});

//   @override
//   State<AdminRewardsPage> createState() => _AdminRewardsPageState();
// }

// class _AdminRewardsPageState extends State<AdminRewardsPage> {
//   final TextEditingController _rewardController = TextEditingController();
//   final TextEditingController _numUsersController = TextEditingController();
//   List<DocumentSnapshot> _users = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//   }

//   Future<void> _fetchUsers() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('users').get();
//       setState(() {
//         _users = snapshot.docs;
//       });
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching users: $error")),
//       );
//     }
//   }

//   void _assignRewards() async {
//     if (_rewardController.text.isEmpty ||
//         _numUsersController.text.isEmpty ||
//         int.tryParse(_numUsersController.text) == null) {
      
//       CustomSnackbar.showCustomSnackbar(
//         message: "Please fill out all fields correctly.",
//         context: context,
//       );
//       return;
//     }

//     int maxUsers = int.parse(_numUsersController.text);

//     if (maxUsers > _users.length) {
//       CustomSnackbar.showCustomSnackbar(
//         message: "Cannot assign rewards to $maxUsers users. Only ${_users.length} users available.",
//         context: context,
//       );
      
//       return;
//     }

//     try {
//       // Shuffle users and select the first `maxUsers` randomly
//       _users.shuffle(Random());
//       List<DocumentSnapshot> selectedUsers = _users.take(maxUsers).toList();

//       for (var user in selectedUsers) {
//         String userId = user.id;
//         String name = user['name'] ?? 'Unknown';
//         String email = user['email'] ?? 'Unknown Email';

//         await FirebaseFirestore.instance.collection('rewards').add({
//           'userId': userId,
//           'name': name,
//           'email': email,
//           'reward': _rewardController.text,
//           'timestamp': FieldValue.serverTimestamp(), // For tracking when the reward was assigned
//         });
//       }

//       CustomSnackbar.showCustomSnackbar(
//         message: "Rewards assigned successfully!",
//         context: context,
//       );

//       _rewardController.clear();
//       _numUsersController.clear();
//     } catch (error) {
      
//       CustomSnackbar.showCustomSnackbar(
//         message: "Error assigning rewards: $error",
//         context: context,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: const Color.fromRGBO(255, 242, 215, 1),
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
//         toolbarHeight: 70,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Reward Input
//             TextFormField(
//               controller: _rewardController,
//               decoration: InputDecoration(
//                 labelText: "Reward",
//                 labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Number of Users Input
//             TextFormField(
//               controller: _numUsersController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Number of Users",
//                 labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Users List Display
//             Expanded(
//               child: _users.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                     padding: const EdgeInsets.all(8),
//                       itemCount: _users.length,
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot user = _users[index];
//                         String name = user['name'] ?? 'Unknown';
//                         String email = user['email'] ?? 'Unknown Email';

//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               name,
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(
//                               email,
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),

//             // Assign Rewards Button
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: _assignRewards,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromRGBO(28, 185, 14, 1),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Assign Rewards",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkminder/custom_snackbar.dart';

class AdminRewardsPage extends StatefulWidget {
  const AdminRewardsPage({super.key});

  @override
  State<AdminRewardsPage> createState() => _AdminRewardsPageState();
}

class _AdminRewardsPageState extends State<AdminRewardsPage> {
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _numUsersController = TextEditingController();
  List<DocumentSnapshot> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _users = snapshot.docs;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching users: $error")),
      );
    }
  }

  void _assignRewards() async {
    if (_rewardController.text.isEmpty ||
        _numUsersController.text.isEmpty ||
        int.tryParse(_numUsersController.text) == null) {
      CustomSnackbar.showCustomSnackbar(
        message: "Please fill out all fields correctly.",
        context: context,
      );
      return;
    }

    int maxUsers = int.parse(_numUsersController.text);

    if (maxUsers > _users.length) {
      CustomSnackbar.showCustomSnackbar(
        message:
            "Cannot assign rewards to $maxUsers users. Only ${_users.length} users available.",
        context: context,
      );
      return;
    }

    try {
      _users.shuffle(Random());
      List<DocumentSnapshot> selectedUsers = _users.take(maxUsers).toList();

      for (var user in selectedUsers) {
        String userId = user.id;
        String name = user['name'] ?? 'Unknown';
        String email = user['email'] ?? 'Unknown Email';

        await FirebaseFirestore.instance.collection('rewards').add({
          'userId': userId,
          'name': name,
          'email': email,
          'reward': _rewardController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      CustomSnackbar.showCustomSnackbar(
        message: "Rewards assigned successfully!",
        context: context,
      );

      _rewardController.clear();
      _numUsersController.clear();
    } catch (error) {
      CustomSnackbar.showCustomSnackbar(
        message: "Error assigning rewards: $error",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58,123,213,1),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reward Input Field
            _buildInputField(
              controller: _rewardController,
              label: "Enter Reward",
              icon: Icons.card_giftcard,
            ),
            const SizedBox(height: 20),

            // Number of Users Input Field
            _buildInputField(
              controller: _numUsersController,
              label: "Number of Users",
              icon: Icons.people,
              isNumber: true,
            ),
            const SizedBox(height: 20),

            // Users List Display
            Expanded(
              child: _users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot user = _users[index];
                        String name = user['name'] ?? 'Unknown';
                        String email = user['email'] ?? 'Unknown Email';

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color.fromRGBO(58,123,213,1),
                              child: Text(
                                name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Assign Rewards Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _assignRewards,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromRGBO(58,123,213,1),
                ),
                child: const Center(
                  child: Text(
                    "Assign Rewards",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromRGBO(58,123,213,1),),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(58,123,213,1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(58,123,213,1), width: 2),
        ),
      ),
    );
  }
}
