import 'package:flutter/material.dart';
import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/widgets/widgets.dart';
import 'package:flutter/rendering.dart';

class DetailsScreen extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie ;
    
    return Scaffold(
        body: CustomScrollView(
          slivers: [ 
            _CustomAppBar(movie),
            SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              _Overview(movie),
              _Overview(movie),
              CastingCards(movie.id)
            ])
            )
          ],
        )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar(this.movie);


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 180,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment:Alignment.bottomCenter ,
          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            ),
        ), 
        background: Container(
          child: FadeInImage(
            alignment: Alignment(0.0,-1.0),
            placeholder: AssetImage('assets/loading.gif'),
            image: NetworkImage(movie.fullBackdropPath.replaceFirst('/w500/', '/w1280/')
),     
           fit: BoxFit.cover
          ),
        ),
      ), 
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  
  final Movie movie;
  const _PosterAndTitle(this.movie);
  
  @override
  Widget build(BuildContext context) {

    final  TextTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;


    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [ 
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage( 
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
 
          SizedBox(width: 20),
 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
              constraints:BoxConstraints(maxWidth:size.width -200),
              child:Text(movie.title,style: TextTheme.headline5,overflow: TextOverflow.ellipsis,maxLines: 2),
              ),
          
           ConstrainedBox(
            constraints:BoxConstraints(maxWidth:size.width -200),
            child: Text(movie.originalTitle,style: TextTheme.subtitle1,overflow: TextOverflow.ellipsis,maxLines: 2)
          ),

            Row(
              children: [
                Icon(Icons.star_outline,size: 15, color: Colors.grey),
                SizedBox(width: 5),
                Text('${movie.voteAverage}', style: TextTheme.caption)
              ],
            )
            ],
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Text(
        movie.overview,
        textAlign:TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1 ,
        ), 
    );
  }
} 