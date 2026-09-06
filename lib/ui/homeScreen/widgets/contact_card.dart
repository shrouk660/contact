import 'package:contact_1/core/resources/assets_manager.dart';
import 'package:contact_1/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/resources/colors_manager.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onDelete;

  const ContactCard({
    required this.contact,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.gold,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: contact.image != null
                    ? Image.file(contact.image!, fit: BoxFit.cover)
                    : Container(
                  color: Colors.black26,
                  child: const Icon(Icons.person, color: Colors.white54, size: 50),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorsManager.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contact.name,
                    style: TextStyle(
                      color: ColorsManager.darkBlur,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: Row(
              children: [
                SvgPicture.asset(AssetsManager.exclude),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    contact.email,
                    style: TextStyle(color: ColorsManager.darkBlur, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                SvgPicture.asset(AssetsManager.phoneCall),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    contact.phone,
                    style: TextStyle(color: ColorsManager.darkBlur, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.red,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.white),
                label: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


