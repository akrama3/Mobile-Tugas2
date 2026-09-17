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
    // 1 Januari 1970 digunakan sebagai tanggal acuan.
    // Pasaran pada tanggal acuan: Wage.
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

  String hitungTahunSaka(DateTime tanggal) {
    /*
      Tahun Saka berganti pada Nyepi yang umumnya berada
      sekitar bulan Maret.

      Untuk tahap awal:
      - Januari sampai sebelum pergantian Saka:
        tahun Masehi - 79
      - Setelah pergantian Saka:
        tahun Masehi - 78

      Perhitungan batas Nyepi akan kita sempurnakan
      pada tahap kalender Bali lengkap.
    */

    if (tanggal.month < 3) {
      return '${tanggal.year - 79} Saka';
    }

    return '${tanggal.year - 78} Saka';
  }

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final weton = hitungWeton(tanggalDipilih);
    final saka = hitungTahunSaka(tanggalDipilih);

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
              'Pilih tanggal untuk melihat informasi kalender.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

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

                    const SizedBox(height: 8),

                    Text('Hari: ${namaHari(tanggalDipilih)}'),

                    Text('Pasaran: ${hitungPasaran(tanggalDipilih)}'),
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
                      saka,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Informasi kalender Saka Bali',
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
