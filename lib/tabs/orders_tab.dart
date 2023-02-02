import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){

      String? uid = UserModel.of(context).firebaseUser?.uid;

      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("users").doc(uid)
          .collection("orders").get(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data?.docs.map((doc) => OrderTile(doc.id)).toList()
                .reversed.toList() as List<Widget>,
            );
          }
        },
      );

    } else {

      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list,
              size: 80.0, color: Theme.of(context).primaryColor,),
            const SizedBox(height: 16.0,),
            const Text("Faça o login para acompanhar!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>const LoginScreen())
                );
              },
              child: const Text("Entrar", style: TextStyle(fontSize: 18.0),),
            )
          ],
        ),
      );

    }

  }
}
