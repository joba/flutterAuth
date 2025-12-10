import 'package:auth_app/auth/cubit/auth_cubit.dart';
import 'package:auth_app/auth/cubit/auth_state.dart';
import 'package:auth_app/models/hero_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageController = TextEditingController();

  Future<void> addHero() async {
    var newHero = HeroModel.fromJson({
      'id': DateTime.now().millisecondsSinceEpoch.toRadixString(36),
      'name': 'Batman',
      'powerstats': {'strength': '80'},
      'appearance': {'gender': 'Male', 'race': 'Human'},
      'biography': {'alignment': 'Good'},
    });

    await FirebaseFirestore.instance
        .collection('heroes')
        .doc(newHero.id)
        .set(newHero.toJson());
  }

  Future<void> addMessage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('message').add({
      'text': messageController.text.trim(),
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Welcome, ${user.email}!')],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('message')
                  .where('uid', isEqualTo: user.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final text = data['text'] ?? 'No text';
                    final uid = data['uid'] ?? '';
                    return ListTile(
                      title: Text(text),
                      subtitle: Text('From: $uid'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: addHero,
              child: const Text('Add Hero'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: addMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
