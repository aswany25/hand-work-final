class PostsWorker {
  String username;
  String phonenumber;
  String city;
  String postTitle;
  String postText;

  PostsWorker({
    required this.username,
    required this.phonenumber,
    required this.city,
    required this.postTitle,
    required this.postText,
  });

  factory PostsWorker.fromJson(Map<String, dynamic> json) {
    return PostsWorker(
      username: json['username'] as String,
      phonenumber: json['phonenumber'] as String,
      city: json['city'] as String,
      postTitle: json['posttitle'] as String,
      postText: json['posttext'] as String,
    );
  }
}