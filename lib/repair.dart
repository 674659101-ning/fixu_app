import 'package:flutter/material.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedCategory = 'เครื่องปรับอากาศ';
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'เครื่องปรับอากาศ', 'icon': Icons.ac_unit_rounded, 'color': const Color(0xFF0066FF)},
    {'name': 'ระบบไฟฟ้า/หลอดไฟ', 'icon': Icons.lightbulb_outline_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'ระบบประปา/ห้องน้ำ', 'icon': Icons.water_drop_outlined, 'color': const Color(0xFF06B6D4)},
    {'name': 'ครุภัณฑ์/เฟอร์นิเจอร์', 'icon': Icons.chair_outlined, 'color': const Color(0xFF8B5CF6)},
    {'name': 'อุปกรณ์คอมพิวเตอร์', 'icon': Icons.computer_rounded, 'color': const Color(0xFF10B981)},
    {'name': 'อื่นๆ', 'icon': Icons.build_circle_outlined, 'color': const Color(0xFF64748B)},
  ];

  @override
  void dispose() {
    _buildingController.dispose();
    _roomController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
              SizedBox(width: 10),
              Text('ส่งข้อมูลสำเร็จ', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'ระบบได้รับข้อมูลการแจ้งซ่อมของท่านเรียบร้อยแล้ว เจ้าหน้าที่จะดำเนินการตรวจสอบโดยเร็วที่สุด',
            style: TextStyle(fontSize: 15, color: Color(0xFF475569)),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to Home
              },
              child: const Text('ตกลง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'แจ้งซ่อม',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Select Category Section
              const Text(
                'หมวดหมู่การแจ้งซ่อม',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat['name'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 18,
                          color: isSelected ? Colors.white : (cat['color'] as Color),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['name'] as String,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF334155),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0066FF),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat['name'] as String;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 2. Location Information Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                        Icon(Icons.location_on_rounded, color: Color(0xFF0066FF), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'สถานที่เกิดปัญหา',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _buildingController,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'ระบุอาคาร / หอพัก (เช่น อาคารเรียนรวม 4)',
                        icon: Icons.business_rounded,
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'กรุณาระบุอาคารหรือสถานที่'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _roomController,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'ระบุห้อง / บริเวณ (เช่น ห้อง 402 ชั้น 4)',
                        icon: Icons.meeting_room_rounded,
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'กรุณาระบุห้องหรือบริเวณ'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Issue Detail Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                        Icon(Icons.description_rounded, color: Color(0xFF0066FF), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'รายละเอียดปัญหา & ติดต่อ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'อธิบายรายละเอียดอาการชำรุดหรือปัญหาที่พบ...',
                        icon: Icons.edit_note_rounded,
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'กรุณาอธิบายรายละเอียดปัญหา'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'เบอร์โทรศัพท์ติดต่อกลับ',
                        icon: Icons.phone_rounded,
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'กรุณาระบุเบอร์โทรศัพท์'
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Photo Upload Area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.add_a_photo_outlined, size: 36, color: Color(0xFF0066FF)),
                    const SizedBox(height: 8),
                    const Text(
                      'แนบรูปภาพสิ่งชำรุด (ถ้ามี)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'รองรับไฟล์ JPG, PNG ไม่เกิน 5MB',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'ส่งข้อมูลแจ้งซ่อม',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      filled: true,
      fillColor: const Color(0xFFFAFAFC),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0066FF), width: 1.8),
      ),
    );
  }
}
