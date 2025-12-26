import 'dart:io';
import 'package:chatapp/core/show_error.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Image state
  File? _localImage;
  String? _profileImageUrl;

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------- IMAGE PICK (TEST MODE) ----------------

  Future<void> _pickAndUploadImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _localImage = File(image.path);
    });

    showErrorPopup(
      context: context,
      errorName: "INFO",
      errorType: "mock-warning",
      errorText: "Image picked successfully (upload not implemented yet).",
      errorIcon: Icons.image,
      errorColor: Colors.green,
    );
  }

  // ---------------- SAVE PROFILE (TEST MODE) ----------------

  void _updateProfileFields() {
    if (_usernameController.text.isEmpty &&
        _emailController.text.isEmpty &&
        _passwordController.text.isEmpty) {
      _showMessage("Nothing to update", Colors.orange);
      return;
    }

    showErrorPopup(
      context: context,
      errorName: "INFO",
      errorType: "mock-warning",
      errorText: "Profile update API not connected yet.",
      errorIcon: Icons.settings,
      errorColor: Colors.green,
    );

    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildProfileAvatar(),
                const SizedBox(height: 40),
                _buildTextField(
                  "Username",
                  _usernameController,
                  Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  "Email",
                  _emailController,
                  Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  "New Password",
                  _passwordController,
                  Icons.lock_outline,
                  isObscure: true,
                ),
                const SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- COMPONENTS ----------------

  Widget _buildProfileAvatar() {
    ImageProvider imageProvider;

    if (_localImage != null) {
      imageProvider = FileImage(_localImage!);
    } else if (_profileImageUrl != null) {
      imageProvider = NetworkImage(_profileImageUrl!);
    } else {
      imageProvider = const AssetImage(
        "assets/img/extra/RecentContactPlaceholder.jpg",
      );
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[900],
            backgroundImage: imageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickAndUploadImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: "Update $label",
            hintStyle: const TextStyle(color: Colors.white24),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _updateProfileFields,
        child: const Text(
          "SAVE CHANGES",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
