class AppConfigModel {
  AppConfigModel({
    this.serverTime,
    this.jumpLink,
    //	注销账号H5链接
    this.cancelAccountLink,
    this.tab,
    this.home,
    this.resources,
    this.scriptures,
    this.desc,
    this.payGiveMav,
    this.cdkCopyWriting,
  });

  AppConfigModel.fromJson(dynamic json) {
    serverTime = json['serverTime'];
    jumpLink = json['jumpLink'];
    cancelAccountLink = json['cancelAccountLink'];
    goldPrice = json['goldPrice'];
    minPayGold = json['minPayGold'];
    payGiveMav = json['payGiveMav'];
    payGoldRule = json['payGoldRule'];
    if (json['tab'] != null) {
      tab = [];
      json['tab'].forEach((v) {
        tab?.add(Tab.fromJson(v));
      });
    }
    if (json['logTypeIcon'] is List) {
      logTypeIcon = [];
      json['logTypeIcon'].forEach((v) {
        logTypeIcon?.add(LogTypeIcon.fromJson(v));
      });
    }
    if (json['home'] != null) {
      home = [];
      json['home'].forEach((v) {
        home?.add(Home.fromJson(v));
      });
    }
    if (json['resources'] != null) {
      resources = [];
      json['resources'].forEach((v) {
        resources?.add(v);
      });
    }
    if (json['scriptures'] is List) {
      scriptures = [];
      json['scriptures'].forEach((v) {
        scriptures?.add(v.toString());
      });
    }
    cdkCopyWriting = json['cdkCopyWriting'] != null ? CdkCopyWriting.fromJson(json['cdkCopyWriting']) : null;
    desc = json['desc'];
  }

  int? serverTime;
  String? jumpLink;
  String? cancelAccountLink;
  ///一个境修币兑换多少人民币（单价）
  num? goldPrice;
  ///最低充值境修币数量
  int? minPayGold;
  //每充值￥1，额外获得功德数
  int? payGiveMav;
  ///充值提示语
  String? payGoldRule;
  List<LogTypeIcon>? logTypeIcon;
  List<Tab>? tab;
  List<Home>? home;
  List<dynamic>? resources;
  String? desc;
  ///cdk信息
  CdkCopyWriting? cdkCopyWriting;
  ///佛经大全的头部文本
  List<String>? scriptures;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serverTime'] = serverTime;
    map['jumpLink'] = jumpLink;
    map['cancelAccountLink'] = cancelAccountLink;
    map['goldPrice'] = goldPrice;
    map['minPayGold'] = minPayGold;
    map['payGiveMav'] = payGiveMav;
    map['payGoldRule'] = payGoldRule;
    if (tab != null) {
      map['tab'] = tab?.map((v) => v.toJson()).toList();
    }
    if (home != null) {
      map['home'] = home?.map((v) => v.toJson()).toList();
    }
    if (resources != null) {
      map['resources'] = resources?.map((v) => v.toJson()).toList();
    }
    if (scriptures != null) {
      map['scriptures'] = scriptures;
    }
    map['desc'] = desc;
    if (cdkCopyWriting != null) {
      map['cdkCopyWriting'] = cdkCopyWriting?.toJson();
    }
    return map;
  }
}

class Home {
  Home({
    this.name,
    this.icon,
    this.selectIcon,
    this.background,
    this.h1,
    this.h2,
    //唯一ID，不可更改
    this.id,
  });

  Home.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
    selectIcon = json['selectIcon'];
    background = json['background'];
    h1 = json['h1'];
    h2 = json['h2'];
    id = json['id'];
  }

  String? name;
  String? icon;
  String? selectIcon;
  String? background;
  String? h1;
  String? h2;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['icon'] = icon;
    map['selectIcon'] = selectIcon;
    map['background'] = background;
    map['h1'] = h1;
    map['h2'] = h2;
    map['id'] = id;
    return map;
  }
}

class Tab {
  Tab({
    this.icon,
    this.selectIcon,
    this.text,
  });

  Tab.fromJson(dynamic json) {
    icon = json['icon'];
    selectIcon = json['selectIcon'];
    text = json['text'];
  }

  String? icon;
  String? selectIcon;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon'] = icon;
    map['selectIcon'] = selectIcon;
    map['text'] = text;
    return map;
  }
}

class LogTypeIcon {
  LogTypeIcon({
    required this.logType,
    required this.icon,
    required this.name,
  });

  factory LogTypeIcon.fromJson(dynamic json) => LogTypeIcon(
    logType: json['logType'] ?? 0,
    icon: json['icon'] ?? '',
    name: json['name'] ?? '',
  );

  final int logType;
  final String icon;
  final String name;
}

class CdkCopyWriting {
  CdkCopyWriting({
    this.title,
    this.address,});

  CdkCopyWriting.fromJson(dynamic json) {
    title = json['title'] != null ? json['title'].cast<String>() : [];
    if (json['address'] != null) {
      address = [];
      json['address'].forEach((v) {
        address?.add(Address.fromJson(v));
      });
    }
  }
  List<String>? title;
  List<Address>? address;
  CdkCopyWriting copyWith({  List<String>? title,
    List<Address>? address,
  }) => CdkCopyWriting(  title: title ?? this.title,
    address: address ?? this.address,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    if (address != null) {
      map['address'] = address?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Address {
  Address({
    this.name,
    this.number,});

  Address.fromJson(dynamic json) {
    name = json['name'];
    number = json['number'];
  }
  String? name;
  String? number;
  Address copyWith({  String? name,
    String? number,
  }) => Address(  name: name ?? this.name,
    number: number ?? this.number,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['number'] = number;
    return map;
  }

}