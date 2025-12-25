import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:dev_icons/dev_icons.dart";

// --- DATA MODELS ---
enum SkillType { language, framework, database, tool }

class Skill {
  final String name;
  final IconData icon;
  final Color color;
  final SkillType type;

  Skill({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}

class DspPage extends StatefulWidget {
  const DspPage({super.key});

  @override
  State<DspPage> createState() => _DspPageState();
}

class _DspPageState extends State<DspPage> with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late AnimationController _pulseController;

  SkillType _selectedType = SkillType.language;

  // CONFIGURATION
  final String _musicAsset = 'audio/Silhouette.mp3';
  final String _devName = "DSP-3";
  final String _tagline = "Creator of this project.";
  final String _introText =
      "A real-time chat app built with Flutter (Bloc) and a Node.js + Express (TypeScript) backend, featuring Socket.IO for live messaging, Firebase Authentication, JWT security, and PostgreSQL for persistent storage. "
      "The complete source code is provided below. Feel free to review the implementation, report bugs, or suggest new features. "
      "All technologies and tools used in this project are listed below for reference.";

  // LINKS
  final String _telegramUrl = "https://t.me/lord_DSP_3";
  final String _instaUrl = "https://instagram.com/lord_dsp_3";
  final String _githubFrontUrl = "https://github.com/Haruto-hyuuga/chatapp";
  final String _githubBackUrl =
      "https://github.com/Haruto-hyuuga/chatapp-backend";

  // --- SKILLS DATA ---
  final List<Skill> _allSkills = [
    // Languages
    Skill(
      name: "Dart",
      icon: DevIcons.dartPlain,
      color: const Color.fromARGB(255, 24, 209, 255),
      type: SkillType.language,
    ),
    Skill(
      name: "C/C++",
      icon: DevIcons.cplusplusPlain,
      color: const Color.fromARGB(255, 145, 2, 255),
      type: SkillType.language,
    ),
    Skill(
      name: "Python",
      icon: DevIcons.pythonPlain,
      color: Colors.blueAccent,
      type: SkillType.language,
    ),
    Skill(
      name: "JavaScript",
      icon: DevIcons.javascriptPlain,
      color: Colors.yellow,
      type: SkillType.language,
    ),
    Skill(
      name: "TypeScript",
      icon: DevIcons.typescriptPlain,
      color: const Color.fromARGB(255, 41, 82, 247),
      type: SkillType.language,
    ),
    // Frameworks
    Skill(
      name: "Flutter",
      icon: DevIcons.flutterPlain,
      color: Colors.lightBlueAccent,
      type: SkillType.framework,
    ),
    Skill(
      name: "Bloc",
      icon: Icons.flutter_dash,
      color: Colors.lightBlueAccent,
      type: SkillType.framework,
    ),
    Skill(
      name: "Node.js",
      icon: DevIcons.nodejsPlain,
      color: Colors.green,
      type: SkillType.framework,
    ),
    Skill(
      name: "Express.js",
      icon: DevIcons.expressOriginal,
      color: Colors.yellow,
      type: SkillType.framework,
    ),
    Skill(
      name: "Socket.io",
      icon: DevIcons.webpackPlain,
      color: Colors.white,
      type: SkillType.framework,
    ),
    Skill(
      name: "FireBase Auth",
      icon: DevIcons.firebasePlain,
      color: Colors.orange,
      type: SkillType.framework,
    ),

    // Databases
    Skill(
      name: "PostgreSQL",
      icon: DevIcons.postgresqlPlain,
      color: Colors.indigo,
      type: SkillType.database,
    ),
    Skill(
      name: "Firestore",
      icon: DevIcons.firebasePlain,
      color: Colors.orange,
      type: SkillType.database,
    ),
    // Tools
    Skill(
      name: "Linux",
      icon: DevIcons.linuxPlain,
      color: Colors.yellow,
      type: SkillType.tool,
    ),
    Skill(
      name: "Android SDK",
      icon: DevIcons.androidPlain,
      color: Colors.lightGreen,
      type: SkillType.tool,
    ),
    Skill(
      name: "Git",
      icon: DevIcons.gitPlain,
      color: Colors.redAccent,
      type: SkillType.tool,
    ),
    Skill(
      name: "Docker",
      icon: DevIcons.dockerPlain,
      color: Colors.blue,
      type: SkillType.tool,
    ),

    Skill(
      name: "pub/npm",
      icon: Icons.view_module_rounded,
      color: Colors.white,
      type: SkillType.tool,
    ),
    Skill(
      name: "psql",
      icon: DevIcons.bashPlain,
      color: Colors.indigo,
      type: SkillType.tool,
    ),
    Skill(
      name: "jwt/bcrypt",
      icon: DevIcons.amazonwebservicesOriginal,
      color: Colors.orangeAccent,
      type: SkillType.tool,
    ),
    Skill(
      name: "tsc",
      icon: Icons.memory,
      color: Colors.indigo,
      type: SkillType.tool,
    ),
    Skill(
      name: "Visual Studio",
      icon: DevIcons.visualstudioPlain,
      color: Colors.blue,
      type: SkillType.tool,
    ),
    Skill(
      name: "Render",
      icon: Icons.table_chart_outlined,
      color: Colors.green,
      type: SkillType.tool,
    ),

    Skill(
      name: "Github",
      icon: DevIcons.githubOriginal,
      color: Colors.white,
      type: SkillType.tool,
    ),
    Skill(
      name: "Api Dash",
      icon: DevIcons.graphqlPlain,
      color: Colors.pinkAccent,
      type: SkillType.tool,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(_musicAsset));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgStart = const Color(0xFF0F172A);
    final Color accent = const Color.fromARGB(255, 255, 117, 244);

    // Skill Filtering
    final List<Skill> displaySkills = _allSkills
        .where((s) => s.type == _selectedType)
        .toList();

    return Scaffold(
      backgroundColor: bgStart,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // --- Ambient Background ---
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.15),
                backgroundBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ), //filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80)),
            ),
          ),

          // --- Scrollable Content ---
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // 1. DISCORD-STYLE HEADER
                // ==========================================
                SizedBox(
                  height: 240, // Height of Banner + Half Avatar
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // A. Banner Image
                      Container(
                        height: 205,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          // Replace with 'assets/img/banner.jpg' if you have one
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 51, 18, 112),
                              Color(0xFF0F172A),
                            ],
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Try to load asset, fallback to gradient if fails (or just keep gradient)
                            Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                "assets/img/extra/dspBg.jpg", // Make sure this exists or remove this widget
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => const SizedBox(),
                              ),
                            ),
                            // Gradient Overlay for readability
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // B. Avatar (Bottom Left)
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      4,
                                    ), // Border width
                                    decoration: BoxDecoration(
                                      color:
                                          bgStart, // Matches background to look like a cutout
                                      shape: BoxShape.circle,
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              if (_isPlaying)
                                                BoxShadow(
                                                  color: accent.withOpacity(
                                                    0.5,
                                                  ),
                                                  blurRadius:
                                                      15 *
                                                      _pulseController.value,
                                                  spreadRadius: 2,
                                                ),
                                            ],
                                          ),
                                          child: const CircleAvatar(
                                            radius: 45,
                                            backgroundImage: AssetImage(
                                              "assets/img/extra/dsp.png",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Online Status Indicator
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: bgStart,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // 2. PROFILE INFO (Name, Bio, Music)
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Row with Music Player
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _devName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  _tagline,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Glass Mini-Player
                          GestureDetector(
                            onTap: _toggleMusic,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _isPlaying
                                    ? accent.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: _isPlaying
                                      ? accent.withOpacity(0.5)
                                      : Colors.white12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: _isPlaying ? accent : Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isPlaying ? "Playing" : "Play BGM",
                                    style: TextStyle(
                                      color: _isPlaying ? accent : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Bio / About Me Section (Glass Look)
                      _GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.terminal,
                                  size: 20,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    73,
                                    231,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "README.md",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _introText,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                _SocialChip(
                                  label: "Telegram",
                                  icon: Icons.send,
                                  color: Colors.blue,
                                  onTap: () => _launchLink(_telegramUrl),
                                ),
                                const SizedBox(width: 10),
                                _SocialChip(
                                  label: "Instagram",
                                  icon: Icons.camera_alt,
                                  color: Colors.pink,
                                  onTap: () => _launchLink(_instaUrl),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // 3. SOURCE CODE SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PROJECT RESOURCES",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _CompactActionCard(
                              icon: Icons.phone_android,
                              title: "App Source Code",
                              color: const Color.fromARGB(255, 65, 234, 71),
                              onTap: () => _launchLink(_githubFrontUrl),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CompactActionCard(
                              icon: Icons.cloud_circle,
                              title: "Backend Source Code",
                              color: const Color.fromARGB(255, 0, 221, 255),
                              onTap: () => _launchLink(_githubBackUrl),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CompactActionCard(
                              icon: Icons.bug_report,
                              title: "Issues/Bugs",
                              color: Colors.red,
                              onTap: () =>
                                  _launchLink("mailto:email@example.com"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. TECH STACK SECTION
                _GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TECHNOLOGIES USED IN PROJECT: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Filter Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: SkillType.values.map((type) {
                            final isSelected = _selectedType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedType = type),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? accent
                                          : Colors.white24,
                                    ),
                                  ),
                                  child: Text(
                                    type.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Skills Grid
                      GridView.builder(
                        padding: EdgeInsets.symmetric(vertical: 45),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                        itemCount: displaySkills.length,
                        itemBuilder: (context, index) {
                          final skill = displaySkills[index];
                          return _SkillBox(skill: skill);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS ---

class _GlassContainer extends StatelessWidget {
  final Widget child;
  const _GlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}

class _SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CompactActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillBox extends StatelessWidget {
  final Skill skill;
  const _SkillBox({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            skill.color.withOpacity(0.15),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: skill.color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(skill.icon, color: skill.color, size: 22),
          const SizedBox(height: 8),
          Text(
            skill.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
