class Verse {
  final String text;
  final String bookName;  
  final String bookAbbrev;
  final int chapter;
  final int number;
  final String version;    

  Verse({
    required this.text,
    required this.bookName,
    required this.bookAbbrev,
    required this.chapter,
    required this.number,
    this.version = 'nvi',
  });

  factory Verse.fromJson(Map<String, dynamic> json, String version) {
    return Verse(
      text: json['text'],

      bookName: json['book'] != null ? json['book']['name'] : '',
      bookAbbrev: json['book'] != null ? json['book']['abbrev']['pt'] : '',
      chapter: json['chapter'],
      number: json['number'],
      version: version,
    );
  }
}