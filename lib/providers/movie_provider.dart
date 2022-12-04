import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier{
  String _baseUrl = "api.themoviedb.org";
  String _apiKey = "f528f27546df6dd098eee832a8642f9a";
  String _language = "es-ES";
  String _page = "1";

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovie = [];

  Map<int, List<Cast>> casting = {};

  MoviesProvider(){
    this.getOnDisplayMovies();
    this.getpopularMovies();
  }

  getOnDisplayMovies() async{
    var url =
      Uri.https(_baseUrl, '3/movie/now_playing',
       {'api_key': _apiKey,
       'language': _language,
       'page' : _page}
       );

  // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final nowPlayingResponse = NowPlayingResponse.fromJson(result.body);

    onDisplayMovie = nowPlayingResponse.results;

    notifyListeners();
  }

  getpopularMovies() async{
    var url =
      Uri.https(_baseUrl, '3/movie/popular',
       {'api_key': _apiKey,
       'language': _language,
       'page' : _page}
       );

  // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final PopResponse = PopularResponse.fromJson(result.body);

    popularMovie = PopResponse.results;

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int idMovie) async {
    var url =
      Uri.https(_baseUrl, '3/movie/${idMovie}/credits',
       {'api_key': _apiKey,
       'language': _language,
       'page' : _page}
       );

  // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final creditsResponse = CreditsResponse.fromJson(result.body);

    casting[idMovie] = creditsResponse.cast;

    return creditsResponse.cast;
  }
}