import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconTextItem {
  final IconData icon;
  final String text;
  final String? desc;

  IconTextItem({required this.icon, required this.text, this.desc});
}

class IconTextTile extends StatelessWidget {
  final IconTextItem item;

  const IconTextTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    bool isThereDesc = item.desc != null;
    double padding = isThereDesc ? 8.0 : 0.0;

    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(item.icon),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.text,
              style: GoogleFonts.inter(
                fontSize: 18.0,
              ),
            ),
            if (isThereDesc)
              Text(
                item.desc!,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
