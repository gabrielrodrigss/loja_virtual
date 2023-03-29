import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  const PlacesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        } else {
          return ListView(
            // Tranformando cada um dos documento em um widget PlaceTile e depos em uma lista
            children: snapshot.data!.docs.map((doc) => PlaceTile(snapshot: doc,)).toList(),
          );
        }
      },
    );
  }
}
