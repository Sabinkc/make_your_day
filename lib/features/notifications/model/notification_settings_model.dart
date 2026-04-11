class NotificationSettings {
  bool notificationsEnabled;
  String userName;
  Map<String, ServiceSchedule> services;

  NotificationSettings({
    this.notificationsEnabled = false,
    this.userName = '',
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'userName': userName,
      'services': services.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      notificationsEnabled: json['notificationsEnabled'] ?? false,
      userName: json['userName'] ?? '',
      services: (json['services'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, ServiceSchedule.fromJson(value)),
      ),
    );
  }
}

class ServiceSchedule {
  bool enabled;
  List<String> times;
  String lastMessageId;

  ServiceSchedule({
    this.enabled = false,
    this.times = const [],
    this.lastMessageId = '',
  });

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'times': times, 'lastMessageId': lastMessageId};
  }

  factory ServiceSchedule.fromJson(Map<String, dynamic> json) {
    return ServiceSchedule(
      enabled: json['enabled'] ?? false,
      times: List<String>.from(json['times'] ?? []),
      lastMessageId: json['lastMessageId'] ?? '',
    );
  }
}
