import 'dart:io';
import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'login.dart';
import 'repair.dart';
import 'tracking.dart';
import 'history.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _userName = 'คุณสมชาย ใจดี';
  String _userStudentId = '650123456';
  String _userProfileImagePath = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await StorageService.getProfile();
    setState(() {
      _userName = profile['name'] ?? 'คุณสมชาย ใจดี';
      _userStudentId = profile['studentId'] ?? '650123456';
      _userProfileImagePath = profile['profileImagePath'] ?? '';
    });
  }

  void _onMenuTap(int index) async {
    switch (index) {
      case 0: // แจ้งซ่อม
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RepairScreen()),
        );
        if (!mounted) return;
        _loadUserProfile();
        break;
      case 1: // ติดตามสถานะ
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingScreen()),
        );
        if (!mounted) return;
        _loadUserProfile();
        break;
      case 2: // ประวัติการแจ้ง
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        if (!mounted) return;
        _loadUserProfile();
        break;
      case 3: // ข่าวสาร
        _showNewsDialog();
        break;
      case 4: // ข้อมูลส่วนตัว / โปรไฟล์
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        if (!mounted) return;
        _loadUserProfile();
        break;
      case 5: // ตั้งค่า
        _showSettingsDialog();
        break;
    }
  }

  void _showNewsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
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
            const Row(
              children: [
                Icon(Icons.campaign_rounded, color: Color(0xFF015ED3), size: 28),
                SizedBox(width: 10),
                Text(
                  'ข่าวสาร & ประกาศล่าสุด',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildNewsCard(
                    title: 'แจ้งปิดปรับปรุงระบบไฟฟ้าประจำสัปดาห์',
                    date: '12 พฤษภาคม 2025',
                    desc: 'ทางกองอาคารสถานที่ขอแจ้งปิดปรับปรุงระบบไฟฟ้ารายสัปดาห์ ณ อาคารเรียนรวม 3 และ 4 ในวันอาทิตย์นี้ เวลา 09.00 - 16.00 น.',
                    tag: 'ประกาศสำคัญ',
                    tagColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  _buildNewsCard(
                    title: 'เพิ่มช่องทางแจ้งซ่อมอุปกรณ์คอมพิวเตอร์และเครือข่าย',
                    date: '10 พฤษภาคม 2025',
                    desc: 'แอป FixU ได้เพิ่มหมวดหมู่การแจ้งซ่อมระบบไอที เครื่องคอมพิวเตอร์ และจุดกระจายสัญญาณ Wi-Fi ประจำคณะแล้ว',
                    tag: 'อัปเดตระบบ',
                    tagColor: const Color(0xFF015ED3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings_rounded, color: Color(0xFF015ED3)),
            SizedBox(width: 10),
            Text('ตั้งค่าระบบ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text('การแจ้งเตือน'),
              trailing: Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFF015ED3)),
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text('ภาษา (Language)'),
              subtitle: const Text('ไทย'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Curved Blue Header Section
            _buildHeader(context),

            const SizedBox(height: 20),

            // 2. Main 6 Grid Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เมนูหลัก',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.92,
                    children: [
                      _buildMenuItem(
                        title: 'แจ้งซ่อม',
                        icon: Icons.build_rounded,
                        bgColor: const Color(0xFF1276EE),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(0),
                      ),
                      _buildMenuItem(
                        title: 'ติดตามสถานะ',
                        icon: Icons.find_in_page_rounded,
                        bgColor: const Color(0xFF4ECB9C),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(1),
                      ),
                      _buildMenuItem(
                        title: 'ประวัติการแจ้ง',
                        icon: Icons.history_rounded,
                        bgColor: const Color(0xFFFDB646),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(2),
                      ),
                      _buildMenuItem(
                        title: 'ข่าวสาร',
                        icon: Icons.newspaper_rounded,
                        bgColor: const Color(0xFF3EC6D0),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(3),
                      ),
                      _buildMenuItem(
                        title: 'ข้อมูลส่วนตัว',
                        icon: Icons.person_rounded,
                        bgColor: const Color(0xFF8B5CF6),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(4),
                      ),
                      _buildMenuItem(
                        title: 'ตั้งค่า',
                        icon: Icons.settings_rounded,
                        bgColor: const Color(0xFF94A3B8),
                        iconColor: Colors.white,
                        onTap: () => _onMenuTap(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. News & Announcements Card Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ประกาศ & ข่าวสาร',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      TextButton(
                        onPressed: _showNewsDialog,
                        child: const Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFF015ED3), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // News Banner Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF4FE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC7E2FE), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF015ED3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'ประชาสัมพันธ์',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '12 พ.ค. 2025',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'แจ้งปิดปรับปรุงระบบไฟฟ้าประจำสัปดาห์',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'ปิดปรับปรุงระบบไฟฟ้า อาคารเรียนรวม 3 และ 4 เพื่อบำรุงรักษาอุปกรณ์ตามรอบประจำเดือน',
                          style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _showNewsDialog,
                          child: const Row(
                            children: [
                              Text(
                                'อ่านรายละเอียดเพิ่มเติม',
                                style: TextStyle(
                                  color: Color(0xFF015ED3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, color: Color(0xFF015ED3), size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // 4. Bottom Navigation Bar
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
          onTap: (index) async {
            setState(() {
              _currentNavIndex = index;
            });
            if (index == 1) {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const RepairScreen()));
              if (!mounted) return;
              _loadUserProfile();
            } else if (index == 2) {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
              if (!mounted) return;
              _loadUserProfile();
            } else if (index == 3) {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              if (!mounted) return;
              _loadUserProfile();
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
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'หน้าแรก'),
            BottomNavigationBarItem(icon: Icon(Icons.build_outlined), label: 'แจ้งซ่อม'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'ประวัติ'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'โปรไฟล์'),
          ],
        ),
      ),
    );
  }

  // Build Curved Blue Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF015ED3),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar (Custom Profile Picture if selected)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  backgroundImage: _userProfileImagePath.isNotEmpty
                      ? FileImage(File(_userProfileImagePath)) as ImageProvider
                      : null,
                  child: _userProfileImagePath.isEmpty
                      ? const Icon(Icons.person, color: Color(0xFF015ED3), size: 28)
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              // User Name & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'สวัสดี 👋',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'รหัสนักศึกษา: $_userStudentId',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Notification Bell Icon with Badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
                    onPressed: _showNewsDialog,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: const Text(
                        '2',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build Grid Menu Item Widget
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build News Item Card inside Bottom Sheet
  Widget _buildNewsCard({
    required String title,
    required String date,
    required String desc,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: tagColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.3)),
        ],
      ),
    );
  }
}
