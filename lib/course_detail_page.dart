import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String content;

  const CourseDetailPage({
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final formattedContent = content.split('\n').map((line) {
      if (line.startsWith("**") && line.endsWith("**")) {
        return Text(
          line.replaceAll("**", ""),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        );
      } else {
        return Text(line, style: TextStyle(fontSize: 15));
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imageUrl), // ✅ this is the fix
            ),
            SizedBox(height: 16),
            Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...formattedContent,
          ],
        ),
      ),
    );
  }
}
