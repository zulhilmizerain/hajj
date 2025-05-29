import 'package:flutter/material.dart';

class CaraMengerjakanPage extends StatelessWidget {
  const CaraMengerjakanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cara mengerjakan Haji'),
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
                'assets/images/Kaabah.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Cara mengerjakan Haji',
              style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Terdapat 3 cara mengerjakan Haji', style: theme.bodyMedium),
            SizedBox(height: 24),
            _buildSubtopic(
              'Tamattu',
              'Haji Tamattu’ ialah ibadat haji yang dimulai dengan mengerjakan ibadat umrah pada bulan-bulan haji (1 Syawal–10 Zulhijjah) dan kemudian mengerjakan ibadat haji pada tahun yang sama.',
              theme,
            ),
            _buildSubtopic(
              'Ifrad',
              'Haji Ifrad ialah ibadat haji yang dilakukan dengan berniat melakukan ibadat haji sahaja di Miqat tanpa disertakan dengan ibadat umrah pada bulan-bulan haji. Kemudian barulah dikerjakan umrah selepas selesai mengerjakan ibadat haji. Haji Ifrad ini tidak dikenakan Dam.',
              theme,
            ),
            _buildSubtopic(
              'Qiran',
              'Haji Qiran ialah ibadat haji yang dilakukan dengan berniat melakukan ibadat haji dan umrah secara serentak di Miqat asal. Ini bermaksud, apabila tiba di Miqat Jemaah berniat untuk melaksanakan ibadat umrah dan haji sekali gus.',
              theme,
            ),
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
