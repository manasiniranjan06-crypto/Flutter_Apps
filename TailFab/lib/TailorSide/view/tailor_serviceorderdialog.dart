
import 'package:firebaseauth/TailorSide/model/tailor_repari_model.dart';
import 'package:firebaseauth/TailorSide/view/tailorReparies.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceOrdersDialog extends StatelessWidget {
  final RepairService service;
  final List<RepairOrder> orders;

  const ServiceOrdersDialog({Key? key, required this.service, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${service.name} Orders',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            orders.isEmpty
                ? Text('No orders for this service')
                : SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          child: ListTile(
                            title: Text(order.customerName),
                            subtitle: Text('Status: ${order.status.name}'),
                            trailing: Text('₹${order.price}'),
                          ),
                        );
                      },
                    ),
                  ),
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
}