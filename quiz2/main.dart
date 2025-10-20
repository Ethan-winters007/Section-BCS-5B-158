import 'dart:io';

import 'package:flutter/material.dart';
import 'movie_database.dart';
import 'add_edit_movie.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Watchlist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MoviesListScreen(),
    );
  }
}

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  void _refreshMovies() {
    _movies = MovieDatabase.instance.readAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Movies')),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final movies = snapshot.data!;
          if (movies.isEmpty) return const Center(child: Text('No movies added yet'));

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddEditMovieScreen(movie: movie),
                    ),
                  );
                  setState(_refreshMovies);
                },
                child: Image.file(
                  File(movie.posterPath),
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditMovieScreen()),
          );
          setState(_refreshMovies);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
