import 'package:alquran_app/common/contants.dart';
import 'package:alquran_app/cubit/ayat/ayat_cubit.dart';
import 'package:alquran_app/data/models/surat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AyatPage extends StatefulWidget {
  const AyatPage({
    Key? key,
    required this.surat,
  }) : super(key: key);
  final SuratModel surat;

  @override
  State<AyatPage> createState() => _AyatPageState();
}

class _AyatPageState extends State<AyatPage> {
  late String _searchQuery;
  late int
      _selectedAyat; // tambahkan variabel untuk menyimpan nomor ayat terpilih

  @override
  void initState() {
    context.read<AyatCubit>().getDetailSurat(widget.surat.nomor);
    _searchQuery = '';
    _selectedAyat =
        -1; // inisialisasi nomor ayat terpilih dengan nilai -1 (tidak ada)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surat.namaLatin,
        ),
      ),
      body: BlocBuilder<AyatCubit, AyatState>(
        builder: (context, state) {
          if (state is AyatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AyatLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari ayat...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                        _selectedAyat =
                            -1; // reset nomor ayat terpilih ketika pencarian berubah
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final ayat = state.detail.ayat![index];
                      if (_searchQuery.isEmpty ||
                          ayat.ar!.toLowerCase().contains(_searchQuery) ||
                          ayat.idn!.toLowerCase().contains(_searchQuery) ||
                          ayat.nomor!.toString().contains(_searchQuery)) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAyat = ayat.nomor!;
                            });
                          },
                          child: Card(
                            color: _selectedAyat == ayat.nomor!
                                ? Colors.grey.shade200
                                : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  '${ayat.nomor}',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${ayat.ar}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('${ayat.idn}'),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    itemCount: state.detail.ayat!.length,
                  ),
                ),
              ],
            );
          }
          if (state is AyatError) {
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
