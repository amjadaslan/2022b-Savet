import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password =new TextEditingController();
  TextEditingController _email = new TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _email = TextEditingController(text: "");
  //   _password = TextEditingController(text: "");
  //   print("Login in");
  // }

  // Future<FirebaseApp> _initializeFirebase() async{
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }


  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<AuthRepository>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Login'),centerTitle:true),
        body: FutureBuilder(
          //future: _initializeFirebase(),
          builder: (context, snapshot){
            return LoginScreen();

            // if(snapshot.connectionState == ConnectionState.done){
            // }
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
          },
        )
    );
  }

  Widget LoginScreen(){

    //final user = Provider.of<AuthRepository>(context);
    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                const Text(''),
                const SizedBox(height: 20),

                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding:  EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _email,
                    decoration:  const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        labelText: 'Email',

                      prefixIcon: Icon(Icons.email),
                        hintText: 'Please enter your Email',
                      border: OutlineInputBorder(),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child:
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration:  const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                        hintText: 'Enter your password',
                      border: OutlineInputBorder(),

                    ),

                  ),
                ),

                const Text(''),
                // //user.status==Status.Authenticating ? const Center(
                //   child: CircularProgressIndicator(),
                // ) :
                Container(
                  height: 40,
                  width: 350,
                  child: TextButton(
                    child: const Text('Log in',style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () async {
                      // await user.signIn(_email.text, _password.text);
                      // (user.isAuthenticated) ?
                      // Navigator.pop(context)
                      //     :
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Not implemented yet')));
                    },
                  ),

                  decoration: BoxDecoration(
                      color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)

                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

// @override
// void dispose() {
//   print("Login Out");
//   _email.dispose();
//   _password.dispose();
//   super.dispose();
// }

}