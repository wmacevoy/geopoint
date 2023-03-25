# Geopoint
Accurate dart wgs84 geometery

# Reason
This package computes distances using an arclength approximation on the WGS-84 spheroid (modern gps standard) model for the earth.  Additionally, the (faster and simpler) mean-earth sphere model can be used for (good) approximate computations with max relative errors about 7×10<sup>-3</sup>.  The arc-length spheroid approximations are very good, with the following errors using to the GeoTest reference test data set

## Sphere vs. Spheroidal (default) Relative Errors on Reference Data Set
| Sphere |  Spheroidal |   Distance Range     | Tests    |
|-------:|------------:|:----------------------:|---------:|
3.8×10<sup>-3</sup> | 1.5×10<sup>-3</sup>  | 10,000 km ≤ d < ∞ | 324,701
5.6×10<sup>-3</sup> | 6.9×10<sup>-6</sup> | 1,000 km ≤ d < 10,000 km | 119,455
|5.7×10<sup>-3</sup> | 4.3×10<sup>-9</sup> | 100 km ≤ d < 1,000 km | 5371
5.7×10<sup>-3</sup> | 3.8×10<sup>-13</sup> | 10 km ≤ d < 100 km | 425
5.6×10<sup>-3</sup> | 2.4×10<sup>-12</sup> | 1 km ≤ d < 10 km | 5125
5.7×10<sup>-3</sup> | 1.9×10<sup>-11</sup> | 100 m ≤ d < 1,000 m | 40,523
5.7×10<sup>-3</sup> | 1.5×10<sup>-10</sup> | 10 m ≤ d < 100 m | 3980
5.7×10<sup>-3</sup> | 3.1×10<sup>-9</sup>  | 1 m ≤ d < 10 m | 413
3.5×10<sup>-3</sup> | 6.0×10<sup>-8</sup>  | 1 m ≤ d < 10 cm | 5
3.1×10<sup>-3</sup> | 1.8×10<sup>-10</sup> | 1 cm ≤ d < 10 cm | 1
6.7×10<sup>-4</sup> | 3.9×10<sup>-7</sup> | 1 mm ≤ d < 1 cm | 1

# References

http://wiki.gis.com/wiki/index.php/Geodetic_system
https://geographiclib.sourceforge.io/C++/doc/classGeographicLib_1_1Geodesic.html
