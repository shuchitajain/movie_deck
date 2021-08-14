import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import 'db_provider.dart';

class DataProvider with ChangeNotifier {
  DbProvider databaseProvider = DbProvider();
  List<Movie> _items = [];
  final tableName = 'moviesWatched';

  DataProvider(this._items, this.databaseProvider) {
    fetchAndSetMovie();
  }

  List<Movie> get items => [..._items];

  void addMovie(String movieName, String directorName, String imagePath) {
    print("Adding movie to table ${databaseProvider.db}");
    if (databaseProvider.db != null) {
      // do not execute if db is not instantiate
      final newMovie = Movie(
        name: movieName,
        director: directorName,
        createdOn: DateTime.now().millisecondsSinceEpoch.toString(),
        updatedOn: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imagePath,
      );
      _items.add(newMovie);
      print("ITEMS $items");
      notifyListeners();
      databaseProvider.createOrUpdate({
        'name': newMovie.name,
        'director': newMovie.director,
        'image': newMovie.imageUrl,
        'createdOn': newMovie.createdOn,
        'updatedOn': newMovie.updatedOn,
      });
    }
  }

  fetchAndSetMovie() async {
    try {
      final dataList = await databaseProvider.read();
      _items = dataList
          .map((item) => Movie(
          name: item['name'],
          director: item['director'],
          imageUrl: item['image'],
          createdOn: item['createdOn'],
          updatedOn: item['updatedOn']))
          .toList();
      notifyListeners();
      print('items $items');
      print('datalist $dataList');
    } catch (e) {
      print(e);
    }
    // if (databaseProvider!.db != null) {
    //   // do not execute if db is not instantiate
    //   final dataList = await databaseProvider!.read();
    //   _items = dataList
    //       .map((item) => Movie(
    //           name: item['name'],
    //           director: item['director'],
    //           imageUrl: item['image'],
    //           createdOn: item['createdOn'],
    //           updatedOn: item['updatedOn']))
    //       .toList();
    //   notifyListeners();
    // }
  }
}
