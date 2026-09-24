import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Map<String, dynamic>> _historyItems = const [
    {
      'id': 'FIX-2025-0038',
      'title': 'หลอดไฟทางเดินหอพักดับ 2 หลอด',
      'category': 'ระบบไฟฟ้า',
      'date': '10 พ.ค. 2025',
      'status': 'ดำเนินการเรียบร้อย',
      'rating': 5,
    },
    {
      'id': 'FIX-2025-0029',
      'title': 'โปรเจกเตอร์ไม่มีสัญญาณภาพ',
      'category': 'อุปกรณ์คอมพิวเตอร์',
      'date': '08 พ.ค. 2025',
      'status': 'ดำเนินการเรียบร้อย',
      'rating': 5,
    },
    {
      'id': 'FIX-2025-0015',
      'title': 'ก๊อกน้ำห้องน้ำชายรั่วซึม',
      'category': 'ระบบประปา',
      'date': '28 เม.ย. 2025',
      'status': 'ดำเนินการเรียบร้อย',
      'rating': 4,
    },
    {
      'id': 'FIX-2025-0004',
      'title': 'เก้าอี้บรรยายชำรุด ขาโยก',
      'category': 'ครุภัณฑ์',
      'date': '15 เม.ย. 2025',
      'status': 'ดำเนินการเรียบร้อย',
      'rating': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ประวัติการแจ้งซ่อม',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF015ED3),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _historyItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = _historyItems[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'หมวดหมู่: ${item['category']} • ${item['date']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                          (starIndex) => Icon(
                            starIndex < (item['rating'] as int)
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 16,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
              ],
            ),
          );
        },
      ),
    );
  }
}
