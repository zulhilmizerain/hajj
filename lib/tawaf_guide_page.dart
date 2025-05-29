import 'package:flutter/material.dart';

class TawafGuidePage extends StatelessWidget {
  TawafGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Tawaf?',
      'content':
          'Tawaf adalah ibadah mengelilingi Kaabah sebanyak 7 kali dengan syarat dan tatacara tertentu, bermula dan berakhir di penjuru Hajar Aswad.\n\nIa adalah salah satu rukun haji dan umrah yang penting. Ia menggambarkan keikhlasan, ketundukan dan cinta kepada Allah SWT.'
    },
    {
      'title': 'Jenis-Jenis Tawaf',
      'content':
          '1. Tawaf Qudum – tawaf selamat datang (sunat bagi haji Ifrad & Qiran).\n2. Tawaf Ifadah – rukun haji, dilakukan selepas melontar Jamrah Aqabah dan tahallul.\n3. Tawaf Wada’ – tawaf perpisahan sebelum meninggalkan Makkah (wajib).\n4. Tawaf Sunat – boleh dilakukan pada bila-bila masa.\n5. Tawaf Nazar – wajib dilaksanakan jika bernazar.'
    },
    {
      'title': 'Syarat Sah Tawaf',
      'content':
          '– Suci dari hadas kecil dan besar.\n– Menutup aurat.\n– Dilakukan dalam Masjidil Haram mengelilingi Kaabah.\n– Bermula di Hajar Aswad dan berakhir di tempat yang sama.\n– Kaabah berada di sebelah kiri.\n– Dilakukan sebanyak 7 pusingan lengkap.'
    },
    {
      'title': 'Cara Melakukan Tawaf',
      'content':
          '1. Berdiri sejajar dengan Hajar Aswad, niat tawaf.\n2. Mengangkat tangan dan mengucap “Bismillah Allahu Akbar.”\n3. Mulakan pusingan lawan arah jam.\n4. Setiap kali lalu Hajar Aswad, ulang ucapan takbir.\n5. Banyakkan zikir, selawat dan doa sepanjang pusingan.\n6. Selesai 7 pusingan, solat sunat 2 rakaat di belakang Maqam Ibrahim (jika boleh).'
    },
    {
      'title': 'Doa & Zikir Ketika Tawaf',
      'content':
          'Tidak ada doa khusus yang wajib. Disunatkan untuk membaca doa, zikir dan selawat yang diyakini maknanya.\n\nContoh:\n“Rabbana atina fid-dunya hasanah, wa fil-akhirati hasanah, waqina ‘azaban nar.”\n\nGunakan waktu ini untuk memohon keampunan, rahmat dan hajat peribadi.'
    },
    {
      'title': 'Kesilapan Biasa Ketika Tawaf',
      'content':
          '– Tidak cukup 7 pusingan.\n– Tidak bermula di Hajar Aswad.\n– Hilang arah (Kaabah tidak di sebelah kiri).\n– Bercakap perkara sia-sia.\n– Menolak jemaah lain secara kasar.\n\n✔️ Elakkan perkara-perkara ini dan laksanakan tawaf dengan adab dan khusyuk.'
    },
    {
      'title': 'Kesimpulan',
      'content':
          'Tawaf adalah simbol kecintaan kepada Allah.\n\nLakukan dengan penuh tawaduk, tertib dan rasa keinsafan. Jadikan setiap pusingan sebagai perjalanan mendekatkan diri kepada Allah SWT.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Tawaf'),
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
                'assets/images/Tawaf Wada’.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Tawaf',
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
