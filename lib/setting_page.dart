import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'settings_controller.dart';
import 'hotel_map_picker_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  String? _name;
  String? _email;
  String? _error;
  String _hotelAddress = 'Tidak ditetapkan';
  LatLng? _hotelLocation;
  bool _isEmailVerified = true;

  bool _isEditing = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserInfo());
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _emailController.text = user.email ?? '';

        setState(() {
          _name = data['name'];
          _email = user.email;
          _isEmailVerified = user.emailVerified;
          if (data.containsKey('hotel')) {
            final geo = data['hotel'];
            _hotelLocation = LatLng(geo.latitude, geo.longitude);
          }
          if (data.containsKey('hotelAddress')) {
            _hotelAddress = data['hotelAddress'];
          }
        });
      } catch (e) {
        setState(() => _error = 'Gagal memuatkan maklumat pengguna');
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Step 1: Re-authenticate with current password
    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
    } on FirebaseAuthException {
      setState(() {
        _error = 'Ralat: Sila masukkan kata laluan semasa yang betul.';
      });
      return;
    }

    // Step 2: Reload to get updated emailVerified status
    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (!refreshedUser!.emailVerified) {
      await refreshedUser.sendEmailVerification();
      setState(() {
        _error =
            'Emel semasa belum disahkan. Sila semak inbox dan sahkan dahulu sebelum tukar emel.';
      });
      return;
    }

    // Step 3: Update Email if changed
    if (_emailController.text != user.email) {
      await user.updateEmail(_emailController.text.trim());
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sila semak emel baru anda untuk pengesahan')),
      );
    }

    // Step 4: Update Password if not empty
    if (_passwordController.text.isNotEmpty) {
      await user.updatePassword(_passwordController.text.trim());
    }

    // Step 5: Update Firestore
    Map<String, dynamic> updateData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    if (_hotelLocation != null && _hotelAddress.isNotEmpty) {
      updateData['hotel'] =
          GeoPoint(_hotelLocation!.latitude, _hotelLocation!.longitude);
      updateData['hotelAddress'] = _hotelAddress;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(updateData);

    await user.updateDisplayName(_nameController.text.trim());
    await user.reload();
    _isEmailVerified = user.emailVerified;

    setState(() {
      _isEditing = false;
      _name = _nameController.text;
      _email = _emailController.text;
      _passwordController.clear();
      _currentPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil berjaya dikemaskini')),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settings = context.watch<SettingsController>();
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tetapan', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text("Nama Pengguna",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _isEditing
                  ? TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama anda',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(_name ?? '...'),
                    ),
              SizedBox(height: 10),
              Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _isEditing
                  ? TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan emel anda',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(_email ?? '...'),
                            if (!_isEmailVerified)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Belum disahkan",
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (!_isEmailVerified)
                          TextButton.icon(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              await user?.sendEmailVerification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Emel pengesahan telah dihantar semula.'),
                                ),
                              );
                            },
                            icon: Icon(Icons.mail),
                            label: Text("Hantar semula pengesahan"),
                          ),
                      ],
                    ),
              SizedBox(height: 30),
              Text("Hotel", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(_hotelAddress.isNotEmpty
                        ? _hotelAddress
                        : 'Tidak ditetapkan'),
                  ),
                  if (_isEditing)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton.icon(
                        icon: Icon(Icons.location_pin, color: Colors.white),
                        label: Text("Pilih Lokasi",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final result =
                              await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HotelMapPickerPage(onLocationPicked: (_) {}),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _hotelLocation = result['location'];
                              _hotelAddress = result['address'];
                            });
                          }
                        },
                      ),
                    ),
                ],
              ),
              if (_isEditing) ...[
                SizedBox(height: 20),
                Text("Kata Laluan Semasa",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata laluan semasa anda',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                Text("Kata Laluan Baharu",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Biarkan kosong jika tidak berubah',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 35),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Simpan Profil'),
                ),
                SizedBox(height: 20),
              ],
              SizedBox(height: 40),
              if (!_isEditing) ...[
                Text('Saiz Fon', style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: settings.fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: settings.fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    context.read<SettingsController>().updateFontSize(value);
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: Icon(Icons.logout),
                  label: Text('Log Keluar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _error!,
                    style: theme.bodyMedium?.copyWith(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
