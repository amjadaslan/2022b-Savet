import 'package:flutter/material.dart';

class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelStyle: const TextStyle(fontSize: 17),
            tabs: [
              Tab(text: "about us"),
              Tab(text: 'Privacy Polic'),
              Tab(text: "Terms of Service"),
            ],
          ),
          title: Text('About us'),
        ),
        body: TabBarView(
          children: [text(), Privacytext(), Termstext()],
        ),
      ),
    );
  }

  Widget Privacytext() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
        SizedBox(height: 15),
        Text(
          "Privacy Policy ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          child: Text(
              "Savet Team built the Savet app as a Free app. This SERVICE is provided by Savet Team at no cost and "
              "is intended for use as is.",
              style: TextStyle(fontSize: 18)),
        ),
        SizedBox(height: 10),
        Text(
            "This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Savet unless otherwise defined in this Privacy Policy.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text("This policy is effective as of 2022-05-26       ",
            style: TextStyle(fontSize: 20)),
        Text(
            "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at SavetGM@gmail.com.",
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text("", style: TextStyle(fontSize: 18)),
      ]),
    )));
  }

  Widget Termstext() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
        SizedBox(height: 15),
        Text(
          "Terms and Conditions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          child: Text(
              "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Savet Team.",
              style: TextStyle(fontSize: 18)),
        ),
        SizedBox(height: 10),
        Text(
            "Savet Team is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "The Savet app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Savet app won’t work properly or at all.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "You should be aware that there are certain things that Savet Team will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Savet Team cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "Along the same lines, Savet Team cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Savet Team cannot accept responsibility.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "With respect to Savet Team’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Savet Team accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text(
            "At some point, we may wish to update the app. The app is currently available on Android – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Savet Team does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text("Changes to This Terms and Conditions",
            style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text(
            "I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text("These terms and conditions are effective as of 2022-05-26",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text("Contact Us", style: TextStyle(fontSize: 20)),
        SizedBox(height: 10),
        Text(
            "If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at SavetGM@gmail.com.",
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text("", style: TextStyle(fontSize: 18)),
      ]),
    )));
  }

  Widget text() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: const <
                    Widget>[
                  SizedBox(height: 15),
                  Center(
                      child: Text(
                    "About us",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                        "Lately, we've been surrounded by many social media apps, and with that many interesting posts, each app does offer to save these posts under a pinned category to make it possible to find these posts again but having multiple social media accounts makes it difficult to remember on which platform was each post saved. And that's where 'Savet' comes, an app that saves each of your favorite content into categories and enables you to share them with family and friends",
                        style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    child: Text("Team members ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  //- Muhammad Mzareeb, Amjad Aslan, Siwar Kanaaneh"
                  // Dr. Oren Mishali, Mr. Raz Levi, Ms. Natali Uda"
                  SizedBox(height: 7),
                  SizedBox(
                    child: Text("Muhammad Mzareeb, Amjad Aslan, Siwar Kanaaneh",
                        style: TextStyle(fontSize: 15)),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      child: Text("Instructors",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                  SizedBox(height: 7),
                  SizedBox(
                    child: Text(
                        "Dr. Oren Mishali, Mr. Raz Levi, Ms. Natali Uda",
                        style: TextStyle(fontSize: 15)),
                  ),
                  Text(''),
                  SizedBox(height: 30),
                  SizedBox(
                    child: Text(
                        "copyright © 2022 all rights Technion - Israel Institute of Technology",
                        style: TextStyle(fontSize: 12)),
                  ),
                ]))));
  }
}


