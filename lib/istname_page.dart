import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListNamePage extends StatefulWidget {
  @override
  _ListNamePageState createState() => _ListNamePageState();
}

class _ListNamePageState extends State<ListNamePage> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsersWithScores().then((users) {
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredUsers = _users.where((user) {
          return user['name'].toLowerCase().contains(query) ||
              user['email'].toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  Future<Map<String, int>> fetchLatestScores() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('scores')
        .orderBy('timestamp', descending: true)
        .get();

    Map<String, int> latestScores = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final uid = data['uid'];
      final score = data['score'];
      if (!latestScores.containsKey(uid)) {
        latestScores[uid] = score;
      }
    }
    return latestScores;
  }

  Future<List<Map<String, dynamic>>> fetchUsersWithScores() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();

    final scoresMap = await fetchLatestScores();

    final userList = userSnapshot.docs.map((doc) {
      final data = doc.data();
      final uid = doc.id;
      return {
        'uid': uid,
        'name': data['name'] ?? 'Tanpa Nama',
        'email': data['email'] ?? '-',
        'score': scoresMap[uid] ?? 0,
      };
    }).toList();

    userList.sort((a, b) => b['score'].compareTo(a['score']));
    return userList;
  }

  Future<void> deleteUser(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    setState(() {
      _users.removeWhere((user) => user['uid'] == uid);
      _filteredUsers.removeWhere((user) => user['uid'] == uid);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Pengguna telah dipadam.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senarai Nama Bakal Haji'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari nama atau email',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text('Tiada pengguna ditemui.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Dismissible(
                        key: Key(user['uid']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Padam Pengguna'),
                              content:
                                  Text('Anda pasti mahu memadam pengguna ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text('Padam'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) => deleteUser(user['uid']),
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user['name']),
                            subtitle: Text('Email: ${user['email']}'),
                            trailing: Text('Skor: ${user['score']}'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
