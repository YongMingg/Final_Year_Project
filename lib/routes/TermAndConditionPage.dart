import 'package:flutter/material.dart';
import 'dart:async';

class TermAndConditionPage extends StatelessWidget {


  const TermAndConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Terms & Conditions",
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
            """Terms and Conditions for E-Smart Home
      
Last Updated: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}
        
        Welcome to E-Smart Home ("App"). These Terms and Conditions ("Terms") govern your use of our application and the associated hardware device ("Device") controlled via WiFi. By accessing or using the App, you agree to be bound by these Terms.
        
1. Acceptance of Terms
        
        By downloading, installing, or using the App, you agree to these Terms and Conditions and our Privacy Policy. If you do not agree to these Terms, do not use the App.
        
2. Description of Service
        
        The App allows users to control the Device using WiFi. The Device is built using Arduino technology and is designed to perform specific tasks as outlined in the product description.
        
3. User Responsibilities
        
        Account Registration: You may need to create an account to use the App. You are responsible for maintaining the confidentiality of your account information.
        
        Compliance: You agree to comply with all applicable laws and regulations while using the App and Device.
        
        Proper Use: You must use the App and Device as intended. Any misuse, including but not limited to tampering with the hardware or software, is prohibited.

4. License and Restrictions
        
        License: We grant you a non-exclusive, non-transferable, limited license to use the App in accordance with these Terms.
        
        Restrictions: You may not modify, reverse engineer, decompile, or disassemble the App or Device.

5. Privacy
        
        Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.
        
6. Intellectual Property
        
        All content, trademarks, service marks, logos, and other intellectual property associated with the App and Device are the property of E-Smart Home or its licensors.
        
7. Warranty Disclaimer
        
        The App and Device are provided "as is" without warranties of any kind, either express or implied. We do not warrant that the App or Device will meet your requirements, be uninterrupted, or error-free.
        
8. Limitation of Liability
        
        To the fullest extent permitted by law, E-Smart Home shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from:
        
        Your use or inability to use the App or Device.
        
        Any unauthorized access to or use of our servers and/or any personal information stored therein.

9. Indemnification
        
        You agree to indemnify and hold harmless E-Smart Home, its affiliates, and their respective officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses, including reasonable attorneys' fees, arising out of or in any way connected with your access to or use of the App or Device.
        
10. Changes to Terms
        
        We may modify these Terms at any time. We will notify you of any changes by posting the new Terms on our website and within the App. Your continued use of the App after the changes become effective constitutes your acceptance of the new Terms.
        
11. Governing Law
        
        These Terms shall be governed by and construed in accordance with the laws of Malaysia, without regard to its conflict of law principles.""",
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
