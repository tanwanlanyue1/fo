
///礼物时效配置
class TimeConfigModel {
  TimeConfigModel({
    //时效ID
    this.id,
    //灯ID
    this.lanternId,
    //	时效（秒）
    this.periodTime,
    //费用
    this.goldNum,
    //默认时效选项 0：非默认 1：默认
    this.acquiesce,
    //+功德
    this.meritsVirtues,
    //+修行
    this.training,
    //总免费次数
    this.freeCount,
    //剩余免费次数
    this.surplusCount,
    //是否开放
    this.isOpen,
    //开放等级
    this.openLevel,
    //等级配置
    this.levelConfig,
    //开放等级名称
    this.openLevelName,
    // 开放功德等级图标
    this.openLevelIcon,
    //当前等级可用次数
    this.levelCount,
    //当前等级剩余次数
    this.levelSurplus,
    //次数刷新时间
    this.refreshTime,
  });

  TimeConfigModel.fromJson(dynamic json) {
    id = json['id'];
    lanternId = json['lanternId'];
    periodTime = json['periodTime'];
    goldNum = json['goldNum'];
    acquiesce = json['acquiesce'];
    meritsVirtues = json['meritsVirtues'];
    training = json['training'];
    freeCount = json['freeCount'];
    surplusCount = json['surplusCount'];
    isOpen = json['isOpen'];
    openLevel = json['openLevel'];
    levelConfig = json['levelConfig'];
    openLevelName = json['openLevelName'];
    openLevelIcon = json['openLevelIcon'];
    levelCount = json['levelCount'];
    levelSurplus = json['levelSurplus'];
    refreshTime = json['refreshTime'];
  }
  int? id;
  int? lanternId;
  int? periodTime;
  int? goldNum;
  int? acquiesce;
  int? meritsVirtues;
  int? training;
  int? freeCount;
  int? surplusCount;
  bool? isOpen;
  int? openLevel;
  String? levelConfig;
  String? openLevelName;
  String? openLevelIcon;
  int? levelCount;
  int? levelSurplus;
  int? refreshTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lanternId'] = lanternId;
    map['periodTime'] = periodTime;
    map['goldNum'] = goldNum;
    map['acquiesce'] = acquiesce;
    map['meritsVirtues'] = meritsVirtues;
    map['training'] = training;
    map['freeCount'] = freeCount;
    map['surplusCount'] = surplusCount;
    map['isOpen'] = isOpen;
    map['openLevel'] = openLevel;
    map['levelConfig'] = levelConfig;
    map['openLevelName'] = openLevelName;
    map['openLevelIcon'] = openLevelIcon;
    map['levelCount'] = levelCount;
    map['levelSurplus'] = levelSurplus;
    map['refreshTime'] = refreshTime;
    return map;
  }

}