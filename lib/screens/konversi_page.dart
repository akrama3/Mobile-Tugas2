import 'package:flutter/material.dart';

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  DateTime? tanggalLahir;
  String hasilUmur = '';

  Future<void> pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahir = tanggal;
        hasilUmur = hitungUmur(tanggal);
      });
    }
  }

  String hitungUmur(DateTime tanggal) {
    final sekarang = DateTime.now();

    int tahun = sekarang.year - tanggal.year;
    int bulan = sekarang.month - tanggal.month;
    int hari = sekarang.day - tanggal.day;

    if (hari < 0) {
      bulan--;

      final hariBulanSebelumnya = DateTime(
        sekarang.year,
        sekarang.month,
        0,
      ).day;

      hari += hariBulanSebelumnya;
    }

    if (bulan < 0) {
      tahun--;
      bulan += 12;
    }

    final totalHari = sekarang.difference(tanggal).inDays;
    final totalJam = sekarang.difference(tanggal).inHours;
    final totalMenit = sekarang.difference(tanggal).inMinutes;
    final totalDetik = sekarang.difference(tanggal).inSeconds;

    return '''
Umur: $tahun tahun, $bulan bulan, $hari hari

Total:
$totalHari hari
$totalJam jam
$totalMenit menit
$totalDetik detik
''';
  }

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Tanggal & Umur'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konversi Tanggal & Umur',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Pilih tanggal lahir untuk menghitung umur.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: pilihTanggal,
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  'Pilih Tanggal Lahir',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (tanggalLahir != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal Lahir',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatTanggal(tanggalLahir!),
                        style: const TextStyle(fontSize: 20),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Hasil Perhitungan Umur',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        hasilUmur,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
