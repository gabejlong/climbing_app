import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'CLIMBS.db'),
      onCreate: (database, version) async {
        await database.execute("""
      CREATE TABLE MYTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        location TEXT NOT NULL,
        date TEXT NOT NULL,
        style TEXT NOT NULL,
        grade DOUBLE NOT NULL,
        attempts TEXT NOT NULL
        )
        """);

        await database.execute(
          "CREATE TABLE IF NOT EXISTS BoulderingGrades(id INTEGER PRIMARY KEY AUTOINCREMENT, grade DOUBLE NOT NULL)",
        );
        await database.execute(
            "INSERT OR IGNORE INTO BoulderingGrades (grade) VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)");

        await database.execute(
          "CREATE TABLE IF NOT EXISTS RopesGrades(id INTEGER PRIMARY KEY AUTOINCREMENT, grade DOUBLE NOT NULL)",
        );
        await database.execute(
            "INSERT OR IGNORE INTO RopesGrades (grade) VALUES (6), (7), (8), (9), (9.9), (10), (10.1), (10.9), (11), (11.1), (11.9), (12), (12.1), (12.9), (13), (13.1)");

        await database.execute("""
        CREATE TABLE IF NOT EXISTS Sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        location TEXT NOT NULL,
        date TEXT NOT NULL
        )
        """);

        await database.execute("""
        CREATE TABLE IF NOT EXISTS Preview(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionID INTEGER NOT NULL,
        style TEXT NOT NULL,
        grade DOUBLE NOT NULL,
        attempts TEXT NOT NULL
        )
        """);
      },
      version: 1,
    );
  }

  Future<bool> insertSession(SessionItem sessionItem) async {
    final Database db = await initDB();
    db.insert("Sessions", sessionItem.toMap());
    return true;
  }

  Future<int> getLastSessionID() async {
    final Database db = await initDB();
    var data = await db.rawQuery("SELECT MAX(id) as max_id FROM Sessions");
    if (data.isNotEmpty && data.first['max_id'] != null) {
      return data.first['max_id'] as int;
    }
    return 0;
  }

  Future<bool> insertPreview(
      int sessionID, List<ClimbPreviewItem> climbPreviews) async {
    final Database db = await initDB();
    for (var climb in climbPreviews) {
      db.insert("Preview", climb.toMap(sessionID));
    }
    return true;
  }

  Future<bool> insertData(ClimbItem climbItem) async {
    final Database db = await initDB();
    db.insert("MYTable", climbItem.toMap());
    return true;
  }

  Future<bool> insertClimbs(List<ClimbItem> climbItems) async {
    final Database db = await initDB();
    for (var climb in climbItems) {
      db.insert("MYTable", climb.toMap());
    }
    return true;
  }

  Future<List<ClimbItem>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas =
        await db.rawQuery("SELECT * FROM MYTable ORDER BY date");
    return datas.map((e) => ClimbItem.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    final Database db = await initDB();
    await db.delete("MYTable", where: "id=?", whereArgs: [id]);
  }

  Future<List<ClimbItem>> sortBy(string) async {
    final Database db = await initDB();

    late List<Map<String, Object?>> datas;
    if (string == 'grade') {
      datas = await db.rawQuery(
          "SELECT * FROM MYTable ORDER BY style COLLATE NOCASE ASC, $string COLLATE NOCASE ASC");
    } else {
      datas = await db.rawQuery(
          "SELECT * FROM MYTable ORDER BY $string COLLATE NOCASE ASC, style COLLATE NOCASE ASC");
    }

    return datas.map((e) => ClimbItem.fromMap(e)).toList();
  }

  Future<List<ClimbItem>> filterSort(
      filterType, filter, sortBy, bool? isRopesGrade) async {
    final Database db = await initDB();
    late List<Map<String, Object?>> datas;
    if (isRopesGrade == null) {
      if (sortBy == 'grade') {
        datas = await db.rawQuery(
            "SELECT * FROM MYTable WHERE $filterType LIKE '$filter' ORDER BY style COLLATE NOCASE ASC, $sortBy COLLATE NOCASE ASC");
      } else {
        datas = await db.rawQuery(
            "SELECT * FROM MYTable WHERE $filterType LIKE '$filter' ORDER BY $sortBy COLLATE NOCASE ASC, style COLLATE NOCASE ASC");
      }
    } else if (isRopesGrade) {
      filter = double.parse(filter);
      datas = await db.rawQuery(
          "SELECT * FROM MYTable WHERE grade LIKE '$filter' AND style NOT LIKE 'Bouldering' ORDER BY $sortBy COLLATE NOCASE ASC");
    } else if (!isRopesGrade) {
      filter = double.parse(filter);
      datas = await db.rawQuery(
          "SELECT * FROM MYTable WHERE grade LIKE '$filter' AND style LIKE 'Bouldering' ORDER BY $sortBy COLLATE NOCASE ASC");
    }
    return datas.map((e) => ClimbItem.fromMap(e)).toList();
  }

  Future<List<double>> getBoulderingFlashGradeCount(conditions) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
SELECT COUNT(m.grade) as count, g.grade FROM BoulderingGrades g LEFT JOIN MYTable m ON g.grade = m.grade $conditions AND attempts = 'Flash' group by g.grade    
""");
    List<double> counts =
        datas.map((row) => (double.parse(row['count'].toString()))).toList();
    return counts;
  }

  Future<List<double>> getBoulderingRedpointGradeCount(conditions) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
SELECT COUNT(m.grade) as count, g.grade FROM BoulderingGrades g LEFT JOIN MYTable m ON g.grade = m.grade $conditions AND attempts = 'Redpoint' group by g.grade    
    """);
    List<double> counts =
        datas.map((row) => (double.parse(row['count'].toString()))).toList();
    return counts;
  }

  Future<List<double>> getRopesFlashGradeCount(conditions) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
SELECT COUNT(m.grade) as count, g.grade FROM RopesGrades g LEFT JOIN MYTable m ON g.grade = m.grade $conditions AND attempts = 'Flash' group by g.grade    
""");
    List<double> counts =
        datas.map((row) => (double.parse(row['count'].toString()))).toList();
    return counts;
  }

  Future<List<double>> getRopesRedpointGradeCount(conditions) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
SELECT COUNT(m.grade) as count, g.grade FROM RopesGrades g LEFT JOIN MYTable m ON g.grade = m.grade $conditions AND attempts = 'Redpoint' group by g.grade    
    """);
    List<double> counts =
        datas.map((row) => (double.parse(row['count'].toString()))).toList();
    return counts;
  }

  Future<List<String>> getDateRangeList(timeFilter, conditions) async {
    final Database db = await initDB();
    late List<Map<String, Object?>> datas;
    if (timeFilter == 'Month') // list of months
    {
      datas = await db.rawQuery("""
      WITH RECURSIVE minDate AS (
  SELECT MIN(date) AS startDate
  FROM MYTable
  $conditions
),
allMonths AS (
  SELECT strftime('%Y-%m-01', startDate) AS month
  FROM minDate
  UNION ALL
  SELECT strftime('%Y-%m-01', date(month, '+1 month'))
  FROM allMonths
  WHERE month < strftime('%Y-%m-01', 'now')
)
SELECT month AS list FROM allMonths;
    """);
    } else if (timeFilter == 'Year') {
      datas = await db.rawQuery("""
      WITH RECURSIVE minYearTable AS (     
  SELECT MIN(strftime('%Y', date)) AS minYear     
  FROM MYTable     
  $conditions
  ), 
  allYears as (     
  SELECT      
  minYear as year     
  FROM minYearTable     
  UNION ALL     
  SELECT CAST(year + 1 as INTEGER) as year
  FROM allYears     
  WHERE year+1 <= CAST(strftime('%Y', 'now') as INTEGER)
  ORDER by year
  ) SELECT allYears.year as list FROM allYears
    """);
    } else if (timeFilter == 'Lifetime') {
      datas = [];
    }

    return datas.map((row) => ((row['list'].toString()))).toList();
  }

  Future<List<int>> getDailyCountByMonth(conditions, date, output) async {
    String? month =
        date != 'null' ? DateFormat('MM').format(DateTime.parse(date)) : null;
    String? year =
        date != 'null' ? DateFormat('yyyy').format(DateTime.parse(date)) : null;
    final dayLimit = date != 'null'
        ? (DateTime.parse(date).month == DateTime.now().month &&
                DateTime.parse(date).year == DateTime.now().year
            ? DateTime.now().day
            : DateTime(int.parse(year!), int.parse(month!) + 1, 0).day)
        : null;
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
WITH RECURSIVE allDays as (
 SELECT 
 '01' as day
 UNION ALL
 SELECT printf('%02d', CAST(day AS INTEGER) + 1)
 FROM allDays
 WHERE CAST(day AS INTEGER) < CAST($dayLimit as INTEGER)
 ORDER BY day
),
gradeCount AS (
  SELECT  
      strftime('%d', date) AS day,
        $output(grade) as grade_count,
        date
        FROM MYTable
        WHERE strftime('%m', date) = '$month' AND strftime('%Y', date) = '$year'
        $conditions
        GROUP BY day
)
SELECT 
allDays.day,
COALESCE(gradeCount.grade_count, 0) as grade_count
FROM allDays
LEFT JOIN gradeCount ON allDays.day = gradeCount.day

    """);
    return datas
        .map((row) => (double.parse(row['grade_count'].toString())).toInt())
        .toList();
  }

  Future<List<int>> getYearlyCountByLifetime(conditions, output) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
 WITH RECURSIVE minYearTable AS (     
  SELECT MIN(strftime('%Y', date)) AS minYear     
  FROM MYTable     
  $conditions
  ), 
  allYears as (     
  SELECT      
  minYear as year     
  FROM minYearTable     
  UNION ALL     
  SELECT CAST(year + 1 as INTEGER) as year
  FROM allYears     
  WHERE year+1 <= CAST(strftime('%Y', 'now') as INTEGER)
  ORDER by year
  ), 
  gradeCount as (     
  SELECT  
  date,
  CAST(strftime('%Y', date) AS INTEGER) as year,     
  $output(grade) as grade_count     
  FROM MYTable     
  $conditions
   GROUP BY year 
  ) 
  SELECT  
  allYears.year, 
  COALESCE(gradeCount.grade_count, 0) as grade_count
  FROM allYears
  LEFT JOIN gradeCount ON allYears.year = gradeCount.year
  ORDER BY gradeCount.date
    """);
    return datas
        .map((row) => (double.parse(row['grade_count'].toString())).toInt())
        .toList();
  }

  Future<List<int>> getMonthlyCountByYear(
      conditions, yearString, output) async {
    final Database db = await initDB();
    int? year = yearString != 'null' ? int.parse(yearString) : null;
    int monthLimit = year == DateTime.now().year ? DateTime.now().month : 12;
    final List<Map<String, Object?>> datas = await db.rawQuery("""
  WITH RECURSIVE allMonths AS (
    SELECT '01' AS month
    UNION ALL
    SELECT printf('%02d', CAST(month AS INTEGER) + 1)
    FROM allMonths
    WHERE CAST(month AS INTEGER) < $monthLimit
  ),
  gradeCount AS (
  SELECT
      strftime('%m', date) AS month,
        $output(grade) as grade_count,
        date
        FROM MYTable
        WHERE strftime('%Y', date) = '$year' $conditions
        GROUP BY month
  )
  SELECT 
  allMonths.month,
    COALESCE(gradeCount.grade_count, 0) as grade_count
  FROM allMonths
  LEFT JOIN gradeCount ON allMonths.month = gradeCount.month
    """);
    return datas
        .map((row) => (double.parse(row['grade_count'].toString())).toInt())
        .toList();
  }

  Future<List<int>> getBest(conditions) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.rawQuery("""
  WITH RECURSIVE allMonths AS (
    SELECT '01' AS month
    UNION ALL
    SELECT printf('%02d', CAST(month AS INTEGER) + 1)
    FROM allMonths
    WHERE month < '12'
  ),
  MonthRank AS (
  SELECT
    month,
    CASE
      WHEN month > strftime('%m', 'now') THEN month - strftime('%m', 'now')
      ELSE month - strftime('%m', 'now') + 12
    END AS rank
  FROM allMonths
),
  gradeCount AS (
  SELECT  
      strftime('%m', date) AS month,
        MAX(grade) as grade_Max,
        date
        FROM MYTable
        WHERE date >= date('now', '-12 months') AND Style = '$conditions' 
        GROUP BY month
  )
  SELECT 
  allMonths.month,
    COALESCE(gradeCount.grade_Max, 0) as grade_Max
  FROM allMonths
  LEFT JOIN gradeCount ON allMonths.month = gradeCount.month 
  LEFT JOIN MonthRank ON allMonths.month = MonthRank.month
  ORDER BY MonthRank.rank
    """);
    return datas
        .map((row) => ((double.parse(row['grade_Max'].toString())).toInt()))
        .toList();
  }

  Future<List<SessionItem>> getSessionList() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas =
        await db.rawQuery("SELECT * FROM Sessions");
    return datas.map((e) => SessionItem.fromMap(e)).toList();
  }

  Future<List<ClimbPreviewItem>> getClimbPreview(sessionId) async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db
        .rawQuery("SELECT * FROM Preview WHERE sessionID LIKE $sessionId");
    return datas.map((e) => ClimbPreviewItem.fromMap(e)).toList();
  }

  void deletePreview(int sessionId) async {
    final Database db = await initDB();
    await db.delete("Preview", where: "sessionID=?", whereArgs: [sessionId]);
  }

  void deleteSession(int sessionId) async {
    final Database db = await initDB();
    await db.delete("Sessions", where: "id=?", whereArgs: [sessionId]);
  }
}

class SessionItem {
  final int? sessionId;
  final String location;
  final String date;

  SessionItem({this.sessionId, required this.location, required this.date});

  Map<String, dynamic> toMap() =>
      {"id": sessionId, "location": location, "date": date};

  factory SessionItem.fromMap(Map<String, dynamic> json) => SessionItem(
        sessionId: json['id'],
        location: json["location"],
        date: json["date"],
      );
}

class ClimbPreviewItem {
  final int? id;
  final String style;
  final double grade;
  final String attempts;

  ClimbPreviewItem(
      {this.id,
      required this.style,
      required this.grade,
      required this.attempts});

  Map<String, dynamic> toMap(int sessionID) => {
        "id": id,
        "sessionID": sessionID,
        "style": style,
        "grade": grade,
        "attempts": attempts
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClimbPreviewItem &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          grade == other.grade &&
          attempts == other.attempts;

  @override
  int get hashCode => style.hashCode ^ grade.hashCode ^ attempts.hashCode;

  factory ClimbPreviewItem.fromMap(Map<String, dynamic> json) =>
      ClimbPreviewItem(
          id: json['id'],
          style: json["style"],
          grade: json["grade"],
          attempts: json["attempts"]);
}

class ClimbItem {
  final int? id;
  final String location;
  final String date;
  final String style;
  final double grade;
  final String attempts;

  ClimbItem(
      {this.id,
      required this.location,
      required this.date,
      required this.style,
      required this.grade,
      required this.attempts});

  factory ClimbItem.fromPreview(
          ClimbPreviewItem climbPreview, String location, String date) =>
      ClimbItem(
          location: location,
          date: date,
          style: climbPreview.style,
          grade: climbPreview.grade,
          attempts: climbPreview.attempts);

  factory ClimbItem.fromMap(Map<String, dynamic> json) => ClimbItem(
      id: json['id'],
      location: json["location"],
      date: json["date"],
      style: json["style"],
      grade: json["grade"],
      attempts: json["attempts"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "location": location,
        "date": date,
        "style": style,
        "grade": grade,
        "attempts": attempts
      };
}
