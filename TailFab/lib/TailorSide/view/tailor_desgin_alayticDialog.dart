import 'package:firebaseauth/TailorSide/model/tailor_designService_model.dart';
import 'package:firebaseauth/TailorSide/view/tailor_desginServ_mange.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DesignAnalyticsDialog extends StatelessWidget {
  final double totalEarnings;
  final int activeProjects;
  final int completedProjects;
  final List<DesignService> services;
  final List<DesignPortfolio> portfolioItems;

  const DesignAnalyticsDialog({
    Key? key,
    required this.totalEarnings,
    required this.activeProjects,
    required this.completedProjects,
    required this.services,
    required this.portfolioItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalProjects = activeProjects + completedProjects;
    final completionRate = totalProjects > 0 ? ((completedProjects / totalProjects) * 100).round() : 0;
    final averagePrice = _calculateAveragePrice();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Design Studio Analytics',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildAnalyticsItem('Total Revenue', '₹$totalEarnings', Icons.attach_money),
            _buildAnalyticsItem('Active Projects', '$activeProjects', Icons.assignment),
            _buildAnalyticsItem('Completed Projects', '$completedProjects', Icons.check_circle),
            _buildAnalyticsItem('Completion Rate', '$completionRate%', Icons.trending_up),
            _buildAnalyticsItem('Design Services', '${services.length}', Icons.palette),
            _buildAnalyticsItem('Portfolio Items', '${portfolioItems.length}', Icons.photo_library),
            _buildAnalyticsItem('Avg. Service Price', '₹${averagePrice.toStringAsFixed(2)}', Icons.trending_up),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8075FF),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF8075FF)),
      title: Text(title),
      trailing: Text(
        value,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Color(0xFF8075FF),
        ),
      ),
    );
  }

  double _calculateAveragePrice() {
    if (services.isEmpty) return 0.0;
    final total = services.map((s) => s.startingPrice).reduce((a, b) => a + b);
    return total / services.length;
  }
}

// Add similar dialog implementations for AddDesignServiceDialog, EditDesignServiceDialog, 
// AllDesignProjectsDialog, ServiceDesignProjectsDialog following the same pattern as repair screen
