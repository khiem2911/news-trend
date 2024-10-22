import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/model/news.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uid = FirebaseAuth.instance.currentUser?.uid;

class SavedNotifier extends StateNotifier<List<News>> {
  SavedNotifier() : super([]);

  bool onAddNews(News news) {
    final newIsSaved = state.contains(news);

    if (newIsSaved) {
      state = state.where((n) => n.title != news.title).toList();
      updateState();
      return false;
    } else {
      state = [...state, news];
    }
    updateState();
    return true;
  }

  void updateState() async {
    List<Map<String, dynamic>> stateAsMapList =
        state.map((news) => news.toMap()).toList();
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'savePages': stateAsMapList,
    }).then((_) {
      print('updated complete');
    }).catchError((error) => print('update failed $error'));
  }

  Future<void> fetchNews() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List<dynamic> savedPages =
          (snapshot.data() as Map<String, dynamic>?)?['savePages'] ?? [];

      state = savedPages.map((data) => News.fromMap(data)).toList();
    } catch (error) {
      print('Failed to fetch news: $error');
    }
  }
}

final SavedProvider = StateNotifierProvider<SavedNotifier, List<News>>((ref) {
  return SavedNotifier();
});
