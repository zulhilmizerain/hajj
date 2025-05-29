import 'package:flutter/material.dart';

class SaieGuidePage extends StatelessWidget {
  SaieGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Sa’i?',
      'content':
          'Sa’i ialah salah satu daripada rukun haji dan umrah. Ia merupakan amalan berjalan ulang-alik sebanyak 7 kali antara bukit Safa dan Marwah di dalam Masjidil Haram.\n\nAmalan ini menghidupkan kembali peristiwa Siti Hajar yang berlari-lari mencari air untuk anaknya Nabi Ismail a.s.'
    },
    {
      'title': 'Hukum Sa’i',
      'content':
          '✔️ Hukum Sa’i adalah **rukun**, maka ia wajib dilaksanakan dalam ibadah haji atau umrah.\n\n❌ Jika tidak melakukannya, ibadah tersebut tidak sah.'
    },
    {
      'title': 'Syarat-Syarat Sa’i',
      'content':
          '📌 Sa’i dilakukan selepas tawaf (Tawaf Qudum untuk haji, Tawaf Umrah untuk umrah)\n\n📌 Dilakukan sebanyak 7 kali pusingan – bermula di Safa dan berakhir di Marwah.\n\n📌 Setiap pusingan mestilah lengkap – 1 kali dari Safa ke Marwah dikira 1 pusingan.'
    },
    {
      'title': 'Cara Pelaksanaan Sa’i',
      'content':
          '1. Naik ke Bukit Safa, menghadap Kaabah dan membaca takbir serta doa.\n\n2. Berniat Sa’i.\n\n3. Berjalan ke arah Marwah sambil berzikir dan berdoa. Lelaki disunatkan berlari-lari anak di kawasan berlampu hijau.\n\n4. Sampai di Marwah, naik sedikit dan berdoa.\n\n5. Ulangi langkah ini sebanyak 7 kali (Safa ke Marwah = 1, Marwah ke Safa = 2, dan seterusnya).\n\n6. Sa’i tamat di Bukit Marwah.'
    },
    {
      'title': 'Doa & Zikir Semasa Sa’i',
      'content':
          '🌟 Tidak ada doa khusus yang diwajibkan semasa Sa’i. Namun, dianjurkan memperbanyak:\n– Zikir\n– Selawat\n– Doa memohon keampunan dan kebaikan dunia akhirat\n\n📖 “Rabbighfir warham, wa anta khairur rahimin” (Ya Allah, ampunilah dan rahmatilah, Engkaulah sebaik-baik pemberi rahmat).'
    },
    {
      'title': 'Kesimpulan',
      'content':
          'Sa’i mengajarkan kita nilai usaha, kesabaran dan keyakinan kepada pertolongan Allah.\n\n💡 Selesaikan Sa’i dengan penuh kekhusyukan dan keikhlasan untuk menghidupkan semangat pengorbanan dan tawakkal yang tinggi kepada Allah SWT.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Sa’i'),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/Sa’i.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Sa’i',
                style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ..._sections
                .map((section) => _buildSubtopic(
                    section['title']!, section['content']!, theme))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtopic(String title, String description, TextTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(description, style: theme.bodyMedium),
        ],
      ),
    );
  }
}
