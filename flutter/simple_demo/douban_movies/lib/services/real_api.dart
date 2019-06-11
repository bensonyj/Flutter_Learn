import 'dart:io';
import 'api.dart';
import 'dart:convert';
import 'package:douban_movies/models/movie.dart';

class RealAPI extends API {
  @override
  Future<Movie> getMovie(String movieId) async{
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse('https://api.douban.com/v2/movie/subject/{$movieId}'));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return Movie.fromJSON(data);
  }

  @override
  Future<MovieEnvelope> getMovieList(int start) async{
    var client = HttpClient();
    var request = await client.getUrl(Uri.parse('https://api.douban.com/v2/movie/top250?start=$start&count=40&apikey=0df993c66c0c636e29ecbb5344252a4a'));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return MovieEnvelope.fromJSON(data);
  }
  
}