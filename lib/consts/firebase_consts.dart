import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;
//collection
const usersCollection = "users";
const productsCollection = "products";
const cartCollection = "cart";
const chatsCollection = "chats";
const messagesCollection = "messages";
const ordersCollection = "orders";

// ignore: deprecated_member_use
final DatabaseReference timerRef =
    FirebaseDatabase.instance.reference().child('timer');
