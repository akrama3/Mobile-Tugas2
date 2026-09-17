import 'package:flutter/material.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  DateTime tanggalDipilih = DateTime.now();

  final List<String> pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];

  final List<String> hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // Daftar tanggal Nyepi sebagai awal tahun Saka.
  // Format: tahun Masehi -> tanggal Nyepi pada tahun tersebut.
  final Map<int, DateTime> tanggalNyepi = {
    2020: DateTime(2020, 3, 25),
    2021: DateTime(2021, 3, 14),
    2022: DateTime(2022, 3, 3),
    2023: DateTime(2023, 3, 22),
    2024: DateTime(2024, 3, 11),
    2025: DateTime(2025, 3, 29),
    2026: DateTime(2026, 3, 19),
    2027: DateTime(2027, 3, 8),
    2028: DateTime(2028, 3, 26),
    2029: DateTime(2029, 3, 15),
    2030: DateTime(2030, 3, 5),
    2031: DateTime(2031, 3, 23),
    2032: DateTime(2032, 3, 12),
    2033: DateTime(2033, 3, 31),
    2034: DateTime(2034, 3, 20),
    2035: DateTime(2035, 3, 10),
    2036: DateTime(2036, 2, 27),
    2037: DateTime(2037, 3, 17),
    2038: DateTime(2038, 3, 6),
    2039: DateTime(2039, 3, 24),
    2040: DateTime(2040, 3, 13),
  };

  Future<void> pilihTanggal() async {
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: tanggalDipilih,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (hasil != null) {
      setState(() {
        tanggalDipilih = hasil;
      });
    }
  }

  String namaHari(DateTime tanggal) {
    return hari[tanggal.weekday - 1];
  }

  String hitungPasaran(DateTime tanggal) {
    /*
      1 Januari 1970 digunakan sebagai tanggal acuan.
      Pasaran pada tanggal tersebut adalah Wage.

      Urutan pasaran:
      Legi → Pahing → Pon → Wage → Kliwon
    */

    final tanggalAcuan = DateTime(1970, 1, 1);
    final selisihHari = tanggal.difference(tanggalAcuan).inDays;

    const indexAcuan = 3; // Wage

    final index = (indexAcuan + selisihHari) % 5;

    final indexPositif = index < 0 ? index + 5 : index;

    return pasaran[indexPositif];
  }

  String hitungWeton(DateTime tanggal) {
    return '${namaHari(tanggal)} ${hitungPasaran(tanggal)}';
  }

  int hitungTahunSaka(DateTime tanggal) {
    /*
      Tahun Saka berganti pada Hari Raya Nyepi.

      Sebelum Nyepi:
        Tahun Saka = Tahun Masehi - 79

      Pada dan setelah Nyepi:
        Tahun Saka = Tahun Masehi - 78
    */

    final nyepi = tanggalNyepi[tanggal.year];

    if (nyepi != null) {
      if (tanggal.isBefore(nyepi)) {
        return tanggal.year - 79;
      }

      return tanggal.year - 78;
    }

    // Fallback apabila tahun yang dipilih
    // belum tersedia dalam daftar Nyepi.
    if (tanggal.month < 3) {
      return tanggal.year - 79;
    }

    return tanggal.year - 78;
  }

  String namaBulan(int bulan) {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return namaBulan[bulan - 1];
  }

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')} '
        '${namaBulan(tanggal.month)} '
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String weton = hitungWeton(tanggalDipilih);
    final int tahunSaka = hitungTahunSaka(tanggalDipilih);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Weton & Saka Bali'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Kalender Weton & Saka Bali',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'Pilih tanggal untuk melihat informasi Weton Jawa dan Tahun Saka Bali.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // =========================
            // TANGGAL
            // =========================
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.calendar_month, size: 50),

                    const SizedBox(height: 15),

                    const Text(
                      'Tanggal Dipilih',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      formatTanggal(tanggalDipilih),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: pilihTanggal,
                        icon: const Icon(Icons.edit_calendar),
                        label: const Text('Pilih Tanggal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // WETON JAWA
            // =========================
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.brightness_5, size: 40),

                    const SizedBox(height: 12),

                    const Text(
                      'Weton Jawa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      weton,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text('Hari: ${namaHari(tanggalDipilih)}'),

                    const SizedBox(height: 5),

                    Text('Pasaran: ${hitungPasaran(tanggalDipilih)}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // SAKA BALI
            // =========================
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.temple_hindu, size: 40),

                    const SizedBox(height: 12),

                    const Text(
                      'Kalender Saka Bali',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '$tahunSaka Saka',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tanggal: ${formatTanggal(tanggalDipilih)}',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Tahun Saka berganti pada Hari Raya Nyepi.',
                      textAlign: TextAlign.center,
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
