import 'package:firebase/provider/google_signin_prvoider.dart';
import 'package:firebase/widget/fetch_userlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildSignUp();
  }

  Widget buildSignUp() {
    return Center(
      child: GoogleSignUpBtnWidget(),
    );
  }
}

class GoogleSignUpBtnWidget extends StatefulWidget {
  const GoogleSignUpBtnWidget({Key? key}) : super(key: key);

  @override
  State<GoogleSignUpBtnWidget> createState() => _GoogleSignUpBtnWidgetState();
}

class _GoogleSignUpBtnWidgetState extends State<GoogleSignUpBtnWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDatabaselist();
  }

  List userprofile = [];
  fetchDatabaselist() async {
    dynamic resultant = await DataBaseManager().getUsersList();
    setState(() {
      userprofile = resultant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(4),
          child: ElevatedButton(
            child: Text("Login With Google"),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.login();
            },
          )),
    );
  }
}
