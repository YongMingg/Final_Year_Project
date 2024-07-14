import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: SingleChildScrollView(
          child: Text(
            """Privacy Policy for E-Smart Home
      
Last Updated: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}
          
          At E-Smart Home, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our application ("App") and the associated hardware device ("Device"). By using the App, you agree to the terms of this Privacy Policy.
          
1. Information We Collect
          
          We collect various types of information in connection with the App, including:
          
          Personal Information: Information that identifies you personally, such as your name, email address, and account credentials.
          
          Device Information: Information about the Device you are using, including hardware model, operating system, and unique device identifiers.
          
          Usage Data: Information about how you use the App and Device, including interaction data, preferences, and settings.
          
2. How We Use Your Information
          
          We use the information we collect for various purposes, including:
          
          To Provide and Improve Our Services: To operate, maintain, and enhance the App and Device.
          
          To Communicate with You: To send you updates, notifications, and other information related to the App.
          
          To Ensure Security: To monitor and ensure the security of the App and Device.
          
          To Comply with Legal Obligations: To comply with legal and regulatory requirements.
          
3. Firebase Databases
          
          Our App uses Firebase for its database solutions, including both Realtime Database and Firestore Database. Firebase may collect and store data on your behalf. For more information on how Firebase handles data, please refer to the Firebase Privacy Policy.
          
4. Sharing Your Information
          
          We do not sell, trade, or otherwise transfer your personal information to outside parties except in the following circumstances:
          
          Service Providers: We may share your information with third-party service providers who perform services on our behalf.
          
          Legal Requirements: We may disclose your information if required to do so by law or in response to valid requests by public authorities.
          
5. Data Security
          
          We implement a variety of security measures to ensure the safety of your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.
          
6. Your Choices
          
          You have certain rights regarding your personal information, including:
          
          Access and Update: You can access and update your personal information through the App.
          
          Delete: You can request the deletion of your account and personal information by contacting us.
          
7. Children's Privacy
          
          Our App is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.
          
8. Changes to This Privacy Policy
          
          We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on our website and within the App. Your continued use of the App after the changes become effective constitutes your acceptance of the new Privacy Policy.""",
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}