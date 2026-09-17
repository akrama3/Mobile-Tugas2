import 'package:flutter/material.dart';

class AkademikPage extends StatefulWidget {
  const AkademikPage({super.key});

  @override
  State<AkademikPage> createState() => _AkademikPageState();
}

class _AkademikPageState extends State<AkademikPage> {
  final List<Map<String, dynamic>> dataAkademik = [
    {
      'nama': 'Contoh Mahasiswa',
      'nim': '12345678',
      'mataKuliah': 'Manajemen Basis Data',
      'nilai': 85.0,
    },
  ];

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
              onPressed: () {
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

                setState(() {
                  dataAkademik.add({
                    'nama': nama,
                    'nim': nim,
                    'mataKuliah': mataKuliah,
                    'nilai': nilai,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void editData(int index) {
    final data = dataAkademik[index];

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
              onPressed: () {
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

                setState(() {
                  dataAkademik[index] = {
                    'nama': nama,
                    'nim': nim,
                    'mataKuliah': mataKuliah,
                    'nilai': nilai,
                  };
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        );
      },
    );
  }

  void hapusData(int index) {
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
              onPressed: () {
                setState(() {
                  dataAkademik.removeAt(index);
                });

                Navigator.pop(context);
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
      body: dataAkademik.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data akademik.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: dataAkademik.length,
              itemBuilder: (context, index) {
                final data = dataAkademik[index];

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
                                data['nama'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  editData(index);
                                } else if (value == 'hapus') {
                                  hapusData(index);
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
                        Text('NIM: ${data['nim']}'),
                        const SizedBox(height: 6),
                        Text('Mata Kuliah: ${data['mataKuliah']}'),
                        const SizedBox(height: 6),
                        Text('Nilai: ${data['nilai']}'),
                      ],
                    ),
                  ),
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
