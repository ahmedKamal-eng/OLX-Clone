
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String userName;
  final String userNumber;
  final String description;
  final String itemModel;
  final String itemColor;
  final String itemPrice;
  final String address;
  final String imgPro;
  final List<String> userImages;
  final double lat;
  final double lng;
  final String postId;
  final String status;
  final DateTime time;

  Product({
    required this.id,
    required this.userName,
    required this.userNumber,
    required this.description,
    required this.itemModel,
    required this.itemColor,
    required this.itemPrice,
    required this.address,
    required this.imgPro,
    required this.userImages,
    required this.postId,
    required this.lat,
    required this.lng,
    required this.status,
    required this.time,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: data['id'],
      userName: data['userName'],
      userNumber: data['userNumber'],
      description: data['description'],
      itemModel: data['itemModel'],
      itemColor: data['itemColor'],
      itemPrice: data['itemPrice'],
      address: data['address'],
      imgPro: data['imgPro'],
      userImages: [data['userImage1'],data['userImage2'],data['userImage3'],data['userImage4'],data['userImage5']],
      postId: data['postId'],
      lat: data['lat'],
      lng: data['lng'],
      status: data['status'],
      time: (data['time'] as Timestamp).toDate(),
    );
  }
}