import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

LatLng toOffset(LatLng source, double zoom, CustomPoint? offset) {
  if (offset == null) return source;
  const crs = Epsg3857();
  final oldCenterPt = crs.latLngToPoint(source, zoom);
  final newCenterPt = oldCenterPt + offset;
  return crs.pointToLatLng(newCenterPt, zoom) ?? source;
}
