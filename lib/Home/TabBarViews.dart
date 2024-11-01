import 'package:flutter/material.dart';

class isiTabs extends StatelessWidget {
  final List<Map<String, dynamic>> list;

  const isiTabs({required this.list, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3,
        childAspectRatio: 0.6,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return itemTabs(isi: list[index]);
      },
    );
  }
}

class itemTabs extends StatelessWidget {
  final Map<String, dynamic> isi;

  const itemTabs({required this.isi, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 0),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(isi['image']),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isi['title'],
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, size: 24, color: Colors.yellow),
                Text(
                  isi['rating'].toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              alignment: Alignment.center,
              child: const Text(
                "Open",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
