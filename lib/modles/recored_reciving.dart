import 'package:floor/floor.dart';

@entity
class RecoredReciving {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? date;
  final String? title;
  final String? typeOfCells;
  final String? numberOfParcel;
  final String? documentId;
  final String? shelter;



  RecoredReciving({
    this.id,
    required this.date,
    required this.title,
    required this.typeOfCells,
    required this.numberOfParcel,
    required this.documentId,
    required this.shelter,

  });


}
