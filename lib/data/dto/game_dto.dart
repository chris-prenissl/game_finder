class GameDto {
  final String title;
  final List<String> genres;
  final String? coverImgUrl;
  final List<String> screenShotUrls;

  GameDto(
      {required this.title,
      required this.genres,
      required this.coverImgUrl,
      required this.screenShotUrls});
}
