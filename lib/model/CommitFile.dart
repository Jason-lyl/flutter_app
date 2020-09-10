import 'package:json_annotation/json_annotation.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'CommitFile.g.dart';

@JsonSerializable()
class CommitFile {
  String sha;
  @JsonKey(name: "filename")
  String fileName;
  String status;
  int additions;
  int deletions;
  int changes;
  @JsonKey(name: "blob_url")
  String blobUrl;
  @JsonKey(name: "raw_url")
  String rawUrl;
  @JsonKey(name: "contents_url")
  String contentsUrl;
  String patch;

  CommitFile(
    this.sha,
    this.fileName,
    this.status,
    this.additions,
    this.deletions,
    this.changes,
    this.blobUrl,
    this.rawUrl,
    this.contentsUrl,
    this.patch,
  );

  factory CommitFile.fromJson(Map<String, dynamic> json) =>
      _$CommitFileFromJson(json);

  Map<String, dynamic> toJson() => _$CommitFileToJson(this);
}
