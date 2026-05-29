class GeneralFireBaseList{
  String? name ;
  String? id ;
  String? filePdf ;
  List<String> categories; // <-- Add this field

  GeneralFireBaseList({this.id , this.filePdf , this.name ,     this.categories = const [],});
  factory GeneralFireBaseList.fromMap(Map<String, dynamic> data) {
    return GeneralFireBaseList(
      id: data['id'],
      name: data['name'],
      filePdf: data['filePdf'],
      categories: List<String>.from(data['categories'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePdf': filePdf,
      'categories': categories,
    };
  }
}