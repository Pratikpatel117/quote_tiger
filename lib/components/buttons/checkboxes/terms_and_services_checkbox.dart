import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:quote_tiger/utils/push.dart';

class TermsAndServicesCheckbox extends StatefulWidget {
  final CheckBoxController controller;
  const TermsAndServicesCheckbox({Key? key, required this.controller})
      : super(key: key);

  @override
  State<TermsAndServicesCheckbox> createState() =>
      _TermsAndServicesCheckboxState();
}

class _TermsAndServicesCheckboxState extends State<TermsAndServicesCheckbox> {
  TextStyle linkStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      );
  TextStyle normalStyle(BuildContext context) =>
      const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          child: Checkbox(
            checkColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            value: widget.controller.value,
            onChanged: (bool? value) {
              setState(() {
                widget.controller.check();
              });
            },
          ),
        ),
        LimitedBox(
          maxWidth: 270,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Yes, I understand and agree to the QuoteTiger ",
                  style: normalStyle(context),
                ),
                TextSpan(
                    text: "Terms of Service",
                    style: linkStyle(context),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        showThing("Terms of Service", terms);
                      }),
                TextSpan(
                  style: normalStyle(context),
                  text: ", including the ",
                ),
                TextSpan(
                    text: "User Agreement",
                    style: linkStyle(context),
                    recognizer: TapGestureRecognizer()..onTap = () async {}),
                TextSpan(
                  style: normalStyle(context),
                  text: " and ",
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: linkStyle(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      showThing("Privacy Policy", privacy);
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  void showThing(String title, String content) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (_) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.75,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class CheckBoxController {
  bool value = false;
  void check() {
    value = !value;
  }
}

final terms = """
The following agreement captures the terms and conditions of use ("Agreement"), applicable to Your use of QuoteTiger ("app"), which promotes business between suppliers and buyers globally. It is an agreement between You as the user of the App/QUOTETIGER Services and QuoteTiger. The expressions “You” “Your” or “User(s)” refers to any person who accesses or uses the App for any purpose.

By subscribing to or interacting with other User(s) on or entering into negotiations in respect of sale or supply of goods or services on or using the App or QuoteTiger Services in any manner for any purpose, You undertake and agree that You have fully read, understood and accepted the Agreement.

If You do not agree to or do not wish to be bound by the Agreement, You may not access or otherwise use the App in any manner.

I. APP- MERELY A PLATFORM
The App acts as a match-making platform for User(s) to negotiate and interact with other User(s) for entering negotiations in respect thereof for sale or supply of goods or services. QuoteTiger are not parties to any negotiations that take place between the User(s) of the App and are further not parties to any agreement including an agreement for sale or supply of goods or services or otherwise, concluded between the User(s) of the App.

QuoteTiger does not control and is not liable in respect of or responsible for the quality, safety, genuineness, lawfulness or availability of the products or services offered for sale  on the App or the ability of the User(s) selling or supplying the goods or services to complete a sale or the ability of User(s) purchasing goods or services to complete a purchase. This agreement shall not be deemed to create any partnership, joint venture, or any other joint business relationship between QuoteTiger and any other party.

2. USER(S) ELIGIBILITY
User(s) represent and warrant that they have the right to avail or use the services provided by QuoteTiger, including but limited to the app or any other services provided by QuoteTiger in relation to the use of the App ("app Services"). App Services can only be availed by those individuals or business entities, including sole proprietorship firms, companies, and partnerships, which are authorised under applicable law to form legally binding agreements. As such, natural persons below 18 years of age and business entities or organisations that are not authorised by law to operate in UNITED KINGDOM or other countries are not authorised to avail or use QuoteTigers Services.

User(s) agree to abide by the Agreement and any other rules and regulations imposed by the applicable law from time to time.  QuoteTiger or the app shall have no liability to the User(s) or anyone else for any content, information or any other material transmitted over QuoteTiger’s Services, including any fraudulent, untrue, misleading, inaccurate, defamatory, offensive or illicit material and that the risk of damage from such material rests entirely with each User(s).The user shall do its own due diligence before entering into any transaction with other users on the app. QuoteTiger at it’s sole discretion reserves the right to refuse QuoteTiger’s Services to anyone at any time. QuoteTiger’s Services are not available and may not be availed or used by User(s) whose Accounts have been temporarily or indefinitely suspended by QuoteTiger.

4. USER(S) AGREEMENT
This Agreement applies to any person who accesses or uses the App or uses QuoteTiger Services for any purpose.  It also applies to any legal entity which may be represented by any person who accesses or uses the App, under actual or apparent authority. User(s) may use this App and/or QuoteTiger Services solely for their commercial/business purposes.

This Agreement applies to all services offered on the App and by QuoteTiger, collectively with any additional terms and conditions that may be applicable in respect of any specific service used or accessed by User(s) on the App. In the event of any conflict or inconsistency between any provision of this Agreement and any additional terms and conditions applicable in respect of any service offered on the App, such additional terms and conditions applicable in respect of that service shall prevail over this Agreement. This Agreement shall govern the User’s usage of QuoteTiger Services and, the User acknowledges that this Agreement shall supersede all or any term, agreement, contract executed between QUOTETIGER and the User.

4. AMENDMENT TO USER(S) AGREEMENT
QUOTETIGER reserves the right to change, modify, amend, or update the Agreement from time to time and such amended provisions of the Agreement shall be effective immediately upon being posted on the App. If You do not agree to such provisions, You must stop using the service with immediate effect. Your continuous use of the service will be deemed to signify Your acceptance of the amended provisions of the Agreement.

5. INTELLECTUAL PROPERTY RIGHTS
QUOTETIGER is the sole owner and the lawful licensee of all the rights to the App and its content ("App Content"). App Content means the design, layout, text, images, graphics, sound, video etc. of or made available on the App. The App Content embodies trade secrets and other intellectual property rights protected under worldwide copyright and other applicable laws pertaining to intellectual property. All title, ownership and intellectual property rights in the App and the App Content shall remain in QUOTETIGER, its affiliates or licensor’s of the App content, as the case may be.

All rights, not otherwise claimed under this Agreement by QUOTETIGER, are hereby reserved. Any information or advertisements contained on, distributed through, or linked, downloaded or accessed from any of the services contained on the App or any offer displayed on or in connection with any service offered on the App ("App Information") is intended, solely to provide general information for the personal use of the User(s), who fully accept any and all responsibility and liabilities arising from and out of the use of such Information. QUOTETIGER does not represent, warrant or endorse in any manner the accuracy or reliability of App Information, or the quality of any products and/or services obtained by the User(s) as a result of any App Information.

For any content and or link uploaded to the App by the User from YouTube, the User agrees to abide and accepts, the terms of service of YouTube, available at https://www.youtube.com/t/terms.

The Information is provided “as is” with no guarantee of completeness, accuracy, timeliness or of the results obtained from the use of the Information, and without warranty of any kind, express or implied, including, but not limited to warranties of performance, merchantability and fitness for a particular purpose. Nothing contained in the Agreement shall to any extent substitute for the independent investigations and the sound technical and business judgment of the User(s). In no event shall QUOTETIGER be liable for any direct, indirect, incidental, punitive, or consequential damages of any kind whatsoever with respect to QUOTETIGER’s Services. User(s) hereby acknowledge that any reliance upon the Information shall be at their sole risk and further understand and acknowledge that the Information has been compiled from publicly aired and published sources. QUOTETIGER respects the rights of such entities and cannot be deemed to be infringing on the respective copyrights or businesses of such entities. QUOTETIGER reserves the right, in its sole discretion and without any obligation, to make improvements to, or correct any error or omissions in any portion of the Information.


⦁	Trademark
"Quotetiger" and related icons and logos are registered trademarks or trademarks or service marks of QUOTETIGER in various jurisdictions and are protected under applicable copyright, trademark and other proprietary and intellectual property rights laws. The unauthorized adoption copying, modification, use or publication of these marks is strictly prohibited.
⦁	Copyright
All App Content including App Information is copyrighted to QUOTETIGER excluding any third-party content and any links to any third-party apps being made available or contained on the App. User(s) may not use any trademark, service mark or logo of any independent third parties without prior written approval from such parties.

User(s) acknowledge and agree that QUOTETIGER is not an arbiter or judge of disputes concerning intellectual property rights and as such cannot verify that User(s) selling or supplying merchandise or providing services on the App have the right to sell the merchandise or provide the services offered by such User(s). QUOTETIGER encourages User(s) to assist QUOTETIGER in identifying listings on the App which in the User(s) knowledge or belief infringe their rights. User(s) further acknowledge and agree by taking down a listing, QUOTETIGER does not and cannot be deemed to be endorsing a claim of infringement and further that in those instances in which QUOTETIGER declines to take down a listing, QUOTETIGER does not and cannot be deemed to be endorsing that the listing is not infringing of third party rights or endorsing any sale or supply of merchandise or services pursuant to or on account of such listing.

QUOTETIGER respects the intellectual property rights of others, and we expect our User(s) to do the same. User(s) agree to not copy, download or reproduce the App Content, Information or any other material, text, images, video clips, directories, files, databases or listings available on or through the App ("QUOTETIGER Content") for the purpose of re-selling or re-distributing, mass mailing (via email, wireless text messages, physical mail or otherwise) operating a business competing with QUOTETIGER, or otherwise commercially exploiting the QUOTETIGER Content unless otherwise agreed between the parties. Systematic retrieval of QUOTETIGER Content to create or compile, directly or indirectly, a collection, compilation, database or directory (whether through robots, spiders, automatic devices or manual processes) without written permission from QUOTETIGER is prohibited.
 
In addition, use of the QUOTETIGER Content for any purpose not expressly permitted in this Agreement is prohibited and entitles QUOTETIGER to initiate appropriate legal action. User(s) agree that as a condition of their access to and use of QUOTETIGER's Services, they will not use QUOTETIGER’s Services to infringe the intellectual property rights of any third parties in any way. QUOTETIGER reserves the right to terminate the right of any User(s) to access or use QUOTETIGER’s Services for any infringement of the rights of third parties in conjunction with use of the QUOTETIGER’s Service, or in the event QUOTETIGER is of the believes that User(s) conduct is prejudicial to the interests of QUOTETIGER, its affiliates, or other User(s), or for any other reason, at QUOTETIGER’s sole discretion, with or without cause.
⦁	URL's/Sub-Domain
URL’s/ Sub-domain names assigned by QUOTETIGER to User(s) (including both paid and free User(s)) are the exclusive property of QUOTETIGER and it cannot be assumed to be permanent in any case. QUOTETIGER reserves the right, without prior notice, at any point of time, to suspend or terminate or restrict access to or edit any URL's/Sub-domain names. IN ALL SUCH CASES, QUOTETIGER WILL NOT BE LIABLE TO ANY PARTY FOR ANY DIRECT, INDIRECT, SPECIAL OR OTHER CONSEQUENTIAL DAMAGES, INCLUDING, WITHOUT LIMITATION, ANY LOST PROFITS, BUSINESS INTERRUPTION OR OTHERWISE.
QUOTETIGER may allow User(s) access to content, products or services offered by third parties through hyperlinks (in the form of word link, banners, channels or otherwise) to the apps offered by such third parties ("Third Party Apps"). QUOTETIGER advises its User(s) to read the terms and conditions of use and/or privacy policies applicable in respect of such Third Party Apps prior to using or accessing such Third Party Websites. Users acknowledge and agree that QUOTETIGER has no control over any content offered on Third Party Websites, does not monitor such Third Party Websites, and shall in no manner be deemed to be liable or responsible to any person for such Third Party Sites, or any content, products or services made available thereof.

6. LINKS TO THIRD PARTY SITES
Links to third party sites are provided on App as a convenience to User(s). User(s) acknowledge and agree that QUOTETIGER does not have any control over the content of such websites and/ or any information, resources or materials provided therein.

QUOTETIGER may allow User(s) access to content, products or services offered by third parties through hyperlinks (in the form of word link, banners, channels or otherwise) to the websites offered by such third parties ("Third Party Websites"). QUOTETIGER advises its User(s) to read the terms and conditions of use and/or privacy policies applicable in respect of such Third Party Websites prior to using or accessing such Third Party Websites. Users acknowledge and agree that QUOTETIGER has no control over any content offered on Third Party Websites, does not monitor such Third Party Websites, and shall in no manner be deemed to be liable or responsible to any person for such Third Party Sites, or any content, products or services made available thereof.

7. TERMINATION
Most content and some of the features on the App are made available to User(s) free of charge. However, QUOTETIGER reserves the right to terminate access to certain areas or features of the App (to paying or registered User(s)) at any time without assigning any reason and with or without notice to such User(s). QUOTETIGER also reserves the universal right to deny access to particular User(s) to any or all of its services or content without any prior notice or explanation in order to protect the interests of QUOTETIGER and/ or other User(s) of the App. QUOTETIGER further reserves the right to limit, deny or create different access to the App and its features with respect to different User(s), or to change any or all of the features of the App or introduce new features without any prior notice to User(s).
QUOTETIGER reserves the right to terminate the membership/subscription of any User(s) temporarily or permanently for any of the following reasons:
(a) If any false information in connection with their account registered with QUOTETIGER is provided by such User(s), or if such User(s) are engaged in fraudulent or illegal activities/transactions.
(b) If such User(s) breaches any provisions of the Agreement.
(c) If such User(s) utilizes the App to send spam messages or repeatedly publish the same product information.
(d) If such User(s) posts any material that is not related to trade or business cooperation.
(e) If such User(s) impersonates or unlawfully uses another person’s or business entity’s name to post information or conduct business in any manner.  
(f) If such User(s) is involved in unauthorized access, use, modification, or control of the App database, network or related services.
(g) If such User(s) obtains by any means another registered User(s) Username and/or Password.
(h) Or any other User(s) activity that may not be in accordance with the ethics and honest business practices.
If QUOTETIGER terminates the membership of any registered User(s) including those User(s) who have subscribed for the paid services of QUOTETIGER, such person will not have the right to re-enrol or join the App under a new account or name unless invited to do so in writing by QUOTETIGER In any case of termination, no subscription/membership fee/charges paid by the User(s) will be refunded. User(s) acknowledge that inability to use the App wholly or partially for whatever reason may have adverse effect on their business. User(s) hereby agree that in no event shall QUOTETIGER be liable to any User(s) or any third parties for any inability to use the App (whether due to disruption, limited access, changes to or termination of any features on the App or otherwise), any delays, errors or omissions with respect to any communication or transmission, or any damage (direct, indirect, consequential or otherwise) arising from the use of or inability to use the App or any of its features.

8. REGISTERED USER(S)
To become a registered User(s) of the App a proper procedure has been made available on the App which is for the convenience of User(s) so that they can easily use the app.

User(s) can become registered User(s) by filling an on-line registration form on the App by providing the required information (including name, contact information, details of User(s) business, etc.). QUOTETIGER will establish an account ("Account") for the User(s) upon successful registration and will assign a user alias ("User ID") and password ("Password") for log-in access to the User(s)’s Account. QUOTETIGER may at its sole discretion assign to User(s) upon registration a web-based email or messaging account (“Email Account”) with limited storage space to send or receive emails or messages. Users will be responsible for the content of all the messages communicated through the account.
 
User(s) registering on the App on behalf of business entities represent and warrant that: (a) they have the requisite authority to bind such business entity this Agreement; (b) the address provided by such User(s) at the time of registration is the principal place of business of such business entity; and (c) all other information provided to QUOTETIGER during the registration process is true, accurate, current and complete. For purposes of this provision, a branch or representative office of a User(s) will not be considered a separate entity and the principal place of business of the User(s) will be deemed to be that of its head office.
 
User(s) agree that by registering on the App, they consent to the inclusion of their personal data in QUOTETIGER’s on-line database and authorize QUOTETIGER to share such information with other User(s). QUOTETIGER may refuse registration and deny the membership and associated User ID and Password to any User(s) for whatever reason. QUOTETIGER may suspend or terminate a registered membership at any time without any prior notification in interest of QUOTETIGER or general interest of its User(s) without assigning any reason thereof and there shall arise no further liability on QUOTETIGER of whatsoever nature due to the suspension or termination of the User account. User(s) registered on the App are in no manner a part of or affiliated to QUOTETIGER.

User(s) further agree and consent to be contacted by QUOTETIGER through phone calls, SMS notifications or any other means of communication, in respect to the services provided by QUOTETIGER even if contact number(s) provided to QUOTETIGER upon registration are on Do Not Call Registry.

9. DATA PROTECTION
Personal information supplied by User(s) during the use of the App is governed by QUOTETIGER’s privacy policy ("Privacy Policy"). 

10. POSTING YOUR CONTENT ON APP.
Some content displayed on the App is provided or posted by third parties. User(s) can post their content on some of the sections/services of the App using the self-help submit and edit tools made at the respective sections of the App. User(s) may need to register and/or pay for using or availing some of these services.

User(s) understand and agree that QUOTETIGER in such case is not the author of the content and that neither QUOTETIGER nor any of its affiliates, directors, officers or employees have entered into any arrangement including any agreement of sale or agency with such third parties by virtue of the display of such content on the App. User(s) further understand and agree QUOTETIGER is not responsible for the accuracy, propriety, lawfulness or truthfulness of any third party content made available on the App and shall not be liable to any User(s) in connection with any damage suffered by the User(s) on account of the User(s)’s reliance on such content. QUOTETIGER shall not be liable for a User(s) activities on the App, and shall not be liable to any person in connection with any damage suffered by any person as a result of any User's conduct.

User(s) solely represent, warrant and agree to:

(a) provide QUOTETIGER with true, accurate, current and complete information to be displayed on the App;
(b) maintain and promptly amend all information provided on the App to keep it true, accurate, current and complete.
User(s) hereby grant QUOTETIGER an irrevocable, perpetual, worldwide and royalty-free, sub-licensable (through multiple tiers) license to display and use all information provided by them in accordance with the purposes set forth in the Agreement and to exercise the copyright, publicity and database rights User(s) have in such material or information, in any form of media, third party copyrights, trademarks, trade secret rights, patents and other personal or proprietary rights affecting or relating to material or information displayed on the App, including but not limited to rights of personality and rights of privacy, or affecting or relating to products that are offered or displayed on the App (hereafter referred to as "Third Party Rights").

User(s) hereby represent, warrants and agree that User(s) shall be solely responsible for ensuring that any material or information posted by User(s) on the App or provided to the App or authorized by the User(s) for display on the App, does not, and that the products represented thereby do not, violate any Third Party Rights, or is posted with the permission of the owner(s) of such Third Party Rights. User(s) hereby represent, warrant and agree that they have the right to manufacture, offer, sell, import and distribute the products offered and displayed on the App, and that such manufacture, offer, sale, importation and/or distribution of those products violates no Third Party Rights.

User(s) agree that they will not use QUOTETIGER Content and/or QUOTETIGER’s Services to send junk mail, chain letters or spamming. Further, registered User(s) of the App agree that they will not use the Email Account to publish, distribute, transmit or circulate any unsolicited advertising or promotional information. User(s) further hereby represent, warrant and agree (i) to host, display, upload, modify, publish, transmit, store, update or share ; or (ii) submit to QUOTETIGER for display on the App or transmit or sought to be transmitted through QUOTETIGER’s Services any content, material or information that does not and shall at no point:

⦁	Contain fraudulent information or make fraudulent offers of items or involve the sale or attempted sale of counterfeit or stolen items or items whose sales and/or marketing is prohibited by applicable law, or otherwise promote other illegal activities;
⦁	Belong to another person and to which User(s) do not have any right to;
⦁	Be part of a scheme to defraud other User(s) of the App or for any other unlawful purpose;
⦁	Be intended to deceive or mislead the addressee about the origin of such messages or knowingly and intentionally is used to communicate any information which (i) is patently false or grossly offensive or menacing/misleading in nature but may reasonably be perceived as a fact; or (ii) harass a person, entity or agency for financial gain or to cause any injury to any person;
⦁	Relate to sale of products or services that infringe or otherwise abet or encourage the infringement or violation of any third party's copyright, patent, trademarks, trade secret or other proprietary right or rights of publicity or privacy, or any other Third Party Rights;
⦁	Violate any applicable law, statute, ordinance or regulation (including without limitation those governing export control, consumer protection, unfair competition, anti-discrimination or false advertising);
⦁	Relate to any controversial weapons, cluster munitions or anti-personnel mines and other such defense equipment;
⦁	Be defamatory, abusive libelous, unlawfully threatening, unlawfully harassing, grossly harmful, indecent, seditious, blasphemous, pedophilic, hateful, invasive of another’s privacy, including bodily privacy racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, leading to breach of confidence, or otherwise unlawful or objectionable in any manner whatever;
⦁	Be vulgar, obscene or contain or infer any pornography or sex-related merchandising or any other content or otherwise promotes sexually explicit materials or is otherwise harmful to minors;
⦁	Promote discrimination based on race, sex, religion, nationality, disability, sexual orientation or age;
⦁	Contain any material that constitutes unauthorized advertising or harassment (including but not limited to spamming), invades anyone's privacy or encourages conduct that would constitute a criminal offense, give rise to civil liability, or otherwise violate any law or regulation;
⦁	Solicit business from any User(s) in connection with a commercial activity that competes with QUOTETIGER;
⦁	Threaten the unity, integrity, defence, security or sovereignty of United Kingdom, friendly relations with foreign states, or public order or causes incitement to the commission of any cognisable offence or prevents investigation of any offence or is insulting any other nation;
⦁	Contain any computer viruses or other destructive devices and codes that have the effect of damaging, interfering with, intercepting or expropriating any software or hardware system, data or personal information or that are designed to interrupt, destroy or limit the functionality of any computer resource;
⦁	Link directly or indirectly to or include descriptions of goods or services that are prohibited under the prevailing law; or Otherwise create any liability for QUOTETIGER or its affiliates.
 

QUOTETIGER reserves the right in its sole discretion to remove any material/content/photos/offers displayed on the App which in QUOTETIGER’s reasonable belief is unlawful or could subject QUOTETIGER to liability or in violation of the Agreement or is otherwise found inappropriate in QUOTETIGER's opinion. QUOTETIGER reserves the right to cooperate fully with governmental authorities, private investigators and/or injured third parties in the investigation of any suspected criminal or civil wrongdoing.

In connection with any of the foregoing, QUOTETIGER reserves the right to suspend or terminate the Account of any User(s) as deemed appropriate by QUOTETIGER at its sole discretion. User(s) agree that QUOTETIGER shall have no liability to any User(s), including liability in respect of consequential or any other damages, in the event QUOTETIGER takes any of the actions mentioned in this provision.

User(s) understand and agree that the App acts as a content integrator and is not responsible for the information provided by User(s) displayed on the App. QUOTETIGER does not have any role in developing the content displayed on the App. QUOTETIGER has the right to promote any content including text, images, videos, brochures etc. provided by User(s) on various platforms owned by the company.

11. INTERACTION BETWEEN USERS
QUOTETIGER provides an on-line platform to facilitate interaction between buyers and suppliers of products and services. QUOTETIGER does not control and is not liable to or responsible for the quality, safety, lawfulness or availability of the products or services offered for sale on the App or the ability of the suppliers to complete a sale or the ability of buyers to complete a purchase. User(s) are cautioned that there may be risks of dealing with foreign nationals or people acting under false pretences on the App. App uses several tools and techniques to verify the accuracy and authenticity of the information provided by User(s). QUOTETIGER however, cannot and does not confirm each User(s)’s purported identity on the App. QUOTETIGER encourages User(s) to evaluate the User(s) with whom they would like to deal with and use the common prudence while dealing with them.

User(s) agree to fully assume the risks of any transactions ("Transaction Risks") conducted on the basis of any content, information or any other material provided on the App and further assume the risks of any liability or harm of any kind arising due to or caused in connection with any subsequent activity relating to any products or services that are the subject of any such transaction.

⦁	Such risks include, but are not limited to, misrepresentation of products and services, fraudulent schemes, unsatisfactory quality, failure to meet specifications, defective or dangerous products, unlawful products, delay or default in delivery or payment, cost miscalculations, breach of warranty, breach of contract and transportation accidents.
⦁	Such risks also include the risks that the manufacture, importation, distribution, offer, display, purchase, sale and/or use of products or services offered or displayed on the App may violate or may be asserted to violate Third Party Rights, and the risk that that User(s) may incur costs of defense or other costs in connection with third parties' assertion of Third Party Rights, or in connection with any claims by any party that they are entitled to defense or indemnification in relation to assertions of rights, demands or claims by Third Party Rights claimants.
⦁	Such risks further include the risks that r the purchasers, end-users of products or others claiming to have suffered injuries or harms relating to product originally obtained by User(s) of the App as a result of purchase and sale transactions in connection with using any content, information or any other material provided on the App may suffer harms and/or assert claims arising from their use of such products.
User(s) agree that QUOTETIGER shall not be liable or responsible for any damages, liabilities, costs, harms, inconveniences, business disruptions or expenditures of any kind that may occur/arise as a result of or in connection with any Transaction Risks. User(s) are solely responsible for all of the terms and conditions of the transactions conducted on, through or as a result of use of any content, information or any other material provided on the App , including, without limitation, terms regarding payment, returns, warranties, shipping, insurance, fees, taxes, title, licenses, fines, permits, handling, transportation and storage. In the event of a dispute with any party to a transaction, User(s) agrees to release and indemnify QUOTETIGER (and our agents, affiliates, directors, officers and employees) from all claims, demands, actions, proceedings, costs, expenses and damages (including without limitation any actual, special, incidental or consequential damages) arising out of or in connection with such transaction  

Quotetiger reserves the right to add/modify/discontinue any of the features offered on QUOTETIGER’s Services.

12. LIMITATION OF LIABILITY/DISCLAIMER
The features and services on the App are provided on an " as is " and " as available " basis, and QUOTETIGER hereby expressly disclaims any and all warranties, express or implied, including but not limited to any warranties of condition, quality, durability, performance, accuracy, reliability, merchantability or fitness for a particular purpose. All such warranties, representations, conditions, undertakings and terms are hereby excluded. QUOTETIGER makes no representations or warranties about the validity, accuracy, correctness, reliability, quality, stability or completeness of any information provided on or through the App including display or listing of tenders on the App which in no manner is endorsed by QUOTETIGER. QUOTETIGER has no association of whatsoever nature with the publisher and/or the published contents. Moreover, QUOTETIGER does not facilitate or participate in any sale, delivery, transaction and / or storage related to any product including but not limited to controversial weapons, cluster munitions or anti-personnel mines and other such defense equipment. QUOTETIGER does not represent or warrant that the manufacture, importation, distribution, offer, display, purchase, sale and/or use of products or services offered or displayed on the App does not violate any Third Party Rights; and QUOTETIGER makes no representations or warranties of any kind concerning any product or service offered or displayed on the App. Any material downloaded or otherwise obtained through the App is at the User(s) sole discretion and risk and the User(s) is solely responsible for any damage to its computer system or loss of data that may result from the download of any such material. No advice or information, whether oral or written, obtained by the User(s) from App or through or from the App shall create or be deemed to create any warranty not expressly stated herein.

Under no circumstances shall QUOTETIGER be held liable for any delay or failure or disruption of the content or services delivered through the App resulting directly or indirectly from acts of nature, forces or causes beyond its reasonable control, including without limitation, Internet failures, computer, telecommunications or any other equipment failures, electrical power failures, strikes, labour disputes, riots, insurrections, civil disturbances, shortages of labour or materials, fires, flood, storms, explosions, Acts of God, natural calamities, war, governmental actions, orders of domestic or foreign courts or tribunals or non-performance of third parties. User(s) hereby agree to indemnify and save QUOTETIGER, its affiliates, directors, officers and employees harmless, from any and all losses, claims, liabilities (including legal costs on a full indemnity basis) which may arise from their use of the App (including but not limited to the display of User(s) information on the App) or from User(s)’s breach of any of the terms and conditions of this Agreement. User(s) hereby further agree to indemnify and save QUOTETIGER, its affiliates, directors, officers and employees harmless, from any and all losses, claims, liabilities (including legal costs on a full indemnity basis) which may arise from User(s)’s breach of any representations and warranties made by the User(s) to QUOTETIGER.

User(s) hereby further agree to indemnify and save QUOTETIGER, its affiliates, directors, officers and employees harmless, from any and all losses, claims, liabilities (including legal costs on a full indemnity basis) which may arise, directly or indirectly, as a result of any claims asserted by Third Party Rights claimants or other third parties relating to products offered or displayed on the App. User(s) hereby further agree that QUOTETIGER is not responsible and shall have no liability for any material posted by other User(s) or any other person, including defamatory, offensive or illicit material and that the risk of damage from such material rests entirely with the User(s). QUOTETIGER reserves the right, at its own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by any User(s), in which event such User(s) shall cooperate with QUOTETIGER in asserting any available defences.

  QUOTETIGER shall not be liable for any special, direct, indirect, punitive, incidental or consequential damages or any damages whatsoever (including but not limited to damages for loss of profits or savings, business interruption, loss of information), whether in contract, negligence, tort, strict liability or otherwise or any other damages resulting from any of the following:
⦁	The use or the inability to use the App;
⦁	Any defect in goods, samples, data, information or services purchased or obtained from a User(s) or a third-party service provider through the app;
⦁	Violation of Third Party Rights or claims or demands that User(s) manufacture, importation, distribution, offer, display, purchase, sale and/or use of products or services offered or displayed on the app may violate or may be asserted to violate Third Party Rights; or claims by any party that they are entitled to defense or indemnification in relation to assertions of rights, demands or claims by Third Party Rights claimants;
⦁	Unauthorized access by third parties to data or private information of any User(s);
⦁	Statements or conduct of any User(s) of the app; or
⦁	Any matters relating to Premium Services however arising, including negligence.


13. NOTICES
 
All notices or demands to or upon QUOTETIGER shall be effective if in writing and shall be deemed to be duly made when sent to QUOTETIGER to QuoteTiger, 3 Hervey close, London N3 2HG. All notices or demands to or upon a User(s) shall be effective if either delivered personally, sent by courier, certified mail, by facsimile or email to the last-known correspondence, fax or email address provided by the User(s) on the App, or by posting such notice or demand on an area of the App that is publicly accessible without a charge.
 

Notice to a User(s) shall be deemed to be received by such User(s) if and when App is able to demonstrate that communication, whether in physical or electronic form, has been sent to such User(s), or immediately upon App’s posting such notice on an area of the App that is publicly accessible without charge.

14. GOVERNING LAW AND DISPUTE RESOLUTIONS
This Agreement and the Privacy Policy shall be governed in all respects by the laws of UNITED KINGDOM Territory. QUOTETIGER considers itself and intends itself to be subject to the jurisdiction of the Courts of UNITED KINGDOM only. The parties to this Agreement hereby submit to the exclusive jurisdiction of the courts UNITED KINGDOM.

15. MISCELLANEOUS
⦁	Headings for any section of the Agreement are for reference purposes only and in no way define, limit, construe or describe the scope or extent of such section.
⦁	QUOTETIGER’s failure to enforce any right or failure to act with respect to any breach by a User(s) under the Agreement and/or Privacy Policy will not be deemed to be a QUOTETIGER’s waiver of that right or QUOTETIGER's waiver of the right to act with respect with subsequent or similar breaches.
 
⦁	QUOTETIGER shall have the right to assign its obligations and duties in this Agreement and in any other agreement relating QUOTETIGER’s Services to any person or entity
⦁	If any provision of this Agreement is held to be invalid or unenforceable, such provision shall be struck out and the remaining provisions of the Agreement shall be enforced.
⦁	All calls to Quotetiger are completely confidential. However, Your call may be recorded to ensure quality of service. Further, for training purpose and to ensure excellent customer service, calls from Quotetiger may be monitored and recorded.
⦁	The Agreement and the Privacy Policy constitute the entire agreement between the User(s) and QUOTETIGER with respect to access to and use of the App, superseding any prior written or oral agreements in relation to the same subject matter herein
⦁	Apart from the said terms & conditions, the Agreement shall be deemed to form part and parcel of BB term and conditions.



17. PHARMACEUTICAL PRODUCT/SERVICE POLICIES
The App does not facilitate the purchase of pharmaceutical products, and only advertises and/or showcases the pharmaceutical products posted by Users(s). User(s) involved in the purchase and supply of pharmaceutical products hereby agree to abide by and be compliant of any applicable laws, rules, regulations, notifications or orders issued by the Government of UNITED KINGDOM or any of its agencies.

QUOTETIGER shall not be responsible for any information, content or material in respect of or related to any pharmaceutical product posted, provided or displayed by User(s) on the App. Accordingly, the User posting the content shall ensure that the content so posted does not violate any statue in the rules made thereunder including the regulation(s) as referred above, so that no consequences of any nature could be attributed to QUOTETIGER in any manner whatsoever. 

Users(s) hereby undertake that they shall solely be responsible and shall bear all the liabilities in respect of selling prescription medicines and/or drugs mentioned in any of the Schedules of the Drug Rules without a prescription issued by a registered medical practitioner and in accordance with the conditions laid down in such rules. In the event of breach of such condition, QUOTETIGER shall not be liable and responsible in any manner whatsoever.

Users(s) undertake and agree to indemnify and hold harmless QUOTETIGER and/or any of its affiliates, directors, officers, employees or representatives from and against any and all losses, liabilities, damages, claims, costs and expenses (including attorney’s fees and expenses, any third party claims), which QUOTETIGER may incur or suffer as a result of or in connection with any illegal sales of drugs and/or medicines.

QUOTETIGER does not offer any guarantees or warranties on the medicinal products or services displayed or listed on the App and is not liable for any relevant transaction between the User(s), including transactions involving sale of any medicine(s) restricted and/or banned for sale by any governmental or any other regulatory authorities.
""";
final privacy = """
The Privacy Policy of QuoteTiger (hereinafter referred to as “app ") detailed herein below governs the collection, possession, storage, handling and dealing of personal identifiable information/data and sensitive personal data (hereinafter collectively referred to as “information”) of the users of the app.
All the users must read and understand this Privacy Policy as it has been formulated to safeguard the user’s privacy. This Privacy Policy also outlines the ways the users can ensure protection of their personal identifiable information.
You must accept the contents of this Policy in order to use or continue using our app. This Privacy Policy detailed herein is also applicable to user of the app or mobile application through mobile or any other similar device.

COLLECTION OF INFORMATION
We confirm that we collect those information from you which is required to extend the services available on the app.
At the time of signing up and registration with the app, we collect user information including name, company name, email address, phone/mobile number, postal address and other business information which may also include business statutory details and tax registration numbers.
In this regard, we may also record conversations and archive correspondence between users and the representatives of the app (including the additional information, if any) in relation to the services for quality control or training purposes.
In relation to our paid services, we may collect personal information of a more sensitive nature which includes bank account numbers and related details to facilitate the sale or purchase of the services available on the app.
We also gather and store the user’s usage statistics such as IP addresses, pages viewed, user behaviour pattern, number of sessions and unique visitors, browsing activities, browser software operating system etc. for analysis, which helps us to provide improved experience and value added services to you.
Once a user registers, the user is no longer anonymous to us and thus all the information provided by you shall be stored, possessed in order to provide you with the requested services and as may be required for compliance with statutory requirements.
User’s registration with us and providing information is intended for facilitating the users in its business.
We retains user provided Information for as long as the Information is required for the purpose of providing services to you or where the same is required for any purpose for which the Information can be lawfully processed or retained as required under any statutory enactments or applicable laws.
User may update, correct, or confirm provided, the requested changes may take reasonable time due to verification process and server cache policies. In case you would like to receive a copy of our information held by us for porting to another service, please contact us.
Users may also choose to delete or deactivate their accounts on the app. We will evaluate such requests on a case-to-case basis and take the requiapp action as per applicable law. In this regard, please note that information sought to be deleted may remain with us in archival records for the purpose of compliance of statutory enactments, or for any other lawful purpose. Therefore, users are requested to carefully evaluate what types of information they would like to provide to us at the time of registration.

PURPOSE AND USAGE OF INFORMATION
The following are the purposes of collecting the Information:
For the verification of your identity, eligibility, registration and to provide customized services.
For facilitating the services offered/available on the app.
For advertising, marketing, displaying & publication.
For enabling communication with the users of the app, so that the users may fetch maximum business opportunities.
For generating business enquires and trade leads.
For sending communications, notifications, newsletters and customized mailers etc.
Please get in touch with us at the above email address in case you would like to object to any purpose of data processing. However, please note that if you object or withdraw consent to process data as above, we may discontinue providing you with services through our app.

DISCLOSURE OF INFORMATION
Information we may collect from you may be disclosed and transferred to external service providers who we rely on to provide services to us or to you directly. For instance, information may be shared with
Affiliated companies for better efficiency, more relevancy, innovative business matchmaking and better personalised services.
Government or regulatory or law enforcement agencies, as mandated under statutory enactment, for verification of identity or for prevention, detection, investigation including cyber incidents, prosecution and punishment of offences.
Service provider including but not limited to payment, customer and cloud computing service provider (“Third Party”) engaged for facilitating service requirements of user.
Business partners for sending their business offers to the users, which are owned and offered by them solely without involvement of the app.
Links to the apps of any of the above may be available on the app as a convenience to user(s) and the app does not have any control over such website or apps. The usage of such websites by the user will be governed by their respective Privacy Policies and the present Privacy Policy will not apply to usage of such websites. The users of such websites are cautioned to read the privacy policies of such websites.
Please get in touch with us at the above email address in case you would like to object to any purpose of data processing. However, please note that if you object or withdraw consent to process data as above, we may discontinue providing you with services through our app.

In relation to such disclosures, receiving parties have consented and confirmed that:
There shall be limited disclosure of any Information to its Directors, officers, employees, agents or representatives who have a need to know such Information in connection with the business transaction and are only permitted to use your Information in connection with the said purpose,
They shall keep the Information confidential and secure by using a reasonable degree of care, and
They shall not disclose any Information received by them further and must abide by the Privacy Policy of the app.
Please keep in mind that whenever a user post personal & business information online, the same becomes accessible to the public and the users may receive messages/emails from visitors of the app.

REASONABLE PROTECTION OF INFORMATION
We employ commercially reasonable and industry-standard security measures to prevent unauthorized access, maintain data accuracy and ensure proper use of information we receive.
These security measures are both electronic as well as physical but at the same time no data transmission over the Internet can be guaranteed to be 100% secure.
We strive to protect the User Information, although we cannot ensure the security of Information furnished/transmitted by the users to us.
We recommend you not to disclose password of your email address, online bank transaction and other important credentials to our employees / agents / affiliates/ personnel, as we do not ask for the same.
We recommend that registered users not to share their app’s account password and also to sign out of their account when they have completed their work. This is to ensure that others cannot access Information of the users and correspondence, if the user shares the computer with someone else or is using a computer in a public place
We recommend you not to disclose password of your email address, online bank transaction and other important credentials to our employees / agents / affiliates/ personnel, as we do not ask for the same

COOKIES

We, and third parties with whom we partner, may use cookies, pixel tags, web beacons, mobile device IDs, “flash cookies” and similar files or technologies to collect and store information in respect to your use of the app and track your visits to third party websites.
We also use cookies to recognize your browser software and to provide features such as recommendations and personalization.
Third parties whose products or services are accessible or advertised through the app, including social media apps, may also use cookies or similar tools, and we advise you to check their privacy policies for information about their cookies and the practices followed by them. We do not control the practices of third parties and their privacy policies govern their interactions with you.

DATA COLLECTION RELATING TO CHILDREN

We strongly believe in protecting the privacy of children. In line with this belief, we do not knowingly collect or maintain Personally Identifiable Information on our App from persons under 18 years of age, and no part of our App is directed to persons under 18 years of age. If you are under 18 years of age, then please do not use or access our services at any time or in any manner. We will take appropriate steps to delete any Personally Identifiable Information of persons less than 18 years of age that has been collected on our App without verified parental consent upon learning of the existence of such Personally Identifiable Information.
If we become aware that a person submitting personal information is under 18, we will delete the account and all related information as soon as possible. If you believe we might have any information from or about a child under 18 please contact us. 

DATA TRANSFERS

User Information that we collect may be transferred to, and stored at, any of our affiliates, partners or service providers which may be inside or outside the country you reside in. By submitting your personal data, you agree to such transfers.
Your Personal Information may be transferred to countries that do not have the same data protection laws as the country in which you initially provided the information. When we transfer or disclose your Personal Information to other countries, we will protect that information as described in this Privacy Policy. relevant, we will ensure appropriate contractual safeguards to ensure that your information is processed with the highest standards of transparency and fairness.

QUESTIONS
Please contact us regarding any questions, clarifications, or grievances. Please contact us.

CHANGES IN PRIVACY POLICY

The policy may change from time to time, so users are requested to check it periodically.
""";
