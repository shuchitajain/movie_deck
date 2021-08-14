import 'dart:convert';

MovieSearchResponse movieSearchResponseFromJson(String str) =>
    MovieSearchResponse.fromJson(json.decode(str));

String movieSearchResponseToJson(MovieSearchResponse data) =>
    json.encode(data.toJson());

class MovieSearchResponse {
  List<Search> search;
  String totalResults;
  String response;
  String error;

  MovieSearchResponse({
    required this.search,
    required this.totalResults,
    required this.response,
    required this.error,
  });

  factory MovieSearchResponse.fromJson(Map<String, dynamic> json) =>
      MovieSearchResponse(
        search: List<Search>.from(
            (json['Search'] ?? []).map((x) => Search.fromJson(x))),
        totalResults: json['totalResults'],
        response: json['Response'],
        error: json['Error'],
      );

  Map<String, dynamic> toJson() => {
    'Search': List<dynamic>.from(search.map((x) => x.toJson())),
    'totalResults': totalResults,
    'Response': response,
    'Error': error,
  };
}

class Search {
  String name;
  String director;

  Search({
    required this.name,
    required this.director,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    name: json['name'],
    director: json['director'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'director': director,
  };
}
