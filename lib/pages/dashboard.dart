import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_abp/utils/routes.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Guest User';
    final email = user?.email ?? 'User belum login';

    return Scaffold(
      backgroundColor: Color(0xFFF2FFF5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF4F7942),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to save the Earth?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang,',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22, 
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16, 
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 80, 
                        height: 80, 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage('assets/images/fakhir2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildNewsBox(context),
                      SizedBox(height: 20),
                      _buildCraftsBox(context),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0xFF4F7942),
              padding: EdgeInsets.symmetric(vertical: 19.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, rDashboard);
                    },
                    child: SvgPicture.asset(
                      'assets/vectors/vector_16_x2.svg',
                      width: 26.7,
                      height: 26.7,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, rHome);
                    },
                    child: SvgPicture.asset(
                      'assets/vectors/vector_15_x2.svg',
                      width: 32,
                      height: 28.8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, rProfile);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/vectors/vector_x2.svg',
                          width: 14,
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<List<dynamic>> fetchNews() async {
    final apiKey = 'ef972ca51228472fb31aa86eb6025de5'; 

    final url = Uri.parse(
      'https://newsapi.org/v2/everything?'
      'q=waste management OR recycling OR plastic waste&'
      'language=en&'
      'sortBy=publishedAt&'
      'apiKey=$apiKey'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
  Widget _buildNewsBox(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(child: Text('Error loading news')),
          );
        } else {
          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(child: Text('No news available')),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: articles.length > 5 ? 5 : articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'No Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        article['description'] ?? 'No Description',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
  Widget _buildCraftsBox(BuildContext context) {
    final List<Map<String, String>> crafts = [
      {
        'image': 'assets/images/craft1.jpg',
        'title': 'Kerajinan Warga Dari Daur Ulang Sampah Kering',
      },
      {
        'image': 'assets/images/craft2.jpg',
        'title': '11 Ide Kerajinan Tangan Daur Ulang Sampah yang Mudah untuk Anak',
      },
      {
        'image': 'assets/images/craft3.jpg',
        'title': 'Ide Kreatif Daur ulang Botol plastik',
      },
      {
        'image': 'assets/images/craft4.jpg',
        'title': 'Berkah Rupiah Dari Kerajinan Daur Ulang Sampah',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KERAJINAN DAUR ULANG SAMPAH',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: 40,
                height: 3,
                color: Colors.red,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: crafts.length,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final craft = crafts[index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        craft['image']!,
                        fit: BoxFit.cover,
                        width: 140,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      craft['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
