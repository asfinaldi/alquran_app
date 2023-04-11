import 'package:alquran_app/common/contants.dart';
import 'package:alquran_app/cubit/surat/surat_cubit.dart';
import 'package:alquran_app/ui/ayat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    context.read<SuratCubit>().getAllSurat();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Surat'),
      ),
      body: BlocBuilder<SuratCubit, SuratState>(
        builder: (context, state) {
          if (state is SuratLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SuratLoaded) {
            final suratList = state.listSurat.where((surat) {
              final query = _query.toLowerCase();
              final namaLatin = surat.namaLatin.toLowerCase();
              final nama = surat.nama.toLowerCase();
              final arti = surat.arti.toLowerCase();
              return namaLatin.contains(query) ||
                  nama.contains(query) ||
                  arti.contains(query);
            }).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final surat = suratList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AyatPage(surat: surat);
                              },
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Text(
                                '${surat.nomor}',
                                style: const TextStyle(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            title: Text('${surat.namaLatin}, ${surat.nama}'),
                            subtitle: Text(
                                '${surat.arti}, ${surat.jumlahAyat} Ayat.'),
                          ),
                        ),
                      );
                    },
                    itemCount: suratList.length,
                  ),
                ),
              ],
            );
          }

          if (state is SuratError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const Center(
            child: Text('no data'),
          );
        },
      ),
    );
  }
}
