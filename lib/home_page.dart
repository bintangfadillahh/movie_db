import 'package:flutter/material.dart';
import 'package:movie_db/movie_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = MovieService().getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Movie DB')),
        body: Center(
          child: FutureBuilder<List<Movie>>(
            future: futureMovies,
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    Movie movie = snapshot.data?[index];
                    return Column(
                      children: [ //Menampilkan data yang telah difetch dari REST API
                        Text(movie.original_title),
                        Image.network('https://image.tmdb.org/t/p/w500${movie.poster_path}'),
                        Text(movie.overview),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.black26);
                  },
                  itemCount: snapshot.data!.length,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
          ),
        ));
  }
}
