//功德等级列表
class MavRes {
  MavRes({
    //图标
    this.icon,
    //大图标
    this.bigIcon,
    //等级
    this.name,
    //	经验值
    this.requiredExp,
    //	升级累计需要天数
    this.requiredDays,
  });

  MavRes.fromJson(dynamic json) {
    icon = json['icon'];
    bigIcon = json['bigIcon'];
    name = json['name'];
    requiredExp = json['requiredExp'];
    requiredDays = json['requiredDays'];
  }
  String? icon;
  String? bigIcon;
  String? name;
  int? requiredExp;
  int? requiredDays;
MavRes copyWith({  String? icon,
  String? bigIcon,
  String? name,
  int? requiredExp,
  int? requiredDays,
}) => MavRes(  icon: icon ?? this.icon,
  bigIcon: bigIcon ?? this.bigIcon,
  name: name ?? this.name,
  requiredExp: requiredExp ?? this.requiredExp,
  requiredDays: requiredDays ?? this.requiredDays,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon'] = icon;
    map['bigIcon'] = bigIcon;
    map['name'] = name;
    map['requiredExp'] = requiredExp;
    map['requiredDays'] = requiredDays;
    return map;
  }

}