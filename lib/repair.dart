import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/storage_service.dart';
import 'tracking.dart';

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
    'หอพักนักศึกษาชาย 2',
    'หอพักนักศึกษาหญิง 1',
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

  // Image Picker List
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _attachedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _roomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 80,
        );
        if (photo != null) {
          setState(() {
            _attachedImages.add(photo);
          });
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 80,
        );
        if (images.isNotEmpty) {
          setState(() {
            _attachedImages.addAll(images);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถเข้าถึงกล้องหรือคลังภาพได้ กรุณาตรวจสอบสิทธิ์การใช้งานในเครื่อง'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'แนบรูปภาพอุปกรณ์ที่ชำรุด',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFF015ED3)),
              title: const Text('ถ่ายรูปด้วยกล้อง (Camera)'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF015ED3)),
              title: const Text('เลือกจากคลังภาพ (Gallery)'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      // Generate Ticket ID & Date
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');
      final randomNum = (now.millisecondsSinceEpoch % 9000) + 1000;

      final ticketId = 'FIX-$year-$randomNum';
      final reportDate = '$day/$month/$year | $hour:$minute น.';

      final newTicket = {
        'id': ticketId,
        'location': '${_selectedLocation ?? "อาคารเรียนรวม"} - ${_roomController.text.trim()}',
        'category': _selectedCategory ?? 'เครื่องปรับอากาศ',
        'description': _descriptionController.text.trim(),
        'reportDate': reportDate,
        'urgency': _urgency,
        'status': 'รอดำเนินการ',
        'imagePaths': _attachedImages.map((e) => e.path).toList(),
        'technicianName': 'ช่างประจำศูนย์ FixU Center',
        'technicianPhone': '02-123-4567',
      };

      // Save to SharedPreferences Local Storage
      await StorageService.addTicket(newTicket);

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

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
                'ส่งแจ้งซ่อมสำเร็จ!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'หมายเลขคำขอ: $ticketId\nระบบได้รับข้อมูลและส่งไปจัดสรรช่างเรียบร้อยแล้ว',
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TrackingScreen()),
                    );
                  },
                  child: const Text(
                    'ดูสถานะการแจ้งซ่อม',
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
              // 1. Real Photo Attach Area
              const Text(
                'รูปภาพอุปกรณ์ที่ชำรุด',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),

              if (_attachedImages.isEmpty)
                GestureDetector(
                  onTap: _showImageSourcePicker,
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_rounded, size: 40, color: Color(0xFF015ED3)),
                        SizedBox(height: 8),
                        Text(
                          'แตะเพื่อเพิ่มรูปภาพ (กล้องหรือคลังภาพ)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'แนบได้หลายรูปถ่ายจากอุปกรณ์จริง',
                          style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _attachedImages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _attachedImages.length) {
                            return GestureDetector(
                              onTap: _showImageSourcePicker,
                              child: Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF4FE),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF015ED3), width: 1.2),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_a_photo_rounded, color: Color(0xFF015ED3), size: 28),
                                    SizedBox(height: 4),
                                    Text('เพิ่มรูปภาพ', style: TextStyle(fontSize: 11, color: Color(0xFF015ED3), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          }

                          final xFile = _attachedImages[index];
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: FileImage(File(xFile.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 14,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
                          'สถานที่เกิดปัญหา',
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
                  onPressed: _isSubmitting ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF015ED3),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
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
