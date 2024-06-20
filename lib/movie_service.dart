import 'dart:convert';
import 'package:http/http.dart' as http;


class Movie {
  final String original_title;
  final String overview;
  final String poster_path;

  const Movie ({
    required this.original_title,
    required this.overview,
    required this.poster_path,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        original_title: json['original_title'],
        overview: json['overview'],
        poster_path: json['poster_path']
    );
  }
}

class MovieService {
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.themoviedb.org/3/discover/movie?api_key=b0453bca0ad3ebdc787978a709d7d8ec&sort_by=popularity.desc&page=1"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Movie> movieList = [];

        for (var entry in data['results']) {
          movieList.add(Movie.fromJson(entry));
        }

        return movieList;
      } else {
        throw Exception('Failed to load movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}