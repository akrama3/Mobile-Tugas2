import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  bool sedangBerjalan = false;
  Duration waktuBerjalan = Duration.zero;

  final List<Duration> daftarLap = [];

  void mulaiJeda() {
    if (sedangBerjalan) {
      // Jeda stopwatch
      stopwatch.stop();
      timer?.cancel();
    } else {
      // Mulai / lanjutkan stopwatch
      stopwatch.start();
      timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        setState(() {
          waktuBerjalan = stopwatch.elapsed;
        });
      });
    }

    setState(() {
      sedangBerjalan = !sedangBerjalan;
    });
  }

  void catatLap() {
    if (!sedangBerjalan) return;

    setState(() {
      daftarLap.insert(0, stopwatch.elapsed);
    });
  }

  void resetStopwatch() {
    stopwatch.stop();
    stopwatch.reset();
    timer?.cancel();

    setState(() {
      sedangBerjalan = false;
      waktuBerjalan = Duration.zero;
      daftarLap.clear();
    });
  }

  String formatWaktu(Duration durasi) {
    final int menit = durasi.inMinutes.remainder(60);
    final int detik = durasi.inSeconds.remainder(60);
    final int milidetik = durasi.inMilliseconds.remainder(1000) ~/ 10;

    final String menitStr = menit.toString().padLeft(2, '0');
    final String detikStr = detik.toString().padLeft(2, '0');
    final String milidetikStr = milidetik.toString().padLeft(2, '0');

    return '$menitStr:$detikStr.$milidetikStr';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stopwatch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Gunakan stopwatch untuk menghitung waktu dan mencatat lap.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    formatWaktu(waktuBerjalan),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: mulaiJeda,
                      icon: Icon(
                        sedangBerjalan ? Icons.pause : Icons.play_arrow,
                      ),
                      label: Text(
                        sedangBerjalan ? 'Jeda' : 'Mulai',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: sedangBerjalan ? catatLap : null,
                      icon: const Icon(Icons.flag),
                      label: const Text('Lap', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: resetStopwatch,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset', style: TextStyle(fontSize: 16)),
              ),
            ),

            if (daftarLap.isNotEmpty) ...[
              const SizedBox(height: 30),

              const Text(
                'Catatan Lap',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarLap.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final int nomorLap = daftarLap.length - index;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'Lap $nomorLap',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      formatWaktu(daftarLap[index]),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}