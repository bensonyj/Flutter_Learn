import 'package:flutter/material.dart';
import 'env.dart';
import 'package:douban_movies/services/real_api.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/movies/movies_bloc.dart';
import 'routes/routes.dart';
import 'pages/home.dart';

void main(List<String> args) {
  Env.apiClient = RealAPI();
  Routes.configureRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlockProvider(
      bloc: MoviesBloc(),
      child: MaterialApp(
        title: 'D Movie Top 250',
        home: Home(),
      ),
    );
  }
}