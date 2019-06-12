import 'package:douban_movies/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:douban_movies/models/movie.dart';
import 'package:douban_movies/blocs/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:douban_movies/routes/routes.dart';
import 'package:douban_movies/pages/movie.dart';

class FavoriteNotification extends Notification {
  final bool isFavorite;
  final Movie movie;

  FavoriteNotification({this.isFavorite, this.movie});
}

class MovieItemBloc implements BlocBase {
  BehaviorSubject<Movie> _movie;
  Stream<Movie> get movie => _movie.stream;

  MovieItemBloc(Movie aMovie) {
    _movie = BehaviorSubject();
    if(aMovie != null) {
      _movie.add(aMovie);
    }
  }

  @override
  void dispose() {
    
  }

  realDispose() {
    _movie.close();
  }

  toggleFavorite(BuildContext context) {
    var currentMovie = _movie.value;
    currentMovie.hasLiked = !currentMovie.hasLiked;
    FavoriteNotification(isFavorite: currentMovie.hasLiked, movie: currentMovie).dispatch(context);
    _movie.add(currentMovie);
  }

  onTap(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      MoviePage moviePage = Router.getWidget('/movie/${_movie.value.id}', context, params: {'movie': _movie.value});
      return moviePage;
    }));
  }
}