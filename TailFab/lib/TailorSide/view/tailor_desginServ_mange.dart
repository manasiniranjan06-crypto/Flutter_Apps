import 'package:firebaseauth/TailorSide/model/tailor_designService_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Supporting Dialog Widgets (Add these similar to the repair screen implementation)
class DesignServiceManagementSheet extends StatelessWidget {
  final DesignService service;
  final VoidCallback onEdit;
  final VoidCallback onViewProjects;
  final VoidCallback onUpdatePrice;
  final VoidCallback onAddToPortfolio;
  final VoidCallback onDelete;

  const DesignServiceManagementSheet({
    Key? key,
    required this.service,
    required this.onEdit,
    required this.onViewProjects,
    required this.onUpdatePrice,
    required this.onAddToPortfolio,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Manage Design Service',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit, color: Color(0xFF8075FF)),
                  title: Text('Edit Service Details'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment, color: Colors.blue),
                  title: Text('View Service Projects'),
                  onTap: () {
                    Navigator.pop(context);
                    onViewProjects();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.green),
                  title: Text('Update Pricing'),
                  onTap: () {
                    Navigator.pop(context);
                    onUpdatePrice();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.purple),
                  title: Text('Add to Portfolio'),
                  onTap: () {
                    Navigator.pop(context);
                    onAddToPortfolio();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.orange),
                  title: Text('Service Analytics'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Service', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
