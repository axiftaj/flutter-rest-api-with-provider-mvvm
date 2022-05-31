import 'package:flutter/material.dart';
import 'package:mvvm/data/remote/response/Status.dart';
import 'package:mvvm/models/moviesList/MoviesMain.dart';
import 'package:mvvm/utils/Utils.dart';
import 'package:mvvm/view/home/widget/LoadingWidget.dart';
import 'package:mvvm/view/home/widget/MyErrorWidget.dart';
import 'package:mvvm/view_model/home/MoviesListVM.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  static final String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MoviesListVM viewModel = MoviesListVM();

  @override
  void initState() {
    viewModel.fetchMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:
        Text('Movie List')),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ChangeNotifierProvider<MoviesListVM>(
        create: (BuildContext context) => viewModel,
        child: Consumer<MoviesListVM>(builder: (context, viewModel, _) {
          switch (viewModel.movieMain.status) {
            case Status.LOADING:
              return LoadingWidget();
            case Status.ERROR:
              return MyErrorWidget(viewModel.movieMain.message ?? "NA");
            case Status.COMPLETED:
              return _getMoviesListView(viewModel.movieMain.data!.movies!);
            default:
          }
          return Container();
        }),
      ),
    );
  }

  Widget _getMoviesListView(List<Movies> moviesList) {
    return ListView.builder(
        itemCount: moviesList.length,
        itemBuilder: (context, position) {
          return _getMovieListItem(moviesList[position]);
        });
  }

  Widget _getMovieListItem(Movies item) {
    return Card(
      child:   ListTile(
        leading: ClipRRect(
          child: Image.network(
            item.posterurl.toString(),
            errorBuilder: (context, error, stackTrace) {
              return  const Icon(Icons.error_outline);
            },
            fit: BoxFit.fill,
            width: 40,
            height: 40,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        title:  Text(item.title.toString()),
        subtitle: Text(item.year.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Utils.setAverageRating(item.ratings!).toString()),
            SizedBox(width: 12,),
            Icon(Icons.star),
          ],
        ),
        onTap: () {
          _sendDataToMovieDetailScreen(context, item);
        },
      ),
      elevation: 1,
    );
  }

  void _sendDataToMovieDetailScreen(BuildContext context, Movies item) {
    //Navigator.pushNamed(context, MovieDetailsScreen.id,arguments: item);
  }
}
