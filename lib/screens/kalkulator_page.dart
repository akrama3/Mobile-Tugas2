import 'package:flutter/material.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController tugasController = TextEditingController();
  final TextEditingController utsController = TextEditingController();
  final TextEditingController uasController = TextEditingController();

  double? nilaiAkhir;
  String grade = '';

  void hitungNilai() {
    final double? tugas = double.tryParse(tugasController.text);
    final double? uts = double.tryParse(utsController.text);
    final double? uas = double.tryParse(uasController.text);

    if (tugas == null || uts == null || uas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nilai tugas, UTS, dan UAS dengan benar.'),
        ),
      );
      return;
    }

    if (tugas < 0 ||
        tugas > 100 ||
        uts < 0 ||
        uts > 100 ||
        uas < 0 ||
        uas > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nilai harus berada antara 0 sampai 100.'),
        ),
      );
      return;
    }

    final double hasil = (tugas * 0.30) + (uts * 0.30) + (uas * 0.40);

    String hasilGrade;

    if (hasil >= 85) {
      hasilGrade = 'A';
    } else if (hasil >= 80) {
      hasilGrade = 'B+';
    } else if (hasil >= 75) {
      hasilGrade = 'B';
    } else if (hasil >= 70) {
      hasilGrade = 'C+';
    } else if (hasil >= 65) {
      hasilGrade = 'C';
    } else if (hasil >= 50) {
      hasilGrade = 'D';
    } else {
      hasilGrade = 'E';
    }

    setState(() {
      nilaiAkhir = hasil;
      grade = hasilGrade;
    });
  }

  void reset() {
    tugasController.clear();
    utsController.clear();
    uasController.clear();

    setState(() {
      nilaiAkhir = null;
      grade = '';
    });
  }

  @override
  void dispose() {
    tugasController.dispose();
    utsController.dispose();
    uasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Nilai'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalkulator Nilai Akademik',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Masukkan nilai tugas, UTS, dan UAS untuk menghitung nilai akhir.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: tugasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai Tugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: utsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai UTS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_document),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: uasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nilai UAS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: hitungNilai,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'Hitung Nilai',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset', style: TextStyle(fontSize: 16)),
              ),
            ),

            if (nilaiAkhir != null) ...[
              const SizedBox(height: 30),

              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Hasil Perhitungan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        nilaiAkhir!.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Grade: $grade',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
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
