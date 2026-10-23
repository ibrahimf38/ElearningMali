import 'package:flutter/material.dart';

class AproposScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue sur Mali Kalan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 12),
             const Text(
              'Mali Kalan est une application moderne conçue pour vous aider à apprendre, progresser et suivre vos cours facilement depuis votre téléphone.',
              style: TextStyle(fontSize: 16),
            ),
             const SizedBox(height: 24),
             const Text(
              'Téléphone : +223 97 54 54 83',
              style: TextStyle(fontSize: 16),
            ),
             const SizedBox(height: 8),
             const Text(
              'Email : site-scolaire@hotmail.com',
              style: TextStyle(fontSize: 16),
            ),
              const SizedBox(height: 8),
             const Text(
              'Adresse :  Banconi Flabougou, Rue : 219, porte : 19',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
            onPressed: () { Navigator.pushNamed(context, '/connexion'); }, 
            child: const Text("Retour"))
          ],
        ),
      ),
    );
  }
}