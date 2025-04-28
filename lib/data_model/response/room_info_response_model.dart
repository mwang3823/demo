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
      room_id: json['data']?['room_id'] as String?,
      channel_id: json['data']?['channel_id'] as String?,
      last_update: json['data']?['last_update'] as String?,
    );
  }
}

class RoomResponse {
  final int error;
  final RoomInfoResponse? data;

  RoomResponse({
    required this.error,
    this.data,
  });

  factory RoomResponse.fromJson(Map<String, dynamic> json) {
    return RoomResponse(
      error: json['error'] as int,
      data:
          json['data'] != null ? RoomInfoResponse.fromJson(json['data']) : null,
    );
  }
}
