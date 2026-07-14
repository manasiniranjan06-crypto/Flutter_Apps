// repositories/alteration_repository.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/TailorSide/model/alternationpage.dart';

class AlterationRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AlterationRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Get all alteration services
  Future<List<AlterationService>> getAlterationServices({String? category}) async {
    try {
      Query query = _firestore
          .collection('alteration_services')
          .where('isActive', isEqualTo: true);

      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      final querySnapshot = await query.orderBy('popularity', descending: true).get();

      if (querySnapshot.docs.isEmpty) {
        return _getDefaultServices();
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AlterationService(
          id: doc.id,
          name: data['name'] ?? 'Alteration Service',
          description: data['description'] ?? 'Professional alteration service',
          price: (data['price'] ?? 0.0).toDouble(),
          image: data['image'] ?? 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
          category: data['category'] ?? 'General',
          duration: data['duration'] ?? '3-5 days',
          rating: (data['rating'] ?? 4.5).toDouble(),
          reviewCount: data['reviewCount'] ?? 0,
          features: List<String>.from(data['features'] ?? ['Professional service', 'Quality guarantee']),
          isPopular: data['isPopular'] ?? false,
        );
      }).toList();
    } catch (e) {
      return _getDefaultServices();
    }
  }

  // Get alteration categories
  Future<List<AlterationCategory>> getAlterationCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('alteration_categories')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      if (querySnapshot.docs.isEmpty) {
        return _getDefaultCategories();
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AlterationCategory(
          id: doc.id,
          name: data['name'] ?? 'Category',
          icon: data['icon'] ?? '👖',
          serviceCount: data['serviceCount'] ?? 0,
        );
      }).toList();
    } catch (e) {
      return _getDefaultCategories();
    }
  }

  // Get alteration requests for tailor
  Stream<List<AlterationRequest>> getAlterationRequests() {
    final tailorId = _auth.currentUser?.uid;
    if (tailorId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('alteration_requests')
        .where('tailorId', isEqualTo: tailorId)
        .orderBy('requestDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AlterationRequest(
          id: doc.id,
          serviceId: data['serviceId'] ?? '',
          customerName: data['customerName'] ?? 'Customer',
          customerImage: data['customerImage'] ?? 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
          serviceName: data['serviceName'] ?? 'Alteration Service',
          requestDate: (data['requestDate'] as Timestamp).toDate(),
          status: data['status'] ?? 'pending',
          description: data['description'] ?? '',
          images: List<String>.from(data['images'] ?? []),
          measurements: data['measurements'] ?? '',
          specialInstructions: data['specialInstructions'] ?? '',
          quotedPrice: (data['quotedPrice'] ?? 0.0).toDouble(),
          deadline: data['deadline'] != null ? (data['deadline'] as Timestamp).toDate() : null,
        );
      }).toList();
    });
  }

  // Update request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('alteration_requests').doc(requestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  // Add price quote to request
  Future<void> addPriceQuote(String requestId, double price, String notes) async {
    try {
      await _firestore.collection('alteration_requests').doc(requestId).update({
        'quotedPrice': price,
        'tailorNotes': notes,
        'status': 'quoted',
        'quotedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add price quote: $e');
    }
  }

  // Default data
  List<AlterationService> _getDefaultServices() {
    return [
      AlterationService(
        id: '1',
        name: 'Pant Length Adjustment',
        description: 'Professional pant length alteration for perfect fit',
        price: 15.0,
        image: 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
        category: 'Pants',
        duration: '2-3 days',
        rating: 4.8,
        reviewCount: 45,
        features: ['Length adjustment', 'Original hem preserved', 'Professional finish'],
        isPopular: true,
      ),
      AlterationService(
        id: '2',
        name: 'Shirt Fitting',
        description: 'Custom shirt fitting and adjustments for perfect fit',
        price: 25.0,
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        category: 'Shirts',
        duration: '3-4 days',
        rating: 4.9,
        reviewCount: 38,
        features: ['Sleeve adjustment', 'Body fitting', 'Collar work'],
        isPopular: true,
      ),
      AlterationService(
        id: '3',
        name: 'Dress Hemming',
        description: 'Professional dress length adjustment',
        price: 35.0,
        image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        category: 'Dresses',
        duration: '4-5 days',
        rating: 4.7,
        reviewCount: 52,
        features: ['Length adjustment', 'Lining work', 'Professional finish'],
        isPopular: false,
      ),
      AlterationService(
        id: '4',
        name: 'Suit Alterations',
        description: 'Complete suit fitting and customization',
        price: 85.0,
        image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
        category: 'Suits',
        duration: '5-7 days',
        rating: 5.0,
        reviewCount: 28,
        features: ['Jacket fitting', 'Pant adjustment', 'Complete customization'],
        isPopular: true,
      ),
      AlterationService(
        id: '5',
        name: 'Zipper Replacement',
        description: 'Professional zipper replacement service',
        price: 20.0,
        image: 'https://images.unsplash.com/photo-1586367579637-87db200e5b0e',
        category: 'Repairs',
        duration: '1-2 days',
        rating: 4.6,
        reviewCount: 34,
        features: ['Zipper replacement', 'Color matching', 'Quick service'],
        isPopular: false,
      ),
      AlterationService(
        id: '6',
        name: 'Waist Adjustment',
        description: 'Professional waist size adjustment',
        price: 30.0,
        image: 'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3',
        category: 'Pants',
        duration: '3-4 days',
        rating: 4.7,
        reviewCount: 41,
        features: ['Waist adjustment', 'Original finish', 'Perfect fit'],
        isPopular: true,
      ),
    ];
  }

  List<AlterationCategory> _getDefaultCategories() {
    return [
      AlterationCategory(id: '1', name: 'All', icon: '👕', serviceCount: 12),
      AlterationCategory(id: '2', name: 'Pants', icon: '👖', serviceCount: 4),
      AlterationCategory(id: '3', name: 'Shirts', icon: '👔', serviceCount: 3),
      AlterationCategory(id: '4', name: 'Dresses', icon: '👗', serviceCount: 3),
      AlterationCategory(id: '5', name: 'Suits', icon: '🥼', serviceCount: 2),
      AlterationCategory(id: '6', name: 'Repairs', icon: '🪡', serviceCount: 5),
    ];
  }
}