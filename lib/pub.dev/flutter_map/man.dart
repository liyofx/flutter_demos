import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demos/pub.dev/flutter_map/utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/util.dart';

/// 1、多图层
/// 2、导航轨迹
/// 3、景点分类
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class ViewCate {
  final String name, type;

  late String icon;
  late Color color;

  ViewCate(this.type, this.name) {
    icon = "assets/images/$type-ico.png";
    color = type == "toilet"
        ? const Color(0xFF29b3fb)
        : type == "park"
            ? const Color(0xFF2f9cd5)
            : const Color(0xFFfc9153);
  }

  @override
  int get hashCode => type.hashCode;

  @override
  bool operator ==(other) {
    if (other is! ViewCate) {
      return false;
    }
    return other.type == type;
  }
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  Map<ViewCate, List<Marker>> markers = {ViewCate("viwescenic", "景点"): [], ViewCate("toilet", "洗手间"): [], ViewCate("museum", "博物馆"): [], ViewCate("hotel", "住宿"): [], ViewCate("park", "停车场"): [], ViewCate("food", "餐饮"): [], ViewCate("shop", "购物商店"): [], ViewCate("hospital", "医疗点"): [], ViewCate("visitorcenter", "游客中心"): [], ViewCate("exitin", "景区出入口"): [], ViewCate("busstop", "观光车站"): []};
  ViewCate? selectedKey;
  bool showScenicName = true;
  bool showDrawTile = true;

  String title = "设置";
  var drawerChildren = <Widget>[];

  Map<String, List<Polyline>> routes = {};
  String? currentRoute;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    loadTianEHu();
  }

  void loadTianEHu() async {
    var source = await rootBundle.loadString("assets/tianehu.json");
    var jsn = jsonDecode(source);
    setState(() {
      jsn['viwelist'].forEach((item) {
        var category = ViewCate(item['viwechildCate'], "");
        var marker = _buildMarker(category, item, false);
        markers[category]?.add(marker);
      });
      jsn["routelist"].forEach((item) {
        routes.putIfAbsent(item['routename'], () {
          List<LatLng> points = jsonDecode(item['points']).map((item) => LatLng(item[0], item[1])).toList().cast<LatLng>();
          return [
            Polyline(points: points, color: Colors.blue, strokeWidth: 4),
          ];
        });
      });
      selectedKey = markers.keys.toList()[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return Scaffold(
      endDrawer: Builder(
        builder: (context) => Drawer(
          child: Container(
            padding: EdgeInsets.only(top: padding.top + 10 + 10, left: 15, right: 15),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              ...(title == "设置"
                  ? [
                      InkWell(
                        onTap: () => setState(() {
                          showScenicName = !showScenicName;
                        }),
                        child: Container(
                          height: 44,
                          child: Row(
                            children: [
                              const Text(
                                "显示景点名称",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                showScenicName ? Icons.toggle_on_outlined : Icons.toggle_off_outlined,
                                color: showScenicName ? const Color(0xFF48c997) : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() {
                          showDrawTile = !showDrawTile;
                        }),
                        child: Container(
                          height: 44,
                          child: Row(
                            children: [
                              const Text(
                                "显示手绘地图",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Icon(
                                showDrawTile ? Icons.toggle_on_outlined : Icons.toggle_off_outlined,
                                color: showDrawTile ? const Color(0xFF48c997) : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() {}),
                        child: Container(
                          height: 44,
                          child: Row(
                            children: [
                              const Text(
                                "景点详情",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                  : List.generate(routes.length, (index) {
                      String name = routes.keys.toList()[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (currentRoute == name) {
                              currentRoute = null;
                            } else {
                              currentRoute = name;
                            }
                          });
                          Scaffold.of(context).closeEndDrawer();
                          var boundsCenter = _mapController.centerZoomFitBounds(LatLngBounds.fromPoints(routes[currentRoute]![0].points));
                          _animatedMapMove(zoom: boundsCenter.zoom, dest: boundsCenter.center);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(name == currentRoute ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                              const SizedBox(width: 10),
                              Text(name),
                            ],
                          ),
                        ),
                      );
                    })),
            ]),
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(enableMultiFingerGestureRace: true, center: LatLng(34.776537, 111.14342), zoom: 14, minZoom: 10, maxZoom: 17),
            nonRotatedChildren: [
              Stack(
                children: [
                  Positioned(
                      bottom: 10,
                      left: 10,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () => _animatedMapMove(zoom: _mapController.zoom + 1),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      color: Color(0xFF29b3fb),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () => _animatedMapMove(zoom: _mapController.zoom - 1),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Color(0xFF29b3fb),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            child: const Icon(
                              Icons.my_location_outlined,
                              color: Color(0xFF48c997),
                            ),
                          )
                        ],
                      )),
                  Positioned(
                      top: padding.top + 10 + 44 + 15,
                      right: 10,
                      bottom: 50,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                title = "设置";
                              });
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.settings,
                                color: Color(0xFF48c997),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                title = "游玩路线";
                              });
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.insights_outlined,
                                color: Color(0xFF48c997),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons.search_outlined,
                              size: 28,
                              color: Color(0xFF48c997),
                            ),
                          ),
                        ],
                      )),
                ],
              )
            ],
            children: [
              // 瓦片图层
              TileLayer(
                urlTemplate: "https://wprd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=256&scl=1&style=7&x={x}&y={y}&z={z}", //瓦片地图的URL
                subdomains: const ["1", "2", "3", "4"],
                retinaMode: true && MediaQuery.of(context).devicePixelRatio > 1.0,
              ),
              // 手绘地图
              if (showDrawTile)
                TileLayer(
                  urlTemplate: "https://map-fengye-tianehu.oss-cn-hangzhou.aliyuncs.com/tiles/{z}/{x}/{y}.png", //瓦片地图的URL
                  retinaMode: true && MediaQuery.of(context).devicePixelRatio > 1.0,
                  backgroundColor: Colors.transparent,
                  fallbackUrl: "https://map-fengye-tianehu.oss-cn-hangzhou.aliyuncs.com/tiles/13/6626/3251.png",
                ),
              if (currentRoute != null)
                PolylineLayer(
                  polylines: routes[currentRoute] ?? [],
                ),
              if (selectedKey != null)
                MarkerLayer(
                  markers: markers[selectedKey]!,
                ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: padding.top + 10, left: 10, right: 10),
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: markers.length,
                itemBuilder: (context, index) {
                  var item = markers.keys.toList()[index];
                  var isSelected = item == selectedKey;
                  var bounding = boundingTextSize(item.name, const TextStyle(fontSize: 14), maxWidth: 200);
                  return InkWell(
                    onTap: () => setState(() {
                      selectedKey = item;
                    }),
                    child: Container(
                      alignment: Alignment.center,
                      width: bounding.width + 10 * 2,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                          style: TextStyle(color: isSelected ? Colors.amber : Colors.black54, fontSize: isSelected ? 14 : 13),
                          child: Text(
                            item.name,
                            strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),
                          )),
                    ),
                  );
                }),
          ),
        ]),
      ),
    );
  }

  void _animatedMapMove({LatLng? dest, double? zoom, CustomPoint? offset}) {
    var destLocation = dest != null ? toOffset(dest, _mapController.zoom, offset) : null;
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(begin: _mapController.center.latitude, end: destLocation == null ? _mapController.center.latitude : destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.center.longitude, end: destLocation == null ? _mapController.center.longitude : destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: zoom ?? _mapController.zoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)), zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  Marker _buildMarker(ViewCate category, Map data, bool isSelected) {
    var position = data['position'].split(",");
    String name = data["viweName"];
    TextStyle style = const TextStyle(color: Color(0xFF555555), fontSize: 10);
    Size nameSize = boundingTextSize(name, style, maxWidth: 86);
    double iconWH = isSelected ? 60 : 20;
    double arrowDownWH = 10;
    var isAudio = data['audio'] == "1";
    var markerSize = Size((showScenicName && nameSize.width > iconWH ? nameSize.width : iconWH) + 5 * 2, iconWH + (isSelected ? arrowDownWH : 0) + (showScenicName ? nameSize.height : 0) + 20);
    return Marker(
        point: LatLng(double.parse(position[0]), double.parse(position[1])),
        width: markerSize.width,
        height: markerSize.height,
        builder: (context) {
          return InkWell(
            onTap: () {},
            child: Column(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: isSelected ? 5 : 0),
                          decoration: BoxDecoration(color: category.color, border: Border.all(color: Colors.white, width: isSelected ? 3 : 2), borderRadius: BorderRadius.circular(100)),
                          child: isSelected
                              ? Image.network(
                                  data["imgurl"],
                                  width: iconWH,
                                  height: iconWH,
                                )
                              : Image.asset(
                                  isAudio ? "assets/images/markeraudio-ico.png" : category.icon,
                                  width: iconWH,
                                  height: iconWH,
                                ),
                        ),
                        if (isSelected) Positioned(left: (iconWH - arrowDownWH) / 2 + 3, top: iconWH + arrowDownWH / 2, child: Image.asset("assets/images/arrow_down2.png"))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (showScenicName)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                        decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFffe884), Color(0xFFf2c600)]), borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          name,
                          style: style,
                          strutStyle: const StrutStyle(forceStrutHeight: true, height: 0.8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
