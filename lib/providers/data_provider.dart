import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_deck/repositories/firestore_helper.dart';
import '../models/movie_model.dart';
import '../repositories/db_helper.dart';

class DataProvider with ChangeNotifier {
  List<Movie> _items = [];
  List<Movie> _filteredItems = [];
  List<Movie> _cloudItems = [];
  int _sorted = 2;
  String _query = "";
  bool _fetch = true;

  int get isSorted => _sorted;
  bool get isFetching => _fetch;
  List<Movie> get items {
    List<Movie> dummyList = _items;
    if(_query != ""){
      dummyList = [..._filteredItems];
      if(_sorted >= 0){
        dummyList = sortItems(dummyList);
      } else {
        dummyList = [..._items.reversed];
      }
    }
    else if(_query == ""){
      if(_sorted >= 0)
        dummyList = sortItems(dummyList);
      else
        dummyList = [..._items.reversed];
    }
    return dummyList;
    // if(query == "") {
    //   if(sorted)
    //     return sortedItems;
    //   else
    //     return [..._items.reversed];
    // }
    // else {
    //   return [..._filteredItems];
    // }
  }

  void toggle(int newSort) {
    _sorted = newSort;
    print("Sort $_sorted");
    notifyListeners();
  }

  void toggleFetch(bool shouldFetch){
    _fetch = shouldFetch;
    notifyListeners();
  }

  void setCloudItems(List<Movie> cloudList) {
    _cloudItems = cloudList;
    notifyListeners();
  }

  sortItems(List<Movie> currList) {
    List<Movie> dummyList = currList;
    if(_sorted == 0){
      dummyList.sort((a, b) => a.name.compareTo(b.name));
    }
    if(_sorted == 1){
      dummyList.sort((b, a) => a.name.compareTo(b.name));
    }
    if(_sorted == 2){
      dummyList = [...currList.reversed];
    }
    return dummyList;
  }

  filterItems(String newQuery) {
    _filteredItems = [];
    _query = newQuery;
    _items.forEach((element) {
      if(element.name.contains(_query)){
        _filteredItems.add(element);
      }
    });
    notifyListeners();
  }

  Future<void> addMovie(String movieName, String directorName, String imagePath, String createdAt, String updatedAt) async {
    print("Adding movie to table $createdAt");
      final newMovie = Movie(
        name: movieName,
        director: directorName,
        createdOn: createdAt,
        updatedOn: updatedAt,
        imageUrl: imagePath,
      );
      bool isDup = _items.any((element) => element.createdOn == createdAt);
      if(isDup) {
        _items.forEach((element) {
          if(element.createdOn == createdAt){
            int index = _items.indexOf(element);
            _items[index] = newMovie;
          }
        });
      } else {
        _items.add(newMovie);
      }
      notifyListeners();
      print("ITEMS $items");
      DbHelper.createOrUpdate({
        'name': newMovie.name,
        'director': newMovie.director,
        'imageUrl': newMovie.imageUrl,
        'createdOn': newMovie.createdOn,
        'updatedOn': newMovie.updatedOn,
      });
      notifyListeners();
  }

  Future<void> deleteMovie(String movieName) async {
    print("Deleting movie from table");
    items.removeWhere((element) => element.name == movieName);
    notifyListeners();
    await DbHelper.delete(movieName);
  }

  Future<void> fetchAndSetMovie() async {
        print('DP: ${_cloudItems.length}');
        bool shouldFetch = false;
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
          shouldFetch = value.data()!["fetch"];
        });
        if(_cloudItems.length > 0 && shouldFetch) {
          _cloudItems.forEach((element) {
            DbHelper.createOrUpdate(element.toMap());
          });
          print("fetching");
        }
        final dataList = await DbHelper.read();
        print("Reading data from DbProvider: ${dataList.length} movies");
        _items = dataList.map((item) =>
            Movie(
              name: item['name'].toString(),
              director: item['director'].toString(),
              imageUrl: item['imageUrl'].toString(),
              createdOn: item['createdOn'].toString(),
              updatedOn: item['updatedOn'].toString(),
            ),).toList();
        //FirestoreHelper.toggleFetching(docId: FirebaseAuth.instance.currentUser!.uid, fetchOrNot: false);
        //toggleFetch(false);
        notifyListeners();
  }
}
