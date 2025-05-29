import 'package:flutter/material.dart';

class MabitGuidePage extends StatelessWidget {
  MabitGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Mabit?',
      'content':
          'Mabit bermaksud bermalam atau berada di suatu tempat pada waktu malam.\n\nDalam ibadah haji, Mabit dilakukan di Mina selepas melontar Jamrah Aqabah pada 10 Zulhijjah, dan terus bermalam di sana pada malam-malam tasyrik.'
    },
    {
      'title': 'Hukum Mabit di Mina',
      'content':
          '📌 Hukum Mabit di Mina ialah **wajib haji**.\n\n❌ Sesiapa yang meninggalkannya tanpa keuzuran, wajib membayar dam (denda) seekor kambing.\n\nJemaah dibenarkan bermalam di khemah yang disediakan atau mana-mana tempat di dalam kawasan Mina yang sah.'
    },
    {
      'title': 'Waktu dan Tempoh Mabit',
      'content':
          '📅 Dilakukan pada malam:\n– 11 Zulhijjah\n– 12 Zulhijjah\n– 13 Zulhijjah (bagi yang lewat keluar dari Mina)\n\n⏰ Waktu minimum: separuh daripada malam tersebut.\n\n🟡 Jemaah yang mahu keluar awal dari Mina (Nafar Awal) boleh keluar selepas melontar pada 12 Zulhijjah sebelum Maghrib.'
    },
    {
      'title': 'Aktiviti Semasa Mabit',
      'content':
          '– Rehat dan tidur di Mina\n– Melontar ketiga-tiga jamrah pada siang hari (11–13 Zulhijjah)\n– Solat berjemaah di kem atau surau\n– Berzikir, berdoa, membaca Al-Quran'
    },
    {
      'title': 'Adab Semasa Mabit',
      'content':
          '✅ Bersabar dan jaga adab dalam keadaan sesak\n\n✅ Ikut arahan mutawif dan pengurusan khemah\n\n✅ Elakkan bergaduh atau menyakiti orang lain\n\n✅ Banyakkan doa dan zikir – manfaatkan malam-malam akhir di Mina'
    },
    {
      'title': 'Kesimpulan',
      'content':
          'Mabit di Mina adalah amalan penting dalam menyempurnakan haji.\n\nIa mengajarkan nilai kesabaran, kebersamaan, dan pengorbanan. Gunakan masa ini untuk muhasabah dan meningkatkan ketakwaan.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Mabit di Mina'),
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
                'assets/images/Mabit di Mina.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Mabit di Mina',
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
