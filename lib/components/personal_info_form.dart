// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:assessment/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/database_helper.dart';

class PersonalInfoForm extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;

  const PersonalInfoForm({required this.onSubmit, super.key});

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    final personalInfo = await DatabaseHelper().getPersonalInfo();
    if (personalInfo.isNotEmpty) {
      _nameController.text = personalInfo['name']!;
      _phoneController.text = personalInfo['phone']!;
      _emailController.text = personalInfo['email']!;
      _addressController.text = personalInfo['address']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Information'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Name',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.deny(RegExp(r'^0')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Email Address',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        MaterialButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final name = _nameController.text;
              final phone = _phoneController.text;
              final email = _emailController.text;
              final address = _addressController.text;

              await DatabaseHelper().insertPersonalInfo(
                name,
                phone,
                email,
                address,
              );
              widget.onSubmit(
                name,
                phone,
                email,
                address,
              );
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(
                    name: name,
                    phone: phone,
                    email: email,
                    address: address,
                  ),
                ),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
