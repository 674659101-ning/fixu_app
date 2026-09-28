import 'dart:io';
import 'package:flutter/material.dart';
import 'services/storage_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _selectedTicketIndex = 0;
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final list = await StorageService.getTickets();
    setState(() {
      _tickets = list;
      _isLoading = false;
      if (_selectedTicketIndex >= _tickets.length && _tickets.isNotEmpty) {
        _selectedTicketIndex = 0;
      }
    });
  }

  void _callTechnician(String name, String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.phone_in_talk_rounded, color: Color(0xFF015ED3), size: 26),
            SizedBox(width: 10),
            Text('ติดต่อช่างผู้รับผิดชอบ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อช่าง: $name', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 6),
            Text('เบอร์โทรศัพท์: $phone', style: const TextStyle(fontSize: 15, color: Color(0xFF015ED3), fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text('กำลังโทรออกยังหมายเลขดังกล่าว...', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF015ED3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.support_agent_rounded, color: Color(0xFF015ED3), size: 28),
                SizedBox(width: 10),
                Text('ศูนย์บริการและช่วยเหลือ FixU', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ],
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.phone_rounded, color: Color(0xFF015ED3)),
              title: Text('สายด่วนแจ้งปัญหา FixU Center'),
              subtitle: Text('02-123-4567 (เวลาทำการ 08:30 - 16:30 น.)'),
            ),
            const ListTile(
              leading: Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF10B981)),
              title: Text('LINE Official Account'),
              subtitle: Text('@FixU_Service (ตลอด 24 ชั่วโมง)'),
            ),
            const SizedBox(height: 16),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ซ่อมเสร็จ':
        return const Color(0xFF10B981); // Green
      case 'กำลังซ่อม':
        return const Color(0xFFF59E0B); // Orange
      case 'รอดำเนินการ':
      default:
        return const Color(0xFF015ED3); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ติดตามสถานะ',
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
          : _tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.assignment_late_outlined, size: 64, color: Color(0xFF94A3B8)),
                      SizedBox(height: 12),
                      Text(
                        'ยังไม่มีรายการแจ้งซ่อม',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'เมื่อคุณส่งแจ้งซ่อม รายการจะปรากฏในหน้านี้',
                        style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Ticket Selector Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tickets.length, (index) {
                            final isSelected = _selectedTicketIndex == index;
                            final item = _tickets[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(
                                  '${item['id']} (${item['status']})',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFF334155),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: const Color(0xFF015ED3),
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF015ED3) : const Color(0xFFE2E8F0),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedTicketIndex = index;
                                    });
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Main Ticket Details Card
                      _buildTicketDetailsCard(_tickets[_selectedTicketIndex]),
                      const SizedBox(height: 22),

                      // 3. Status Timeline Section
                      _buildTimelineCard(_tickets[_selectedTicketIndex]),
                      const SizedBox(height: 22),

                      // 4. Technician Info Card
                      _buildTechnicianCard(_tickets[_selectedTicketIndex]),
                      const SizedBox(height: 20),

                      // 5. Contact Support Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF015ED3), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _contactSupport,
                          icon: const Icon(Icons.headset_mic_rounded, color: Color(0xFF015ED3), size: 20),
                          label: const Text(
                            'ติดต่อเจ้าหน้าที่ / ศูนย์บริการ FixU',
                            style: TextStyle(
                              color: Color(0xFF015ED3),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTicketDetailsCard(Map<String, dynamic> ticket) {
    final status = ticket['status'] as String? ?? 'รอดำเนินการ';
    final statusColor = _getStatusColor(status);
    final List<dynamic> imagePaths = ticket['imagePaths'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined, color: Color(0xFF015ED3), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    ticket['id'] as String? ?? 'FIX-2025-0000',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF015ED3),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
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
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          _buildDetailRow(Icons.business_rounded, 'สถานที่', ticket['location'] as String? ?? ''),
          const SizedBox(height: 10),
          _buildDetailRow(Icons.category_rounded, 'ประเภทอุปกรณ์', ticket['category'] as String? ?? ''),
          const SizedBox(height: 10),
          _buildDetailRow(Icons.description_outlined, 'รายละเอียด', ticket['description'] as String? ?? ''),
          const SizedBox(height: 10),
          _buildDetailRow(Icons.access_time_rounded, 'วันที่แจ้งซ่อม', ticket['reportDate'] as String? ?? ''),
          const SizedBox(height: 10),
          _buildDetailRow(Icons.speed_rounded, 'ความเร่งด่วน', ticket['urgency'] as String? ?? 'ปกติ'),

          // Attached Images Gallery Preview
          if (imagePaths.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text(
              'รูปภาพที่แนบ:',
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
        ],
      ),
    );
  }

  Widget _buildTimelineCard(Map<String, dynamic> ticket) {
    final status = ticket['status'] as String? ?? 'รอดำเนินการ';

    final bool isStep1Done = true;
    final bool isStep2Done = status == 'กำลังซ่อม' || status == 'ซ่อมเสร็จ';
    final bool isStep3Done = status == 'ซ่อมเสร็จ';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.timeline_rounded, color: Color(0xFF015ED3), size: 22),
              SizedBox(width: 8),
              Text(
                'สถานะการดำเนินงาน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Step 1: รอดำเนินการ
          _buildTimelineStep(
            title: '1. รอดำเนินการ',
            subtitle: 'ระบบรับข้อมูลคำขอเรียบร้อยแล้ว อยู่ระหว่างจัดสรรช่าง',
            time: ticket['reportDate'] as String? ?? '',
            isDone: isStep1Done,
            isActive: status == 'รอดำเนินการ',
            isLast: false,
          ),

          // Step 2: กำลังซ่อม
          _buildTimelineStep(
            title: '2. กำลังซ่อม',
            subtitle: isStep2Done
                ? 'ช่างรับเรื่อง เข้าดำเนินการตรวจเช็กและซ่อมแซม'
                : 'รอช่างเข้ารับงานและเริ่มดำเนินการซ่อมแซม',
            time: isStep2Done ? 'ดำเนินการอยู่' : 'รอดำเนินการ',
            isDone: isStep2Done,
            isActive: status == 'กำลังซ่อม',
            isLast: false,
          ),

          // Step 3: ซ่อมเสร็จ
          _buildTimelineStep(
            title: '3. ซ่อมเสร็จ',
            subtitle: isStep3Done
                ? 'การซ่อมแซมเสร็จสิ้น ตรวจสอบความถูกต้องเรียบร้อยแล้ว'
                : 'รอส่งมอบงานหลังการซ่อมแซมเสร็จสิ้น',
            time: isStep3Done ? 'เสร็จสิ้นเรียบร้อย' : 'รอดำเนินการ',
            isDone: isStep3Done,
            isActive: status == 'ซ่อมเสร็จ',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required String time,
    required bool isDone,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFFF59E0B)
                    : (isDone ? const Color(0xFF10B981) : const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Icon(
                  isDone ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
                  size: 16,
                  color: isDone ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.5,
                height: 48,
                color: isDone ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDone ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ปัจจุบัน',
                          style: TextStyle(fontSize: 10, color: Color(0xFFD97706), fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDone ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicianCard(Map<String, dynamic> ticket) {
    final techName = ticket['technicianName'] as String? ?? 'ช่างประจำศูนย์ FixU Center';
    final techPhone = ticket['technicianPhone'] as String? ?? '02-123-4567';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ช่างผู้รับผิดชอบ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0EDFF),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF015ED3),
                  child: Icon(Icons.engineering_rounded, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      techName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'เบอร์โทร: $techPhone',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF015ED3),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _callTechnician(techName, techPhone),
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: const Text('ติดต่อช่าง', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
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
          width: 90,
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
}
