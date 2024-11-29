import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditUserPage({super.key, required this.userId, required this.userData});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _bankAccountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneController = TextEditingController(text: widget.userData['phoneNumber']);
    _cityController = TextEditingController(text: widget.userData['city']);
    _bankAccountController = TextEditingController(text: widget.userData['bankAccountNumber']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
  if (_formKey.currentState!.validate()) {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'city': _cityController.text,
        'bankAccountNumber': _bankAccountController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User details updated successfully!')),
      );

      Navigator.pop(context, true); // Pass `true` to indicate success
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $error')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58,123,213,1),
        title: const Text("Edit User"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Name", _nameController),
                const SizedBox(height: 15),
                _buildTextField("Email", _emailController),
                const SizedBox(height: 15),
                _buildTextField("Phone Number", _phoneController),
                const SizedBox(height: 15),
                _buildTextField("City", _cityController),
                const SizedBox(height: 15),
                _buildTextField("Bank Account Number", _bankAccountController),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(58,123,213,1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }
}
