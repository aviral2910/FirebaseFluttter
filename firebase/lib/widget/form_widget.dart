import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController _description = TextEditingController();
  TextEditingController _userName = TextEditingController();

  TextEditingController _price = TextEditingController();

  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  var _compressedsize;
  var _originalsize;
  var _imageDownloadUri;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0, left: 40, right: 0, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Add Data here",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
                _userName, Icons.person, "Product", "Product is not valid"),
            CustomFormField(_description, Icons.mail, "Description",
                "Description should be greater than 10 character"),
            Row(
              children: [
                imagebtn(),
                image != null
                    ? Image.file(
                        image!,
                        width: 200,
                        height: 200,
                      )
                    : Icon(
                        Icons.person,
                        size: 200,
                      ),
              ],
            ),
            Text("Original Size = ${_originalsize}"),
            Text("Compressed Size= ${_compressedsize}"),
            CustomFormField(_price, Icons.money, "Price", "Enter Price here !"),
            SubmitBtn(10.0),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/list');
                },
                child: Text("List User"))
          ],
        ),
      ),
    );
  }

  SizedBox SubmitBtn(double TextFormradius) {
    return SizedBox(
      width: 300,
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        onPressed: () {
          if (_formkey1.currentState!.validate()) {
            RegistrationUser();
            Navigator.pushNamed(context, '/list');
            //Navigator.pushNamed(context, '/');
          }
        },
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TextFormradius),
          //side: BorderSide(color: Colors.black45, width: 2)),
        ),
        textColor: Colors.white,
        child: Text("Submit"),
      ),
    );
  }

  Container SocialMediaImage(String Path, BoxFit bxfit) {
    return Container(
      height: 25,
      width: 75,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Path),
          fit: bxfit,
        ),
      ),
    );
  }

  Padding CustomFormField(TextEditingController _controller, IconData icon,
      String hinttext, String warningMessage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: SizedBox(
        width: 400,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            icon: Icon(icon),
            hintText: hinttext,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return warningMessage;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget imagebtn() {
    return ElevatedButton(
        onPressed: () => pickImage(), child: Icon(Icons.image));
  }

  //Functions are here

  Future RegistrationUser() async {
    return product.add({
      'productname': _userName.text,
      'description': _description.text,
      'prodImage': _imageDownloadUri,
      'price': _price.text,
    });
  }

  static String getFileSizeString({@required int? bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes!) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  File? image;
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    File originalfile = new File(image.path);
    var osize = getFileSizeString(bytes: originalfile.lengthSync());
    setState(() {
      _originalsize = osize;
    });

    var file = await compressimage(image.path, 35); //path of compressed image
    File compressedfile = new File(file.path);
    var csize = getFileSizeString(bytes: compressedfile.lengthSync());

    // final compressfile = File(file.path);
    // final size = ImageSizeGetter.getSize(FileInput(compressfile));
    setState(() {
      _compressedsize = csize;
    });
    await uploadFile(file.path);

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  Future compressimage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      newPath,
      quality: quality,
    );

    return result;
  }

  Future uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('images/${p.basename(path)}'); //making the file reference
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      _imageDownloadUri = fileUrl;
    });
  }
}
