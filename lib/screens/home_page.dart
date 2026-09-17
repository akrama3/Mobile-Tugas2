import 'package:flutter/material.dart';

import 'anggota_page.dart';
import 'kalkulator_page.dart';
import 'akademik_page.dart';
import 'konversi_page.dart';
import 'kalender_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EduMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                'Aplikasi Pendidikan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                'Belajar, menghitung, dan mengelola data akademik',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView(
                  children: [
                    _buildMenu(
                      context,
                      Icons.groups,
                      'Daftar Anggota',
                      AnggotaPage(),
                    ),

                    _buildMenu(
                      context,
                      Icons.calculate,
                      'Kalkulator Nilai',
                      KalkulatorPage(),
                    ),

                    _buildMenu(
                      context,
                      Icons.school,
                      'Data Akademik',
                      AkademikPage(),
                    ),

                    _buildMenu(
                      context,
                      Icons.calendar_month,
                      'Konversi Tanggal & Umur',
                      KonversiPage(),
                    ),

                    _buildMenu(
                      context,
                      Icons.brightness_3,
                      'Kalender Weton & Saka Bali',
                      KalenderPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 58,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return page;
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Icon(icon, size: 28),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
