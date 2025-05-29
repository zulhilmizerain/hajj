import 'package:flutter/material.dart';

class TahalulGuidePage extends StatelessWidget {
  TahalulGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Tahalul?',
      'content':
          'Tahalul bermaksud keluar daripada larangan ihram melalui perbuatan bercukur atau bergunting rambut.\n\nIa menandakan seseorang telah menyempurnakan sebahagian besar amalan haji dan dibenarkan melakukan perkara-perkara yang sebelum ini dilarang ketika berihram.'
    },
    {
      'title': 'Jenis Tahalul',
      'content':
          '🔸 Tahalul Awal (Pertama):\nDilakukan selepas melontar Jamrah Aqabah pada 10 Zulhijjah.\n➡️ Membolehkan semua larangan ihram diangkat kecuali hubungan suami isteri.\n\n🔸 Tahalul Thani (Kedua):\nDilakukan selepas melengkapkan Tawaf Ifadah dan Sa’i.\n➡️ Semua larangan ihram diangkat sepenuhnya.'
    },
    {
      'title': 'Cara Melakukan Tahalul',
      'content':
          '1. Untuk Lelaki:\nDisunatkan mencukur seluruh kepala. Jika tidak, boleh bergunting sekurang-kurangnya 3 helai rambut.\n\n2. Untuk Wanita:\nBergunting sedikit rambut (sekitar 1 ruas jari) dari hujung rambut di belakang kepala.\n\n✂️ Gunakan gunting yang bersih dan selamat.'
    },
    {
      'title': 'Hukum & Kepentingan Tahalul',
      'content':
          '✔️ Tahalul adalah rukun dalam umrah dan wajib dalam haji.\n\n❌ Sesiapa yang tidak melakukannya, hajinya tidak sah (untuk umrah), atau perlu bayar dam (untuk haji).\n\n🟡 Tahalul bukan sekadar simbolik, tetapi lambang ketaatan dan kesempurnaan ibadah.'
    },
    {
      'title': 'Pantang Larang Selepas Tahalul',
      'content':
          '– Selepas Tahalul Awal: masih tidak boleh bersama pasangan.\n– Selepas Tahalul Thani: semua larangan ihram telah gugur.\n\nJemaah boleh mula memakai pakaian biasa, menggunakan wangian, dan mencabut bulu/kuku.'
    },
    {
      'title': 'Kesimpulan',
      'content':
          'Tahalul ialah penutup kepada amalan-amalan dalam ihram.\n\nIa memberi simbolik kebebasan dari larangan dan permulaan kepada kehidupan yang bersih, setelah melalui tempoh ibadah yang berat dan bermakna.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Tahalul'),
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
                'assets/images/Tahalul.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Tahalul',
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
