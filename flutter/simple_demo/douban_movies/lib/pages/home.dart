import 'package:flutter/material.dart';
import 'package:douban_movies/widgets/home/movies.dart';
import 'package:douban_movies/blocs/movies/movie_item_bloc.dart';

class _BadegeWidget extends StatelessWidget {
  final int count;
  _BadegeWidget({this.count});

  @override
  Widget build(BuildContext context) {
    if (count > 0) {
      return Padding(
padding: EdgeInsets.only(right: 10),
child: Stack(
  alignment: Alignment.center,
  children: <Widget>[
    Container(width: 24, height: 24, decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Colors.red,
    ),),
    Text(count.toString(), style: TextStyle(color: Colors.white)),
  ],
),
      );
    } else {
      return Container();
    }
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Set<String> favoriteMovies = Set();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FavoriteNotification>(
      child: Scaffold(
        appBar: AppBar(
          title: Text('D Movie Top 205'),
          actions: <Widget>[
            _BadegeWidget(count: favoriteMovies.length,),
          ],
        ),
        body: Movies(),
      ),
      onNotification: (FavoriteNotification notification){
        if (notification.isFavorite) {
          favoriteMovies.add(notification.movie.id);
        } else {
          favoriteMovies.remove(notification.movie.id);
        }
        setState(() {
          
        });
      },
    );
  }
}