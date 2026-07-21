// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class ChatScreen extends StatefulWidget {
//   final String currentUser; // "Sender" or "Receiver"
//   final String? receiverName;
//   final String? receiverImage;
//   final String? receiverId;
  
//   const ChatScreen({
//     Key? key,
//     required this.currentUser,
//     this.receiverName,
//     this.receiverImage,
//     this.receiverId,
//   }) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ScrollController _scrollController = ScrollController();
//   bool _isTyping = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() async {
//     if (_controller.text.trim().isEmpty) return;

//     final messageText = _controller.text.trim();
//     _controller.clear();
//     setState(() => _isTyping = false);

//     await _firestore.collection('messages').add({
//       'sender': widget.currentUser,
//       'text': messageText,
//       'timestamp': FieldValue.serverTimestamp(),
//       'receiverId': widget.receiverId,
//       'read': false,
//     });

//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       });
//     }
//   }

//   String _formatTime(Timestamp? timestamp) {
//     if (timestamp == null) return '';
//     final dateTime = timestamp.toDate();
//     final now = DateTime.now();
//     final diff = now.difference(dateTime);

//     if (diff.inDays == 0) {
//       return DateFormat('h:mm a').format(dateTime);
//     } else if (diff.inDays == 1) {
//       return 'Yesterday ${DateFormat('h:mm a').format(dateTime)}';
//     } else if (diff.inDays < 7) {
//       return DateFormat('EEE h:mm a').format(dateTime);
//     } else {
//       return DateFormat('MMM d, h:mm a').format(dateTime);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: _buildAppBar(isTablet),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: const Color(0xFF8075FF),
//                     ),
//                   );
//                 }

//                 final messages = snapshot.data!.docs;

//                 if (messages.isEmpty) {
//                   return _buildEmptyState();
//                 }

//                 // Scroll to bottom when new messages arrive
//                 WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.all(isTablet ? 20 : 16),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index].data() as Map<String, dynamic>;
//                     final isMe = msg['sender'] == widget.currentUser;
//                     final timestamp = msg['timestamp'] as Timestamp?;
                    
//                     // Show date separator
//                     bool showDateSeparator = false;
//                     if (index == 0 || _shouldShowDateSeparator(messages, index)) {
//                       showDateSeparator = true;
//                     }

//                     return Column(
//                       children: [
//                         if (showDateSeparator) _buildDateSeparator(timestamp),
//                         _buildMessageBubble(msg, isMe, timestamp, isTablet),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(isTablet),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(bool isTablet) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: const Color(0xFF8075FF),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Row(
//         children: [
//           Container(
//             width: isTablet ? 48 : 40,
//             height: isTablet ? 48 : 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//               image: widget.receiverImage != null
//                   ? DecorationImage(
//                       image: NetworkImage(widget.receiverImage!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: widget.receiverImage == null
//                 ? Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: isTablet ? 28 : 24,
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.receiverName ?? 
//                       (widget.currentUser == "Sender" ? "Tailor" : "Customer"),
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: isTablet ? 18 : 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Active now',
//                   style: GoogleFonts.poppins(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: isTablet ? 13 : 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.videocam, color: Colors.white),
//           onPressed: () => _showSnackBar('Video call feature coming soon'),
//         ),
//         IconButton(
//           icon: const Icon(Icons.call, color: Colors.white),
//           onPressed: () => _showSnackBar('Voice call feature coming soon'),
//         ),
//         PopupMenuButton<String>(
//           icon: const Icon(Icons.more_vert, color: Colors.white),
//           onSelected: (value) {
//             switch (value) {
//               case 'clear':
//                 _showClearChatDialog();
//                 break;
//               case 'block':
//                 _showSnackBar('Block feature coming soon');
//                 break;
//               case 'report':
//                 _showSnackBar('Report feature coming soon');
//                 break;
//             }
//           },
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               value: 'clear',
//               child: Row(
//                 children: [
//                   const Icon(Icons.delete_outline, size: 20),
//                   const SizedBox(width: 12),
//                   Text('Clear Chat', style: GoogleFonts.poppins(fontSize: 14)),
//                 ],
//               ),
//             ),
//             PopupMenuItem(
//               value: 'block',
//               child: Row(
//                 children: [
//                   const Icon(Icons.block, size: 20, color: Colors.red),
//                   const SizedBox(width: 12),
//                   Text('Block User', style: GoogleFonts.poppins(fontSize: 14, color: Colors.red)),
//                 ],
//               ),
//             ),
//             PopupMenuItem(
//               value: 'report',
//               child: Row(
//                 children: [
//                   const Icon(Icons.report_outlined, size: 20, color: Colors.orange),
//                   const SizedBox(width: 12),
//                   Text('Report', style: GoogleFonts.poppins(fontSize: 14, color: Colors.orange)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(30),
//             decoration: BoxDecoration(
//               color: const Color(0xFF8075FF).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.chat_bubble_outline,
//               size: 80,
//               color: const Color(0xFF8075FF).withOpacity(0.5),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Start Conversation',
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Send a message to begin chatting',
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _shouldShowDateSeparator(List<QueryDocumentSnapshot> messages, int index) {
//     if (index == 0) return true;
    
//     final currentMsg = messages[index].data() as Map<String, dynamic>;
//     final previousMsg = messages[index - 1].data() as Map<String, dynamic>;
    
//     final currentTime = currentMsg['timestamp'] as Timestamp?;
//     final previousTime = previousMsg['timestamp'] as Timestamp?;
    
//     if (currentTime == null || previousTime == null) return false;
    
//     final currentDate = currentTime.toDate();
//     final previousDate = previousTime.toDate();
    
//     return currentDate.day != previousDate.day ||
//            currentDate.month != previousDate.month ||
//            currentDate.year != previousDate.year;
//   }

//   Widget _buildDateSeparator(Timestamp? timestamp) {
//     if (timestamp == null) return const SizedBox.shrink();
    
//     final date = timestamp.toDate();
//     final now = DateTime.now();
//     final diff = now.difference(date);
    
//     String dateText;
//     if (diff.inDays == 0) {
//       dateText = 'Today';
//     } else if (diff.inDays == 1) {
//       dateText = 'Yesterday';
//     } else if (diff.inDays < 7) {
//       dateText = DateFormat('EEEE').format(date);
//     } else {
//       dateText = DateFormat('MMM d, yyyy').format(date);
//     }
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           Expanded(child: Divider(color: Colors.grey[300])),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 dateText,
//                 style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   color: Colors.grey[700],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(child: Divider(color: Colors.grey[300])),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(
//     Map<String, dynamic> msg,
//     bool isMe,
//     Timestamp? timestamp,
//     bool isTablet,
//   ) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * (isTablet ? 0.5 : 0.75),
//         ),
//         child: Column(
//           crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: isMe
//                     ? const LinearGradient(
//                         colors: [Color(0xFF8075FF), Color(0xFF9D8FFF)],
//                       )
//                     : null,
//                 color: isMe ? null : Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(20),
//                   topRight: const Radius.circular(20),
//                   bottomLeft: Radius.circular(isMe ? 20 : 4),
//                   bottomRight: Radius.circular(isMe ? 4 : 20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (!isMe)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         msg['sender'] ?? 'Unknown',
//                         style: GoogleFonts.poppins(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFF8075FF),
//                         ),
//                       ),
//                     ),
//                   Text(
//                     msg['text'] ?? '',
//                     style: GoogleFonts.poppins(
//                       fontSize: isTablet ? 15 : 14,
//                       color: isMe ? Colors.white : Colors.black87,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     _formatTime(timestamp),
//                     style: GoogleFonts.poppins(
//                       fontSize: 11,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                   if (isMe) ...[
//                     const SizedBox(width: 4),
//                     Icon(
//                       msg['read'] == true ? Icons.done_all : Icons.done,
//                       size: 14,
//                       color: msg['read'] == true
//                           ? const Color(0xFF8075FF)
//                           : Colors.grey[500],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput(bool isTablet) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: const Color(0xFF8075FF),
//                 size: isTablet ? 32 : 28,
//               ),
//               onPressed: () => _showAttachmentOptions(),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: TextField(
//                   controller: _controller,
//                   maxLines: null,
//                   textCapitalization: TextCapitalization.sentences,
//                   style: GoogleFonts.poppins(
//                     fontSize: isTablet ? 15 : 14,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: "Type a message...",
//                     hintStyle: GoogleFonts.poppins(
//                       color: Colors.grey[400],
//                       fontSize: isTablet ? 15 : 14,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                   ),
//                   onChanged: (text) {
//                     setState(() => _isTyping = text.trim().isNotEmpty);
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             _isTyping
//                 ? Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF8075FF), Color(0xFF9D8FFF)],
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.send,
//                         color: Colors.white,
//                         size: isTablet ? 24 : 22,
//                       ),
//                       onPressed: _sendMessage,
//                     ),
//                   )
//                 : Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.camera_alt,
//                           color: const Color(0xFF8075FF),
//                           size: isTablet ? 28 : 24,
//                         ),
//                         onPressed: () => _showSnackBar('Camera feature coming soon'),
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           Icons.mic,
//                           color: const Color(0xFF8075FF),
//                           size: isTablet ? 28 : 24,
//                         ),
//                         onPressed: () => _showSnackBar('Voice message coming soon'),
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAttachmentOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 60,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Share',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _attachmentOption(Icons.photo_library, 'Gallery', Colors.purple),
//                 _attachmentOption(Icons.camera_alt, 'Camera', Colors.pink),
//                 _attachmentOption(Icons.insert_drive_file, 'Document', Colors.blue),
//                 _attachmentOption(Icons.location_on, 'Location', Colors.green),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _attachmentOption(IconData icon, String label, Color color) {
//     return InkWell(
//       onTap: () {
//         Navigator.pop(context);
//         _showSnackBar('$label feature coming soon');
//       },
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showClearChatDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(
//           'Clear Chat?',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to clear all messages? This action cannot be undone.',
//           style: GoogleFonts.poppins(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.poppins(color: Colors.grey),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               // Delete all messages
//               final messages = await _firestore.collection('messages').get();
//               for (var doc in messages.docs) {
//                 await doc.reference.delete();
//               }
//               _showSnackBar('Chat cleared');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               'Clear',
//               style: GoogleFonts.poppins(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: GoogleFonts.poppins(),
//         ),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: const Color(0xFF8075FF),
//         duration: const Duration(seconds: 2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
// }

// // Sender Screen
// class SenderScreen extends StatelessWidget {
//   const SenderScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const ChatScreen(
//       currentUser: "Sender",
//       receiverName: "Fashion Hub Tailor",
//       receiverImage: "https://images.unsplash.com/photo-1556906781-9a412961c28c?w=500",
//       receiverId: "tailor_123",
//     );
//   }
// }

// // Receiver Screen
// class ReceiverScreen extends StatelessWidget {
//   const ReceiverScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const ChatScreen(
//       currentUser: "Receiver",
//       receiverName: "John Customer",
//       receiverImage: "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500",
//       receiverId: "customer_456",
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String currentUser;
  final String? receiverName;
  final String? receiverImage;
  final String? receiverId;
  final String? chatId;
  
  const ChatScreen({
    Key? key,
    required this.currentUser,
    this.receiverName,
    this.receiverImage,
    this.receiverId,
    this.chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isTyping = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() async {
    final messages = await _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: widget.currentUser)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({'read': true});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({
    String? text,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
    String? fileType,
    Map<String, dynamic>? location,
    String? localImagePath,
    List<int>? fileBytes,
  }) async {
    if (text == null && imageUrl == null && fileUrl == null && location == null && localImagePath == null && fileBytes == null) return;

    final messageData = {
      'senderId': widget.currentUser,
      'text': text,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
      'location': location,
      'localImagePath': localImagePath,
      'fileBytes': fileBytes,
      'timestamp': FieldValue.serverTimestamp(),
      'receiverId': widget.receiverId,
      'read': false,
      'messageType': _getMessageType(text, imageUrl, fileUrl, location, localImagePath, fileBytes),
    };

    await _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(messageData);

    // Update last message in chat document
    await _firestore.collection('chats').doc(widget.chatId).update({
      'lastMessage': text ?? (imageUrl != null || localImagePath != null ? '📷 Image' : (fileUrl != null || fileBytes != null ? '📄 Document' : '📍 Location')),
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    });

    _scrollToBottom();
  }

  String _getMessageType(
    String? text, 
    String? imageUrl, 
    String? fileUrl, 
    Map<String, dynamic>? location,
    String? localImagePath,
    List<int>? fileBytes,
  ) {
    if (imageUrl != null || localImagePath != null) return 'image';
    if (fileUrl != null || fileBytes != null) return 'file';
    if (location != null) return 'location';
    return 'text';
  }

  Future<void> _sendTextMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final messageText = _controller.text.trim();
    _controller.clear();
    setState(() => _isTyping = false);

    await _sendMessage(text: messageText);
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        await _sendLocalImage(File(image.path));
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _takeAndSendPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (image != null) {
        await _sendLocalImage(File(image.path));
      }
    } catch (e) {
      _showSnackBar('Failed to take photo: $e');
    }
  }

  Future<void> _sendLocalImage(File imageFile) async {
    setState(() => _isUploading = true);

    try {
      // Convert image to bytes and store directly in Firestore
      final imageBytes = await imageFile.readAsBytes();
      
      await _sendMessage(
        localImagePath: imageFile.path,
        fileBytes: imageBytes,
      );
    } catch (e) {
      _showSnackBar('Failed to send image: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickAndSendDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await _sendLocalDocument(File(result.files.single.path!), result.files.single);
      }
    } catch (e) {
      _showSnackBar('Failed to pick document: $e');
    }
  }

  Future<void> _sendLocalDocument(File file, PlatformFile platformFile) async {
    setState(() => _isUploading = true);

    try {
      // Convert file to bytes and store directly in Firestore
      final fileBytes = await file.readAsBytes();
      
      await _sendMessage(
        fileName: platformFile.name,
        fileType: platformFile.extension,
        fileBytes: fileBytes,
      );
    } catch (e) {
      _showSnackBar('Failed to send document: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _sendLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        return;
      }

      _showSnackBar('Getting your location...');

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': 'Current Location',
      };

      await _sendMessage(location: locationData);
    } catch (e) {
      _showSnackBar('Failed to get location: $e');
    }
  }

  void _openLocation(Map<String, dynamic> location) async {
    final String url = 'https://www.google.com/maps/search/?api=1&query=${location['latitude']},${location['longitude']}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar('Could not open maps');
    }
  }

  void _initiateVideoCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          currentUser: widget.currentUser,
          receiverName: widget.receiverName,
          receiverImage: widget.receiverImage,
          isVideoCall: true,
        ),
      ),
    );
  }

  void _initiateVoiceCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          currentUser: widget.currentUser,
          receiverName: widget.receiverName,
          receiverImage: widget.receiverImage,
          isVideoCall: false,
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(isTablet),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF8075FF),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return _buildEmptyState();
                }

                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == widget.currentUser;
                    final timestamp = msg['timestamp'] as Timestamp?;
                    final messageType = msg['messageType'] ?? 'text';
                    
                    bool showDateSeparator = false;
                    if (index == 0 || _shouldShowDateSeparator(messages, index)) {
                      showDateSeparator = true;
                    }

                    return Column(
                      children: [
                        if (showDateSeparator) _buildDateSeparator(timestamp),
                        _buildMessageBubble(msg, isMe, timestamp, messageType, isTablet),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          if (_isUploading) _buildUploadingIndicator(),
          _buildMessageInput(isTablet),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isTablet) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF8075FF),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: isTablet ? 48 : 40,
            height: isTablet ? 48 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: widget.receiverImage != null
                  ? DecorationImage(
                      image: NetworkImage(widget.receiverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.receiverImage == null
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                    size: isTablet ? 28 : 24,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName ?? 
                      (widget.currentUser == "Sender" ? "Tailor" : "Customer"),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Active now',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: isTablet ? 13 : 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white),
          onPressed: _initiateVideoCall,
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          onPressed: _initiateVoiceCall,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            switch (value) {
              case 'clear':
                _showClearChatDialog();
                break;
              case 'block':
                _showSnackBar('Block feature coming soon');
                break;
              case 'report':
                _showSnackBar('Report feature coming soon');
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 20),
                  const SizedBox(width: 12),
                  Text('Clear Chat', style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  const Icon(Icons.block, size: 20, color: Colors.red),
                  const SizedBox(width: 12),
                  Text('Block User', style: GoogleFonts.poppins(fontSize: 14, color: Colors.red)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  const Icon(Icons.report_outlined, size: 20, color: Colors.orange),
                  const SizedBox(width: 12),
                  Text('Report', style: GoogleFonts.poppins(fontSize: 14, color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF8075FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: const Color(0xFF8075FF).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Start Conversation',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to begin chatting',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDateSeparator(List<QueryDocumentSnapshot> messages, int index) {
    if (index == 0) return true;
    
    final currentMsg = messages[index].data() as Map<String, dynamic>;
    final previousMsg = messages[index - 1].data() as Map<String, dynamic>;
    
    final currentTime = currentMsg['timestamp'] as Timestamp?;
    final previousTime = previousMsg['timestamp'] as Timestamp?;
    
    if (currentTime == null || previousTime == null) return false;
    
    final currentDate = currentTime.toDate();
    final previousDate = previousTime.toDate();
    
    return currentDate.day != previousDate.day ||
           currentDate.month != previousDate.month ||
           currentDate.year != previousDate.year;
  }

  Widget _buildDateSeparator(Timestamp? timestamp) {
    if (timestamp == null) return const SizedBox.shrink();
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    
    String dateText;
    if (diff.inDays == 0) {
      dateText = 'Today';
    } else if (diff.inDays == 1) {
      dateText = 'Yesterday';
    } else if (diff.inDays < 7) {
      dateText = DateFormat('EEEE').format(date);
    } else {
      dateText = DateFormat('MMM d, yyyy').format(date);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dateText,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    Map<String, dynamic> msg,
    bool isMe,
    Timestamp? timestamp,
    String messageType,
    bool isTablet,
  ) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * (isTablet ? 0.5 : 0.75),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                gradient: isMe
                    ? const LinearGradient(
                        colors: [Color(0xFF8075FF), Color(0xFF9D8FFF)],
                      )
                    : null,
                color: isMe ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildMessageContent(msg, messageType, isMe, isTablet),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(timestamp),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      msg['read'] == true ? Icons.done_all : Icons.done,
                      size: 14,
                      color: msg['read'] == true
                          ? const Color(0xFF8075FF)
                          : Colors.grey[500],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> msg, String messageType, bool isMe, bool isTablet) {
    switch (messageType) {
      case 'image':
        return _buildImageMessage(msg, isMe);
      case 'file':
        return _buildFileMessage(msg, isMe);
      case 'location':
        return _buildLocationMessage(msg, isMe);
      default:
        return _buildTextMessage(msg, isMe, isTablet);
    }
  }

  Widget _buildTextMessage(Map<String, dynamic> msg, bool isMe, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                msg['senderId'] ?? 'Unknown',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8075FF),
                ),
              ),
            ),
          Text(
            msg['text'] ?? '',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 15 : 14,
              color: isMe ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(Map<String, dynamic> msg, bool isMe) {
    // Check if it's a local image or network image
    final bool isLocalImage = msg['localImagePath'] != null;
    final String imageSource = isLocalImage ? msg['localImagePath'] : msg['imageUrl'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(
              imageSource: imageSource,
              isLocalImage: isLocalImage,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8),
                child: Text(
                  msg['senderId'] ?? 'Unknown',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8075FF),
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLocalImage
                  ? Image.file(
                      File(imageSource),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImageError(),
                    )
                  : Image.network(
                      imageSource,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildImageLoading();
                      },
                      errorBuilder: (context, error, stackTrace) => _buildImageError(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoading() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF8075FF),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.grey[500], size: 40),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(Map<String, dynamic> msg, bool isMe) {
    final bool isLocalFile = msg['fileBytes'] != null;
    
    return GestureDetector(
      onTap: () {
        if (isLocalFile) {
          _showLocalFileOptions(msg);
        } else {
          _launchFileUrl(msg['fileUrl']);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  msg['senderId'] ?? 'Unknown',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8075FF),
                  ),
                ),
              ),
            Row(
              children: [
                Icon(
                  _getFileIcon(msg['fileType']),
                  color: isMe ? Colors.white : const Color(0xFF8075FF),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['fileName'] ?? 'Document',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isMe ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${msg['fileType']?.toString().toUpperCase() ?? 'FILE'} • Tap to ${isLocalFile ? 'view' : 'download'}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocalFileOptions(Map<String, dynamic> msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('File Options', style: GoogleFonts.poppins()),
        content: Text('What would you like to do with "${msg['fileName'] ?? 'the file'}"?', 
          style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('File saved to device');
              // Here you could implement actual file saving logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8075FF),
            ),
            child: Text('Save File', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchFileUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar('Cannot open file');
    }
  }

  Widget _buildLocationMessage(Map<String, dynamic> msg, bool isMe) {
    final location = msg['location'] ?? {};
    return GestureDetector(
      onTap: () => _openLocation(location),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  msg['senderId'] ?? 'Unknown',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8075FF),
                  ),
                ),
              ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Shared',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isMe ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Tap to view on maps',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String? fileType) {
    if (fileType == null) return Icons.insert_drive_file;
    
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildUploadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: const Color(0xFF8075FF),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Sending...',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: const Color(0xFF8075FF),
                size: isTablet ? 32 : 28,
              ),
              onPressed: _showAttachmentOptions,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 15 : 14,
                  ),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: isTablet ? 15 : 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (text) {
                    setState(() => _isTyping = text.trim().isNotEmpty);
                  },
                  onSubmitted: (text) => _sendTextMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _isTyping
                ? Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8075FF), Color(0xFF9D8FFF)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: isTablet ? 24 : 22,
                      ),
                      onPressed: _sendTextMessage,
                    ),
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: const Color(0xFF8075FF),
                          size: isTablet ? 28 : 24,
                        ),
                        onPressed: _takeAndSendPhoto,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: const Color(0xFF8075FF),
                          size: isTablet ? 28 : 24,
                        ),
                        onPressed: () => _showSnackBar('Voice message coming soon'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Share',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachmentOption(Icons.photo_library, 'Gallery', Colors.purple, _pickAndSendImage),
                _attachmentOption(Icons.camera_alt, 'Camera', Colors.pink, _takeAndSendPhoto),
                _attachmentOption(Icons.insert_drive_file, 'Document', Colors.blue, _pickAndSendDocument),
                _attachmentOption(Icons.location_on, 'Location', Colors.green, _sendLocation),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _attachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear Chat?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all messages? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final messages = await _firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .get();
              for (var doc in messages.docs) {
                await doc.reference.delete();
              }
              _showSnackBar('Chat cleared');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8075FF),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Full Screen Image Viewer
class FullScreenImage extends StatelessWidget {
  final String imageSource;
  final bool isLocalImage;

  const FullScreenImage({
    Key? key,
    required this.imageSource,
    required this.isLocalImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: isLocalImage
              ? Image.file(File(imageSource), fit: BoxFit.contain)
              : Image.network(imageSource, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// Video/Voice Call Screen
class VideoCallScreen extends StatefulWidget {
  final String currentUser;
  final String? receiverName;
  final String? receiverImage;
  final bool isVideoCall;

  const VideoCallScreen({
    Key? key,
    required this.currentUser,
    this.receiverName,
    this.receiverImage,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isVideoOn = true;
  bool _isFrontCamera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: widget.receiverImage != null
                            ? DecorationImage(
                                image: NetworkImage(widget.receiverImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[800],
                      ),
                      child: widget.receiverImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.receiverName ?? 'Unknown',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isVideoCall ? 'Video Call' : 'Voice Call',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callControlButton(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  _isMuted ? Colors.red : Colors.white,
                  () => setState(() => _isMuted = !_isMuted),
                ),

                if (widget.isVideoCall)
                  _callControlButton(
                    _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    _isSpeakerOn ? Colors.white : Colors.grey,
                    () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                  ),

                if (widget.isVideoCall)
                  _callControlButton(
                    _isVideoOn ? Icons.videocam : Icons.videocam_off,
                    _isVideoOn ? Colors.white : Colors.red,
                    () => setState(() => _isVideoOn = !_isVideoOn),
                  ),

                _callControlButton(
                  Icons.call_end,
                  Colors.red,
                  () => Navigator.pop(context),
                  isEndCall: true,
                ),
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callControlButton(IconData icon, Color color, VoidCallback onTap, {bool isEndCall = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isEndCall ? 70 : 60,
        height: isEndCall ? 70 : 60,
        decoration: BoxDecoration(
          color: isEndCall ? Colors.red : Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: isEndCall ? null : Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: color, size: isEndCall ? 30 : 24),
      ),
    );
  }
}

// Database Helper
class ChatDatabase {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> getOrCreateChat(String user1, String user2) async {
    final chats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: user1)
        .get();

    for (var chat in chats.docs) {
      final participants = List<String>.from(chat['participants']);
      if (participants.contains(user2)) {
        return chat.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'participants': [user1, user2],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': 0,
    });

    return newChat.id;
  }

  static Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  static Future<void> markMessagesAsRead(String chatId, String userId) async {
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({'read': true});
    }

    await _firestore.collection('chats').doc(chatId).update({
      'unreadCount': 0,
    });
  }
}