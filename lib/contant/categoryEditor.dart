import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/category.dart';
import '../model/generalFireBaseList.dart';
import 'nasheedList.dart';
///
// class CategoryEditor extends StatefulWidget {
//   final GeneralFireBaseList pdfFile;
//
//   const CategoryEditor({required this.pdfFile, Key? key}) : super(key: key);
//
//   @override
//   State<CategoryEditor> createState() => _CategoryEditorState();
// }

// class _CategoryEditorState extends State<CategoryEditor> {
//   final TextEditingController _controller = TextEditingController();
//   List<String> _selectedCategoryIds = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedCategoryIds = List<String>.from(widget.pdfFile.categories ?? []);
//   }
//
//   Future<void> _addCategory(String input) async {
//     final newName = input.trim().toLowerCase();
//     if (newName.isEmpty) return;
//
//     final firestore = FirebaseFirestore.instance;
//
//     // Check if category with the same name already exists
//     final existingQuery = await firestore
//         .collection("categories")
//         .where("name", isEqualTo: newName)
//         .limit(1)
//         .get();
//
//     late String categoryId;
//
//     if (existingQuery.docs.isNotEmpty) {
//       categoryId = existingQuery.docs.first.id;
//     } else {
//       final docRef = firestore.collection("categories").doc();
//       await docRef.set({
//         'id': docRef.id,
//         'name': newName,
//       });
//       categoryId = docRef.id;
//     }
//
//     if (_selectedCategoryIds.contains(categoryId)) return;
//
//     setState(() => _selectedCategoryIds.add(categoryId));
//
//     // Update the Nasheed document
//     await firestore
//         .collection('Nasheed')
//         .doc(widget.pdfFile.id)
//         .update({'categories': _selectedCategoryIds});
//   }
//
//   Future<void> _removeCategory(String categoryId) async {
//     setState(() => _selectedCategoryIds.remove(categoryId));
//     await FirebaseFirestore.instance
//         .collection('Nasheed')
//         .doc(widget.pdfFile.id)
//         .update({'categories': _selectedCategoryIds});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const CircularProgressIndicator();
//
//         final allCategories = snapshot.data!.docs
//             .map((doc) => Category.fromMap(doc.data()! as Map<String, dynamic>, doc.id))
//             .toList();
//
//         return Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Wrap(
//                 spacing: 6,
//                 children: _selectedCategoryIds.map((id) {
//                   final category = allCategories.firstWhere(
//                         (cat) => cat.id == id,
//                     orElse: () => Category(id: id, name: ''),
//                   );
//                   return Chip(
//                     label: Text(category.name),
//                     onDeleted: () => _removeCategory(id),
//                   );
//                 }).toList(),
//               ),
//               TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: 'ادخل او اختار تصنيف القصيدة',
//                 ),
//                 onSubmitted: (val) {
//                   _addCategory(val);
//                   _controller.clear();
//                 },
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 6,
//                 children: allCategories
//                     .where((cat) => !_selectedCategoryIds.contains(cat.id))
//                     .map((cat) => ActionChip(
//                   label: Text(cat.name),
//                   onPressed: () => _addCategory(cat.name),
//                 ))
//                     .toList(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
/// with search
// class CategoryEditor extends StatefulWidget {
//   final GeneralFireBaseList pdfFile;
//
//   const CategoryEditor({required this.pdfFile, Key? key}) : super(key: key);
//
//   @override
//   State<CategoryEditor> createState() => _CategoryEditorState();
// }
//
// class _CategoryEditorState extends State<CategoryEditor> {
//   final TextEditingController _controller = TextEditingController();
//   List<String> _selectedCategoryIds = [];
//   List<Category> _allCategories = [];
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedCategoryIds = List<String>.from(widget.pdfFile.categories ?? []);
//     _listenToCategories();
//   }
//
//   void _listenToCategories() {
//     FirebaseFirestore.instance
//         .collection('categories')
//         .snapshots()
//         .listen((snapshot) {
//       setState(() {
//         _allCategories = snapshot.docs
//             .map((doc) =>
//             Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//             .toList();
//       });
//     });
//   }
//
//   Future<void> _addCategory(String input) async {
//     final name = input.trim().toLowerCase();
//     if (name.isEmpty) return;
//
//     final firestore = FirebaseFirestore.instance;
//
//     // Check for existing category by name
//     final existing = _allCategories.firstWhere(
//           (cat) => cat.name.toLowerCase() == name,
//       orElse: () => Category(id: '', name: ''),
//     );
//
//     late String categoryId;
//
//     if (existing.id.isNotEmpty) {
//       categoryId = existing.id;
//     } else {
//       // Create new category
//       final docRef = firestore.collection("categories").doc();
//       final newCategory = Category(id: docRef.id, name: name);
//       await docRef.set(newCategory.toMap());
//       categoryId = docRef.id;
//     }
//
//     if (_selectedCategoryIds.contains(categoryId)) return;
//
//     setState(() => _selectedCategoryIds.add(categoryId));
//
//     await firestore
//         .collection('Nasheed')
//         .doc(widget.pdfFile.id)
//         .update({'categories': _selectedCategoryIds});
//
//     _controller.clear();
//     _searchQuery = '';
//   }
//
//   Future<void> _removeCategory(String categoryId) async {
//     setState(() => _selectedCategoryIds.remove(categoryId));
//     await FirebaseFirestore.instance
//         .collection('Nasheed')
//         .doc(widget.pdfFile.id)
//         .update({'categories': _selectedCategoryIds});
//   }
//
//   List<Category> get _filteredSuggestions {
//     if (_searchQuery.trim().isEmpty) {
//       return _allCategories
//           .where((cat) => !_selectedCategoryIds.contains(cat.id))
//           .toList();
//     }
//
//     final lowerQuery = _searchQuery.toLowerCase();
//
//     return _allCategories
//         .where((cat) =>
//     cat.name.toLowerCase().contains(lowerQuery) &&
//         !_selectedCategoryIds.contains(cat.id))
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Wrap(
//               spacing: 6,
//               children: _selectedCategoryIds.map((id) {
//                 final category = _allCategories.firstWhere(
//                       (cat) => cat.id == id,
//                   orElse: () => Category(id: id, name: 'Unknown'),
//                 );
//                 return GestureDetector(
//                   onLongPress: () => _removeCategory(id),
//                   child: Chip(
//                     label: Text(category.name),
//                     backgroundColor: Colors.blue.shade100,
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _controller,
//               decoration: const InputDecoration(
//                 hintText: 'ادخل او اختار تصنيف القصيدة',
//               ),
//               onChanged: (val) => setState(() => _searchQuery = val),
//               onSubmitted: (val) => _addCategory(val),
//             ),
//             const SizedBox(height: 10),
//             if (_filteredSuggestions.isNotEmpty)
//               Wrap(
//                 spacing: 6,
//                 children: _filteredSuggestions.map((cat) {
//                   return ActionChip(
//                     label: Text(cat.name),
//                     onPressed: () => _addCategory(cat.name),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///
class CategoryEditor extends StatefulWidget {
  final GeneralFireBaseList pdfFile;
  final BuildContext scaffoldContext;

  const CategoryEditor({required this.pdfFile,required this.scaffoldContext, Key? key}) : super(key: key);

  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  final TextEditingController _controller = TextEditingController();
  List<String> _selectedCategoryIds = [];
  List<Category> _allCategories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = List<String>.from(widget.pdfFile.categories ?? []);
    _listenToCategories();
  }

  void _listenToCategories() {
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _allCategories = snapshot.docs
            .map((doc) =>
            Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    });
  }

  Future<void> _addCategory(String input) async {
    final name = input.trim().toLowerCase();
    if (name.isEmpty) return;

    final firestore = FirebaseFirestore.instance;

    // Check for existing category by name
    final existing = _allCategories.firstWhere(
          (cat) => cat.name.toLowerCase() == name,
      orElse: () => Category(id: '', name: ''),
    );

    late String categoryId;

    if (existing.id.isNotEmpty) {
      categoryId = existing.id;
    } else {
      final docRef = firestore.collection("categories").doc();
      final newCategory = Category(id: docRef.id, name: name);
      await docRef.set(newCategory.toMap());
      categoryId = docRef.id;
      await docRef.update({'id': categoryId});
    }




    if (_selectedCategoryIds.contains(categoryId)) return;

    setState(() => _selectedCategoryIds.add(categoryId));

    await firestore
        .collection('Nasheed')
        .doc(widget.pdfFile.id)
        .update({'categories': _selectedCategoryIds});

    _controller.clear();
    _searchQuery = '';
  }

  Future<void> _removeCategoryFromFile(String categoryId) async {
    setState(() => _selectedCategoryIds.remove(categoryId));
    await FirebaseFirestore.instance
        .collection('Nasheed')
        .doc(widget.pdfFile.id)
        .update({'categories': _selectedCategoryIds});
  }

  Future<void> _deleteCategoryFromFirebase(String categoryId) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  List<Category> get _filteredSuggestions {
    if (_searchQuery.trim().isEmpty) {
      return _allCategories
          .where((cat) => !_selectedCategoryIds.contains(cat.id))
          .toList();
    }

    final lowerQuery = _searchQuery.toLowerCase();

    return _allCategories
        .where((cat) =>
    cat.name.toLowerCase().contains(lowerQuery) &&
        !_selectedCategoryIds.contains(cat.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                children: _selectedCategoryIds.map((id) {
                  final category = _allCategories.firstWhere(
                        (cat) => cat.id == id,
                    orElse: () => Category(id: id, name: 'Unknown'),
                  );
                  return Chip(
                    label: Text(category.name),
                    onDeleted: () => _removeCategoryFromFile(id),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'ادخل او اختار تصنيف القصيدة',
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
                onSubmitted: (val) => _addCategory(val),
              ),
              const SizedBox(height: 10),
              if (_filteredSuggestions.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: _filteredSuggestions.map((cat) {
                    return GestureDetector(
                      // onLongPress: () async {
                      //   final confirm = await showDialog<bool>(
                      //     context: context,
                      //     builder: (context) => Directionality(
                      //       textDirection: TextDirection.rtl,
                      //       child: AlertDialog(
                      //         title: const Text("حذف التصنيف"),
                      //         content: Text("هل تريد حذف التصنيف '${cat.name}' من قاعدة البيانات؟"),
                      //         actions: [
                      //           TextButton(
                      //             child: const Text("إلغاء"),
                      //             onPressed: () => Navigator.of(context).pop(false),
                      //           ),
                      //           TextButton(
                      //             child: const Text("حذف"),
                      //             onPressed: () => Navigator.of(context).pop(true),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      //
                      //   if (confirm == true) {
                      //     final firestore = FirebaseFirestore.instance;
                      //
                      //     // Check if category is used
                      //     final usageQuery = await firestore
                      //         .collection('Nasheed')
                      //         .where('categories', arrayContains: cat.id)
                      //         .get();
                      //
                      //     if (usageQuery.docs.isNotEmpty) {
                      //       // ✅ Remove the category from all linked files
                      //       final batch = firestore.batch();
                      //
                      //       for (var doc in usageQuery.docs) {
                      //         final List<dynamic> currentCategories = doc['categories'] ?? [];
                      //         final updatedCategories = List<String>.from(currentCategories)..remove(cat.id);
                      //         batch.update(doc.reference, {'categories': updatedCategories});
                      //       }
                      //
                      //       // ✅ Delete the category document itself
                      //       batch.delete(firestore.collection('categories').doc(cat.id));
                      //
                      //       await batch.commit();
                      //
                      //       // ✅ Close sheet & show snackbar
                      //       Navigator.of(context).pop();
                      //       Future.delayed(Duration(milliseconds: 100), () {
                      //         rootScaffoldMessengerKey.currentState?.showSnackBar(
                      //           SnackBar(content: Text("تم حذف التصنيف '${cat.name}' وإزالته من جميع الملفات.")),
                      //         );
                      //       });
                      //     } else {
                      //       // Not used → just delete it
                      //       await firestore.collection('categories').doc(cat.id).delete();
                      //
                      //       Navigator.of(context).pop();
                      //       Future.delayed(Duration(milliseconds: 100), () {
                      //         rootScaffoldMessengerKey.currentState?.showSnackBar(
                      //           SnackBar(content: Text("تم حذف التصنيف '${cat.name}'.")),
                      //         );
                      //       });
                      //     }
                      //   }
                      //
                      // },
                      child: ActionChip(
                        label: Text(cat.name),
                        onPressed: () => _addCategory(cat.name),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
