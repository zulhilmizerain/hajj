import 'package:flutter/material.dart';

class MelontarGuidePage extends StatelessWidget {
  MelontarGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Melontar Jamrah?',
      'content':
          'Melontar jamrah ialah amalan wajib dalam ibadah haji yang melibatkan lontaran batu kecil ke arah tiga tiang (jamrah) di Mina:\n\n1. Jamrah Ula\n2. Jamrah Wusta\n3. Jamrah Aqabah\n\nIa melambangkan penolakan terhadap godaan syaitan dan pengabdian kepada Allah.'
    },
    {
      'title': 'Hukum Melontar Jamrah',
      'content':
          '🔸 Hukum: **Wajib Haji**\n\n❌ Sesiapa yang meninggalkannya, wajib menggantikan dengan dam.\n\nMelontar dilakukan dengan tertib, bilangan dan waktu yang betul.'
    },
    {
      'title': 'Lokasi & Simbolik Jamrah',
      'content':
          '📍 Ketiga-tiga jamrah terletak di Mina.\n\n🪨 Ia adalah tempat Nabi Ibrahim a.s. melontar syaitan ketika digoda agar tidak menyembelih anaknya.\n\nMelontar menjadi simbol menolak kejahatan dan memperbaharui ketaatan kepada Allah.'
    },
    {
      'title': 'Bila Melontar Dilakukan?',
      'content':
          '📅 Melontar dilakukan pada:\n\n– 10 Zulhijjah (Jamrah Aqabah sahaja)\n– 11, 12 & 13 Zulhijjah (semua 3 jamrah: Ula, Wusta, Aqabah)\n\nWaktu melontar bermula dari tergelincir matahari (Zuhur) sehingga subuh keesokan harinya. Waktu afdal: antara Zuhur dan Maghrib.'
    },
    {
      'title': 'Cara Melontar Jamrah',
      'content':
          '1. Ambil 7 biji batu kecil dari Muzdalifah atau Mina.\n2. Niat melontar kerana Allah.\n3. Hadap arah jamrah (tiang).\n4. Lontar satu demi satu batu sambil ucap:\n“Allahu Akbar” setiap lontaran.\n5. Ulang 7 kali untuk setiap jamrah.\n6. Gunakan tangan kanan, lontar dengan yakin, dan pastikan batu jatuh dalam kawasan yang ditentukan.'
    },
    {
      'title': 'Adab dan Doa',
      'content':
          '✅ Disunatkan berdoa selepas melontar Jamrah Ula & Wusta. Tiada doa selepas Jamrah Aqabah.\n\n✅ Melontar dengan tenang, tidak menyakiti jemaah lain, dan tidak membaling dengan kasar.\n\n🚫 Jangan melontar dengan selipar, tongkat, atau benda besar.'
    },
    {
      'title': 'Kesimpulan',
      'content':
          'Melontar jamrah adalah simbol perjuangan melawan hawa nafsu dan syaitan.\n\nLakukan dengan penuh penghayatan dan ikhlas. Ia bukan sekadar lontaran fizikal, tetapi ikrar ketaatan kepada Allah.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Melontar Jamrah'),
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
                'assets/images/Melontar jumrah.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Melontar Jamrah',
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
