import 'dart:convert';

import 'package:alquran_app/data/models/surat_detail_model.dart';
import 'package:alquran_app/data/models/surat_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  ApiService({
    required this.client,
  });

  Future<Either<String, List<SuratModel>>> getAllSurat() async {
    try {
      final response =
          await client.get(Uri.parse('https://equran.id/api/surat'));
      return Right(List<SuratModel>.from(
        jsonDecode(response.body).map(
          (x) => SuratModel.fromJson(x),
        ),
      ).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SuratDetailModel>> getDetailSurat(
      int nomorSurat) async {
    try {
      final response = await client
          .get(Uri.parse('https://equran.id/api/surat/$nomorSurat'));
      return Right(SuratDetailModel.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<SuratModel>>> searchSurat(String query) async {
    try {
      final response =
          await client.get(Uri.parse('https://equran.id/api/search/$query'));
      return Right(List<SuratModel>.from(
        jsonDecode(response.body).map(
          (x) => SuratModel.fromJson(x),
        ),
      ).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

}
