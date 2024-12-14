
import 'package:floor/floor.dart';
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/recored_reciving.dart';
import 'package:untitled2/modles/users_info_for_local.dart';

@dao
abstract class UserInfoDao {
  @insert
  Future<void> insertUserInfoForlocal(UserInfoForlocal userInfoForlocal);
  @Query('SELECT * FROM UserInfoForlocal WHERE shelter = :shelter')
  Stream<List<UserInfoForlocal>> getUsersFamily(String shelter);

  @Query('SELECT * FROM UserInfoForlocal WHERE shelter = :shelter')
  Future<List<UserInfoForlocal>> getUsersFamilyAsFuture(String shelter);
  @insert
  Future<void> insertRecoredRecpients(RecoredRecpients recoredRecpients);

  @Query("DELETE FROM UserInfoForlocal")
  Future<void> deleteAllPersons();
  @Query("DELETE FROM UserInfoForlocal WHERE primery_key = :primery_key")
  Future<void> deletePersonById(String primery_key);


  @insert
  Future<void> insertRecordReciving(RecoredReciving recoredReciving);

  @Query('SELECT * FROM RecoredRecpients WHERE documentId = :primery_key')
  Stream<List<RecoredRecpients>>  getRecoredRecpients(String primery_key);



  @Query('SELECT * FROM RecoredReciving WHERE shelter = :shelter')
  Stream<List<RecoredReciving>> getRecordReciving(String shelter);

  @Query('SELECT * FROM RecoredReciving')
  Stream<List<RecoredReciving>> getAllRecordReciving();

  @Query('SELECT * FROM RecoredRecpients')
  Stream<List<RecoredRecpients>> getAllRecoredRecpients();

  @Query("DELETE FROM RecoredReciving WHERE documentId = :primery_key")
  Future<void> deleteRecoredReciving(String primery_key);

  @Query('UPDATE RecoredRecpients SET receiving_status = :receivingStatus WHERE primery_key = :primery_key')
  Future<void> updateReceivingStatus(String primery_key, String receivingStatus);
  @Query("DELETE FROM RecoredRecpients WHERE primery_key = :primery_key")
  Future<void> deleteRecoredRecipientsById(String primery_key);

}
