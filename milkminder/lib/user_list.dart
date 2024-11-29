

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:milkminder/signup.dart'; 
import 'package:milkminder/receipt_entry_page.dart'; 
import 'package:milkminder/userdetailsadmin.dart'; 

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching users"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          } else {
            List<DocumentSnapshot> users = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                String name = users[index]['name'];
                String email = users[index]['email'] ?? 'No email provided';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4, // Shadow intensity
                    shadowColor: Colors.grey.withOpacity(0.5), // Shadow color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: ExpansionTileCard(
                      baseColor: Colors.white,
                      expandedColor: Colors.grey[100], // Color when expanded
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color.fromRGBO(58,123,213,1),
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 52.0,
                          buttonMinWidth: 90.0,
                          children: <Widget>[

                            // Add Receipt button
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReceiptFormPage(email: email), // Navigate to ReceiptFormPage
                                  ),
                                );
                              },
                              child: const Column(
                                children: <Widget>[
                                  Icon(Icons.receipt_long),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text('Add Receipt'),
                                ],
                              ),
                            ),
                            
                            // view more button
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailsPage(email: email), // Navigate to UserDetailsPage
                                  ),
                                );
                              },
                              child: const Column(
                                children: <Widget>[
                                  Icon(Icons.info_outline),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Text('View More'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        },
        backgroundColor: const Color.fromRGBO(58,123,213,1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


