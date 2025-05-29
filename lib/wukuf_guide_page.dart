import 'package:flutter/material.dart';

class WukufGuidePage extends StatelessWidget {
  WukufGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Wukuf?',
      'content':
          'Wukuf di Arafah adalah salah satu rukun haji yang paling utama. Ia bermaksud berhenti atau berada di Padang Arafah pada waktu tertentu dengan niat ibadah.\n\nWaktu pelaksanaan wukuf adalah pada 9 Dzulhijjah, bermula selepas tergelincir matahari (waktu Zuhur) sehingga terbit fajar 10 Dzulhijjah.'
    },
    {
      'title': 'Hukum dan Kedudukan Wukuf',
      'content':
          '✅ Wukuf adalah **rukun haji** yang wajib dilakukan.\n\n❌ Tanpa wukuf, haji seseorang tidak sah, walaupun ia telah melakukan semua amalan lain.\n\nNabi ﷺ bersabda: “Haji itu adalah Arafah.” (HR. Abu Daud)'
    },
    {
      'title': 'Aktiviti Semasa Wukuf',
      'content':
          '🕌 Wukuf bukan bermaksud berdiri sahaja. Ia boleh dilakukan sambil duduk, berbaring, atau berada dalam khemah.\n\nAktiviti sunat dilakukan semasa wukuf:\n– Mendengar khutbah wukuf\n– Berzikir dan berdoa\n– Membaca Al-Quran\n– Solat jamak dan qasar Zuhur + Asar\n– Muhasabah dan taubat\n\nDisunatkan untuk memperbanyak doa secara bersungguh-sungguh, kerana waktu wukuf adalah antara waktu paling mustajab untuk berdoa.'
    },
    {
      'title': 'Tempat dan Had Arafah',
      'content':
          '📍 Wukuf wajib dilakukan dalam sempadan Arafah yang telah ditetapkan. Jika berada di luar kawasan, wukuf tidak sah.\n\n🚫 Tidak dibenarkan wukuf sebelum 9 Dzulhijjah atau selepas terbit fajar 10 Dzulhijjah.'
    },
    {
      'title': 'Kesimpulan',
      'content':
          '✔️ Wukuf adalah puncak ibadah haji.\n\n✔️ Pastikan hadir di Arafah pada waktu yang ditentukan.\n\n✔️ Isilah masa dengan ibadah, doa, taubat dan zikir sebagai bentuk penghambaan kepada Allah.\n\n🌤️ Semoga Allah menerima haji kita dan memberi keampunan atas segala dosa.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Wukuf di Arafah'),
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
                'assets/images/Wukuf di Arafah.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Wukuf di Arafah',
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
