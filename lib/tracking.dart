import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _selectedFilter = 0; // 0: ทั้งหมด, 1: กำลังดำเนินการ, 2: เสร็จสิ้น

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'FIX-2025-0042',
      'title': 'แอร์ห้องเรียน 402 ไม่เย็น มีเสียงดัง',
      'location': 'อาคารเรียนรวม 4 ชั้น 4 ห้อง 402',
      'date': '12 พ.ค. 2025, 09:30 น.',
      'status': 'กำลังดำเนินการ',
      'statusColor': const Color(0xFFF59E0B),
      'step': 2,
      'technician': 'ช่างสมศักดิ์ (เบอร์ 081-234-5678)',
    },
    {
      'id': 'FIX-2025-0038',
      'title': 'หลอดไฟทางเดินหอพักดับ 2 หลอด',
      'location': 'หอพักนักศึกษาชาย 2 ชั้น 3',
      'date': '10 พ.ค. 2025, 14:15 น.',
      'status': 'เสร็จสิ้น',
      'statusColor': const Color(0xFF10B981),
      'step': 3,
      'technician': 'ช่างวิชัย (ดำเนินการเสร็จแล้ว)',
    },
    {
      'id': 'FIX-2025-0029',
      'title': 'โปรเจกเตอร์ไม่มีสัญญาณภาพ',
      'location': 'อาคารคณะวิศวกรรมศาสตร์ ห้อง 201',
      'date': '08 พ.ค. 2025, 11:00 น.',
      'status': 'เสร็จสิ้น',
      'statusColor': const Color(0xFF10B981),
      'step': 3,
      'technician': 'ช่างมานพ (ดำเนินการเสร็จแล้ว)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTickets = _tickets.where((ticket) {
      if (_selectedFilter == 1) return ticket['status'] == 'กำลังดำเนินการ';
      if (_selectedFilter == 2) return ticket['status'] == 'เสร็จสิ้น';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ติดตามสถานะแจ้งซ่อม',
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
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildFilterTab('ทั้งหมด', 0),
                const SizedBox(width: 8),
                _buildFilterTab('กำลังดำเนินการ', 1),
                const SizedBox(width: 8),
                _buildFilterTab('เสร็จสิ้น', 2),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tickets List
          Expanded(
            child: filteredTickets.isEmpty
                ? const Center(
                    child: Text('ไม่พบรายการแจ้งซ่อม', style: TextStyle(color: Color(0xFF94A3B8))),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredTickets.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredTickets[index];
                      final Color statusColor = item['statusColor'] as Color;

                      return Container(
                        padding: const EdgeInsets.all(18),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['id'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
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
                            const SizedBox(height: 8),
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item['location'] as String,
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF94A3B8)),
                                const SizedBox(width: 4),
                                Text(
                                  item['date'] as String,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.person_pin_rounded, color: Color(0xFF0066FF), size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'ผู้ดูแล: ${item['technician']}',
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
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
