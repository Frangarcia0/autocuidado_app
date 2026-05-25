import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/recipes_provider.dart';
import '../../shared/models/recipe_model.dart';
import 'recipe_detail_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String _selectedCategory = 'todos';
  String _searchQuery = '';
  final Set<String> _favorites = {};
  final TextEditingController _searchController = TextEditingController();

  static const _categories = [
    ('todos', 'Todos'),
    ('desayuno', 'Desayunos'),
    ('almuerzo', 'Almuerzos'),
    ('cena', 'Cenas'),
    ('snack', 'Snacks'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecipeModel> _filtered(List<RecipeModel> all) {
    return all.where((r) {
      final matchCat =
          _selectedCategory == 'todos' || r.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          r.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipesProvider>();
    final recipes = provider.recipes;
    final filtered = _filtered(recipes);

    // Featured: primera receta de la lista completa
    final featured = recipes.isNotEmpty ? recipes.first : null;
    // Recommended: resto de las recetas filtradas (sin la featured si está visible)
    final recommended = filtered
        .where((r) => featured == null || r.id != featured.id)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: Column(
        children: [
          // ── AppBar personalizada ──────────────────────────────
          _RecipesAppBar(
            searchController: _searchController,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
          ),

          // ── Contenido scrollable ──────────────────────────────
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      // Chips de categoría
                      _CategoryChips(
                        selected: _selectedCategory,
                        onSelect: (cat) =>
                            setState(() => _selectedCategory = cat),
                        categories: _categories,
                      ),
                      const SizedBox(height: 20),

                      // Sección destacada (solo si no hay búsqueda activa)
                      if (_searchQuery.isEmpty && featured != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Destacados para ti',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3D3D3D),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(
                                    () => _selectedCategory = 'todos'),
                                child: const Text(
                                  'Ver más',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFA3B18A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _FeaturedCard(
                            recipe: featured,
                            onTap: () => _openDetail(featured),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Sección recomendadas
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? 'Resultados de búsqueda'
                              : 'Recetas recomendadas',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D3D3D),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (recommended.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No hay recetas para esta categoría',
                              style: TextStyle(
                                color: Color(0xFF7A7A7A),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        ...recommended.map(
                          (recipe) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: _RecipeCard(
                              recipe: recipe,
                              isFavorite: _favorites.contains(recipe.id),
                              onFavorite: () => setState(() {
                                _favorites.contains(recipe.id)
                                    ? _favorites.remove(recipe.id)
                                    : _favorites.add(recipe.id);
                              }),
                              onTap: () => _openDetail(recipe),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(RecipeModel recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
  }
}

// ── AppBar con buscador ───────────────────────────────────────

class _RecipesAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _RecipesAppBar({
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: const Color(0xFFA3B18A),
      padding: EdgeInsets.fromLTRB(20, top + 12, 20, 16),
      child: Column(
        children: [
          const Text(
            'Recetas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF3D3D3D)),
                    decoration: const InputDecoration(
                      hintText: 'Buscar recetas...',
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
                      prefixIcon: Icon(Icons.search,
                          color: Color(0xFF5E5A55), size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Color(0xFF5E5A55),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Chips de categoría ────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final List<(String, String)> categories;

  const _CategoryChips({
    required this.selected,
    required this.onSelect,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (value, label) = categories[i];
          final isSelected = selected == value;
          return GestureDetector(
            onTap: () => onSelect(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFA3B18A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA3B18A)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF5E5A55),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Tarjeta destacada ─────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const _FeaturedCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen de fondo
              _RecipeImage(
                imageName: recipe.image,
                fit: BoxFit.cover,
              ),

              // Overlay degradado
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Color(0xCC6B8F5E),
                    ],
                    stops: [0.35, 1.0],
                  ),
                ),
              ),

              // Texto sobre la imagen (derecha)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                width: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.prepTime} min',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.edit_outlined,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          recipe.difficulty,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe.tag,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tarjeta de receta ─────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 110,
                height: 100,
                child: _RecipeImage(
                  imageName: recipe.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 13, color: Color(0xFF7A7A7A)),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.prepTime} min',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF7A7A7A)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.edit_outlined,
                            size: 13, color: Color(0xFF7A7A7A)),
                        const SizedBox(width: 4),
                        Text(
                          recipe.difficulty,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF7A7A7A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Corazón
            GestureDetector(
              onTap: onFavorite,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 22,
                  color: isFavorite
                      ? const Color(0xFFE57373)
                      : const Color(0xFF7A7A7A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget de imagen con fallback ─────────────────────────────

class _RecipeImage extends StatelessWidget {
  final String imageName;
  final BoxFit fit;

  const _RecipeImage({required this.imageName, required this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/$imageName',
      fit: fit,
      errorBuilder: (_, _, _) => Container(
        color: const Color(0xFFE8EFE0),
        child: const Center(
          child: Icon(
            Icons.restaurant,
            size: 32,
            color: Color(0xFFA3B18A),
          ),
        ),
      ),
    );
  }
}
