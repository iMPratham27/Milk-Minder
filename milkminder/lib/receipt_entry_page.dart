import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReceiptFormPage extends StatefulWidget {
  final String email;

  const ReceiptFormPage({super.key, required this.email});

  @override
  State<ReceiptFormPage> createState() => _ReceiptFormPageState();
}

class _ReceiptFormPageState extends State<ReceiptFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _snfController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email; // Autofill email
  }

 Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String date = _dateController.text.trim();
    double? quantity = double.tryParse(_quantityController.text.trim());
    double? fats = double.tryParse(_fatsController.text.trim());
    double? snf = double.tryParse(_snfController.text.trim());
    String type = _typeController.text.trim();
    double? amount = double.tryParse(_amountController.text.trim());

    if (quantity == null || fats == null || snf == null || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Map<String, dynamic> currentEntry = {
      'date': DateFormat('yyyy-MM-dd').parse(date),
      'quantity': quantity,
      'fats': fats,
      'snf': snf,
      'type': type,
      'amount': amount,
    };

    try {
      DocumentReference userDocRef =
          _firestore.collection('receipts').doc(email);

      DocumentSnapshot userDoc = await userDocRef.get();

      // Handle user document and entries
      if (userDoc.exists) {
        List<dynamic> existingEntries = userDoc.get('entries') ?? [];
        existingEntries.add(currentEntry);

        // Add to the user document
        await userDocRef.update({
          'entries': existingEntries,
        });
      } else {
        // Create the user document if it doesn't exist
        await userDocRef.set({
          'email': email,
          'entries': [currentEntry],
        });
      }

      // Update totals collection (separate from user data)
      DocumentReference totalsDocRef = _firestore.collection('totals').doc(email);
      DocumentSnapshot totalsDoc = await totalsDocRef.get();

      if (totalsDoc.exists) {
        await totalsDocRef.update({
          'total_quantity': FieldValue.increment(quantity),
          'total_amount': FieldValue.increment(amount),
        });
      } else {
        await totalsDocRef.set({
          'email': email,
          'total_quantity': quantity,
          'total_amount': amount,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt information saved successfully')),
      );

      // Reset form
      _formKey.currentState!.reset();
      _dateController.clear();
      _quantityController.clear();
      _fatsController.clear();
      _snfController.clear();
      _typeController.clear();
      _amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving receipt: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58,123,213, 1),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color:  Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon: Icon(Icons.email, color: Color.fromRGBO(58,123,213, 1)),
                  ),
                ),
                const SizedBox(height: 16),
                // Date
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: 'YYYY-MM-DD',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color:const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon:
                        const Icon(Icons.calendar_today,color: const Color.fromRGBO(58,123,213, 1)),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon: const Icon(Icons.currency_rupee_outlined,
                        color: const Color.fromRGBO(58,123,213, 1)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity (liters)',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color:const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon:
                        const Icon(Icons.local_drink, color: const Color.fromRGBO(58,123,213, 1)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fats
                TextFormField(
                  controller: _fatsController,
                  decoration: InputDecoration(
                    labelText: 'Fats (%)',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon: const Icon(Icons.percent, color: const Color.fromRGBO(58,123,213, 1)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fats percentage';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // SNF
                TextFormField(
                  controller: _snfController,
                  decoration: InputDecoration(
                    labelText: 'SNF (%)',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon: const Icon(Icons.percent, color:const Color.fromRGBO(58,123,213, 1)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter SNF percentage';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Type
                // TextFormField(
                //   controller: _typeController,
                //   decoration: InputDecoration(
                //     labelText: 'Type (e.g., Cow/Buffalo)',
                //     labelStyle: const TextStyle(color: Colors.green),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.green.shade400),
                //     ),
                //     focusedBorder: const OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.green),
                //     ),
                //     prefixIcon: const Icon(Icons.pets, color: Colors.green),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter type';
                //     }
                //     return null;
                //   },
                // ),
                
                DropdownButtonFormField<String>(
                  value: _typeController.text.isNotEmpty
                      ? _typeController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromRGBO(58,123,213, 1)),
                    ),
                    prefixIcon: const Icon(Icons.pets, color: const Color.fromRGBO(58,123,213, 1)),
                  ),
                  items: ['Cow', 'Buffalo']
                      .map(
                        (type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _typeController.text = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  menuMaxHeight: 200,
                  borderRadius: BorderRadius.circular(12),
                ),

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(58,123,213, 1), // Green background
                      foregroundColor: Colors.white, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                      ),
                      minimumSize: const Size(200, 50), // Button size
                      elevation: 5, // Shadow effect
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0), // Padding inside the button
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          )
                        : const Text(
                            'Add Receipt',
                            style: TextStyle(
                              fontSize: 18.0, // Text size
                              fontWeight: FontWeight.w600, // Bold text
                            ),
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
}