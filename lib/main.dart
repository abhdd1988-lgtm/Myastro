
import 'package:flutter/material.dart';

void main() => runApp(const AstroApp());

class AstroApp extends StatelessWidget {
  const AstroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF12121E),
      ),
      home: const BirthChartScreen(),
    );
  }
}

class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  DateTime? selectedDate = DateTime(2000, 1, 1);
  TimeOfDay? selectedTime = const TimeOfDay(hour: 12, minute: 0);
  double latitude = 35.6892;
  double longitude = 51.3890;

  String? risingSign;
  List<String> annualEvents = [];

  final List<String> zodiacSigns = [
    "حمل (Aries)", "ثور (Taurus)", "جوزا (Gemini)", "سرطان (Cancer)",
    "اسد (Leo)", "سنبله (Virgo)", "میزان (Libra)", "عقرب (Scorpio)",
    "قوس (Sagittarius)", "جدی (Capricorn)", "دلو (Aquarius)", "حوت (Pisces)"
  ];

  void calculateChart() {
    if (selectedDate == null || selectedTime == null) return;

    double totalHours = selectedTime!.hour + (selectedTime!.minute / 60.0);
    double localSiderealEstimate = (totalHours + (longitude / 15.0)) % 24;
    int signIndex = (localSiderealEstimate / 2).floor() % 12;

    setState(() {
      risingSign = zodiacSigns[signIndex];
      annualEvents = [
        "بازگشت خورشیدی (Solar Return): حوالی روز تولد در ماه ${selectedDate!.month}",
        "ترانزیت زحل (Saturn Transition): بررسی فشارها و تکالیف مسئولیت‌پذیری",
        "ماه نو در برج $risingSign: بهترین زمان برای شروع اهداف و بازآفرینی فردی",
        "بازگشت مشتری (Jupiter Return): دوره ۱۲ ساله رشد، شانس و توسعه فردی",
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("محاسبه چارت تولد و رایزینگ"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              tileColor: const Color(0xFF1E1E2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.calendar_month, color: Colors.amber),
              title: Text("تاریخ تولد: ${selectedDate?.toLocal().toString().split(' ')[0]}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate!,
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => selectedDate = date);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: const Color(0xFF1E1E2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.access_time, color: Colors.cyan),
              title: Text("ساعت تولد: ${selectedTime?.format(context)}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime!,
                );
                if (time != null) setState(() => selectedTime = time);
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("مختصات جغرافیایی (طول و عرض):"),
                      Text("Lon: ${longitude.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.greenAccent)),
                    ],
                  ),
                  Slider(
                    value: longitude,
                    min: 44.0,
                    max: 63.0,
                    divisions: 190,
                    label: "${longitude.toStringAsFixed(2)}",
                    onChanged: (val) => setState(() => longitude = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: calculateChart,
              child: const Text("محاسبه طالع و ترانزیت‌ها", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 25),
            if (risingSign != null) ...[
              Card(
                color: const Color(0xFF2A2050),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text("نشان طالع (رایزینگ شما):", style: TextStyle(fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(risingSign!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...annualEvents.map((event) => Card(
                    color: const Color(0xFF1A1A2E),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.auto_awesome, color: Colors.orangeAccent),
                      title: Text(event, style: const TextStyle(fontSize: 13)),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
