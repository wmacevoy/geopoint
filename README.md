# Geopoint
Accurate dart wgs84 geometery

# Reason
This package computes distances using an arclength approximation on the WGS-84 spheroid (modern gps standard) model for the earth.  Additionally, the (faster and simpler) mean-earth sphere model can be used for (good) approximate computations with max relative errors about 7×10<sup>-3</sup>.  The arc-length spheroid approximations are very good, with the following errors using to the GeoTest reference test data set

## WGS84 (ellipse) Relative Errors on Reference Data Set
| Ellipse Dist Rel Error | Double Lat/Lon Resolution Rel Error | Distance Range     | Tests    |
|-------:|------------:|:----------------------:|---------:|
| 8.1×10<sup>-6</sup> | 2.6×10<sup>-16</sup> | 10<sup>6</sup> m ≤ d < 10<sup>7</sup> m  | 111,352 |
| 6.7×10<sup>-6</sup> | 1.4×10<sup>-16</sup> | 10<sup>7</sup> m ≤ d < 10<sup>8</sup> m  | 333,132 |
| 3.5×10<sup>-9</sup> | 2.0×10<sup>-16</sup> | 10<sup>5</sup> m ≤ d < 10<sup>6</sup> m  | 5,069 |
| 3.3×10<sup>-13</sup> | 2.9×10<sup>-16</sup> | 10<sup>4</sup> m ≤ d < 10<sup>5</sup> m  | 401 |
| 1.4×10<sup>-10</sup> | 1.0×10<sup>-10</sup> | 10<sup>1</sup> m ≤ d < 10<sup>2</sup> m  | 3,785 |
| 2.0×10<sup>-11</sup> | 3.2×10<sup>-12</sup> | 10<sup>2</sup> m ≤ d < 10<sup>3</sup> m  | 38,447 |
| 2.4×10<sup>-12</sup> | 3.6×10<sup>-16</sup> | 10<sup>3</sup> m ≤ d < 10<sup>4</sup> m  | 7,417 |
| 1.6×10<sup>-9</sup> | 1.1×10<sup>-9</sup> | 10<sup>0</sup> m ≤ d < 10<sup>1</sup> m  | 354 |
| 3.1×10<sup>-9</sup> | 5.5×10<sup>-10</sup> | 10<sup>-1</sup> m ≤ d < 10<sup>0</sup> m  | 36 |
| 3.8×10<sup>-7</sup> | 1.3×10<sup>-6</sup> | 10<sup>-3</sup> m ≤ d < 10<sup>-2</sup> m  | 2 |
| 5.9×10<sup>-8</sup> | 3.4×10<sup>-8</sup> | 10<sup>-2</sup> m ≤ d < 10<sup>-1</sup> m  | 5 |
| 8.1×10<sup>-6</sup> | | 10<sup>-3</sup> m ≤ d < 10<sup>8</sup> m  | 500,000 |
# References

http://wiki.gis.com/wiki/index.php/Geodetic_system
https://geographiclib.sourceforge.io/C++/doc/classGeographicLib_1_1Geodesic.html
