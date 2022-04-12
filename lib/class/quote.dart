import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Quote {
  Quote(DocumentSnapshot doc) {
    title = doc['title'];
    content = doc['content'];
    updatedAt = DateFormat('yyyy/MM/dd H:m:s').format(doc['updated_at'].toDate().toLocal());
  }
  late String title, content, updatedAt;
}
