import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderTile extends StatelessWidget {
  final String? name;
  final bool isSelected;

  GenderTile({required this.name, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: (20)),
        margin: EdgeInsets.only(bottom: 10),
        height: size.height * 0.07,
        width: size.width * 0.95,
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.red.withOpacity(0.5) : Color(0xFF80899A),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              name == 'Laki-Laki' ? Icons.male : Icons.female,
              color: isSelected ? Colors.white : Color(0xFF80899A),
            ),
            SizedBox(width: size.width * 0.005),
            Text(
              name ?? '',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 16,
                    color: isSelected ? Colors.white : Color(0xFF80899A),
                    letterSpacing: 2),
              ),
            )
          ],
        ));
  }
}
