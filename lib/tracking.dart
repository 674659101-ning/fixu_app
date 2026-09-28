import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int _selectedTicketIndex = 0;

  // Sample Tracking Tickets Dataset
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'FIX-2025-0042',
      'location': 'อาคารเรียนรวม (LHC) - ห้อง 305',
      'category': 'เครื่องปรับอากาศ',
      'description': 'แอร์มีเสียงดังและไม่เย็น มีน้ำหยดลงพื้นห้องเรียน',
      'reportDate': '12 พ.ค. 2025 | 10:30 น.',
      'urgency': 'ด่วน 🚨',
      'urgencyColor': Colors.redAccent,
      'status': 'กำลังซ่อม',
      'statusColor': const Color(0xFFF59E0B),
      'currentStep': 2, // 1: รอดำเนินการ, 2: กำลังซ่อม, 3: ซ่อมเสร็จ
      'technician': {
        'name': 'ช่างสมศักดิ์ มีสุข',
        'role': 'ช่างเทคนิคระบบความเย็นประจำอาคาร',
        'phone': '081-234-5678',
      },
      'timeline': [
        {
          'title': 'รอดำเนินการ',
          'subtitle': 'ระบบได้รับข้อมูลการแจ้งซ่อมเรียบร้อยแล้ว',
          'time': '12 พ.ค. 2025, 10:30 น.',
          'isDone': true,
        },
        {
          'title': 'กำลังซ่อม',
          'subtitle': 'ช่างสมศักดิ์ เข้าตรวจสอบเครื่องปรับอากาศและเปลี่ยนอะไหล่',
          'time': '12 พ.ค. 2025, 13:15 น.',
          'isDone': true,
          'isActive': true,
        },
        {
          'title': 'ซ่อมเสร็จ',
          'subtitle': 'ดำเนินการซ่อมแซมเสร็จสิ้น ตรวจสอบความเรียบร้อย',
          'time': 'คาดว่าเสร็จสิ้น 12 พ.ค. 16:00 น.',
          'isDone': false,
        },
      ],
    },
    {
      'id': 'FIX-2025-0038',
      'location': 'หอพักนักศึกษาชาย 2 - ชั้น 3',
      'category': 'ระบบไฟฟ้า / หลอดไฟ',
      'description': 'หลอดไฟทางเดินหน้าห้อง 302 และ 304 ดับมืด',
      'reportDate': '10 พ.ค. 2025 | 14:15 น.',
      'urgency': 'ปกติ',
      'urgencyColor': const Color(0xFF015ED3),
      'status': 'ซ่อมเสร็จ',
      'statusColor': const Color(0xFF10B981),
      'currentStep': 3,
      'technician': {
        'name': 'ช่างวิชัย ประเสริฐ',
        'role': 'ช่างไฟฟ้าประจำหอพัก',
        'phone': '089-876-5432',
      },
      'timeline': [
        {
          'title': 'รอดำเนินการ',
          'subtitle': 'ระบบได้รับข้อมูลเรียบร้อยแล้ว',
          'time': '10 พ.ค. 2025, 14:15 น.',
          'isDone': true,
        },
        {
          'title': 'กำลังซ่อม',
          'subtitle': 'ช่างวิชัย รับเรื่องและเปลี่ยนหลอดไฟใหม่',
          'time': '10 พ.ค. 2025, 15:00 น.',
          'isDone': true,
        },
        {
          'title': 'ซ่อมเสร็จ',
          'subtitle': 'เปลี่ยนหลอดไฟ LED เรียบร้อยแล้ว ใช้งานได้ปกติ',
          'time': '10 พ.ค. 2025, 15:45 น.',
          'isDone': true,
          'isActive': true,
        },
      ],
    },
    {
      'id': 'FIX-2025-0050',
      'location': 'อาคารวิศวกรรมศาสตร์ - ห้อง 201',
      'category': 'อุปกรณ์คอมพิวเตอร์',
      'description': 'สายสัญญาณโปรเจกเตอร์ชำรุด ไม่มีภาพขึ้นหน้าจอ',
      'reportDate': '13 พ.ค. 2025 | 08:45 น.',
      'urgency': 'ปกติ',
      'urgencyColor': const Color(0xFF015ED3),
      'status': 'รอดำเนินการ',
      'statusColor': const Color(0xFF015ED3),
      'currentStep': 1,
      'technician': {
        'name': 'ศูนย์บริการ FixU IT',
        'role': 'กำลังมอบหมายช่างผู้รับผิดชอบ',
        'phone': '02-123-4567',
      },
      'timeline': [
        {
          'title': 'รอดำเนินการ',
          'subtitle': 'ระบบบันทึกรายการแจ้งซ่อม อยู่ระหว่างจัดสรรช่าง',
          'time': '13 พ.ค. 2025, 08:45 น.',
          'isDone': true,
          'isActive': true,
        },
        {
          'title': 'กำลังซ่อม',
          'subtitle': 'ช่างเตรียมอุปกรณ์และเข้าตรวจสอบ',
          'time': 'รอดำเนินการ',
          'isDone': false,
        },
        {
          'title': 'ซ่อมเสร็จ',
          'subtitle': 'ตรวจสอบการใช้งานหลังการซ่อมแซม',
          'time': 'รอดำเนินการ',
          'isDone': false,
        },
      ],
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final ticket = _tickets[_selectedTicketIndex];
    final tech = ticket['technician'] as Map<String, String>;
    final timeline = ticket['timeline'] as List<Map<String, dynamic>>;

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
      body: SingleChildScrollView(
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
            Container(
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
                            ticket['id'] as String,
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
                          color: (ticket['statusColor'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ticket['status'] as String,
                          style: TextStyle(
                            color: ticket['statusColor'] as Color,
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
                  _buildDetailRow(Icons.business_rounded, 'สถานที่', ticket['location'] as String),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.category_rounded, 'ประเภทอุปกรณ์', ticket['category'] as String),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.description_outlined, 'รายละเอียด', ticket['description'] as String),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.access_time_rounded, 'วันที่แจ้งซ่อม', ticket['reportDate'] as String),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 3. Status Timeline Section
            Container(
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

                  // Timeline Steps
                  Column(
                    children: List.generate(timeline.length, (index) {
                      final item = timeline[index];
                      final isLast = index == timeline.length - 1;
                      final bool isDone = item['isDone'] as bool;
                      final bool isActive = item['isActive'] ?? false;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline indicator line & circle
                          Column(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDone
                                      ? (isActive ? const Color(0xFFF59E0B) : const Color(0xFF10B981))
                                      : const Color(0xFFE2E8F0),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFF59E0B).withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Icon(
                                    isDone
                                        ? (isActive ? Icons.build_circle_rounded : Icons.check_rounded)
                                        : Icons.radio_button_unchecked_rounded,
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

                          // Timeline text details
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
                                        item['title'] as String,
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
                                    item['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDone ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['time'] as String,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 4. Technician Info Card
            Container(
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
                              tech['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tech['role']!,
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
                        onPressed: () => _callTechnician(tech['name']!, tech['phone']!),
                        icon: const Icon(Icons.phone_rounded, size: 16),
                        label: const Text('ติดต่อช่าง', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Contact Support / Officer Button
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
