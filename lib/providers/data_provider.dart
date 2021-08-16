import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import 'db_provider.dart';

class DataProvider with ChangeNotifier {
  List<Movie> _items = [];
  List<Movie> _filteredItems = [];
  int sorted = 2;
  String query = "";
  bool fetch = true;

  void toggle(int newSort) {
    sorted = newSort;
    print("Sort $sorted");
    notifyListeners();
  }

  void toggleFetch(){
    fetch = false;
    notifyListeners();
  }

  int get isSorted => sorted;
  bool get isFetching => fetch;

  List<Movie> get items {
    List<Movie> dummyList = _items;
    if(query != ""){
      dummyList = [..._filteredItems];
      if(sorted >= 0){
        dummyList = sortItems(dummyList);
      } else {
        dummyList = [..._items.reversed];
      }
    }
    else if(query == ""){
      if(sorted >= 0)
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

  sortItems(List<Movie> currList) {
    List<Movie> dummyList = currList;
    if(sorted == 0){
      dummyList.sort((a, b) => a.name.compareTo(b.name));
    }
    if(sorted == 1){
      dummyList.sort((b, a) => a.name.compareTo(b.name));
    }
    if(sorted == 2){
      dummyList = [...currList.reversed];
    }
    return dummyList;
  }

  filterItems(String newQuery) {
    _filteredItems = [];
    query = newQuery;
    _items.forEach((element) {
      if(element.name.contains(query)){
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
      DbProvider.createOrUpdate({
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
    await DbProvider.delete(movieName);
  }

  Future<void> fetchAndSetMovie(List<Movie> cloudData) async {
        if(cloudData.length > 0 && fetch) {
          cloudData.forEach((element) {
            DbProvider.createOrUpdate(element.toMap());
          });
          print("fetching");
        }
        final dataList = await DbProvider.read();
        print("Reading data from DbProvider: ${dataList.length} movies");
        _items = dataList.map((item) =>
            Movie(
              name: item['name'].toString(),
              director: item['director'].toString(),
              imageUrl: item['imageUrl'].toString(),
              createdOn: item['createdOn'].toString(),
              updatedOn: item['updatedOn'].toString(),
            ),).toList();
        notifyListeners();
  }
}
