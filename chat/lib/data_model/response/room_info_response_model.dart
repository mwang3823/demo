class RoomInfoResponse {
  final String? room_id;
  final String? channel_id;
  final String? last_update;

  RoomInfoResponse({
    this.room_id,
    this.channel_id,
    this.last_update,
  });

  factory RoomInfoResponse.fromJson(Map<String, dynamic> json) {
    return RoomInfoResponse(
      room_id: json['room_id'] as String?,
      channel_id: json['channel_id'] as String?,
      last_update: json['last_update'] as String?,
    );
  }
}
