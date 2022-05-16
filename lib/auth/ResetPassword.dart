import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import 'auth_repoitory.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email = new TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthRepository.instance();
    _email = TextEditingController(text: "");
    print("Reset Page in");
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset password'), centerTitle: false,
          //automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            return ResetPassword();

            if (snapshot.connectionState == ConnectionState.done) {}
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget ResetPassword() {
    final user = Provider.of<AuthRepository>(context);
    // if(user.isAuthenticated)
    //   user.signOut();
    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            const Text(''),
            const SizedBox(height: 20),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Please enter your Email',
                    //suffixIcon: Icon(Icons.panorama_fisheye_sharp),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Text(''),
            user.status == Status.Authenticating
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                :
                //width: MediaQuery.of(context).size.width * 0.55,
                Container(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      child: const Text(
                        'Send to email',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () async {
                        (user.isAuthenticated)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const homepage()))
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error to Log in')));
                      },
                    ),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20)),
                  ),
          ],
        ),
      )),
    );
  }
}
