// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// Future<void> generateInvoice(Map<String, dynamic> activity) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Header(
//               level: 0,
//               child: pw.Text(
//                 'MilkMinder Invoice',
//                 style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.SizedBox(height: 16),
//             pw.Text(
//               'Customer Details:',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text('Email: ${activity['email']}'),
//             pw.SizedBox(height: 16),
//             pw.Text(
//               'Invoice Details:',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Table(
//               border: pw.TableBorder.all(),
//               children: [
//                 pw.TableRow(
//                   children: [
//                     pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text('Quantity (L)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text('Fats (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text('SNF (%)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     pw.Text('Amount (₹)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ],
//                 ),
//                 pw.TableRow(
//                   children: [
//                     pw.Text(DateFormat('yyyy-MM-dd').format(activity['date'].toDate())),
//                     pw.Text('${activity['quantity']}'),
//                     pw.Text('${activity['fats']}'),
//                     pw.Text('${activity['snf']}'),
//                     pw.Text(activity['type']),
//                     pw.Text('₹${activity['amount']}'),
//                   ],
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 16),
//             pw.Text(
//               'Total Amount: ₹${activity['amount']}',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 16),
//             pw.Footer(
//               title: pw.Text(
//                 'Thank you for using MilkMinder!',
//                 style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }



// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// Future<void> generateInvoice(Map<String, dynamic> activity) async {
//   final pdf = pw.Document();
  
//   // Load the logo asynchronously
//   final ByteData data = await rootBundle.load('assets/MilkMinderLogo2.png');
//   final image = pw.MemoryImage(data.buffer.asUint8List());

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Header with Company Name and Logo (you can add an image asset for the logo)
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               children: [
//                 // Image logo
//                 pw.Image(image, height: 60, width: 80),
//                 pw.SizedBox(width: 8),
//                 pw.Text(
//                   'MilkMinder Invoice',
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.green,
//                   ),
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 20),
            
//             // Customer Details Section
//             pw.Text(
//               'Customer Details:',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text('Email: ${activity['email']}'),
//             pw.SizedBox(height: 16),

//             // Invoice Details Section
//             pw.Text(
//               'Invoice Details:',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Table(
//               border: pw.TableBorder.all(color: PdfColors.grey400),
//               children: [
//                 // Table headers
//                 pw.TableRow(
//                   decoration: pw.BoxDecoration(color: PdfColors.green),
//                   children: [
//                     _buildTableCell('Date', bold: true),
//                     _buildTableCell('Quantity (L)', bold: true),
//                     _buildTableCell('Fats (%)', bold: true),
//                     _buildTableCell('SNF (%)', bold: true),
//                     _buildTableCell('Type', bold: true),
//                     _buildTableCell('Amount (₹)', bold: true),
//                   ],
//                 ),
//                 // Table row with data
//                 pw.TableRow(
//                   children: [
//                     _buildTableCell(DateFormat('yyyy-MM-dd').format(activity['date'].toDate())),
//                     _buildTableCell('${activity['quantity']}'),
//                     _buildTableCell('${activity['fats']}'),
//                     _buildTableCell('${activity['snf']}'),
//                     _buildTableCell(activity['type']),
//                     _buildTableCell('Rs.${activity['amount']}'),
//                   ],
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 16),

//             // Total Amount
//             pw.Text(
//               'Total Amount: Rs.${activity['amount']}',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green),
//             ),
//             pw.SizedBox(height: 20),

//             // Footer with thank you message
//             pw.Divider(color: PdfColors.grey),
//             pw.SizedBox(height: 8),
//             pw.Text(
//               'Thank you for choosing MilkMinder!',
//               style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic, color: PdfColors.black),
//             ),
//             pw.SizedBox(height: 8),
//             // pw.Text(
//             //   'Visit us at www.milkminder.com for more details.',
//             //   style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.normal, color: PdfColors.grey),
//             // ),
//           ],
//         );
//       },
//     ),
//   );

//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }

// // Helper function for generating table cells
// pw.Widget _buildTableCell(String text, {bool bold = false}) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(6.0),
//     child: pw.Text(
//       text,
//       style: pw.TextStyle(
//         fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
//         color: PdfColors.black,
//       ),
//     ),
//   );
// }



import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateInvoice(Map<String, dynamic> activity, String email) async {
  final pdf = pw.Document();

  // Load the logo asynchronously
  final ByteData data = await rootBundle.load('assets/MilkMinderLogo2.png');
  final image = pw.MemoryImage(data.buffer.asUint8List());

  // Load a font that supports the rupee symbol
  final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  // Fetch user details from Firestore
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final userDoc = await _firestore.collection('users').doc(email).get();
  // final userName = userDoc.exists ? userDoc['name'] : 'Customer'; // Fallback to 'Customer' if name doesn't exist

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with Company Name and Logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Image(image, height: 60, width: 80),
                pw.SizedBox(width: 8),
                pw.Text(
                  'MilkMinder Invoice',
                  style: pw.TextStyle(
                    fontSize: 21,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                    font: ttf,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Customer Details Section (Name and Email)
            // pw.Text(
            //   'Customer: $userName',
            //   style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
            // ),
            pw.Text(
              'Email: $email',
              style: pw.TextStyle(fontSize: 16, font: ttf),
            ),
            pw.SizedBox(height: 16),

            // Invoice Details Section
            pw.Text(
              'Invoice Details:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
            ),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.green),
                  children: [
                    _buildTableCell('Date', bold: true, font: ttf),
                    _buildTableCell('Quantity (L)', bold: true, font: ttf),
                    _buildTableCell('Fats (%)', bold: true, font: ttf),
                    _buildTableCell('SNF (%)', bold: true, font: ttf),
                    _buildTableCell('Type', bold: true, font: ttf),
                    _buildTableCell('Amount (₹)', bold: true, font: ttf),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _buildTableCell(DateFormat('yyyy-MM-dd').format(activity['date'].toDate()), font: ttf),
                    _buildTableCell('${activity['quantity']}', font: ttf),
                    _buildTableCell('${activity['fats']}', font: ttf),
                    _buildTableCell('${activity['snf']}', font: ttf),
                    _buildTableCell(activity['type'], font: ttf),
                    _buildTableCell('₹${activity['amount']}', font: ttf),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // Total Amount
            pw.Text(
              'Total Amount: ₹${activity['amount']}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green, font: ttf),
            ),
            pw.SizedBox(height: 20),

            // Footer with thank you message
            pw.Divider(color: PdfColors.grey),
            pw.SizedBox(height: 8),
            pw.Text(
              'Thank you for choosing MilkMinder!',
              style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic, color: PdfColors.black, font: ttf),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// Helper function for generating table cells
pw.Widget _buildTableCell(String text, {bool bold = false, required pw.Font font}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6.0),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: PdfColors.black,
        font: font,
      ),
    ),
  );
}






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'dart:io';

// // Function to generate and save the invoice as a PDF
// Future<void> generateInvoice(Map<String, dynamic> activity, String email) async {
//   final pdf = pw.Document();

//   // Load the logo asynchronously
//   final ByteData data = await rootBundle.load('assets/MilkMinderLogo2.png');
//   final image = pw.MemoryImage(data.buffer.asUint8List());

//   // Load a font that supports the rupee symbol
//   final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
//   final ttf = pw.Font.ttf(fontData);

//   // Fetch user details from Firestore
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final userDoc = await _firestore.collection('users').doc(email).get();
//   final userName = userDoc.exists ? userDoc['name'] : 'Customer'; // Fallback to 'Customer' if name doesn't exist

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Header with Company Name and Logo
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               children: [
//                 pw.Image(image, height: 60, width: 80),
//                 pw.SizedBox(width: 8),
//                 pw.Text(
//                   'MilkMinder Invoice',
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.green,
//                     font: ttf,
//                   ),
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 20),

//             // Customer Details Section (Name and Email)
//             // pw.Text(
//             //   'Customer: $userName',
//             //   style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
//             // ),
//             pw.Text(
//               'Email: $email',
//               style: pw.TextStyle(fontSize: 16, font: ttf),
//             ),
//             pw.SizedBox(height: 16),

//             // Invoice Details Section
//             pw.Text(
//               'Invoice Details:',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf),
//             ),
//             pw.Table(
//               border: pw.TableBorder.all(color: PdfColors.grey400),
//               children: [
//                 pw.TableRow(
//                   decoration: pw.BoxDecoration(color: PdfColors.green),
//                   children: [
//                     _buildTableCell('Date', bold: true, font: ttf),
//                     _buildTableCell('Quantity (L)', bold: true, font: ttf),
//                     _buildTableCell('Fats (%)', bold: true, font: ttf),
//                     _buildTableCell('SNF (%)', bold: true, font: ttf),
//                     _buildTableCell('Type', bold: true, font: ttf),
//                     _buildTableCell('Amount (₹)', bold: true, font: ttf),
//                   ],
//                 ),
//                 pw.TableRow(
//                   children: [
//                     _buildTableCell(DateFormat('yyyy-MM-dd').format(activity['date'].toDate()), font: ttf),
//                     _buildTableCell('${activity['quantity']}', font: ttf),
//                     _buildTableCell('${activity['fats']}', font: ttf),
//                     _buildTableCell('${activity['snf']}', font: ttf),
//                     _buildTableCell(activity['type'], font: ttf),
//                     _buildTableCell('₹${activity['amount']}', font: ttf),
//                   ],
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 16),

//             // Total Amount
//             pw.Text(
//               'Total Amount: ₹${activity['amount']}',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green, font: ttf),
//             ),
//             pw.SizedBox(height: 20),

//             // Footer with thank you message
//             pw.Divider(color: PdfColors.grey),
//             pw.SizedBox(height: 8),
//             pw.Text(
//               'Thank you for choosing MilkMinder!',
//               style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic, color: PdfColors.black, font: ttf),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   // Save the PDF to persistent storage
//   final pdfPath = await savePdfToStorage(pdf, 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf');

//   // Open the saved PDF file
//   await openSavedPdf(pdfPath);
// }

// // Save the PDF to the app's persistent storage
// Future<String> savePdfToStorage(pw.Document pdf, String fileName) async {
//   final directory = await getApplicationDocumentsDirectory(); // Persistent directory
//   final file = File("${directory.path}/$fileName");

//   // Write the generated PDF to the file
//   await file.writeAsBytes(await pdf.save());

//   return file.path; // Return the file path
// }

// // Open the saved PDF file
// Future<void> openSavedPdf(String pdfPath) async {
//   final file = File(pdfPath);
//   if (await file.exists()) {
//     await OpenFile.open(pdfPath);  // Open the file with the default viewer
//   } else {
//     print('PDF file not found.');
//   }
// }

// // Helper function for generating table cells
// pw.Widget _buildTableCell(String text, {bool bold = false, required pw.Font font}) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(6.0),
//     child: pw.Text(
//       text,
//       style: pw.TextStyle(
//         fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
//         color: PdfColors.black,
//         font: font,
//       ),
//     ),
//   );
// }
