
import 'package:contact_1/model/contact_model.dart';
import 'package:contact_1/ui/homeScreen/widgets/add_contact_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/colors_manager.dart';
import '../widgets/contact_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ContactModel> contactes =[];

  void _openAddContactSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddContactSheet(
        onAdd: (newContact) {
          setState(() {
            contactes.add(newContact);
          }
          );
        },
      )

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBlur,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (contactes.isNotEmpty) ...[
            FloatingActionButton(
              heroTag: 'delete_last',
              backgroundColor: Colors.red,
              onPressed: () {
                setState(() {
                  contactes.removeLast();
                });
              },
              child: const Icon(Icons.delete_sharp, color: Colors.white),
            ),
            const SizedBox(height: 12),
          ],
          if (contactes.length < 6)
            FloatingActionButton(
              heroTag: 'add_contact',
              backgroundColor: ColorsManager.gold,
              onPressed: _openAddContactSheet,
              child: SvgPicture.asset(AssetsManager.icon),
            ),
        ],
      ),
      body: SafeArea(
        child:Stack(
          children: [
            Lottie.asset(AssetsManager.background,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              repeat: true,
            ),
            Positioned(
              top: 12,
              left: 20,
              child: Image.asset(
                AssetsManager.logo,
                width: 100,
                height: 39,
              ),
            ),
            if (contactes.isEmpty)
              Align(
                alignment: const Alignment(0, 0.4),
                child: Text(
                  "There is No Contacts Added Here",
                  style: TextStyle(
                    color: ColorsManager.gold,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: GridView.builder(
                  itemCount: contactes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  itemBuilder: (context, index) {
                    return ContactCard(
                      contact: contactes[index],
                      onDelete: () {
                        setState(() {
                          contactes.removeAt(index);
                        });
                      },
                    );

                  },
                ),
              )
          ],
        )
      ),

    );
  }
}
