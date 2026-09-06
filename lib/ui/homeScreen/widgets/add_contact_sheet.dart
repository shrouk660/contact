import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/colors_manager.dart';
import '../../../model/contact_model.dart';

class AddContactSheet extends StatefulWidget {
  final void Function(ContactModel) onAdd;

  const AddContactSheet({super.key, required this.onAdd});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _pickedImage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _submitContact() {
    if (formKey.currentState!.validate()) {
      final newContact = ContactModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        image: _pickedImage,
      );

      widget.onAdd(newContact);

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _pickedImage = null;

      Navigator.pop(context);
    }
  }

  InputDecoration _sheetInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ColorsManager.lightBlue),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ColorsManager.gold, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ColorsManager.gold, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ColorsManager.gold, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsManager.darkBlur,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorsManager.gold, width: 1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _pickedImage != null
                          ? Image.file(_pickedImage!, fit: BoxFit.cover)
                          : Lottie.asset(AssetsManager.imagePicker),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text.isEmpty ? 'User Name' : _nameController.text,
                          style: TextStyle(color: ColorsManager.gold, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: ColorsManager.gold, height: 2),
                        const SizedBox(height: 8),
                        Text(
                          _emailController.text.isEmpty ? 'example@email.com' : _emailController.text,
                          style: TextStyle(color: ColorsManager.gold, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: ColorsManager.gold, height: 2),
                        const SizedBox(height: 8),
                        Text(
                          _phoneController.text.isEmpty ? '+200000000000' : _phoneController.text,
                          style: TextStyle(color: ColorsManager.gold, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: ColorsManager.lightBlue),
                decoration: _sheetInputDecoration('Enter User Name'),
                onChanged: (value) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: ColorsManager.lightBlue),
                decoration: _sheetInputDecoration('Enter User Email'),
                onChanged: (value) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Invalid Email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: ColorsManager.lightBlue),
                decoration: _sheetInputDecoration('Enter User Phone'),
                onChanged: (value) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your phone number";
                  }
                  final phoneRegex = RegExp(r'^[0-9]{8,15}$');
                  if (!phoneRegex.hasMatch(value.trim())) {
                    return "Invalid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.gold,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submitContact,
                  child: const Text(
                    'Enter user',
                    style: TextStyle(color: ColorsManager.darkBlur, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}