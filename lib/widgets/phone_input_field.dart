import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Champ de saisie téléphone avec préfixe pays fixe (+223) non modifiable.
///
/// L'utilisateur ne peut taper que ses 8 chiffres locaux — impossible
/// d'oublier ou de mal saisir le préfixe international. [onChanged]
/// renvoie uniquement les chiffres tapés (sans le préfixe), à utiliser
/// avec `auth.setPhone()` qui ajoute déjà +223 automatiquement.
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String prefix;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.prefix = '+223',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Préfixe pays fixe, non éditable
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: Text(
              prefix,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          // Champ pour les 8 chiffres locaux uniquement
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              maxLength: 8,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: '76 12 34 56',
                hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                counterText: '',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
