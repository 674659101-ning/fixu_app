import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กำลังเข้าสู่ระบบ...'),
          duration: Duration(milliseconds: 800),
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    }
  }

  void _onGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('กำลังเข้าสู่ระบบด้วย Google...'),
        duration: Duration(milliseconds: 800),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  void _onRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ไปที่หน้าสมัครสมาชิก')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Bottom Campus Illustration Background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height * 0.22,
            child: const CustomPaint(
              painter: _CampusIllustrationPainter(),
            ),
          ),

          // 2. Top Left Blue Wave Fluid Accent
          Positioned(
            top: 0,
            left: 0,
            child: CustomPaint(
              size: Size(size.width * 0.55, 120),
              painter: const _TopWavePainter(),
            ),
          ),

          // 3. Main Content Scrollable View
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),

                        // App Logo Pin
                        const _FixULogoWidget(),
                        const SizedBox(height: 12),

                        // App Title: FixU
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'Fix',
                                style: TextStyle(color: Color(0xFF0D253C)),
                              ),
                              TextSpan(
                                text: 'U',
                                style: TextStyle(color: Color(0xFF0066FF)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Subtitle
                        const Text(
                          'แอปแจ้งซ่อมในมหาวิทยาลัย',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0052CC),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Input Field 1: Email / Student ID
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
                          decoration: InputDecoration(
                            hintText: 'อีเมล หรือ รหัสนักศึกษา',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF0066FF),
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.8,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกอีเมลหรือรหัสนักศึกษา';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Input Field 2: Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
                          decoration: InputDecoration(
                            hintText: 'รหัสผ่าน',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF94A3B8),
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF0066FF),
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.8,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Main Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Divider Line with "หรือ"
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'หรือ',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Google Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _onGoogleLogin,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _GoogleLogoWidget(size: 22),
                                SizedBox(width: 12),
                                Text(
                                  'เข้าสู่ระบบด้วย ',
                                  style: TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register Link Row
                        GestureDetector(
                          onTap: _onRegister,
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 15),
                              children: [
                                TextSpan(
                                  text: 'ยังไม่มีบัญชี? ',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                TextSpan(
                                  text: 'สมัครสมาชิก',
                                  style: TextStyle(
                                    color: Color(0xFF0066FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Pin Logo Widget
class _FixULogoWidget extends StatelessWidget {
  const _FixULogoWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 140,
      child: Image.asset(
        'assets/fixu_pin_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const CustomPaint(
          painter: _FixUPinPainter(),
        ),
      ),
    );
  }
}

class _FixUPinPainter extends CustomPainter {
  const _FixUPinPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Offset center = Offset(w / 2, h / 2 - 2);

    // 1. Ambient Drop Shadow under Pin/Badge
    final Paint shadowPaint = Paint()
      ..color = const Color(0xFF0066FF).withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(center.dx, center.dy + 8), w * 0.40, shadowPaint);

    // 2. Main Location Pin Badge Container
    final double headRadius = w * 0.42;
    final Offset pinHeadCenter = Offset(w / 2, headRadius + 4);

    final Paint pinPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0066FF), Color(0xFF0044CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final Path pinPath = Path();
    pinPath.addArc(
      Rect.fromCircle(center: pinHeadCenter, radius: headRadius),
      0.55,
      5.18,
    );
    pinPath.cubicTo(
      w / 2 - headRadius * 0.95, pinHeadCenter.dy + headRadius * 0.8,
      w / 2 - headRadius * 0.35, h - 14,
      w / 2, h - 4,
    );
    pinPath.cubicTo(
      w / 2 + headRadius * 0.35, h - 14,
      w / 2 + headRadius * 0.95, pinHeadCenter.dy + headRadius * 0.8,
      w / 2 + headRadius * 0.85, pinHeadCenter.dy + headRadius * 0.52,
    );
    pinPath.close();

    canvas.drawPath(pinPath, pinPaint);

    // Subtle Inner Ring Accent
    final Paint ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(pinHeadCenter, headRadius * 0.88, ringPaint);

    // 3. PROMINENT WHITE WRENCH (ประแจ) IN CENTER
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint blueCutoutPaint = Paint()
      ..color = const Color(0xFF0044CC)
      ..style = PaintingStyle.fill;

    canvas.save();
    // Translate to center of wrench and rotate -38 degrees for dynamic slant
    canvas.translate(pinHeadCenter.dx, pinHeadCenter.dy - 2);
    canvas.rotate(-0.66); // ~ -38 degrees

    final double wLength = headRadius * 1.05;
    final double handleWidth = headRadius * 0.28;

    // (A) Wrench Ergonomic Handle
    final RRect handleRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-handleWidth / 2, -wLength / 2, handleWidth, wLength),
      Radius.circular(handleWidth / 2),
    );
    canvas.drawRRect(handleRRect, whitePaint);

    // Handle Inner Mechanical Slot Cutout
    final RRect innerSlot = RRect.fromRectAndRadius(
      Rect.fromLTWH(-handleWidth * 0.20, -wLength * 0.24, handleWidth * 0.40, wLength * 0.48),
      Radius.circular(handleWidth * 0.20),
    );
    canvas.drawRRect(innerSlot, blueCutoutPaint);

    // (B) Top Open-Ended Wrench Head
    final double topHeadR = headRadius * 0.38;
    final Offset topHeadPos = Offset(0, -wLength / 2);

    canvas.drawCircle(topHeadPos, topHeadR, whitePaint);

    // Open Jaw Cutout in Top Head
    final double jawW = topHeadR * 0.90;
    final double jawH = topHeadR * 1.30;
    canvas.save();
    canvas.translate(topHeadPos.dx, topHeadPos.dy);
    canvas.rotate(-0.35); // Slight angle for open jaw
    canvas.drawRect(
      Rect.fromLTWH(-jawW / 2, -jawH * 0.80, jawW, jawH),
      blueCutoutPaint,
    );
    canvas.restore();

    // (C) Bottom Ring Box-End Wrench Head
    final double bottomHeadR = headRadius * 0.32;
    final Offset bottomHeadPos = Offset(0, wLength / 2);

    canvas.drawCircle(bottomHeadPos, bottomHeadR, whitePaint);
    canvas.drawCircle(bottomHeadPos, bottomHeadR * 0.52, blueCutoutPaint);

    canvas.restore(); // Restore Wrench Rotation

    // 4. University Building Silhouette at the base of the Pin Head
    final double bWidth = headRadius * 0.85;
    final double bHeight = headRadius * 0.38;
    final double bTopY = pinHeadCenter.dy + headRadius * 0.42;
    final double bLeftX = pinHeadCenter.dx - bWidth / 2;

    // Roof Pediment
    final Path roofPath = Path();
    roofPath.moveTo(bLeftX, bTopY + bHeight * 0.35);
    roofPath.lineTo(pinHeadCenter.dx, bTopY);
    roofPath.lineTo(bLeftX + bWidth, bTopY + bHeight * 0.35);
    roofPath.close();
    canvas.drawPath(roofPath, whitePaint);

    // Facade Body
    final double facadeY = bTopY + bHeight * 0.38;
    final double facadeH = bHeight * 0.62;
    canvas.drawRect(
      Rect.fromLTWH(bLeftX + 1, facadeY, bWidth - 2, facadeH),
      whitePaint,
    );

    // Column Cutouts
    final double colW = headRadius * 0.05;
    canvas.drawRect(
      Rect.fromLTWH(pinHeadCenter.dx - bWidth * 0.26, facadeY + 1, colW, facadeH - 1),
      blueCutoutPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(pinHeadCenter.dx + bWidth * 0.26 - colW, facadeY + 1, colW, facadeH - 1),
      blueCutoutPaint,
    );

    // Central Entrance Arch Doorway
    final double doorW = headRadius * 0.18;
    final double doorH = facadeH * 0.70;
    final Rect doorRect = Rect.fromLTWH(
      pinHeadCenter.dx - doorW / 2,
      facadeY + facadeH - doorH,
      doorW,
      doorH,
    );
    final RRect doorRRect = RRect.fromRectAndCorners(
      doorRect,
      topLeft: Radius.circular(doorW / 2),
      topRight: Radius.circular(doorW / 2),
    );
    canvas.drawRRect(doorRRect, blueCutoutPaint);

    // 5. Repair Spark Accent at top right of pin
    final Offset sparkCenter = Offset(pinHeadCenter.dx + headRadius * 0.62, pinHeadCenter.dy - headRadius * 0.62);
    final Paint sparkPaint = Paint()
      ..color = const Color(0xFF60A5FA)
      ..style = PaintingStyle.fill;

    final Path sparkPath = Path();
    const double rOuter = 6.5;
    const double rInner = 2.5;
    for (int i = 0; i < 8; i++) {
      final double angle = (i * math.pi / 4);
      final double r = i.isEven ? rOuter : rInner;
      final double x = sparkCenter.dx + r * math.cos(angle);
      final double y = sparkCenter.dy + r * math.sin(angle);
      if (i == 0) {
        sparkPath.moveTo(x, y);
      } else {
        sparkPath.lineTo(x, y);
      }
    }
    sparkPath.close();
    canvas.drawPath(sparkPath, sparkPaint);
    canvas.drawCircle(sparkCenter, 1.8, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Top Wave Painter
class _TopWavePainter extends CustomPainter {
  const _TopWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0066FF)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.75, 0);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.7,
      0,
      size.height,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Google 'G' Logo
class _GoogleLogoWidget extends StatelessWidget {
  final double size;
  const _GoogleLogoWidget({this.size = 22.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final double strokeWidth = size.width * 0.22;
    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final Paint p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red arc (Top)
    p.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -2.4, 1.8, false, p);

    // Yellow arc (Bottom-Left)
    p.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.0, 1.1, false, p);

    // Green arc (Bottom-Right)
    p.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 0.4, 1.6, false, p);

    // Blue arc (Right)
    p.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.6, 1.0, false, p);

    // Blue horizontal bar
    final Paint fillBlue = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - strokeWidth / 2,
        radius - strokeWidth / 4,
        strokeWidth,
      ),
      fillBlue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Bottom Campus Background Painter
class _CampusIllustrationPainter extends CustomPainter {
  const _CampusIllustrationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background soft blue hills/clouds
    final Paint bgHillPaint1 = Paint()..color = const Color(0xFFE8F1FC);
    final Path hill1 = Path();
    hill1.moveTo(0, h * 0.4);
    hill1.quadraticBezierTo(w * 0.25, h * 0.1, w * 0.5, h * 0.35);
    hill1.quadraticBezierTo(w * 0.75, h * 0.15, w, h * 0.4);
    hill1.lineTo(w, h);
    hill1.lineTo(0, h);
    hill1.close();
    canvas.drawPath(hill1, bgHillPaint1);

    final Paint bgHillPaint2 = Paint()..color = const Color(0xFFD3E4F9);
    final Path hill2 = Path();
    hill2.moveTo(0, h * 0.55);
    hill2.quadraticBezierTo(w * 0.3, h * 0.25, w * 0.6, h * 0.45);
    hill2.quadraticBezierTo(w * 0.85, h * 0.3, w, h * 0.5);
    hill2.lineTo(w, h);
    hill2.lineTo(0, h);
    hill2.close();
    canvas.drawPath(hill2, bgHillPaint2);

    // Campus Buildings
    final double mainW = w * 0.36;
    final double mainH = h * 0.52;
    final double mainX = (w - mainW) / 2;
    final double mainY = h - mainH - 12;

    final Paint mainBuildingPaint = Paint()..color = const Color(0xFFB5D5FA);
    final Paint accentBuildingPaint = Paint()..color = const Color(0xFF82B7F6);
    final Paint windowPaint = Paint()..color = const Color(0xFF3B82F6);
    final Paint whiteDoorPaint = Paint()..color = Colors.white;

    // Left Wing
    final double wingW = w * 0.24;
    final double wingH = h * 0.38;
    final double wingY = h - wingH - 12;
    canvas.drawRect(
      Rect.fromLTWH(mainX - wingW + 10, wingY, wingW, wingH),
      accentBuildingPaint,
    );
    // Right Wing
    canvas.drawRect(
      Rect.fromLTWH(mainX + mainW - 10, wingY, wingW, wingH),
      accentBuildingPaint,
    );

    // Left/Right Wing Windows
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        canvas.drawRect(
          Rect.fromLTWH(
            mainX - wingW + 18 + c * 16,
            wingY + 10 + r * 16,
            10,
            10,
          ),
          windowPaint,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            mainX + mainW + 6 + c * 16,
            wingY + 10 + r * 16,
            10,
            10,
          ),
          windowPaint,
        );
      }
    }

    // Main Central Building Body
    canvas.drawRect(
      Rect.fromLTWH(mainX, mainY, mainW, mainH),
      mainBuildingPaint,
    );

    // Pediment / Triangular Roof
    final Path roof = Path();
    roof.moveTo(mainX - 6, mainY);
    roof.lineTo(mainX + mainW / 2, mainY - 22);
    roof.lineTo(mainX + mainW + 6, mainY);
    roof.close();
    canvas.drawPath(roof, accentBuildingPaint);

    // Roof Pediment Circle Accent
    canvas.drawCircle(
      Offset(mainX + mainW / 2, mainY - 8),
      5,
      windowPaint,
    );

    // Main Building Windows
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 4; c++) {
        canvas.drawRect(
          Rect.fromLTWH(
            mainX + 12 + c * 22,
            mainY + 10 + r * 18,
            14,
            12,
          ),
          windowPaint,
        );
      }
    }

    // Entrance Arch & Pillars
    final double entranceW = mainW * 0.38;
    final double entranceX = mainX + (mainW - entranceW) / 2;
    final double entranceH = mainH * 0.35;
    final double entranceY = mainY + mainH - entranceH;

    canvas.drawRect(
      Rect.fromLTWH(entranceX, entranceY, entranceW, entranceH),
      whiteDoorPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(entranceX + 4, entranceY + 4, entranceW - 8, entranceH),
      windowPaint,
    );

    // Bushes & Trees
    final Paint treeDark = Paint()..color = const Color(0xFF0284C7);
    final Paint treeLight = Paint()..color = const Color(0xFF0369A1);
    final Paint treeGreen = Paint()..color = const Color(0xFF0D9488);

    // Left trees
    canvas.drawCircle(Offset(30, h - 20), 22, treeDark);
    canvas.drawCircle(Offset(55, h - 25), 18, treeLight);
    canvas.drawCircle(Offset(80, h - 15), 16, treeGreen);

    // Right trees
    canvas.drawCircle(Offset(w - 30, h - 20), 22, treeDark);
    canvas.drawCircle(Offset(w - 55, h - 25), 18, treeLight);
    canvas.drawCircle(Offset(w - 80, h - 15), 16, treeGreen);

    // Ground line
    final Paint groundPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawRect(Rect.fromLTWH(0, h - 12, w, 12), groundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
