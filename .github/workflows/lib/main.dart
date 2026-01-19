import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lunar_calendar_converter_new/lunar_solar_converter.dart';

// ==========================================
// PHẦN 1: LOGIC XỬ LÝ ÂM LỊCH (Gộp vào đây)
// ==========================================
class LunarUtils {
  static const List<String> CAN = [
    "Giáp",
    "Ất",
    "Bính",
    "Đinh",
    "Mậu",
    "Kỷ",
    "Canh",
    "Tân",
    "Nhâm",
    "Quý"
  ];
  static const List<String> CHI = [
    "Tý",
    "Sửu",
    "Dần",
    "Mão",
    "Thìn",
    "Tỵ",
    "Ngọ",
    "Mùi",
    "Thân",
    "Dậu",
    "Tuất",
    "Hợi"
  ];

  static Lunar convertSolarToLunar(DateTime date) {
    Solar solar =
        Solar(solarYear: date.year, solarMonth: date.month, solarDay: date.day);
    return LunarSolarConverter.solarToLunar(solar);
  }

  static String getLunarDateString(DateTime date) {
    Lunar lunar = convertSolarToLunar(date);
    return "${lunar.lunarDay}/${lunar.lunarMonth}";
  }

  static String getYearCanChi(int year) {
    String can = CAN[(year + 6) % 10];
    String chi = CHI[(year + 8) % 12];
    return "$can $chi";
  }

  static String getDayCanChi(DateTime date) {
    int a = ((14 - date.month) / 12).floor();
    int y = date.year + 4800 - a;
    int m = date.month + 12 * a - 3;
    int jdn = date.day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
    return "${CAN[(jdn + 9) % 10]} ${CHI[(jdn + 1) % 12]}";
  }

  static Map<String, String> getFullInfo(DateTime date) {
    Lunar lunar = convertSolarToLunar(date);
    return {
      "day": "${lunar.lunarDay}",
      "month": "Tháng ${lunar.lunarMonth}",
      "yearCanChi": getYearCanChi(lunar.lunarYear!),
      "dayCanChi": getDayCanChi(date),
    };
  }
}

// ==========================================
// PHẦN 2: GIAO DIỆN ỨNG DỤNG (UI)
// ==========================================
void main() {
  runApp(const LunarCalendarApp());
}

class LunarCalendarApp extends StatelessWidget {
  const LunarCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lịch Vạn Niên',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE53935)),
      ),
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final lunarInfo = LunarUtils.getFullInfo(_selectedDay ?? DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Lịch Vạn Niên',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // KHỐI THÔNG TIN CHI TIẾT
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.orange.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  // Ngày Dương
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('EEEE').format(_selectedDay!),
                        style: const TextStyle(color: Colors.white70)),
                    Text("${_selectedDay?.day}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.0)),
                    Text("Tháng ${_selectedDay?.month} - ${_selectedDay?.year}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                Container(
                  // Ngày Âm
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const Text("ÂM LỊCH",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 10)),
                      Text(lunarInfo['day']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      Text(lunarInfo['month']!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(lunarInfo['yearCanChi']!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                      Text(lunarInfo['dayCanChi']!,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                )
              ],
            ),
          ),

          // KHỐI LỊCH
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: TableCalendar(
                locale: 'en_US',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) =>
                      _buildCustomDay(day, isSelected: false, isToday: false),
                  selectedBuilder: (context, day, focusedDay) =>
                      _buildCustomDay(day, isSelected: true, isToday: false),
                  todayBuilder: (context, day, focusedDay) =>
                      _buildCustomDay(day, isSelected: false, isToday: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDay(DateTime day,
      {required bool isSelected, required bool isToday}) {
    final String lunarText = LunarUtils.getLunarDateString(day).split('/')[0];
    Color bgColor = Colors.transparent;
    Color solarColor = Colors.black87;
    Color lunarColor = Colors.grey;

    if (isSelected) {
      bgColor = const Color(0xFFE53935);
      solarColor = Colors.white;
      lunarColor = Colors.white70;
    } else if (isToday) {
      bgColor = Colors.red.shade50;
      solarColor = Colors.red;
      lunarColor = Colors.red.shade300;
    } else if (day.weekday == DateTime.sunday ||
        day.weekday == DateTime.saturday) {
      solarColor = Colors.red.shade800;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: Colors.red.shade200)
              : null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: solarColor)),
          Text(lunarText, style: TextStyle(fontSize: 10, color: lunarColor)),
        ],
      ),
    );
  }
}
