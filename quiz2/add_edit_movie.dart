import 'dart:io';
import 'package:flutter/material.dart';
import 'movie_database.dart';
import 'package:image_picker/image_picker.dart';

class AddEditMovieScreen extends StatefulWidget {
  final Movie? movie;
  const AddEditMovieScreen({super.key, this.movie});

  @override
  State<AddEditMovieScreen> createState() => _AddEditMovieScreenState();
}

class _AddEditMovieScreenState extends State<AddEditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, platform, rating, genre, category, language, country, duration, description, releaseDate;
  String? posterPath;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      final m = widget.movie!;
      name = m.name;
      platform = m.platform;
      rating = m.rating;
      genre = m.genre;
      category = m.category;
      language = m.language;
      country = m.country;
      duration = m.duration;
      description = m.description;
      releaseDate = m.releaseDate;
      posterPath = m.posterPath;
    } else {
      name = platform = rating = genre = category = language = country = duration = description = releaseDate = '';
    }
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        posterPath = pickedFile.path;
      });
    }
  }

  void saveMovie() async {
    if (_formKey.currentState!.validate() && posterPath != null) {
      _formKey.currentState!.save();
      final movie = Movie(
        id: widget.movie?.id,
        name: name,
        platform: platform,
        rating: rating,
        genre: genre,
        category: category,
        language: language,
        country: country,
        duration: duration,
        description: description,
        releaseDate: releaseDate,
        posterPath: posterPath!,
      );
      if (widget.movie == null) {
        await MovieDatabase.instance.create(movie);
      } else {
        await MovieDatabase.instance.update(movie);
      }
      Navigator.of(context).pop();
    }
  }

  void deleteMovie() async {
    if (widget.movie != null) {
      await MovieDatabase.instance.delete(widget.movie!.id!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: posterPath == null
                    ? Container(height: 150, color: Colors.grey[300], child: const Icon(Icons.image, size: 50))
                    : Image.file(File(posterPath!), height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Movie Name'),
                validator: (val) => val!.isEmpty ? 'Enter movie name' : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                initialValue: platform,
                decoration: const InputDecoration(labelText: 'Platform'),
                onSaved: (val) => platform = val!,
              ),
              TextFormField(
                initialValue: rating,
                decoration: const InputDecoration(labelText: 'Rating'),
                onSaved: (val) => rating = val!,
              ),
              TextFormField(
                initialValue: genre,
                decoration: const InputDecoration(labelText: 'Genre'),
                onSaved: (val) => genre = val!,
              ),
              TextFormField(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (val) => category = val!,
              ),
              TextFormField(
                initialValue: language,
                decoration: const InputDecoration(labelText: 'Language'),
                onSaved: (val) => language = val!,
              ),
              TextFormField(
                initialValue: country,
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (val) => country = val!,
              ),
              TextFormField(
                initialValue: duration,
                decoration: const InputDecoration(labelText: 'Duration'),
                onSaved: (val) => duration = val!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => description = val!,
              ),
              TextFormField(
                initialValue: releaseDate,
                decoration: const InputDecoration(labelText: 'Release Date'),
                onSaved: (val) => releaseDate = val!,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveMovie,
                    child: const Text('Save Movie'),
                  ),
                  if (widget.movie != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this movie?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteMovie();
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
