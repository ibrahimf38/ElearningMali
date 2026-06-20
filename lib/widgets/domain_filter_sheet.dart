import 'package:flutter/material.dart';
import '../models/filtre_model.dart';
import '../services/filtre_service.dart';

/// Affiche le bottom sheet "Filtré par niveau :" avec les domaines
/// chargés depuis le backend. Retourne le [DomaineModel] sélectionné,
/// ou null si annulé.
Future<DomaineModel?> showDomainFilterSheet(
  BuildContext context, {
  DomaineModel? selected,
}) {
  return showModalBottomSheet<DomaineModel>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return _DomainFilterContent(selected: selected);
    },
  );
}

class _DomainFilterContent extends StatefulWidget {
  final DomaineModel? selected;
  const _DomainFilterContent({this.selected});

  @override
  State<_DomainFilterContent> createState() => _DomainFilterContentState();
}

class _DomainFilterContentState extends State<_DomainFilterContent> {
  final FiltreService _service = FiltreService();
  List<DomaineModel> _domaines = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final domaines = await _service.getDomaines();
      setState(() {
        _domaines = domaines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les domaines';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Filtré par niveau :',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Text(_error!, style: const TextStyle(color: Color(0xFF6B7280))),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _load,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          else if (_domaines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Aucun domaine disponible',
                  style: TextStyle(color: Color(0xFF9E9E9E))),
            )
          else
            ..._domaines.map((domaine) {
              final isSelected = domaine.id == widget.selected?.id;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, domaine),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2E7D32).withOpacity(0.12)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      domaine.nomDomaine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}