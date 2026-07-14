// lib/TailorSide/model/tailor_order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  rejected,
}

class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String customerId;
  final String tailorId;
  final String tailorName;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final List<OrderItem> items;
  final double totalAmount;
  OrderStatus status;
  String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerId,
    required this.tailorId,
    required this.tailorName,
    required this.orderDate,
    required this.deliveryDate,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  // Convert Firestore document to Order object
  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Order(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      customerId: data['customerId'] ?? '',
      tailorId: data['tailorId'] ?? '',
      tailorName: data['tailorName'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
      items: List<OrderItem>.from((data['items'] as List).map((item) => OrderItem.fromMap(item))),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: _parseOrderStatus(data['status'] ?? 'pending'),
      rejectionReason: data['rejectionReason'],
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  static OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'rejected':
        return OrderStatus.rejected;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  // Convert OrderStatus to string for Firestore
  String get statusString {
    switch (status) {
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.rejected:
        return 'rejected';
      case OrderStatus.pending:
      default:
        return 'pending';
    }
  }
}

class OrderItem {
  final String garmentType;
  final Map<String, String> measurements;
  final String fabric;
  final String color;
  final String specialInstructions;
  final int quantity;
  final double price;

  OrderItem({
    required this.garmentType,
    required this.measurements,
    required this.fabric,
    required this.color,
    required this.specialInstructions,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      garmentType: data['garmentType'] ?? '',
      fabric: data['fabric'] ?? '',
      color: data['color'] ?? '',
      quantity: data['quantity'] ?? 1,
      price: (data['price'] as num).toDouble(),
      measurements: Map<String, String>.from(data['measurements'] ?? {}),
      specialInstructions: data['specialInstructions'] ?? '',
    );
  }
}