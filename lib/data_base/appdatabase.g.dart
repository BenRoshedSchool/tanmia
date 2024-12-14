// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appdatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserInfoDao? _personDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserInfoForlocal` (`i` INTEGER PRIMARY KEY AUTOINCREMENT, `id1` INTEGER, `id2` INTEGER, `name1` TEXT, `name2` TEXT, `notes` TEXT, `numberOfFamily` INTEGER, `originalResidence` TEXT, `primery_key` TEXT, `residenceStatus` TEXT, `receiving_status` TEXT, `shelter` TEXT, `status` TEXT, `mobile` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecoredRecpients` (`i` INTEGER PRIMARY KEY AUTOINCREMENT, `documentId` TEXT, `id1` INTEGER, `id2` INTEGER, `name1` TEXT, `name2` TEXT, `notes` TEXT, `numberOfFamily` INTEGER, `originalResidence` TEXT, `primery_key` TEXT, `residenceStatus` TEXT, `receiving_status` TEXT, `shelter` TEXT, `status` TEXT, `mobile` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecoredReciving` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT, `title` TEXT, `typeOfCells` TEXT, `numberOfParcel` TEXT, `documentId` TEXT, `shelter` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserInfoDao get personDao {
    return _personDaoInstance ??= _$UserInfoDao(database, changeListener);
  }
}

class _$UserInfoDao extends UserInfoDao {
  _$UserInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInfoForlocalInsertionAdapter = InsertionAdapter(
            database,
            'UserInfoForlocal',
            (UserInfoForlocal item) => <String, Object?>{
                  'i': item.i,
                  'id1': item.id1,
                  'id2': item.id2,
                  'name1': item.name1,
                  'name2': item.name2,
                  'notes': item.notes,
                  'numberOfFamily': item.numberOfFamily,
                  'originalResidence': item.originalResidence,
                  'primery_key': item.primery_key,
                  'residenceStatus': item.residenceStatus,
                  'receiving_status': item.receiving_status,
                  'shelter': item.shelter,
                  'status': item.status,
                  'mobile': item.mobile
                },
            changeListener),
        _recoredRecpientsInsertionAdapter = InsertionAdapter(
            database,
            'RecoredRecpients',
            (RecoredRecpients item) => <String, Object?>{
                  'i': item.i,
                  'documentId': item.documentId,
                  'id1': item.id1,
                  'id2': item.id2,
                  'name1': item.name1,
                  'name2': item.name2,
                  'notes': item.notes,
                  'numberOfFamily': item.numberOfFamily,
                  'originalResidence': item.originalResidence,
                  'primery_key': item.primery_key,
                  'residenceStatus': item.residenceStatus,
                  'receiving_status': item.receiving_status,
                  'shelter': item.shelter,
                  'status': item.status,
                  'mobile': item.mobile
                },
            changeListener),
        _recoredRecivingInsertionAdapter = InsertionAdapter(
            database,
            'RecoredReciving',
            (RecoredReciving item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'title': item.title,
                  'typeOfCells': item.typeOfCells,
                  'numberOfParcel': item.numberOfParcel,
                  'documentId': item.documentId,
                  'shelter': item.shelter
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserInfoForlocal> _userInfoForlocalInsertionAdapter;

  final InsertionAdapter<RecoredRecpients> _recoredRecpientsInsertionAdapter;

  final InsertionAdapter<RecoredReciving> _recoredRecivingInsertionAdapter;

  @override
  Stream<List<UserInfoForlocal>> getUsersFamily(String shelter) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM UserInfoForlocal WHERE shelter = ?1',
        mapper: (Map<String, Object?> row) => UserInfoForlocal(
            i: row['i'] as int?,
            id1: row['id1'] as int?,
            id2: row['id2'] as int?,
            name1: row['name1'] as String?,
            name2: row['name2'] as String?,
            notes: row['notes'] as String?,
            numberOfFamily: row['numberOfFamily'] as int?,
            originalResidence: row['originalResidence'] as String?,
            primery_key: row['primery_key'] as String?,
            residenceStatus: row['residenceStatus'] as String?,
            shelter: row['shelter'] as String?,
            status: row['status'] as String?,
            mobile: row['mobile'] as int?,
            receiving_status: row['receiving_status'] as String?),
        arguments: [shelter],
        queryableName: 'UserInfoForlocal',
        isView: false);
  }

  @override
  Future<List<UserInfoForlocal>> getUsersFamilyAsFuture(String shelter) async {
    return _queryAdapter.queryList(
        'SELECT * FROM UserInfoForlocal WHERE shelter = ?1',
        mapper: (Map<String, Object?> row) => UserInfoForlocal(
            i: row['i'] as int?,
            id1: row['id1'] as int?,
            id2: row['id2'] as int?,
            name1: row['name1'] as String?,
            name2: row['name2'] as String?,
            notes: row['notes'] as String?,
            numberOfFamily: row['numberOfFamily'] as int?,
            originalResidence: row['originalResidence'] as String?,
            primery_key: row['primery_key'] as String?,
            residenceStatus: row['residenceStatus'] as String?,
            shelter: row['shelter'] as String?,
            status: row['status'] as String?,
            mobile: row['mobile'] as int?,
            receiving_status: row['receiving_status'] as String?),
        arguments: [shelter]);
  }

  @override
  Future<void> deleteAllPersons() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserInfoForlocal');
  }

  @override
  Future<void> deletePersonById(String primery_key) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM UserInfoForlocal WHERE primery_key = ?1',
        arguments: [primery_key]);
  }

  @override
  Stream<List<RecoredRecpients>> getRecoredRecpients(String primery_key) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM RecoredRecpients WHERE documentId = ?1',
        mapper: (Map<String, Object?> row) => RecoredRecpients(
            i: row['i'] as int?,
            documentId: row['documentId'] as String?,
            id1: row['id1'] as int?,
            id2: row['id2'] as int?,
            name1: row['name1'] as String?,
            name2: row['name2'] as String?,
            notes: row['notes'] as String?,
            numberOfFamily: row['numberOfFamily'] as int?,
            originalResidence: row['originalResidence'] as String?,
            primery_key: row['primery_key'] as String?,
            residenceStatus: row['residenceStatus'] as String?,
            shelter: row['shelter'] as String?,
            status: row['status'] as String?,
            mobile: row['mobile'] as int?,
            receiving_status: row['receiving_status'] as String?),
        arguments: [primery_key],
        queryableName: 'RecoredRecpients',
        isView: false);
  }

  @override
  Stream<List<RecoredReciving>> getRecordReciving(String shelter) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM RecoredReciving WHERE shelter = ?1',
        mapper: (Map<String, Object?> row) => RecoredReciving(
            id: row['id'] as int?,
            date: row['date'] as String?,
            title: row['title'] as String?,
            typeOfCells: row['typeOfCells'] as String?,
            numberOfParcel: row['numberOfParcel'] as String?,
            documentId: row['documentId'] as String?,
            shelter: row['shelter'] as String?),
        arguments: [shelter],
        queryableName: 'RecoredReciving',
        isView: false);
  }

  @override
  Stream<List<RecoredReciving>> getAllRecordReciving() {
    return _queryAdapter.queryListStream('SELECT * FROM RecoredReciving',
        mapper: (Map<String, Object?> row) => RecoredReciving(
            id: row['id'] as int?,
            date: row['date'] as String?,
            title: row['title'] as String?,
            typeOfCells: row['typeOfCells'] as String?,
            numberOfParcel: row['numberOfParcel'] as String?,
            documentId: row['documentId'] as String?,
            shelter: row['shelter'] as String?),
        queryableName: 'RecoredReciving',
        isView: false);
  }

  @override
  Stream<List<RecoredRecpients>> getAllRecoredRecpients() {
    return _queryAdapter.queryListStream('SELECT * FROM RecoredRecpients',
        mapper: (Map<String, Object?> row) => RecoredRecpients(
            i: row['i'] as int?,
            documentId: row['documentId'] as String?,
            id1: row['id1'] as int?,
            id2: row['id2'] as int?,
            name1: row['name1'] as String?,
            name2: row['name2'] as String?,
            notes: row['notes'] as String?,
            numberOfFamily: row['numberOfFamily'] as int?,
            originalResidence: row['originalResidence'] as String?,
            primery_key: row['primery_key'] as String?,
            residenceStatus: row['residenceStatus'] as String?,
            shelter: row['shelter'] as String?,
            status: row['status'] as String?,
            mobile: row['mobile'] as int?,
            receiving_status: row['receiving_status'] as String?),
        queryableName: 'RecoredRecpients',
        isView: false);
  }

  @override
  Future<void> deleteRecoredReciving(String primery_key) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM RecoredReciving WHERE documentId = ?1',
        arguments: [primery_key]);
  }

  @override
  Future<void> updateReceivingStatus(
    String primery_key,
    String receivingStatus,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE RecoredRecpients SET receiving_status = ?2 WHERE primery_key = ?1',
        arguments: [primery_key, receivingStatus]);
  }

  @override
  Future<void> deleteRecoredRecipientsById(String primery_key) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM RecoredRecpients WHERE primery_key = ?1',
        arguments: [primery_key]);
  }

  @override
  Future<void> insertUserInfoForlocal(UserInfoForlocal userInfoForlocal) async {
    await _userInfoForlocalInsertionAdapter.insert(
        userInfoForlocal, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRecoredRecpients(RecoredRecpients recoredRecpients) async {
    await _recoredRecpientsInsertionAdapter.insert(
        recoredRecpients, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRecordReciving(RecoredReciving recoredReciving) async {
    await _recoredRecivingInsertionAdapter.insert(
        recoredReciving, OnConflictStrategy.abort);
  }
}
