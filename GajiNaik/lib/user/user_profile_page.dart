import 'package:flutter/material.dart';
import 'package:gaji_naik/user/user_login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Placeholder user data - in a real app, this would come from a backend or shared preferences
  final Map<String, dynamic> userData = {
    'name': 'Ahmad Fauzi',
    'nik': '3174052501980001',
    'email': 'ahmad.fauzi@email.com',
    'phone': '08123456789',
    'position': 'Pegawai Negeri Sipil',
    'institution': 'Kementerian Keuangan',
    'profileImage': 'assets/profile_placeholder.png',
    'lastLogin': '26 Mei 2025, 10:30 WIB',
    'accountCreated': '20 Mei 2025',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
              Color(0xFF0A1F64),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Profil Pengguna',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // Navigate to edit profile page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit profil akan segera hadir'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile header with profile picture
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Profile picture
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1565C0),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(userData['profileImage']),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Name
                            Text(
                              userData['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Position & Institution
                            Text(
                              "${userData['position']}\n${userData['institution']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.3,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Quick stats
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFF1565C0).withOpacity(0.08),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Last Login',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        userData['lastLogin'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Member Since',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        userData['accountCreated'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Personal Information
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF1565C0),
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Informasi Pribadi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // NIK
                            _buildInfoItem(
                              icon: Icons.badge_outlined,
                              title: 'NIK',
                              value: userData['nik'],
                            ),
                            
                            // Email
                            _buildInfoItem(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              value: userData['email'],
                            ),
                            
                            // Phone
                            _buildInfoItem(
                              icon: Icons.phone_outlined,
                              title: 'No. Telepon',
                              value: userData['phone'],
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Account Settings
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.settings_outlined,
                                  color: Color(0xFF1565C0),
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Pengaturan Akun',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            _buildSettingItem(
                              icon: Icons.lock_outline,
                              title: 'Ubah Password',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur akan segera hadir'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            
                            _buildSettingItem(
                              icon: Icons.notifications_outlined,
                              title: 'Notifikasi',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur akan segera hadir'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            
                            _buildSettingItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privasi & Keamanan',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur akan segera hadir'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            
                            _buildSettingItem(
                              icon: Icons.help_outline,
                              title: 'Bantuan & Dukungan',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur akan segera hadir'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            
                            _buildSettingItem(
                              icon: Icons.info_outline,
                              title: 'Tentang Aplikasi',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur akan segera hadir'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi Logout'),
                                content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to login page
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => const UserLoginPage(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon, 
    required String title, 
    required String value,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.black54,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (!isLast) 
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
      ],
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.black54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}