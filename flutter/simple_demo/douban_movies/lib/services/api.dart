import 'package:douban_movies/models/movie.dart';

abstract class API {
  Future<MovieEnvelope> getMovieList(int start);
  Future<Movie> getMovie(String movieId);
}