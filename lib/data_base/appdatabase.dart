// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/recored_reciving.dart';

import '../modles/users_info_for_local.dart';
import 'dao/dao.dart';


part 'appdatabase.g.dart'; // the generated code will be there

@Database(version: 3, entities: [UserInfoForlocal , RecoredRecpients , RecoredReciving])
abstract class AppDatabase extends FloorDatabase {
  UserInfoDao get personDao;
}