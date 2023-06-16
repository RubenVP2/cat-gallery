class Cat {

  final String id;
  final String url;
  final int width;
  final int height;

  const Cat({
    required this.id,
    required this.url,
    required this.width,
    required this.height
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height']
    );
  }

}