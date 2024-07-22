import 'dart:io';
import 'package:flutter/material.dart';
import 'package:comic_reader/constants.dart';
import 'package:comic_reader/models/comics.dart';
import 'package:comic_reader/Data/api_service.dart';
import '../Slider/SliderSyncDemo.dart';
import 'package:comic_reader/detail_comic_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Comic>> futureComics;

  @override
  void initState() {
    super.initState();
    futureComics = APIService().fetchComics();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF276AD4), Color(0xFF510F83)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderSyncDemo(
                largeImageUrls: [
                  'assets/images/Slider_1.png',
                  'assets/images/a2.jpg',
                  'assets/images/a6.jpg',
                ],
                smallImageUrls: [
                  'assets/images/Slider_1.png',
                  'assets/images/a2.jpg',
                  'assets/images/a6.jpg',
                ],
              ),
              _buildSectionTitle('Mới Cập Nhật'),
              FutureBuilder<List<Comic>>(
                future: futureComics,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No comics found'));
                  } else {
                    return Column(
                      children: snapshot.data!.map((comic) {
                        return _buildComic(comic, context);
                      }).toList(),
                    );
                  }
                },
              ),
              _buildSectionTitle('Truyện nổi bật'),
              // Add your prominent comics section here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 6, top: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _buildComic(Comic comic, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailComicPage(comic: comic), // Pass the comic object
          ),
        );
      },
      child: Opacity(
        opacity: 0.5,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100.0, // Increased height for better spacing
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.8),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: FileImage(File(comic.thumbnailComic)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                        image: FileImage(File(comic.thumbnailComic)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comic.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Constants.blackColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          comic.author ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Constants.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
