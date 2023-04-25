class AyatModel {
  final int nomor;
  final String teks;
  final String terjemahan;
  final String keterangan;

  AyatModel({
    required this.nomor,
    required this.teks,
    required this.terjemahan,
    required this.keterangan,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      nomor: json['nomor'],
      teks: json['teks'],
      terjemahan: json['terjemahan'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'teks': teks,
      'terjemahan': terjemahan,
      'keterangan': keterangan,
    };
  }
}
