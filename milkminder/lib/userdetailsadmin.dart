import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milkminder/editusersdetails.dart';

class UserDetailsPage extends StatefulWidget {
  final String email;

  const UserDetailsPage({super.key, required this.email});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Future<DocumentSnapshot> fetchUserDetails(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58,123,213,1),
        title: const Text("User Details"),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchUserDetails(widget.email),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text("Error: ${userSnapshot.error}"),
            );
          } else if (!userSnapshot.hasData) {
            return const Center(
              child: Text("User not found"),
            );
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromRGBO(58,123,213,1),
                    child: Text(
                      userData['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['name'],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['email'],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow("Phone Number", userData['phoneNumber']),
                          const Divider(),
                          _buildDetailRow("City", userData['city']),
                          const Divider(),
                          _buildDetailRow("Bank Account Number", userData['bankAccountNumber']),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserPage(
                            userId: userSnapshot.data!.id,
                            userData: userData,
                          ),
                        ),
                      );
                      if (result == true) {
                        setState(() {}); // Refresh user details
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(58,123,213,1),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Edit User",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


