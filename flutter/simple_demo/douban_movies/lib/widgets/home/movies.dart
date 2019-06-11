import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:douban_movies/models/movie.dart';
import 'package:douban_movies/blocs/bloc_provider.dart';
import 'package:douban_movies/blocs/movies/movies_bloc.dart';
import 'package:douban_movies/widgets/home/movie_item.dart';
import 'package:douban_movies/blocs/movies/movie_item_bloc.dart';

const int _childrenPerBlock = 5;
const int _rowPerBlock = 3;

class _MoviesGridLayout extends SliverGridLayout {
  const _MoviesGridLayout({
    @required this.rowStride,
    @required this.columnStride,
    @required this.tileHeight,
    @required this.tileWidth,
    @required this.bottomHeight,
    @required this.totalCount,
  });

  final double rowStride; // 一行有多高
  final double columnStride; // 一列有多宽
  final double tileHeight; // 一行有多高（不带 spacing）
  final double tileWidth; // 一列有多宽（不带 spacing）
  final double bottomHeight; // 用于展示 loadmore
  final int totalCount;

  int rowOfIndex(int index) {
    return index ~/ _childrenPerBlock * _rowPerBlock + <int>[0,1,1,2,2][index % _childrenPerBlock];
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final nthRow = scrollOffset ~/ rowStride;
    return <int>[0, 1, 3][nthRow % _rowPerBlock] + nthRow ~/ _rowPerBlock * _childrenPerBlock;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final nthRow = scrollOffset ~/ rowStride;
    return <int>[0, 2, 4][nthRow % _rowPerBlock] + nthRow ~/ _rowPerBlock * _childrenPerBlock;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return SliverGridGeometry(
      crossAxisExtent:
          <int>[1, 0, 0, 0, 0][index % _childrenPerBlock] * columnStride +
              tileWidth,
      mainAxisExtent: (index == totalCount - 1) ? bottomHeight : tileHeight,
      crossAxisOffset:
          <int>[0, 0, 1, 0, 1][index % _childrenPerBlock] * columnStride,
      scrollOffset: rowOfIndex(index) * rowStride,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    final offset = rowOfIndex(childCount - 1) * rowStride;
    return (childCount - 1) % _childrenPerBlock == 0 ? offset + bottomHeight : offset;
  }
}

class _MoviesGridDelegate extends SliverGridDelegate {
  static const int _spacing = 10;
  static const double _bottomHeight = 50;

  final int totalCount;

  _MoviesGridDelegate({@required this.totalCount});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent - _spacing) / 2.0;
    const double tileHeight = 250;
    return _MoviesGridLayout(
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      rowStride: tileHeight + _spacing,
      columnStride: tileWidth + _spacing,
      bottomHeight: _bottomHeight,
      totalCount: totalCount,
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return false;
  }
}

class Movies extends StatefulWidget {
  Movies({Key key}) : super(key: key);

  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  Set<MovieItemBloc> itemBlocs = Set();

  @override
  Widget build(BuildContext context) {
    final bloc = BlockProvider.of<MoviesBloc>(context);
    
    return StreamBuilder<MovieEnvelope>(
      stream: bloc.movieEnvelope,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data.movies.length == 0) {
          return Center(child: CupertinoActivityIndicator(),);
        }

        final movieEnvelope = snapshot.data;
        final movies = movieEnvelope.movies;

        return GridView.builder(
          gridDelegate: _MoviesGridDelegate(totalCount: movies.length + 1),
          padding: EdgeInsets.all(10),
          itemCount: movies.length + 1,
          itemBuilder: (context, index) {
            if (index == movies.length) {
              if(movieEnvelope.start >= movieEnvelope.total) {
                return Center(child: Text('没有更多了...'),);
              }

              return Center(child: CupertinoActivityIndicator(),);
            }
            bloc.displayingItemOfIndex(index);
            final movieBloc = MovieItemBloc(movies[index]);
            itemBlocs.add(movieBloc);
            if (((index + 1) % _childrenPerBlock) == 1) {
              return BlockProvider(bloc: movieBloc, child: MovieItemBig(),);
            }else{
              return BlockProvider(bloc: movieBloc, child: MovieItemSmall(),);
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    itemBlocs.forEach((bloc) => bloc.realDispose());
    super.dispose();
  }
}