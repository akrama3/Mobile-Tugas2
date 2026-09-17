import 'package:flutter/material.dart';

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  DateTime? tanggalDipilih;

  String hasilHijriah = '';
  String hasilUmur = '';

  final List<String> namaBulanHijriah = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  Future<void> pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: tanggalDipilih ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (tanggal != null) {
      setState(() {
        tanggalDipilih = tanggal;
        hasilHijriah = konversiKeHijriah(tanggal);
        hasilUmur = hitungUmur(tanggal);
      });
    }
  }

  String konversiKeHijriah(DateTime tanggal) {
    /*
      Konversi Julian Day → Kalender Hijriah.

      Algoritma digunakan untuk memberikan
      hasil tanggal Hijriah berdasarkan tanggal
      Masehi yang dipilih.
    */

    final int a = ((14 - tanggal.month) ~/ 12);
    final int y = tanggal.year + 4800 - a;
    final int m = tanggal.month + (12 * a) - 3;

    final int jd =
        tanggal.day +
        ((153 * m + 2) ~/ 5) +
        (365 * y) +
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045;

    int l = jd - 1948440 + 10632;

    final int n = ((l - 1) ~/ 10631);

    l = l - (10631 * n) + 354;

    final int j =
        (((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719)) +
        ((l ~/ 5670) * ((43 * l) ~/ 15238));

    l =
        l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        ((j ~/ 16) * ((15238 * j) ~/ 43)) +
        29;

    final int bulan = (24 * l) ~/ 709;

    final int hari = l - ((709 * bulan) ~/ 24);

    final int tahun = (30 * n) + j - 30;

    final String namaBulan = namaBulanHijriah[bulan - 1];

    return '$hari $namaBulan $tahun H';
  }

  String hitungUmur(DateTime tanggalLahir) {
    final DateTime sekarang = DateTime.now();

    int tahun = sekarang.year - tanggalLahir.year;
    int bulan = sekarang.month - tanggalLahir.month;
    int hari = sekarang.day - tanggalLahir.day;

    if (hari < 0) {
      bulan--;

      final int hariBulanSebelumnya = DateTime(
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

    final int totalHari = sekarang.difference(tanggalLahir).inDays;

    final int totalJam = sekarang.difference(tanggalLahir).inHours;

    final int totalMenit = sekarang.difference(tanggalLahir).inMinutes;

    final int totalDetik = sekarang.difference(tanggalLahir).inSeconds;

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

            const SizedBox(height: 8),

            const Text(
              'Pilih tanggal untuk melihat tanggal Hijriah dan menghitung umur.',
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
                  'Pilih Tanggal',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (tanggalDipilih != null) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal Masehi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatTanggal(tanggalDipilih!),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Tanggal Hijriah',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        hasilHijriah,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Perhitungan Umur',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        hasilUmur,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
