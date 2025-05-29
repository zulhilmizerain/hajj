import 'package:flutter/material.dart';

class IhramGuidePage extends StatelessWidget {
  IhramGuidePage({Key? key}) : super(key: key);

  final List<Map<String, String>> _sections = [
    {
      'title': 'Apa Itu Ihram?',
      'content':
          'Ihram adalah keadaan khusus dimana seorang Muslim berniat untuk menjalankan ibadah umrah atau haji dan mematuhi beberapa pantang larang selama berada dalam keadaan tersebut. Selain itu, ihram juga merujuk pada pakaian khusus yang dikenakan saat memasuki keadaan tersebut. Ihram untuk lelaki adalah dua helai kain tanpa jahitan. Bagi perempuan pula, pakaian sederhana yang menutupi tubuh namun meninggalkan wajah dan telapak tangan terbuka.'
    },
    {
      'title': 'Ihram Sebagai Keadaan',
      'content':
          'Ihram adalah keadaan khusus dimana seorang Muslim memasuki niat untuk melakukan ibadah haji atau umrah. Dalam keadaan ini, orang tersebut wajib patuh kepada pantang larang khusus yang ditetapkan dalam syariat Islam. Keadaan ihram dimulai dengan niat di tempat miqat dan berakhir setelah selesai ibadah.'
    },
    {
      'title': 'Ihram Sebagai Pakaian',
      'content':
          'Untuk lelaki: dua helai kain tanpa jahitan – satu di bahagian bawah (seperti sarung) dan satu lagi di atas (sebagai selendang). Untuk wanita: pakaian yang menutup seluruh tubuh kecuali muka dan tangan. Tidak boleh memakai wangian atau hiasan berlebihan.'
    },
    {
      'title': 'Tempat dan Waktu Ihram (Miqat)',
      'content':
          '1. Dzulhulaifah (Bir Ali) – 450 km dari Makkah\n2. Al-Juhfah – 187 km dari Makkah\n3. Qarnul Manazil – 95 km dari Makkah\n4. Yalamlam – 54 km dari Makkah\n5. Dzat \'Irqin – 95 km dari Makkah\n\nWajib berihram dari tempat ini atau perlu bayar dam seekor kambing.'
    },
    {
      'title': 'Perkara Sunat Sebelum Memakai Ihram',
      'content':
          '– Memotong kuku dan bulu\n– Mandi sunat ihram\n– Memakai minyak rambut\n– Memakai wangian di badan (bukan pada kain ihram)'
    },
    {
      'title': 'Cara Mandi Sunat Ihram',
      'content':
          '1. Basuh tangan\n2. Bersihkan najis\n3. Kumur dan hidung\n4. Basuh muka dan tangan 3x\n5. Usap kepala dan telinga\n6. Basuh badan kanan lalu kiri\n7. Basuh kaki terakhir\n\nTidak disunatkan keringkan badan dengan kain.'
    },
    {
      'title': 'Cara Memakai Ihram Lelaki & Perempuan',
      'content':
          'Lelaki: 2 kain – bawah menutup pusat ke lutut, atas menutup badan.\n\nPerempuan: Pakaian menutup seluruh aurat kecuali muka dan tangan. Disunatkan pakai warna putih.'
    },
    {
      'title': 'Solat Sunat Ihram',
      'content':
          '2 rakaat selepas pakai ihram, sebelum niat. \nRakaat 1: Al-Fatihah + Al-Kafirun\nRakaat 2: Al-Fatihah + Al-Ikhlas'
    },
    {
      'title': 'Niat Ihram Umrah & Haji',
      'content':
          'Umrah: "Nawaitul ‘Umrata Wa Ahramtu Bihaa Lillahi Ta’ala"\nHaji: "Nawaitul Hajja Wa Ahramtu Bihi Lillahi Ta’aalaa"\n\nJika ragu akan haid: Tambah niat bersyarat, "jika aku didatangi haid maka aku menjadi halal".'
    },
    {
      'title': 'Talbiah Selepas Niat',
      'content':
          '"Labbaika Allahumma labbaik, labbaika laa syarika laka labbaik, innal hamda wan-ni’mata laka wal-mulk, laa syarika lak."\n\nDibaca selepas niat dan sepanjang menuju ke Makkah, sampai mula tawaf.'
    },
    {
      'title': 'Pantang Larang Ihram',
      'content':
          '🔹 Untuk lelaki:\n– Tidak boleh pakai pakaian berjahit\n– Tidak boleh tutup kepala\n\n🔹 Untuk wanita:\n– Tidak boleh tutup muka\n\n🔹 Umum (lelaki & wanita):\n– Tidak boleh pakai wangian\n– Tidak boleh potong rambut/kuku\n– Tidak boleh berburu\n– Tidak boleh berkahwin atau kahwinkan orang lain\n– Tidak boleh bersetubuh'
    },
    {
      'title': 'Jika Langgar Pantang',
      'content':
          'Wajib bayar dam mengikut jenis kesalahan:\n\n– Dam Tertib & Taqdir\n– Dam Tertib & Ta’dil\n– Dam Takhyir & Ta’dil\n– Dam Takhyir & Taqdir'
    },
    {
      'title': 'Soalan Lazim',
      'content':
          '– ❓ Wanita haid boleh niat ihram? ✔️ Ya\n– ❓ Kena mandi juga? ✔️ Ya, sunat\n– ❓ Bila kena buat semua sunat ihram? ✔️ Sebelum miqat\n– ❓ Boleh pakai sandal? ✔️ Ya, jika nampak jari dan tumit\n– ❓ Isteri tergunting rambut suami? ✔️ Keduanya bayar dam'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panduan Ihram'),
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
                'assets/images/Ihramm.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text('Panduan Ihram',
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
