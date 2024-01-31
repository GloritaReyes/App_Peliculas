
import 'dart:async';
import 'package:app_peliculas/helpers/debouncer.dart';
import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/models/search_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier{

  String _apikey    ='71cb9fdcd58d64a72fc0c3dd07dfe807';
  String _baseUrl  ='api.themoviedb.org';
  String _language ='es-ES';

  List<Movie> onDisplayMovies =[];
  List<Movie> popularMovies =[];
  
  Map<int, List<Cast>> moviesCast ={};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
    
    );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;


  MoviesProvider(){
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();

  }

  Future<String> _getJsonData(String endpoint,[int page = 1] )async{
    final url = Uri.https( _baseUrl,endpoint, {
      'api_key'  : _apikey,   
      'language' : _language,
      'page'     : '$page'
    });

  // Await the http get response, then decode the json-formatted response.
  final response = await http.get(url);  
  return response.body;

  }

  getOnDisplayMovies() async{
    
    final  jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;

     notifyListeners();
  } 

  getPopularMovies()async{
     _popularPage++;
    
    final  jsonData = await _getJsonData('3/movie/popular',1);
    final popularResponse = PopularResponse.fromJson(jsonData);

     popularMovies = [...popularMovies, ...popularResponse.results]; 
     notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId)async{
    
    if (moviesCast.containsKey(movieId))return moviesCast[movieId]!;
    
    print('pidiendo info al servidor -cast');

  final  jsonData = await _getJsonData('3/movie/$movieId/credits');
  final creditsResponse = CreditsResponse.fromJson(jsonData);

  moviesCast[movieId]= creditsResponse.cast;
  
  return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }
    void getSuggestionsByQuery(String searchTerm){
      debouncer.value = '';
      debouncer.onValue = (value) async{

      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);

      };
      final timer = Timer.periodic(Duration(milliseconds: 300) , (_){
        debouncer.value = searchTerm;

  
      });
       Future.delayed(Duration(milliseconds: 301)).then ((_) => timer.cancel());
      }
  }
  
