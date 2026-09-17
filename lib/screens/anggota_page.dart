import 'package:flutter/material.dart';

class AnggotaPage extends StatelessWidget {
  const AnggotaPage({super.key});

  final List<Map<String, String>> anggota = const [
    {'nama': 'Anggota 1', 'nim': 'NIM 1', 'role': 'Mahasiswa'},
    {'nama': 'Anggota 2', 'nim': 'NIM 2', 'role': 'Mahasiswa'},
    {'nama': 'Anggota 3', 'nim': 'NIM 3', 'role': 'Mahasiswa'},
    {'nama': 'Anggota 4', 'nim': 'NIM 4', 'role': 'Mahasiswa'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: anggota.length,
        itemBuilder: (context, index) {
          final data = anggota[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 25,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                data['nama']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('${data['nim']} • ${data['role']}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
