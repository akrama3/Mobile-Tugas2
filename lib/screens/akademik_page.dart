import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AkademikPage extends StatefulWidget {
  const AkademikPage({super.key});

  @override
  State<AkademikPage> createState() => _AkademikPageState();
}

class _AkademikPageState extends State<AkademikPage> {
  final CollectionReference akademikRef = FirebaseFirestore.instance
      .collection('akademik');

  void tambahData() {
    final namaController = TextEditingController();
    final nimController = TextEditingController();
    final mataKuliahController = TextEditingController();
    final nilaiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Data Akademik'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Mahasiswa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: mataKuliahController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nilaiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nama = namaController.text.trim();
                final nim = nimController.text.trim();
                final mataKuliah = mataKuliahController.text.trim();
                final nilai = double.tryParse(nilaiController.text.trim());

                if (nama.isEmpty ||
                    nim.isEmpty ||
                    mataKuliah.isEmpty ||
                    nilai == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua data harus diisi dengan benar.'),
                    ),
                  );
                  return;
                }

                if (nilai < 0 || nilai > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nilai harus berada antara 0 sampai 100.'),
                    ),
                  );
                  return;
                }

                await akademikRef.add({
                  'nama': nama,
                  'nim': nim,
                  'mataKuliah': mataKuliah,
                  'nilai': nilai,
                });

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void editData(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final namaController = TextEditingController(text: data['nama']);

    final nimController = TextEditingController(text: data['nim']);

    final mataKuliahController = TextEditingController(
      text: data['mataKuliah'],
    );

    final nilaiController = TextEditingController(
      text: data['nilai'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Data Akademik'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Mahasiswa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: mataKuliahController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nilaiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nama = namaController.text.trim();
                final nim = nimController.text.trim();
                final mataKuliah = mataKuliahController.text.trim();
                final nilai = double.tryParse(nilaiController.text.trim());

                if (nama.isEmpty ||
                    nim.isEmpty ||
                    mataKuliah.isEmpty ||
                    nilai == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua data harus diisi dengan benar.'),
                    ),
                  );
                  return;
                }

                if (nilai < 0 || nilai > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nilai harus berada antara 0 sampai 100.'),
                    ),
                  );
                  return;
                }

                await akademikRef.doc(doc.id).update({
                  'nama': nama,
                  'nim': nim,
                  'mataKuliah': mataKuliah,
                  'nilai': nilai,
                });

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        );
      },
    );
  }

  void hapusData(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text('Apakah kamu yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await akademikRef.doc(docId).delete();

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Akademik'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: akademikRef.snapshots(),
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
                'Belum ada data akademik.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              data['nama'] ?? '',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                editData(doc);
                              } else if (value == 'hapus') {
                                hapusData(doc.id);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'hapus',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 25),
                      Text('NIM: ${data['nim'] ?? ''}'),
                      const SizedBox(height: 6),
                      Text('Mata Kuliah: ${data['mataKuliah'] ?? ''}'),
                      const SizedBox(height: 6),
                      Text('Nilai: ${data['nilai'] ?? ''}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahData,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}