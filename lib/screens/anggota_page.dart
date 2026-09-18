import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnggotaPage extends StatelessWidget {
  const AnggotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference anggotaRef = FirebaseFirestore.instance
        .collection('anggota');

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Anggota'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: anggotaRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data anggota.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

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
                    data['nama'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${data['nim'] ?? ''} • ${data['role'] ?? ''}',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}