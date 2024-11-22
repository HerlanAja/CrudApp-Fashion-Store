import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List profiles = [];
  final String apiUrl = "http://192.168.95.151:5000/api/profiles";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          profiles = json.decode(response.body);
        });
      } else {
        throw Exception("Failed to load profiles");
      }
    } catch (e) {
      print("Error fetching profiles: $e");
    }
  }

  Future<void> createProfile(Map<String, String> profileData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(profileData),
      );
      if (response.statusCode == 201) {
        fetchProfiles();
      } else {
        throw Exception("Failed to create profile");
      }
    } catch (e) {
      print("Error creating profile: $e");
    }
  }

  Future<void> updateProfile(String id, Map<String, String> profileData) async {
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(profileData),
      );
      if (response.statusCode == 200) {
        fetchProfiles();
      } else {
        throw Exception("Failed to update profile");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        fetchProfiles();
      } else {
        throw Exception("Failed to delete profile");
      }
    } catch (e) {
      print("Error deleting profile: $e");
    }
  }

  void showProfileForm({Map<String, dynamic>? profile}) {
    if (profile != null) {
      nameController.text = profile['name'] ?? '';
      emailController.text = profile['email'] ?? '';
      phoneController.text = profile['phone_number'] ?? '';
      addressController.text = profile['address'] ?? '';
      passwordController.clear();
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      addressController.clear();
      passwordController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            profile == null ? 'Create Profile' : 'Update Profile',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, "Name"),
                const SizedBox(height: 10),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 10),
                _buildTextField(phoneController, "Phone"),
                const SizedBox(height: 10),
                _buildTextField(addressController, "Address"),
                const SizedBox(height: 10),
                _buildTextField(passwordController, "Password", obscureText: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
            ),
            ElevatedButton(
              onPressed: () {
                final profileData = {
                  "name": nameController.text,
                  "email": emailController.text,
                  "phone_number": phoneController.text,
                  "address": addressController.text,
                  "password": passwordController.text,
                };
                if (profile == null) {
                  createProfile(profileData);
                } else {
                  updateProfile(profile['id'].toString(), profileData);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orange),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: profiles.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[200],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      profile['name'] ?? 'No Name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(profile['email'] ?? 'No Email'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => showProfileForm(profile: profile),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProfile(profile['id'].toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProfileForm(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
