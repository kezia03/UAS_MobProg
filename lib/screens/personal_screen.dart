import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String name = 'John Doe';
  String dateOfBirth = '01-01-1990';
  String gender = 'Male';
  String email = 'johndoe@example.com';
  String phone = '+123456789';

  String? _profileImageUrl;
  File? _profileImage;

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() => _profileImage = File(pickedFile.path));
                  await _uploadToFirebase(_profileImage!);
                }
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() => _profileImage = File(pickedFile.path));
                  await _uploadToFirebase(_profileImage!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to upload the image to Firebase Storage
  Future<void> _uploadToFirebase(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  // Build editable field method
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

  // Show edit dialog method
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

  // Show date picker method
  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirth = '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
      });
    }
  }

  // Show gender selection dialog
  void _showGenderDialog() async {
    String? selectedGender = gender;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Male', 'Female', 'Other']
              .map((genderOption) => RadioListTile<String>(
                    title: Text(genderOption),
                    value: genderOption,
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                      Navigator.of(context).pop();
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B61DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B61DD),
        elevation: 0,
        title: const Text(
          'Personal Info',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              value: name,
              onEdit: () => _showEditDialog('Name', name, (newValue) {
                setState(() => name = newValue);
              }),
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              label: 'Date of Birth',
              value: dateOfBirth,
              onEdit: () => _showDatePicker(context),
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              label: 'Gender',
              value: gender,
              onEdit: () => _showGenderDialog(),
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              label: 'Email',
              value: email,
              onEdit: () => _showEditDialog('Email', email, (newValue) {
                setState(() => email = newValue);
              }),
            ),
            const SizedBox(height: 15),
            _buildEditableField(
              label: 'Phone',
              value: phone,
              onEdit: () => _showEditDialog('Phone', phone, (newValue) {
                setState(() => phone = newValue);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
