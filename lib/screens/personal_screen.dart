import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String name = '';
  String email = '';
  String dateOfBirth = '';
  String gender = '';
  String phone = '';

  String? _profileImageUrl;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        name = user.displayName ?? '';
        email = user.email ?? '';
        _profileImageUrl = user.photoURL;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      await _uploadProfileImage(_profileImage!);
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user.uid}.jpg');
        final uploadTask = storageRef.putFile(image);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await user.updatePhotoURL(downloadUrl);
        await user.reload();
        _fetchUserData(); // Refresh user data

        setState(() {
          _profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  void _showEditDialog(String label, String currentValue, ValueChanged<String> onChanged) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new $label'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onChanged(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!) as ImageProvider
                        : const AssetImage('assets/placeholder.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              label: 'Name',
              value: name.isEmpty ? 'Please enter your name' : name,
              onEdit: () => _showEditDialog('Name', name, (newValue) {
                setState(() => name = newValue);
              }),
            ),
            _buildEditableField(
              label: 'Email',
              value: email.isEmpty ? 'Please enter your email' : email,
              onEdit: () => _showEditDialog('Email', email, (newValue) {
                setState(() => email = newValue);
              }),
            ),
            _buildEditableField(
              label: 'Phone',
              value: phone.isEmpty ? 'Please enter your phone number' : phone,
              onEdit: () => _showEditDialog('Phone', phone, (newValue) {
                setState(() => phone = newValue);
              }),
            ),
            _buildEditableField(
              label: 'Date of Birth',
              value: dateOfBirth.isEmpty ? 'Please enter your date of birth' : dateOfBirth,
              onEdit: () => _showEditDialog('Date of Birth', dateOfBirth, (newValue) {
                setState(() => dateOfBirth = newValue);
              }),
            ),
            _buildEditableField(
              label: 'Gender',
              value: gender.isEmpty ? 'Please enter your gender' : gender,
              onEdit: () => _showEditDialog('Gender', gender, (newValue) {
                setState(() => gender = newValue);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return InkWell(
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Icon(Icons.edit, color: Colors.blue),
        ],
      ),
    );
  }
}
