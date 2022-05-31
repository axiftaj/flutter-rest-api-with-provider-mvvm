import 'dart:convert';

import 'package:mvvm/data/remote/network/ApiEndPoints.dart';
import 'package:mvvm/data/remote/network/BaseApiService.dart';
import 'package:mvvm/data/remote/network/NetworkApiService.dart';
import 'package:mvvm/models/moviesList/MoviesMain.dart';

import 'MovieRepo.dart';


class MovieRepoImp implements MovieRepo{

  BaseApiService _apiService = NetworkApiService();

  @override
  Future<MoviesMain?> getMoviesList() async {
    try {
      dynamic response = await _apiService.getResponse(ApiEndPoints().getMovies);
      print("MARAJ $response");
      final jsonData = MoviesMain.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

}