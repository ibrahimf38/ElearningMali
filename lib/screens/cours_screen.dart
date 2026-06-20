import 'package:flutter/material.dart';
import '../models/filtre_model.dart';
import '../services/filtre_service.dart';
import '../widgets/section_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/domain_filter_sheet.dart';

class CoursScreen extends StatefulWidget {
  const CoursScreen({super.key});

  @override
  State<CoursScreen> createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  final FiltreService _service = FiltreService();

  DomaineModel? _selectedDomaine;
  NiveauModel? _selectedNiveau;
  List<NiveauModel> _niveaux = [];
  List<MatiereModel> _matieres = [];

  bool _isLoadingNiveaux = false;
  bool _isLoadingMatieres = false;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDefaultDomaine();
  }

  /// Charge le premier domaine disponible au démarrage de l'écran,
  /// pour afficher quelque chose sans attendre une action de l'utilisateur.
  Future<void> _loadDefaultDomaine() async {
    try {
      final domaines = await _service.getDomaines();
      if (domaines.isNotEmpty) {
        await _selectDomaine(domaines.first);
      }
    } catch (e) {
      setState(() => _error = 'Impossible de charger les domaines');
    }
  }

  Future<void> _selectDomaine(DomaineModel domaine) async {
    setState(() {
      _selectedDomaine = domaine;
      _selectedNiveau = null;
      _niveaux = [];
      _matieres = [];
      _isLoadingNiveaux = true;
      _error = null;
    });
    try {
      final niveaux = await _service.getNiveaux(domaine.id);
      setState(() {
        _niveaux = niveaux;
        _isLoadingNiveaux = false;
      });
      if (niveaux.isNotEmpty) {
        await _selectNiveau(niveaux.first);
      }
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les niveaux';
        _isLoadingNiveaux = false;
      });
    }
  }

  Future<void> _selectNiveau(NiveauModel niveau) async {
    setState(() {
      _selectedNiveau = niveau;
      _matieres = [];
      _isLoadingMatieres = true;
      _error = null;
    });
    try {
      final matieres = await _service.getMatieres(niveau.id);
      setState(() {
        _matieres = matieres;
        _isLoadingMatieres = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les matières';
        _isLoadingMatieres = false;
      });
    }
  }

  List<MatiereModel> get _filteredMatieres {
    if (_searchQuery.isEmpty) return _matieres;
    final q = _searchQuery.toLowerCase();
    return _matieres
        .where((m) => m.nomMatiere.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _openFilter() async {
    final result = await showDomainFilterSheet(
      context,
      selected: _selectedDomaine,
    );
    if (result != null) {
      await _selectDomaine(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) => Column(
          children: [
            // ── Header ──────────────────────────────────────
            SafeArea(
              bottom: false,
              child: SectionHeader(
                title: 'Cours',
                onMenuTap: () => Scaffold.of(context).openDrawer(),
              ),
            ),

            // ── Recherche + filtre ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Recherche les cours',
                        hintStyle: const TextStyle(
                            color: Color(0xFF9E9E9E), fontSize: 14),
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xFF2E7D32)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF2E7D32), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF2E7D32), width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _openFilter,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.filter_list_rounded,
                          color: Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
            ),

            // Domaine sélectionné
            if (_selectedDomaine != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark, size: 16, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 6),
                    Text(
                      'Domaine : ${_selectedDomaine!.nomDomaine}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // ── Tags niveaux ───────────────────────────────────
            if (_isLoadingNiveaux)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFF2E7D32)),
                ),
              )
            else if (_niveaux.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _niveaux.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final niveau = _niveaux[index];
                    final isSelected = niveau.id == _selectedNiveau?.id;
                    return GestureDetector(
                      onTap: () => _selectNiveau(niveau),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8FBC94)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8FBC94)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          niveau.nomNiveau,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // ── Titre Matiere ────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Matiere',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Liste matières ───────────────────────────────
            Expanded(
              child: _buildMatieresList(),
            ),

            // ── Bottom nav ────────────────────────────────────
            const BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildMatieresList() {
    if (_isLoadingMatieres) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: Color(0xFF9E9E9E)),
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDefaultDomaine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_filteredMatieres.isEmpty) {
      return const Center(
        child: Text(
          'Aucune matière trouvée',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredMatieres.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final matiere = _filteredMatieres[index];
        return _MatiereTile(
          label: matiere.nomMatiere,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/matiere-detail',
              arguments: {
                'idMatiere': matiere.id,
                'nomMatiere': matiere.nomMatiere,
              },
            );
          },
        );
      },
    );
  }
}

class _MatiereTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MatiereTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: Color(0xFF555555), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9E9E9E)),
          ],
        ),
      ),
    );
  }
}