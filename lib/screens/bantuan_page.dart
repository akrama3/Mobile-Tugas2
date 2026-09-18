import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  Future<void> logout(BuildContext context) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah kamu yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Cara Menggunakan EduMate',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          const Text(
            'EduMate merupakan aplikasi pendidikan yang '
            'menyediakan berbagai fitur untuk membantu '
            'pengguna dalam mengelola data akademik dan '
            'melakukan berbagai perhitungan.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),

          const SizedBox(height: 25),

          _buildHelpItem(
            icon: Icons.groups,
            title: 'Daftar Anggota',
            description: 'Menampilkan informasi anggota kelompok.',
          ),

          _buildHelpItem(
            icon: Icons.calculate,
            title: 'Kalkulator Nilai',
            description: 'Digunakan untuk menghitung nilai akademik.',
          ),

          _buildHelpItem(
            icon: Icons.school,
            title: 'Data Akademik',
            description: 'Digunakan untuk mengelola data akademik.',
          ),

          _buildHelpItem(
            icon: Icons.calendar_month,
            title: 'Konversi',
            description:
                'Digunakan untuk melakukan konversi tanggal '
                'dan menghitung umur.',
          ),

          _buildHelpItem(
            icon: Icons.brightness_3,
            title: 'Kalender',
            description: 'Menampilkan informasi Weton dan Saka Bali.',
          ),

          _buildHelpItem(
            icon: Icons.timer,
            title: 'Stopwatch',
            description: 'Digunakan untuk mengukur durasi belajar.',
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('EduMate - Aplikasi Pendidikan'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'EduMate',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Aplikasi Pendidikan',
              );
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }
}
