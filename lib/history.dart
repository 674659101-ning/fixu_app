import 'dart:io';
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'home.dart';
import 'repair.dart';
import 'profile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0; // 0: ทั้งหมด, 1: กำลังดำเนินการ, 2: เสร็จสิ้น
  List<Map<String, dynamic>> _historyItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    final list = await StorageService.getTickets();
    setState(() {
      _historyItems = list;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ซ่อมเสร็จ':
      case 'ดำเนินการเรียบร้อย':
        return const Color(0xFF10B981); // Green
      case 'กำลังซ่อม':
      case 'กำลังดำเนินการ':
        return const Color(0xFFF59E0B); // Orange
      case 'ยกเลิก':
        return const Color(0xFF64748B); // Gray
      case 'รอดำเนินการ':
      default:
        return const Color(0xFF015ED3); // Blue
    }
  }

  Color _getStatusBg(String status) {
    switch (status) {
      case 'ซ่อมเสร็จ':
      case 'ดำเนินการเรียบร้อย':
        return const Color(0xFFD1FAE5);
      case 'กำลังซ่อม':
      case 'กำลังดำเนินการ':
        return const Color(0xFFFEF3C7);
      case 'ยกเลิก':
        return const Color(0xFFF1F5F9);
      case 'รอดำเนินการ':
      default:
        return const Color(0xFFEBF4FE);
    }
  }

  void _showItemDetail(Map<String, dynamic> item) {
    final status = item['status'] as String? ?? 'รอดำเนินการ';
    final statusColor = _getStatusColor(status);
    final statusBg = _getStatusBg(status);
    final List<dynamic> imagePaths = item['imagePaths'] as List<dynamic>? ?? [];

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
                  item['id'] as String? ?? 'FIX-2025-0000',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF015ED3),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
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
            _buildDetailRow(Icons.category_rounded, 'ประเภทอุปกรณ์', item['category'] as String? ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.business_rounded, 'สถานที่', item['location'] as String? ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time_rounded, 'วันที่แจ้งซ่อม', item['reportDate'] as String? ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.description_outlined, 'รายละเอียด', item['description'] as String? ?? ''),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.speed_rounded, 'ความเร่งด่วน', item['urgency'] as String? ?? 'ปกติ'),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.engineering_rounded, 'ช่างผู้ดูแล', item['technicianName'] as String? ?? 'ศูนย์ FixU Center'),

            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'รูปภาพอุปกรณ์ที่แนบ:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, idx) {
                    final path = imagePaths[idx].toString();
                    return Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
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
      final status = item['status'] as String? ?? '';
      if (_selectedFilter == 1) {
        return status == 'กำลังซ่อม' || status == 'กำลังดำเนินการ' || status == 'รอดำเนินการ';
      }
      if (_selectedFilter == 2) {
        return status == 'ซ่อมเสร็จ' || status == 'ดำเนินการเรียบร้อย';
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF015ED3)))
          : Column(
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
                            final status = item['status'] as String? ?? 'รอดำเนินการ';
                            final Color statusColor = _getStatusColor(status);
                            final Color statusBg = _getStatusBg(status);

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
                                            const Icon(Icons.build_circle_rounded, size: 18, color: Color(0xFF015ED3)),
                                            const SizedBox(width: 6),
                                            Text(
                                              item['id'] as String? ?? 'FIX-2025-0000',
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
                                            status,
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
                                      item['description'] as String? ?? '',
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
                                              item['reportDate'] as String? ?? '',
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

      // 3. Bottom Navigation Bar (Highlighting "ประวัติ" Tab - Index 2)
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
          currentIndex: 2, // History Tab
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RepairScreen()));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
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
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'หน้าแรก'),
            BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'แจ้งซ่อม'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'ประวัติ'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'โปรไฟล์'),
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
