abstract class MapConvertible {
  Map<dynamic, dynamic> toMap();

  MapConvertible fromMap(Map<dynamic, dynamic> map);
}

class Movie extends MapConvertible {
  final String name;
  final String director;
  final String imageUrl;
  String createdOn; // sql doesn't support dates
  String updatedOn;

  Movie({
    this.name = "",
    this.director = "",
    this.imageUrl = "",
    this.createdOn = "",
    this.updatedOn = "",
  });

  @override
  Movie fromMap(Map map) {
    return Movie(
      name: map['name'],
      director: map['director'],
      imageUrl: map['imageUrl'],
      createdOn: map['createdOn'],
      updatedOn: map['updatedOn'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'director': director,
      'imageUrl': imageUrl,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
