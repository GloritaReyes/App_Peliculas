
import 'package:flutter/material.dart';
import 'package:app_peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:app_peliculas/providers/movies_provider.dart';
import 'package:app_peliculas/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
         IconButton(
            icon: Icon(Icons.search_outlined),
           onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate()),
          )
        ],
      ),
      body:SingleChildScrollView(
         child: Column(
        children: [
          //tarjetas principales
             CardSwiper(movies: moviesProvider.onDisplayMovies),

          // slider de peliculas
          MovieSlider(
            movies:moviesProvider.popularMovies,
            title:'populares',
            onNextPage: ()=> moviesProvider.getPopularMovies(),
          ),

        ],
      )
      )
    );
  }
}