import 'package:flutter/material.dart';
import 'home.dart';
import 'repair.dart';
import 'tracking.dart';
import 'login.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0; // 0: ทั้งหมด, 1: กำลังดำเนินการ, 2: เสร็จสิ้น
  int _currentNavIndex = 3; // Active tab is "ประวัติ" (Index 3)

  // Sample Mock Dataset for History Items
  final List<Map<String, dynamic>> _historyItems = [
    {
      'id': 'FIX-2025-0042',
      'category': 'เครื่องปรับอากาศ',
      'location': 'อาคารเรียนรวม (LHC) - ห้อง 305',
      'date': '12 พ.ค. 2025 | 10:30 น.',
      'status': 'กำลังซ่อม',
      'statusColor': const Color(0xFFF59E0B), // Orange
      'statusBg': const Color(0xFFFEF3C7),
      'icon': Icons.ac_unit_rounded,
      'description': 'แอร์มีเสียงดังและไม่เย็น มีน้ำหยดลงพื้นห้องเรียน',
      'technician': 'ช่างสมศักดิ์ มีสุข (081-234-5678)',
      'rating': 0,
    },
    {
      'id': 'FIX-2025-0038',
      'category': 'ระบบไฟฟ้า',
      'location': 'หอพักนักศึกษาชาย 2 - ชั้น 3',
      'date': '10 พ.ค. 2025 | 14:15 น.',
      'status': 'ซ่อมเสร็จ',
      'statusColor': const Color(0xFF10B981), // Green
      'statusBg': const Color(0xFFD1FAE5),
      'icon': Icons.lightbulb_outline_rounded,
      'description': 'หลอดไฟทางเดินหน้าห้อง 302 และ 304 ดับมืด',
      'technician': 'ช่างวิชัย ประเสริฐ (089-876-5432)',
      'rating': 5,
    },
    {
      'id': 'FIX-2025-0029',
      'category': 'อุปกรณ์ไอที',
      'location': 'อาคารวิศวกรรมศาสตร์ - ห้อง 201',
      'date': '08 พ.ค. 2025 | 11:00 น.',
      'status': 'ซ่อมเสร็จ',
      'statusColor': const Color(0xFF10B981), // Green
      'statusBg': const Color(0xFFD1FAE5),
      'icon': Icons.computer_rounded,
      'description': 'สายสัญญาณโปรเจกเตอร์ชำรุด ไม่มีภาพขึ้นหน้าจอ',
      'technician': 'ช่างมานพ ใจมั่น (082-345-6789)',
      'rating': 5,
    },
    {
      'id': 'FIX-2025-0015',
      'category': 'ระบบประปา',
      'location': 'อาคารวิทยาศาสตร์ - ห้องน้ำชั้น 1',
      'date': '28 เม.ย. 2025 | 09:20 น.',
      'status': 'ยกเลิก',
      'statusColor': const Color(0xFF64748B), // Gray
      'statusBg': const Color(0xFFF1F5F9),
      'icon': Icons.water_drop_outlined,
      'description': 'ก๊อกน้ำอ่างล้างมือรั่วซึม (ยกเลิกเนื่องจากแจ้งข้อมูลซ้ำ)',
      'technician': 'เจ้าหน้าที่รับเรื่องยกเลิก',
      'rating': 0,
    },
    {
      'id': 'FIX-2025-0008',
      'category': 'ครุภัณฑ์',
      'location': 'หอประชุมใหญ่ - แถว B',
      'date': '15 เม.ย. 2025 | 13:40 น.',
      'status': 'ซ่อมเสร็จ',
      'statusColor': const Color(0xFF10B981), // Green
      'statusBg': const Color(0xFFD1FAE5),
      'icon': Icons.chair_outlined,
      'description': 'เก้าอี้บรรยายชำรุด น็อตยึดพนักพิงหลุด',
      'technician': 'ช่างวิศรุต สุขเกษม (084-567-8901)',
      'rating': 4,
    },
  ];

  void _showItemDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['id'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF015ED3),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item['statusBg'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'] as String,
                    style: TextStyle(
                      color: item['statusColor'] as Color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.category_rounded, 'ประเภทอุปกรณ์', item['category'] as String),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.business_rounded, 'สถานที่', item['location'] as String),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time_rounded, 'วันที่แจ้งซ่อม', item['date'] as String),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.description_outlined, 'รายละเอียด', item['description'] as String),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.engineering_rounded, 'ช่างผู้รับผิดชอบ', item['technician'] as String),
            if ((item['rating'] as int) > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 100,
                    child: Text('คะแนนประเมิน', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (starIndex) => Icon(
                        starIndex < (item['rating'] as int)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 18,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF015ED3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('ปิด', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter history list based on selected filter tab
    final filteredList = _historyItems.where((item) {
      if (_selectedFilter == 1) {
        return item['status'] == 'กำลังซ่อม' || item['status'] == 'กำลังดำเนินการ';
      }
      if (_selectedFilter == 2) {
        return item['status'] == 'ซ่อมเสร็จ' || item['status'] == 'ดำเนินการเรียบร้อย';
      }
      return true; // 0: ทั้งหมด
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ประวัติการแจ้ง',
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
      body: Column(
        children: [
          // 1. Filter Chips Bar (ทั้งหมด / กำลังดำเนินการ / เสร็จสิ้น)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('ทั้งหมด', 0),
                const SizedBox(width: 8),
                _buildFilterChip('กำลังดำเนินการ', 1),
                const SizedBox(width: 8),
                _buildFilterChip('เสร็จสิ้น', 2),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 2. History Cards List
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text('ไม่พบประวัติการแจ้งซ่อมในหมวดหมู่นี้', style: TextStyle(color: Color(0xFF94A3B8))),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final Color statusColor = item['statusColor'] as Color;
                      final Color statusBg = item['statusBg'] as Color;

                      return GestureDetector(
                        onTap: () => _showItemDetail(item),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Request ID & Status Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(item['icon'] as IconData, size: 18, color: const Color(0xFF015ED3)),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['id'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF015ED3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['status'] as String,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Category & Location
                              Text(
                                '${item['category']} • ${item['location']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Description Preview
                              Text(
                                item['description'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                              ),
                              const SizedBox(height: 12),

                              // Date & View Details Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF94A3B8)),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['date'] as String,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        'ดูรายละเอียด',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF015ED3),
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF015ED3)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // 3. Bottom Navigation Bar (Highlighting "ประวัติ" Tab - Index 3)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
            if (index == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RepairScreen()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingScreen()));
            } else if (index == 4) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF015ED3),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              label: 'แจ้งซ่อม',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined),
              label: 'ติดตาม',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'ประวัติ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'ตั้งค่า',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF015ED3) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
