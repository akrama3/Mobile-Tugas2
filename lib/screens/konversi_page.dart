import 'package:flutter/material.dart';

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  // ============================================================
  // DATA TANGGAL
  // ============================================================

  DateTime? tanggalDipilih;
  DateTime? tanggalLahir;

  // ============================================================
  // HASIL KONVERSI HIJRIAH
  // ============================================================

  String hasilHijriah = '';

  // ============================================================
  // HASIL UMUR
  // ============================================================

  int umurTahun = 0;
  int umurBulan = 0;
  int umurHari = 0;

  int totalHari = 0;
  int totalJam = 0;
  int totalMenit = 0;
  int totalDetik = 0;

  bool sudahHitungUmur = false;

  // ============================================================
  // NAMA BULAN HIJRIAH
  // ============================================================

  final List<String> bulanHijriah = const [
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

  // ============================================================
  // PILIH TANGGAL
  // ============================================================

  Future<void> pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalDipilih ?? DateTime.now(),
      firstDate: DateTime(1, 1, 1),
      lastDate: DateTime(9999, 12, 31),
      helpText: 'Pilih tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked == null) return;

    setState(() {
      tanggalDipilih = picked;
      hasilHijriah = konversiKeHijriah(picked);
    });
  }

  Future<void> pilihTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Pilih tanggal lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked == null) return;

    setState(() {
      tanggalLahir = picked;
      sudahHitungUmur = false;
    });
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }

  // ============================================================
  // KONVERSI MASEHI KE HIJRIAH
  //
  // Menggunakan algoritma aritmetika kalender Hijriah.
  // ============================================================

  String konversiKeHijriah(DateTime tanggal) {
    final int jd = hitungJulianDay(tanggal.year, tanggal.month, tanggal.day);

    final int l = jd - 1948440 + 10632;
    final int n = ((l - 1) / 10631).floor();

    final int l2 = l - 10631 * n + 354;

    final int j =
        (((10985 - l2) / 5316).floor()) * ((50 * l2 / 17719).floor()) +
        ((l2 / 5670).floor()) * ((43 * l2 / 15238).floor());

    final int l3 =
        l2 -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;

    final int bulan = ((24 * l3) / 709).floor();

    final int hari = l3 - ((709 * bulan) / 24).floor();

    final int tahun = 30 * n + j - 30;

    if (bulan < 1 || bulan > 12 || hari < 1 || hari > 30) {
      return 'Tidak dapat dikonversi';
    }

    return '$hari ${bulanHijriah[bulan - 1]} $tahun H';
  }

  // ============================================================
  // HITUNG JULIAN DAY
  // ============================================================

  int hitungJulianDay(int tahun, int bulan, int hari) {
    int y = tahun;
    int m = bulan;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    final int a = (y / 100).floor();

    final int b = 2 - a + (a / 4).floor();

    final double jd =
        (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        hari +
        b -
        1524.5;

    return jd.floor();
  }

  // ============================================================
  // HITUNG UMUR
  // ============================================================

  void hitungUmur() {
    if (tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal lahir terlebih dahulu.'),
        ),
      );
      return;
    }

    final DateTime sekarang = DateTime.now();
    final DateTime lahir = tanggalLahir!;

    if (lahir.isAfter(sekarang)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lahir tidak boleh lebih besar dari hari ini.'),
        ),
      );
      return;
    }

    int tahun = sekarang.year - lahir.year;
    int bulan = sekarang.month - lahir.month;
    int hari = sekarang.day - lahir.day;

    if (hari < 0) {
      bulan--;

      final DateTime bulanSebelumnya = DateTime(
        sekarang.year,
        sekarang.month,
        0,
      );

      hari += bulanSebelumnya.day;
    }

    if (bulan < 0) {
      tahun--;
      bulan += 12;
    }

    final Duration selisih = sekarang.difference(lahir);

    final int hariTotal = selisih.inDays;
    final int jamTotal = selisih.inHours;
    final int menitTotal = selisih.inMinutes;
    final int detikTotal = selisih.inSeconds;

    setState(() {
      umurTahun = tahun;
      umurBulan = bulan;
      umurHari = hari;

      totalHari = hariTotal;
      totalJam = jamTotal;
      totalMenit = menitTotal;
      totalDetik = detikTotal;

      sudahHitungUmur = true;
    });
  }

  // ============================================================
  // RESET KONVERSI
  // ============================================================

  void resetKonversi() {
    setState(() {
      tanggalDipilih = null;
      hasilHijriah = '';
    });
  }

  // ============================================================
  // RESET UMUR
  // ============================================================

  void resetUmur() {
    setState(() {
      tanggalLahir = null;

      umurTahun = 0;
      umurBulan = 0;
      umurHari = 0;

      totalHari = 0;
      totalJam = 0;
      totalMenit = 0;
      totalDetik = 0;

      sudahHitungUmur = false;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konversi Tanggal & Umur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ==================================================
            // BAGIAN 1 - MASEHI KE HIJRIAH
            // ==================================================

            const Text(
              'Konversi Masehi ke Hijriah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Pilih tanggal Masehi untuk melihat perkiraan tanggal Hijriahnya.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 18),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: pilihTanggal,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          tanggalDipilih == null
                              ? 'Pilih Tanggal Masehi'
                              : formatTanggal(tanggalDipilih!),
                        ),
                      ),
                    ),

                    if (hasilHijriah.isNotEmpty) ...[
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Hasil Konversi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hasilHijriah,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: resetKonversi,
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // BAGIAN 2 - HITUNG UMUR
            // ==================================================
            const Text(
              'Hitung Umur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Masukkan tanggal lahir untuk menghitung usia secara detail.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 18),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: pilihTanggalLahir,
                        icon: const Icon(Icons.cake),
                        label: Text(
                          tanggalLahir == null
                              ? 'Pilih Tanggal Lahir'
                              : formatTanggal(tanggalLahir!),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: hitungUmur,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Hitung Umur'),
                      ),
                    ),

                    if (sudahHitungUmur) ...[
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Usia Saat Ini',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '$umurTahun Tahun '
                              '$umurBulan Bulan '
                              '$umurHari Hari',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ========================================
                      // TOTAL HARI
                      // ========================================
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Total Hari',
                        value: '$totalHari hari',
                      ),

                      const SizedBox(height: 10),

                      // ========================================
                      // TOTAL JAM
                      // ========================================
                      _buildInfoCard(
                        icon: Icons.access_time,
                        title: 'Total Jam',
                        value: '$totalJam jam',
                      ),

                      const SizedBox(height: 10),

                      // ========================================
                      // TOTAL MENIT
                      // ========================================
                      _buildInfoCard(
                        icon: Icons.schedule,
                        title: 'Total Menit',
                        value: '$totalMenit menit',
                      ),

                      const SizedBox(height: 10),

                      // ========================================
                      // TOTAL DETIK
                      // ========================================
                      _buildInfoCard(
                        icon: Icons.timer,
                        title: 'Total Detik',
                        value: '$totalDetik detik',
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: resetUmur,
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CATATAN
            // ==================================================
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 22),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET INFO
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
