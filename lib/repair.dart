import 'package:flutter/material.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  final _formKey = GlobalKey<FormState>();

  // Location Dropdown & Room
  String? _selectedLocation = 'อาคารเรียนรวม (LHC)';
  final List<String> _locations = [
    'อาคารเรียนรวม (LHC)',
    'อาคารวิศวกรรมศาสตร์',
    'อาคารวิทยาศาสตร์',
    'อาคารเทคโนโลยีสารสนเทศ',
    'หอพักนักศึกษาชาย',
    'หอพักนักศึกษาหญิง',
    'อาคารสำนักงานอธิการบดี',
    'หอประชุมใหญ่',
  ];
  final TextEditingController _roomController = TextEditingController(text: 'ห้อง 305');

  // Category Dropdown
  String? _selectedCategory = 'เครื่องปรับอากาศ';
  final List<Map<String, dynamic>> _categories = [
    {'name': 'เครื่องปรับอากาศ', 'icon': Icons.ac_unit_rounded},
    {'name': 'ระบบไฟฟ้า / หลอดไฟ', 'icon': Icons.lightbulb_outline_rounded},
    {'name': 'ระบบประปา / ห้องน้ำ', 'icon': Icons.water_drop_outlined},
    {'name': 'ครุภัณฑ์ / โต๊ะเก้าอี้', 'icon': Icons.chair_outlined},
    {'name': 'อุปกรณ์คอมพิวเตอร์ / ไอที', 'icon': Icons.computer_rounded},
    {'name': 'อุปกรณ์อื่น ๆ', 'icon': Icons.build_circle_outlined},
  ];

  // Description
  final TextEditingController _descriptionController = TextEditingController();

  // Urgency
  String _urgency = 'ปกติ'; // 'ปกติ' or 'ด่วน'

  // Image attach state
  bool _hasImageAttached = false;

  @override
  void dispose() {
    _roomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'ส่งคำขอสำเร็จ!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ระบบได้รับข้อมูลการแจ้งซ่อมเรียบร้อยแล้ว\nความเร่งด่วน: $_urgency',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF015ED3),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Back to previous screen
                  },
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
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
              // 1. Photo Attach Area
              const Text(
                'รูปภาพอุปกรณ์ที่ชำรุด',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _hasImageAttached = !_hasImageAttached;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_hasImageAttached ? 'แนบรูปภาพเรียบร้อยแล้ว' : 'ยกเลิกการแนบรูปภาพ'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _hasImageAttached ? const Color(0xFFEBF4FE) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _hasImageAttached ? const Color(0xFF015ED3) : const Color(0xFFCBD5E1),
                      width: _hasImageAttached ? 2 : 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _hasImageAttached ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                        size: 40,
                        color: const Color(0xFF015ED3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _hasImageAttached ? 'แนบรูปภาพอุปกรณ์แล้ว (แตะเพื่อเปลี่ยน)' : 'แตะเพื่อแนบรูปภาพหรือถ่ายรูปอุปกรณ์',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'รองรับไฟล์ JPG, PNG (ไม่เกิน 10MB)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 2. Location & Room Section
              Container(
                padding: const EdgeInsets.all(18),
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
                        Icon(Icons.location_on_rounded, color: Color(0xFF015ED3), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'เลือกสถานที่เกิดปัญหา',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Location Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                      decoration: _inputDecoration(
                        hint: 'เลือกอาคาร / สถานที่',
                        icon: Icons.business_rounded,
                      ),
                      items: _locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty) ? 'กรุณาเลือกสถานที่' : null,
                    ),
                    const SizedBox(height: 12),

                    // Room Input
                    TextFormField(
                      controller: _roomController,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                      decoration: _inputDecoration(
                        hint: 'ระบุห้อง / บริเวณ (เช่น ห้อง 305)',
                        icon: Icons.meeting_room_rounded,
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty) ? 'กรุณาระบุห้องหรือบริเวณ' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Category & Description Section
              Container(
                padding: const EdgeInsets.all(18),
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
                        Icon(Icons.build_circle_rounded, color: Color(0xFF015ED3), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'ประเภทปัญหา & รายละเอียด',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                      decoration: _inputDecoration(
                        hint: 'เลือกประเภทปัญหา',
                        icon: Icons.category_rounded,
                      ),
                      items: _categories.map((cat) {
                        final String name = cat['name'] as String;
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty) ? 'กรุณาเลือกประเภทปัญหา' : null,
                    ),
                    const SizedBox(height: 12),

                    // Description Text Area
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                      decoration: _inputDecoration(
                        hint: 'กรอกอธิบายอาการชำรุดหรือรายละเอียดเพิ่มเติม...',
                        icon: Icons.edit_note_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกรายละเอียดปัญหา';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Urgency Level Selection
              Container(
                padding: const EdgeInsets.all(18),
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
                        Icon(Icons.speed_rounded, color: Color(0xFF015ED3), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'ระดับความเร่งด่วน',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUrgencyOption(
                            label: 'ปกติ',
                            icon: Icons.schedule_rounded,
                            activeColor: const Color(0xFF015ED3),
                            isSelected: _urgency == 'ปกติ',
                            onTap: () {
                              setState(() {
                                _urgency = 'ปกติ';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildUrgencyOption(
                            label: 'ด่วน 🚨',
                            icon: Icons.warning_amber_rounded,
                            activeColor: Colors.redAccent,
                            isSelected: _urgency == 'ด่วน',
                            onTap: () {
                              setState(() {
                                _urgency = 'ด่วน';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 5. Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF015ED3),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'ส่งแจ้งซ่อม',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyOption({
    required String label,
    required IconData icon,
    required Color activeColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.12) : const Color(0xFFFAFAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? activeColor : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : const Color(0xFF64748B),
              ),
            ),
          ],
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
        borderSide: const BorderSide(color: Color(0xFF015ED3), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }
}
