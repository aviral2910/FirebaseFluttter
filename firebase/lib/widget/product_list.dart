import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../model/product.dart';

class ProductList extends StatefulWidget {
  ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var productref =
      FirebaseFirestore.instance.collection('product').withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
            () {
              setState(() {
                final product = FirebaseFirestore.instance
                    .collection('product')
                    .withConverter<Product>(
                      fromFirestore: (snapshot, _) =>
                          Product.fromJson(snapshot.data()!),
                      toFirestore: (user, _) => user.toJson(),
                    );
                productref = product;
              });
            },
          );
        },
        child: FirestoreListView<Product>(
            physics: const AlwaysScrollableScrollPhysics(),
            query: productref,
            pageSize: 10,
            itemBuilder: (context, snapshot) {
              final prod = snapshot.data();
              print(prod.prodImage.toString());
              return Card(
                child: ListTile(
                  title: Text(prod.productname.toString()),
                  subtitle: Text(prod.description.toString()),
                  leading: CircleAvatar(
                    child: prod.prodImage != null
                        ? Image.network(
                            prod.prodImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Icon(Icons.person),
                  ),
                  trailing: Text('${prod.price.toString()} Rs'),
                ),
              );
            }),
      ),
    );
  }
}
