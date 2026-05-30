class WaslaItem {
  final int order;
  final String nasheedId;

  WaslaItem({required this.order, required this.nasheedId});

  factory WaslaItem.fromMap(Map<String, dynamic> map) {
    return WaslaItem(
      order: map['order'] ?? 0,
      nasheedId: map['nasheedId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'nasheedId': nasheedId,
    };
  }
}

class GeneralFireBaseList {
  final String? id;
  final String? name;
  final String? filePdf;
  final String? imageUrl;
  final String? textContent;
  final String? contentType;
  final List<String>? categories;
  final List<WaslaItem>? items; // NEW

  GeneralFireBaseList({
    this.id,
    this.name,
    this.filePdf,
    this.imageUrl,
    this.textContent,
    this.contentType,
    this.categories,
    this.items, // NEW
  });

  factory GeneralFireBaseList.fromMap(Map<String, dynamic> map) {
    return GeneralFireBaseList(
      id: map['id'],
      name: map['name'],
      filePdf: map['file_pdf'],
      imageUrl: map['image_url'],
      textContent: map['text_content'],
      contentType: map['content_type'],
      categories: map['categories'] != null
          ? List<String>.from(map['categories'])
          : null,
      // NEW:
      items: map['items'] != null
          ? (map['items'] as List)
          .map((i) => WaslaItem.fromMap(i as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      if (filePdf != null) 'file_pdf': filePdf,
      if (imageUrl != null) 'image_url': imageUrl,
      if (textContent != null) 'text_content': textContent,
      if (contentType != null) 'content_type': contentType,
      if (categories != null) 'categories': categories,
      if (items != null)
        'items': items!.map((i) => i.toMap()).toList(), // NEW
    };
  }
}