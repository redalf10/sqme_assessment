// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:assessment/components/shop_button.dart';
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
      title: Text('Personal Information',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          )),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  hintText: 'Address',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
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
        ShopButton(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ShopButton(
          onTap: () async {
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
          child: Text(
            'Submit',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
