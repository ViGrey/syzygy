-- Copyright (c) 2022, Vi Grey
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
--
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.

import Data.Fixed
import Data.Time.Clock.POSIX
import GHC.IO.Encoding
import System.Environment

-- (Appendix III Earth L0-L5) Astronomical Algorithms, 2nd Edition
--   p 418-420
-- Periodic terms for the ecliptical longitude of the Earth
periodicTermsEarthEclipticalLongitude =
  [[0, 175347046, 0, 0],
   [0, 3341656, 4.6692568, 6283.0758500],
   [0, 34894, 4.62610, 12566.15170],
   [0, 3497, 2.7441, 5753.3849],
   [0, 3418, 2.8289, 3.5231],
   [0, 3136, 3.6277, 77713.7715],
   [0, 2676, 4.4181, 7860.4194],
   [0, 2343, 6.1352, 3930.2097],
   [0, 1324, 0.7425, 11506.7698],
   [0, 1273, 2.0371, 529.6910],
   [0, 1199, 1.1096, 1577.3435],
   [0, 990, 5.233, 5884.927],
   [0, 902, 2.045, 26.298],
   [0, 857, 3.508, 398.149],
   [0, 780, 1.179, 5223.694],
   [0, 753, 2.533, 5507.553],
   [0, 505, 4.583, 18849.228],
   [0, 492, 4.205, 775.523],
   [0, 357, 2.920, 0.067],
   [0, 317, 5.849, 11790.629],
   [0, 284, 1.899, 796.298],
   [0, 271, 0.315, 10977.079],
   [0, 243, 0.345, 5486.778],
   [0, 206, 4.806, 2544.314],
   [0, 205, 1.869, 5573.143],
   [0, 202, 2.458, 6069.777],
   [0, 156, 0.833, 213.299],
   [0, 132, 3.411, 2942.463],
   [0, 126, 1.083, 20.775],
   [0, 115, 0.645, 0.980],
   [0, 103, 0.636, 4694.003],
   [0, 102, 0.976, 15720.839],
   [0, 102, 4.267, 7.114],
   [0, 99, 6.21, 2146.17],
   [0, 98, 0.68, 155.42],
   [0, 86, 5.98, 161000.69],
   [0, 85, 1.30, 6275.96],
   [0, 85, 3.67, 71430.70],
   [0, 80, 1.81, 17260.15],
   [0, 79, 3.04, 12036.46],
   [0, 75, 1.76, 5088.63],
   [0, 74, 3.50, 3154.69],
   [0, 74, 4.68, 801.82],
   [0, 70, 0.83, 9437.76],
   [0, 62, 3.98, 8827.39],
   [0, 61, 1.82, 7084.90],
   [0, 57, 2.78, 6286.60],
   [0, 56, 4.39, 14143.50],
   [0, 56, 3.47, 6279.55],
   [0, 52, 0.19, 12139.55],
   [0, 52, 1.33, 1748.02],
   [0, 51, 0.28, 5856.48],
   [0, 49, 0.49, 1194.45],
   [0, 41, 5.37, 8429.24],
   [0, 41, 2.40, 19651.05],
   [0, 39, 6.17, 10447.39],
   [0, 37, 6.04, 10213.29],
   [0, 37, 2.57, 1059.38],
   [0, 36, 1.71, 2352.87],
   [0, 36, 1.78, 6812.77],
   [0, 33, 0.59, 17789.85],
   [0, 30, 0.44, 83996.85],
   [0, 30, 2.74, 1349.87],
   [0, 25, 3.16, 4690.48],
   [1, 628331966747, 0, 0],
   [1, 206059, 2.678235, 6283.075850],
   [1, 4303, 2.6351, 12566.1517],
   [1, 425, 1.590, 3.523],
   [1, 119, 5.796, 26.298],
   [1, 109, 2.966, 1577.344],
   [1, 93, 2.59, 18849.23],
   [1, 72, 1.14, 529.69],
   [1, 68, 1.87, 398.15],
   [1, 67, 4.41, 5507.55],
   [1, 59, 2.89, 5223.69],
   [1, 56, 2.17, 155.42],
   [1, 45, 0.40, 796.30],
   [1, 36, 0.47, 775.52],
   [1, 29, 2.65, 7.11],
   [1, 21, 5.34, 0.98],
   [1, 19, 1.85, 5486.78],
   [1, 19, 4.97, 213.30],
   [1, 17, 2.99, 6275.96],
   [1, 16, 0.03, 2544.31],
   [1, 16, 1.43, 2146.17],
   [1, 15, 1.21, 10977.08],
   [1, 12, 2.83, 1748.02],
   [1, 12, 3.26, 5088.63],
   [1, 12, 5.27, 1194.45],
   [1, 12, 2.08, 4694.00],
   [1, 11, 0.77, 553.57],
   [1, 10, 1.30, 6286.60],
   [1, 10, 4.24, 1349.87],
   [1, 9, 2.70, 242.73],
   [1, 9, 5.64, 951.72],
   [1, 8, 5.30, 2352.87],
   [1, 6, 2.65, 9437.76],
   [1, 6, 4.67, 4690.48],
   [2, 52919, 0, 0],
   [2, 8720, 1.0721, 6283.0758],
   [2, 309, 0.867, 12566.152],
   [2, 27, 0.05, 3.52],
   [2, 16, 5.19, 26.30],
   [2, 16, 3.68, 155.42],
   [2, 10, 0.76, 18849.23],
   [2, 9, 2.06, 77713.77],
   [2, 7, 0.83, 775.52],
   [2, 5, 4.66, 1577.34],
   [2, 4, 1.03, 7.11],
   [2, 4, 3.44, 5573.14],
   [2, 3, 5.14, 796.30],
   [2, 3, 6.05, 5507.55],
   [2, 3, 1.19, 242.73],
   [2, 3, 6.12, 529.69],
   [2, 3, 0.31, 398.15],
   [2, 3, 2.28, 553.57],
   [2, 2, 4.38, 5223.69],
   [2, 2, 3.75, 0.98],
   [3, 289, 5.844, 6283.076],
   [3, 35, 0, 0],
   [3, 17, 5.49, 12566.15],
   [3, 3, 5.20, 155.42],
   [3, 1, 4.72, 3.52],
   [3, 1, 5.30, 18849.23],
   [3, 1, 5.97, 242.73],
   [4, 114, 3.142, 0],
   [4, 8, 4.13, 6283.08],
   [4, 1, 3.84, 12566.15],
   [5, 1, 3.14, 0]]

-- (Appendix III Earth B0-B1) Astronomical Algorithms, 2nd Edition
--   p 420
-- Periodic terms for the ecliptical latitude of the Earth
periodicTermsEarthEclipticalLatitude =
  [[0, 280, 3.199, 84334.662],
   [0, 102, 5.422, 5507.553],
   [0, 80, 3.88, 5223.69],
   [0, 44, 3.70, 2352.87],
   [0, 32, 4.00, 1577.34],
   [1, 9, 3.90, 5507.55],
   [1, 6, 1.73, 5223.69]]

-- (Appendix III Earth R0-R4) Astronomical Algorithms, 2nd Edition
--   p 420 & 421
-- Periodic terms for the radius vector of the Earth
periodicTermsEarthRadiusVector =
  [[0, 100013989, 0, 0],
   [0, 1670700, 3.0984635, 6283.0758500],
   [0, 13956, 3.05525, 12566.15170],
   [0, 3084, 5.1985, 77713.7715],
   [0, 1628, 1.1739, 5753.3849],
   [0, 1576, 2.8469, 7860.4194],
   [0, 925, 5.453, 11506.770],
   [0, 542, 4.564, 3930.210],
   [0, 472, 3.661, 5884.927],
   [0, 346, 0.964, 5507.553],
   [0, 329, 5.900, 5223.694],
   [0, 307, 0.299, 5573.143],
   [0, 243, 4.273, 11790.629],
   [0, 212, 5.847, 1577.344],
   [0, 186, 5.022, 10977.079],
   [0, 175, 3.012, 18849.228],
   [0, 110, 5.055, 5486.778],
   [0, 98, 0.89, 6069.78],
   [0, 86, 5.69, 15720.84],
   [0, 86, 1.27, 161000.69],
   [0, 65, 0.27, 17260.15],
   [0, 63, 0.92, 529.69],
   [0, 57, 2.01, 83996.85],
   [0, 56, 5.24, 71430.70],
   [0, 49, 3.25, 2544.31],
   [0, 47, 2.58, 775.52],
   [0, 45, 5.54, 9437.76],
   [0, 43, 6.01, 6275.96],
   [0, 39, 5.36, 4694.00],
   [0, 38, 2.39, 8827.39],
   [0, 37, 0.83, 19651.05],
   [0, 37, 4.90, 12139.55],
   [0, 36, 1.67, 12036.46],
   [0, 35, 1.84, 2942.46],
   [0, 33, 0.24, 7084.90],
   [0, 32, 0.18, 5088.63],
   [0, 32, 1.78, 398.15],
   [0, 28, 1.21, 6286.60],
   [0, 28, 1.90, 6279.55],
   [0, 26, 4.59, 10447.39],
   [1, 103079, 1.107490, 6283.075850],
   [1, 1721, 1.0644, 12566.1517],
   [1, 702, 3.142, 0],
   [1, 32, 1.02, 18849.23],
   [1, 31, 2.84, 5507.55],
   [1, 25, 1.32, 5223.69],
   [1, 18, 1.42, 1577.34],
   [1, 10, 5.91, 10977.08],
   [1, 9, 1.42, 6275.96],
   [1, 9, 0.27, 5486.78],
   [2, 4359, 5.7846, 6283.0758],
   [2, 124, 5.579, 12566.152],
   [2, 12, 3.14, 0],
   [2, 9, 3.63, 77713.77],
   [2, 6, 1.87, 5573.14],
   [2, 3, 5.47, 18849.23],
   [3, 145, 4.273, 6283.076],
   [3, 7, 3.92, 12566.15],
   [4, 4, 2.56, 6283.08]]

-- Astronomical Algorithms, 2nd Edition p 168
-- Daily variation, in arcseconds, for longitude of the Sun
variationOfSunLongitude =
  [[118.568, 0, 87.5287, 359993.7286],
   [2.476, 0, 85.0561, 719987.4571],
   [1.376, 0, 27.8502, 4452671.1152],
   [0.119, 0, 73.1375, 450368.8564],
   [0.114, 0, 337.2264, 329644.6718],
   [0.086, 0, 222.5400, 659289.3436],
   [0.078, 0, 162.8136, 9224659.7915],
   [0.054, 0, 82.5823, 1079981.1857],
   [0.052, 0, 171.5189, 225184.4282],
   [0.034, 0, 30.3214, 4092677.3866],
   [0.033, 0, 119.8105, 337181.4711],
   [0.023, 0, 247.5418, 299295.6151],
   [0.023, 0, 325.1526, 315559.5560],
   [0.021, 0, 155.1241, 675553.2846],
   [7.311, 1, 333.4515, 359993.7286],
   [0.305, 1, 330.9814, 719987.4571],
   [0.010, 1, 328.5170, 1079981.1857],
   [0.309, 2, 241.4518, 359993.7286],
   [0.021, 2, 205.0482, 719987.4571],
   [0.004, 2, 297.8610, 4452671.1152],
   [0.010, 3, 154.7066, 359993.7286]]



-- (47.A) Astronomical Algorithms, 2nd Edition p 339
-- Periodic terms for the longitude and distance of the Moon
periodicTermsMoonLongitudeAndDistance =
  [[[0, 0, 1, 0], [6288774], [(-20905355)]],
  [[2, 0, (-1), 0], [1274027], [(-3699111)]],
  [[2, 0, 0, 0], [658314], [(-2955968)]],
  [[0, 0, 2, 0], [213618], [(-569925)]],
  [[0, 1, 0, 0], [(-185116)], [48888]],
  [[0, 0, 0, 2], [(-114332)], [(-3149)]],
  [[2, 0, (-2), 0], [58793], [246158]],
  [[2, (-1), (-1), 0], [57066], [(-152138)]],
  [[2, 0, 1, 0], [53322], [(-170733)]],
  [[2, (-1), 0, 0], [45758], [(-204586)]],
  [[0, 1, (-1), 0], [(-40923)], [(-129620)]],
  [[1, 0, 0, 0], [(-34720)], [108743]],
  [[0, 1, 1, 0], [(-30383)], [104755]],
  [[2, 0, 0, (-2)], [15327], [10321]],
  [[0, 0, 1, 2], [(-12528)], [0]],
  [[0, 0, 1, (-2)], [10980], [79661]],
  [[4, 0, (-1), 0], [10675], [(-34782)]],
  [[0, 0, 3, 0], [10034], [(-23210)]],
  [[4, 0, (-2), 0], [8548], [(-21636)]],
  [[2, 1, (-1), 0], [(-7888)], [24208]],
  [[2, 1, 0, 0], [(-6766)], [30824]],
  [[1, 0, (-1), 0], [(-5163)], [(-8379)]],
  [[1, 1, 0, 0], [4987], [(-16675)]],
  [[2, (-1), 1, 0], [4036], [(-12831)]],
  [[2, 0, 2, 0], [3994], [(-10445)]],
  [[4, 0, 0, 0], [3861], [(-11650)]],
  [[2, 0, (-3), 0], [3665], [14403]],
  [[0, 1, (-2), 0], [(-2689)], [(-7003)]],
  [[2, 0, (-1), 2], [(-2602)], [0]],
  [[2, (-1), (-2), 0], [2390], [10056]],
  [[1, 0, 1, 0], [(-2348)], [6322]],
  [[2, (-2), 0, 0], [2236], [(-9884)]],
  [[0, 1, 2, 0], [(-2120)], [5751]],
  [[0, 2, 0, 0], [(-2069)], [0]],
  [[2, (-2), (-1), 0], [2048], [(-4950)]],
  [[2, 0, 1, (-2)], [(-1773)], [4130]],
  [[2, 0, 0, 2], [(-1595)], [0]],
  [[4, (-1), (-1), 0], [1215], [(-3958)]],
  [[0, 0, 2, 2], [(-1110)], [0]],
  [[3, 0, (-1), 0], [(-892)], [3258]],
  [[2, 1, 1, 0], [(-810)], [2616]],
  [[4, (-1), (-2), 0], [759], [(-1897)]],
  [[0, 2, (-1), 0], [(-713)], [(-2117)]],
  [[2, 2, (-1), 0], [(-700)], [2354]],
  [[2, 1, (-2), 0], [691], [0]],
  [[2, (-1), 0, (-2)], [596], [0]],
  [[4, 0, 1, 0], [549], [(-1423)]],
  [[0, 0, 4, 0], [537], [(-1117)]],
  [[4, (-1), 0, 0], [520], [(-1571)]],
  [[1, 0, (-2), 0], [(-487)], [(-1739)]],
  [[2, 1, 0, (-2)], [(-399)], [0]],
  [[0, 0, 2, (-2)], [(-381)], [(-4421)]],
  [[1, 1, 1, 0], [351], [0]],
  [[3, 0, (-2), 0], [(-340)], [0]],
  [[4, 0, (-3), 0], [330], [0]],
  [[2, (-1), 2, 0], [327], [0]],
  [[0, 2, 1, 0], [(-323)], [1165]],
  [[1, 1, (-1), 0], [299], [0]],
  [[2, 0, 3, 0], [294], [0]],
  [[2, 0, (-1), (-2)], [0], [8752]]]

-- (47.A) Astronomical Algorithms, 2nd Edition p 341
-- Periodic terms for the latitude of the Moon
periodicTermsMoonLatitude =
  [[[0, 0, 0, 1], [5128122]],
  [[0, 0, 1, 1], [280602]],
  [[0, 0, 1, (-1)], [277693]],
  [[2, 0, 0, (-1)], [173237]],
  [[2, 0, (-1), 1], [55413]],
  [[2, 0, (-1), (-1)], [46271]],
  [[2, 0, 0, 1], [32573]],
  [[0, 0, 2, 1], [17198]],
  [[2, 0, 1, (-1)], [9266]],
  [[0, 0, 2, (-1)], [8822]],
  [[2, (-1), 0, (-1)], [8216]],
  [[2, 0, (-2), (-1)], [4324]],
  [[2, 0, 1, 1], [4200]],
  [[2, 1, 0, (-1)], [(-3359)]],
  [[2, (-1), (-1), 1], [2463]],
  [[2, (-1), 0, 1], [2211]],
  [[2, (-1), (-1), (-1)], [2065]],
  [[0, 1, (-1), (-1)], [(-1870)]],
  [[4, 0, (-1), (-1)], [1828]],
  [[0, 1, 0, 1], [(-1794)]],
  [[0, 0, 0, 3], [(-1749)]],
  [[0, 1, (-1), 1], [(-1565)]],
  [[1, 0, 0, 1], [(-1491)]],
  [[0, 1, 1, 1], [(-1475)]],
  [[0, 1, 1, (-1)], [(-1410)]],
  [[0, 1, 0, (-1)], [(-1344)]],
  [[1, 0, 0, (-1)], [(-1335)]],
  [[0, 0, 3, 1], [1107]],
  [[4, 0, 0, (-1)], [1021]],
  [[4, 0, (-1), 1], [833]],
  [[0, 0, 1, (-3)], [777]],
  [[4, 0, (-2), 1], [671]],
  [[2, 0, 0, (-3)], [607]],
  [[2, 0, 2, (-1)], [596]],
  [[2, (-1), 1, (-1)], [491]],
  [[2, 0, (-2), 1], [(-451)]],
  [[0, 0, 3, (-1)], [439]],
  [[2, 0, 2, 1], [422]],
  [[2, 0, (-3), (-1)], [421]],
  [[2, 1, (-1), 1], [(-366)]],
  [[2, 1, 0, 1], [(-351)]],
  [[4, 0, 0, 1], [331]],
  [[2, (-1), 1, 1], [315]],
  [[2, (-2), 0, (-1)], [302]],
  [[0, 0, 1, 3], [(-283)]],
  [[2, 1, 1, (-1)], [(-229)]],
  [[1, 1, 0, (-1)], [223]],
  [[1, 1, 0, 1], [223]],
  [[0, 1, (-2), (-1)], [(-220)]],
  [[2, 1, (-1), (-1)], [(-220)]],
  [[1, 0, 1, 1], [(-185)]],
  [[2, (-1), (-2), (-1)], [181]],
  [[0, 1, 2, 1], [(-177)]],
  [[4, 0, (-2), (-1)], [176]],
  [[4, (-1), (-1), (-1)], [166]],
  [[1, 0, 1, (-1)], [(-164)]],
  [[4, 0, 1, (-1)], [132]],
  [[1, 0, (-1), (-1)], [(-119)]],
  [[4, (-1), 0, (-1)], [115]],
  [[2, (-2), 0, 1], [107]]]

-- (22.A) Astronomical Algorithms, 2nd Edition p 145
-- Periodic terms for the nutation in longitude and in obliquity
periodicTermsNutationLongitudeAndObliquity =
  [[[0, 0, 0, 0, 1], [(-171996), (-174.2)], [92025, 8.9]],
  [[(-2), 0, 0, 2, 2], [(-13187), (-1.6)], [5736, (-3.1)]],
  [[0, 0, 0, 2, 2], [(-2274), (-0.2)], [977, (-0.5)]],
  [[0, 0, 0, 0, 2], [2062, 0.2], [(-895), 0.5]],
  [[0, 1, 0, 0, 0], [1426, (-3.4)], [54, (-0.1)]],
  [[0, 0, 1, 0, 0], [712, 0.1], [(-7), 0]],
  [[(-2), 1, 0, 2, 2], [(-517), 1.2], [224, (-0.6)]],
  [[0, 0, 0, 2, 1], [(-386), (-0.4)], [200, 0]],
  [[0, 0, 1, 2, 2], [(-301), 0], [129, (-0.1)]],
  [[(-2), (-1), 0, 2, 2], [217, (-0.5)], [(-95), 0.3]],
  [[(-2), 0, 1, 0, 0], [(-158), 0], [0, 0]],
  [[(-2), 0, 0, 2, 1], [129, 0.1], [(-70), 0]],
  [[0, 0, (-1), 2, 2], [123, 0], [(-53), 0]],
  [[2, 0, 0, 0, 0], [63, 0], [0, 0]],
  [[0, 0, 1, 0, 1], [63, 0.1], [(-33), 0]],
  [[2, 0, (-1), 2, 2], [(-59), 0], [26, 0]],
  [[0, 0, (-1), 0, 1], [(-58), (-0.1)], [32, 0]],
  [[0, 0, 1, 2, 1], [(-51), 0], [27, 0]],
  [[(-2), 0, 2, 0, 0], [48, 0], [0, 0]],
  [[0, 0, (-2), 2, 1], [46, 0], [(-24), 0]],
  [[2, 0, 0, 2, 2], [(-38), 0], [16, 0]],
  [[0, 0, 2, 2, 2], [(-31), 0], [13, 0]],
  [[0, 0, 2, 0, 0], [29, 0], [0, 0]],
  [[(-2), 0, 1, 2, 2], [29, 0], [(-12), 0]],
  [[0, 0, 0, 2, 0], [26, 0], [0, 0]],
  [[(-2), 0, 0, 2, 0], [(-22), 0], [0, 0]],
  [[0, 0, (-1), 2, 1], [21, 0], [(-10), 0]],
  [[0, 2, 0, 0, 0], [17, (-0.1)], [0, 0]],
  [[2, 0, (-1), 0, 1], [16, 0], [(-8), 0]],
  [[(-2), 2, 0, 2, 2], [(-16), 0.1], [7, 0]],
  [[0, 1, 0, 0, 1], [(-15), 0], [9, 0]],
  [[(-2), 0, 1, 0, 1], [(-13), 0], [7, 0]],
  [[0, (-1), 0, 0, 1], [(-12), 0], [6, 0]],
  [[0, 0, 2, (-2), 0], [11, 0], [0, 0]],
  [[2, 0, (-1), 2, 1], [(-10), 0], [5, 0]],
  [[2, 0, 1, 2, 2], [(-8), 0], [3, 0]],
  [[0, 1, 0, 2, 2], [7, 0], [(-3), 0]],
  [[(-2), 1, 1, 0, 0], [(-7), 0], [0, 0]],
  [[0, (-1), 0, 2, 2], [(-7), 0], [3, 0]],
  [[2, 0, 0, 2, 1], [(-7), 0], [3, 0]],
  [[2, 0, 1, 0, 0], [6, 0], [0, 0]],
  [[(-2), 0, 2, 2, 2], [6, 0], [(-3), 0]],
  [[(-2), 0, 1, 2, 1], [6, 0], [(-3), 0]],
  [[2, 0, (-2), 0, 1], [(-6), 0], [3, 0]],
  [[2, 0, 0, 0, 1], [(-6), 0], [3, 0]],
  [[0, (-1), 1, 0, 0], [5, 0], [0, 0]],
  [[(-2), (-1), 0, 2, 1], [(-5), 0], [3, 0]],
  [[(-2), 0, 0, 0, 1], [(-5), 0], [3, 0]],
  [[0, 0, 2, 2, 1], [(-5), 0], [3, 0]],
  [[(-2), 0, 2, 0, 1], [4, 0], [0, 0]],
  [[(-2), 1, 0, 2, 1], [4, 0], [0, 0]],
  [[0, 0, 1, (-2), 0], [4, 0], [0, 0]],
  [[(-1), 0, 1, 0, 0], [(-4), 0], [0, 0]],
  [[(-2), 1, 0, 0, 0], [(-4), 0], [0, 0]],
  [[1, 0, 0, 0, 0], [(-4), 0], [0, 0]],
  [[0, 0, 1, 2, 0], [3, 0], [0, 0]],
  [[0, 0, (-2), 2, 2], [(-3), 0], [0, 0]],
  [[(-1), (-1), 1, 0, 0], [(-3), 0], [0, 0]],
  [[0, 1, 1, 0, 0], [(-3), 0], [0, 0]],
  [[0, (-1), 1, 2, 2], [(-3), 0], [0, 0]],
  [[2, (-1), (-1), 2, 2], [(-3), 0], [0, 0]],
  [[0, 0, 3, 2, 2], [(-3), 0], [0, 0]],
  [[2, (-1), 0, 2, 2], [(-3), 0], [0, 0]]]

-- (47.1) Astronomical Algorithms, 2nd Edition p 338
-- Moon Mean Longitude
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonMeanLongitude :: Double -> Double
moonMeanLongitude t =
  218.3164477 + t * 481267.88123421 - t**2 * 0.0015786
  + t**3 / 538841 - t**4 / 6519400

-- (47.2) Astronomical Algorithms, 2nd Edition p 338
-- Moon Mean Elongation
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonMeanElongation :: Double -> Double
moonMeanElongation t =
  297.8501921 + t * 445267.1114034 - t**2 * 0.0018819
  + t**3 / 545868 - t**4 / 113065000

-- (47.4) Astronomical Algorithms, 2nd Edition p 338
-- Moon Mean Anomaly
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonMeanAnomaly :: Double -> Double
moonMeanAnomaly t =
  134.9633964 + t * 477198.8675055 + t**2 * 0.0087414
  + t**3 / 69699 - t**4 / 14712000

-- (47.5) Astronomical Algorithms, 2nd Edition p 338
-- Moon Argument of Latitude (mean distance of moon from ascending node)
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonArgumentOfLatitude :: Double -> Double
moonArgumentOfLatitude t =
  93.2720950 + t * 483202.0175233 - t**2 * 0.0036539
  - t**3 / 3526000 + t**4 / 863310000

-- Astronomical Algorithms, 2nd Edition p 338
-- Moon Correction Term A1 (due to action of Venus)
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonA1 :: Double -> Double
moonA1 t = 119.75 + t * 131.849

-- Astronomical Algorithms, 2nd Edition p 338
-- Moon Correction Term A2 (due to action of Jupiter)
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonA2 :: Double -> Double
moonA2 t = 53.09 + t * 479264.29

-- Astronomical Algorithms, 2nd Edition p 338
-- Moon Correction Term A3 (due to flattening of Earth)
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonA3 :: Double -> Double
moonA3 t = 313.45 + t * 481266.484

-- (47.6) Astronomical Algorithms, 2nd Edition p 338
-- Earth Eccentricity for Moon Calculations
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
earthEccentricityForMoon :: Double -> Double
earthEccentricityForMoon t = 1 - t * 0.002516 - t**2 * 0.0000074

-- (47.7) Astronomical Algorithms, 2nd Edition p 338
-- Moon Longitude of Ascending Node
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
moonLongitudeOfAscendingNode :: Double -> Double
moonLongitudeOfAscendingNode t =
  125.04452 - t * 1934.136261 + t**2 * 0.0020708
  + t**3 / 450000



-- Convert degrees, arc minutes, and arc seconds into decimal degrees
-- degs is degrees
-- mins is arcminutes
-- secs is arcseconds
arcDegToDecDeg :: Integer -> Integer -> Double -> Double
arcDegToDecDeg degs mins secs =
  fromIntegral degs + fromIntegral mins / 60 + secs / 3600

-- 2451545.0 is Noon of Jan 1, 2000 12:00:00 UTC (Noon)
-- 946728000 is the Unix Timestamp of Jan 1, 2000 12:00:00 UTC (Noon)
-- unixTime is the Unix Timestamp of a particular datetime
jdeOfUnixTimestamp :: Double -> Double
jdeOfUnixTimestamp unixTime = (unixTime - 946728000) / 86400 + j2000

-- (7.1) Astronomical Algorithms, 2nd Edition p 61
-- Julian Ephemeris Day from Gregorian Date
jdeOfGregorianDate :: Integer -> Integer -> Double -> Double
jdeOfGregorianDate yr mon day  = 
  fromIntegral (floor (fromIntegral (y + 4716) * 365.25))
  + fromIntegral (floor (fromIntegral (m + 1) * 30.6))
  + day + b - 1524.5
      where y
              | mon > 2 = yr
              | otherwise = yr - 1
            m
              | mon > 2 = mon
              | otherwise = mon + 12
            b = fromIntegral (2 - a + div a 4)
              where a = div y 100

-- Astronomical Almanac 1992, p B6
-- GMST from Julian Date
jdeToGMST :: Double -> Double
jdeToGMST jde = 2 * pi * gmst / 86400
  where
    ut = (jde + 0.5 - fromIntegral (floor (jde + 0.5)))
    jday = jde - ut
    tu = (jday - 2451545.0) / 36525
    gmst = mod' ((24110.54841 + 8640184.812866 * tu + 0.093104 * tu**2 - 0.0000062 * tu**3) + 86400 * 1.00273790934 * ut) 86400
    

geodeticToGeocentricLat :: Double -> Double
geodeticToGeocentricLat lat = atan (tan lat * (1 - f)**2)
  where
    a = 6378.137
    b = 6356.75231424518
    f = (a - b) / a

geocentricToGeodeticLat :: Double -> Double
geocentricToGeodeticLat lat = atan (tan lat * (1 / (1 - f)**2))
  where
    a = 6378.137
    b = 6356.75231424518
    f = (a - b) / a

-- Get fraction of day from hour, minute, and second
dayFraction :: Integer -> Integer -> Integer -> Double
dayFraction hr min sec =
  fromIntegral hr / 24 + fromIntegral min / 1440
  + fromIntegral sec / 86400

-- Epoch J2000
-- Julian Ephemeris Day of January 1, 2000 12:00:00 UTC (Noon)
j2000 :: Double
j2000 = jdeOfGregorianDate 2000 1 (1 + dayFraction 12 0 0)

degreesToRadians :: Double -> Double
degreesToRadians d = mod' (pi / 180 * d) (2 * pi)

radiansToDegrees :: Double -> Double
radiansToDegrees r
  | d > 180 = (-360) + d
  | otherwise = d
  where
    d = mod' (180 / pi * r) 360


-- (22.3) Astronomical Algorithms, 2nd Edition p 147
-- Earth Mean Obliquity Of Ecliptic
-- u is time measured in units of 10000 Julian years from J2000.0
obliquityOfEcliptic :: Double -> Double
obliquityOfEcliptic u =
  arcDegToDecDeg 23 26 21.448
  - arcDegToDecDeg 0 0 1.55 * u**2
  + arcDegToDecDeg 0 0 1999.25 * u**3
  - arcDegToDecDeg 0 0 51.38 * u**4
  - arcDegToDecDeg 0 0 249.67 * u**5
  - arcDegToDecDeg 0 0 39.05 * u**6
  + arcDegToDecDeg 0 0 7.12 * u**7
  + arcDegToDecDeg 0 0 27.87 * u**8
  + arcDegToDecDeg 0 0 5.79 * u**9
  + arcDegToDecDeg 0 0 2.45 * u**10


-- (28.2) Astronomical Algorithms, 2nd Edition p 183
-- Sun Mean Longitude
sunMeanLongitude :: Double -> Double
sunMeanLongitude t =
  280.466567 + t*36000.76982779 + t**2*0.0003032028 +
    t**3/49.931 - t**4/1.53 - t**5/20

-- (47.3) Astronomical Algorithms, 2nd Edition p 338
-- Sun Mean Anomaly
sunMeanAnomaly :: Double -> Double
sunMeanAnomaly t =
  357.5291092 + t*35999.0502909 - t**2*0.0001536 +
    t**3/24490000


-- Astronomical Algorithms, 2nd Edition p 338 & 342
-- Moon Longitude and Distance
-- d is the mean elongation of the Moon from the sun
-- m is the mean anomaly of the Sun (Earth)
-- mp is the mean anomaly of the Moon
-- f is the argument of latitude of the Moon
-- lp is the mean longitude of the Moon
-- e is the eccentricity of the Earth for Moon calcutations
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
-- a is the list of periodic terms for the nutation in
--   longitude and in obliquity
moonLongitudeAndDistance :: Double -> Double -> Double -> Double -> Double -> Double -> Double -> [[[Double]]] -> Double -> Double -> (Double, Double)
moonLongitudeAndDistance d m mp f lp e t a lon dist
  | null a = (0.000001 * (lon
               + 3958 * sin (degreesToRadians (moonA1 t))
               + 1962 * sin (degreesToRadians (lp - f))
               + 318 * sin (degreesToRadians (moonA2 t))), 
              0.001 * dist)
  | otherwise =
        moonLongitudeAndDistance d m mp f lp e t (tail a) lonNew distNew
  where
    arg = degreesToRadians ((head a !! 0 !! 0 * d)
                            + (head a !! 0 !! 1 * m)
                            + (head a !! 0 !! 2 * mp)
                            + (head a !! 0 !! 3 * f))
    lonNew = lon + e ** abs (head a !! 0 !! 1) * sin arg * (head a !! 1 !! 0)
    distNew = dist + e ** abs (head a !! 0 !! 1) * cos arg * (head a !! 2 !! 0)


-- Astronomical Algorithms, 2nd Edition p 338 & 342
-- Moon Latitude
-- d is the mean elongation of the Moon from the sun
-- m is the mean anomaly of the Sun (Earth)
-- mp is the mean anomaly of the Moon
-- f is the argument of latitude of the Moon
-- lp is the mean longitude of the Moon
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
-- a is the list of periodic terms for the nutation in
--   longitude and in obliquity
moonLatitude :: Double -> Double -> Double -> Double -> Double -> Double -> Double -> [[[Double]]] -> Double -> Double
moonLatitude d m mp f lp e t a lat
  | null a = 0.000001 * (lat
               - 2235 * sin (degreesToRadians lp)
               + 382 * sin (degreesToRadians (moonA3 t))
               + 175 * sin (degreesToRadians (moonA1 t - f))
               + 175 * sin (degreesToRadians (moonA1 t + f))
               + 127 * sin (degreesToRadians (lp - mp))
               - 115 * sin (degreesToRadians (lp + mp)))
  | otherwise =
        moonLatitude d m mp f lp e t (tail a) latNew
  where
    arg = degreesToRadians ((head a !! 0 !! 0 * d)
                            + (head a !! 0 !! 1 * m)
                            + (head a !! 0 !! 2 * mp)
                            + (head a !! 0 !! 3 * f))
    latNew = lat + e ** abs (head a !! 0 !! 1) * sin arg * (head a !! 1 !! 0)

-- Astronomical Algorithms, 2nd Edition p 144
-- Moon Nutation In Longitude and in Obliquity
-- d is the mean elongation of the Moon from the sun
-- m is the mean anomaly of the Sun (Earth)
-- mp is the mean anomaly of the Moon
-- f is the argument of latitude of the Moon
-- o is the longitude of ascending node of the Moon
-- t is time measured in Julian centuries from the
--   Epoch J2000.0 (JDE 2451545.0)
-- a is the list of periodic terms for the nutation in
--   longitude and in obliquity
moonNutationLongitudeAndObliquity :: Double -> Double -> Double -> Double -> Double -> Double -> [[[Double]]] -> Double -> Double -> (Double, Double)
moonNutationLongitudeAndObliquity d m mp f o t a lon obl
  | null a = ((0.0001 / 3600 * lon), (0.0001 / 3600 * obl))
  | otherwise =
        moonNutationLongitudeAndObliquity d m mp f o t (tail a) lonNew oblNew
  where
    arg = degreesToRadians ((head a !! 0 !! 0 * d)
                            + (head a !! 0 !! 1 * m)
                            + (head a !! 0 !! 2 * mp)
                            + (head a !! 0 !! 3 * f)
                            + (head a !! 0 !! 4 * o))
    lonNew = lon + sin arg * ((head a !! 1 !! 0)
                              + (head a !! 1 !! 1 * t))
    oblNew = obl + cos arg * ((head a !! 2 !! 0)
                              + (head a !! 2 !! 1 * t))

-- Astronomical Algorithms, 2nd Edition p 338 & 342
-- Sun Daily Varation of Longitude
-- tm is time measured in Julian millennia from the
--   Epoch J2000.0 (JDE 2451545.0)
-- a is the list of terms of daily variation of the longitude of Sun
sunLongitudeVariation :: Double -> [[Double]] -> Double -> Double
sunLongitudeVariation tm a variation
  | null a = 3548.193 + variation
  | otherwise =
        sunLongitudeVariation tm (tail a) (variation + arg)
  where
    arg = arcDegToDecDeg 0 0 (head a !! 0) * tm ** (head a !! 1)
            * sin (degreesToRadians ((head a !! 2)
                   + (head a !! 3 * tm)))

-- (32.2) Astronomical Algorithms, 2nd Edition p 218
-- Earth Radius Vector
-- tm is time measured in Julian millennia from the
--   Epoch J2000.0 (JDE 2451545.0)
-- a is the list of periodic terms of the radius vector of Earth
sumOfPeriodicTerms :: Double -> [[Double]] -> Double -> Double
sumOfPeriodicTerms tm a s
  | null a = s * 0.00000001
  | otherwise =
        sumOfPeriodicTerms tm (tail a) (s + arg)
  where
    arg = tm ** (head a !! 0) * (head a !! 1)
            * cos ((head a !! 2) + (head a !! 3 * tm))


-- Astronomical Algorithms, 2nd Edition p 342
-- Moon Latitude
moonLongitude :: Double -> Double -> Double
moonLongitude lp sumL = lp + sumL

-- Astronomical Algorithms, 2nd Edition p 342
-- Moon Distance
moonDistance :: Double -> Double
moonDistance sumR = 385000.56 + sumR


-- Convert AU to KM
auToKM :: Double -> Double
auToKM d = 149597870.691 * d


-- Astronomical Algorithms, 2nd Edition p 147
-- Earth True Obliquity Of Ecliptic
-- u is time measured in units of 10000 Julian years from J2000.0
-- dE is nutation in obliquity
trueObliquityOfEcliptic :: Double -> Double -> Double
trueObliquityOfEcliptic u dE = obliquityOfEcliptic u + dE


-- (13.3) Astronomical Algorithms, 2nd Edition p 93
-- Right Ascension
-- lon is the longitude in raidians
-- lat is the latitude in radians
-- obl is the obliquity of the ecliptic
rightAscension :: Double -> Double -> Double -> Double
rightAscension lon lat obl =
  atan2 (sin lon * cos obl - tan lat * sin obl) (cos lon)

-- (13.4) Astronomical Algorithms, 2nd Edition p 93
-- Declination
-- lon is the longitude in raidians
-- lat is the latitude in radians
-- obl is the obliquity of the ecliptic
declination :: Double -> Double -> Double -> Double
declination lon lat obl =
  asin (sin lat * cos obl + cos lat * sin obl * sin lon)

illuminationPercent :: Double -> Double
illuminationPercent i = (1 + cos i) / 2

-- x : number you want rounded, n : number of decimal places you want...
truncate' :: Double -> Int -> Double
truncate' x n = (fromIntegral (round (x * t))) / t
  where t = 10^n

-- (26.1) Astronomical Algorithms, 2nd Edition p 171
geocentricLLAToECEF :: Double -> Double -> Double -> Double -> Double -> (Double, Double, Double)
geocentricLLAToECEF latRad lonRad alt obliquity gmst = (x * cos gmst + y2 * sin gmst, (-x) * sin gmst + y2 * cos gmst, z2)
  where
    r = alt * cos latRad
    x = r * cos lonRad
    y = r * sin lonRad
    z = alt * sin latRad
    y2 = y * cos obliquity - z * sin obliquity
    z2 = y * sin obliquity + z * cos obliquity

geodeticLLAToECEF :: Double -> Double -> (Double, Double, Double)
geodeticLLAToECEF latRad lonRad = (a * c * cos latRad * cos lonRad, a * c * cos latRad * sin lonRad, a * s * sin latRad)
  where
    a = 6378.137
    b = 6356.75231424518
    f = (a - b) / a
    c = 1 / (sqrt (1 + f * (f - 2) * (sin latRad)**2))
    s = (1 - f)**2 * c

geodeticECEFToLLA :: Double -> Double -> Double -> Double -> Integer -> (Double, Double, Double)
geodeticECEFToLLA x y z lat count
  | count == 20 = geodeticECEFToLLA x y z latPrime (count - 1)
  | count > 0 = geodeticECEFToLLA x y z latNew (count - 1)
  | otherwise = (latNew, atan2 y x, sqrt (x**2 + y**2 + z**2))
  where
    a = 6378.137
    b = 6356.75231424518
    f = (a - b) / a
    xyLen = sqrt (x**2 + y**2)
    latPrime = atan2 z xyLen
    e2 = 2 * f - f**2
    c = 1 / (sqrt (1 - e2 * (sin lat)**2))
    s = (1 - f)**2 * c
    latNew = atan2 (z + a * c * e2 * sin lat) xyLen

earthLatLonArgs :: [String] -> (Double, Double)
earthLatLonArgs args
  | length args > 1 = (read (args !! 0) :: Double, read (args !! 1) :: Double)
  | otherwise = (0, 0)

jdeArg :: [String] -> POSIXTime -> (Double, Double)
jdeArg args curTime
  | length args > 2 = (jdeOfUnixTimestamp (fromIntegral (floor (read (args !! 2) :: Double))), fromIntegral (floor (read (args !! 2) :: Double)))
  | length args == 1 = (jdeOfUnixTimestamp (fromIntegral (floor (read (args !! 0) :: Double))), fromIntegral (floor (read (args !! 0) :: Double)))
  | otherwise = (jdeOfUnixTimestamp (fromIntegral (floor curTime)), fromIntegral (floor curTime))

main = do
  setLocaleEncoding utf8
  args <- getArgs
  curTime <- getPOSIXTime
  let (jde, time) = jdeArg args curTime
  let t = (jde - j2000) / 36525
  let u = t / 100
  let tm = t / 10
  let lp = moonMeanLongitude t
  let d = moonMeanElongation t
  let m = sunMeanAnomaly t
  let mp = moonMeanAnomaly t
  let f = moonArgumentOfLatitude t
  let o = moonLongitudeOfAscendingNode t
  let e = earthEccentricityForMoon t
  let (dY, dE) = moonNutationLongitudeAndObliquity d m mp f o t periodicTermsNutationLongitudeAndObliquity 0 0
  let (sumL, sumR) = moonLongitudeAndDistance d m mp f lp e t periodicTermsMoonLongitudeAndDistance 0 0
  let moonApparentLon = mod' (moonLongitude lp sumL + dY) 360
  let moonApparentLat = mod' (moonLatitude d m mp f lp e t periodicTermsMoonLatitude 0) 360
  let moonDist = moonDistance sumR
  let trueObliquity = trueObliquityOfEcliptic u dE
  let dL = arcDegToDecDeg 0 0 (sunLongitudeVariation tm variationOfSunLongitude 0)
  let sunLonInit = radiansToDegrees (sumOfPeriodicTerms tm periodicTermsEarthEclipticalLongitude 0 + pi)
  let sunLatInit = (-1) * radiansToDegrees (sumOfPeriodicTerms tm periodicTermsEarthEclipticalLatitude 0)
  let sunRadiusVector = sumOfPeriodicTerms tm periodicTermsEarthRadiusVector 0
  let sunLamdaPrime = sunLonInit - t * 1.397 - t ** 2 * 0.00031
  let dO = arcDegToDecDeg 0 0 (-0.09033)
  let dB = arcDegToDecDeg 0 0 0.03916 * (cos (degreesToRadians sunLamdaPrime) - sin (degreesToRadians sunLamdaPrime))

  let sunApparentLon = mod' (sunLonInit + dY + dO + (-0.005775518) * sunRadiusVector * dL) 360
  let sunApparentLat = mod' (sunLatInit + dB) 360
  let sunDist = auToKM sunRadiusVector

  let gmst = jdeToGMST jde
  let (moonX, moonY, moonZ) = geocentricLLAToECEF (degreesToRadians moonApparentLat) (degreesToRadians moonApparentLon) moonDist (degreesToRadians trueObliquity) gmst
  let (sunX, sunY, sunZ) = geocentricLLAToECEF (degreesToRadians sunApparentLat) (degreesToRadians sunApparentLon) sunDist (degreesToRadians trueObliquity) gmst
  let (earthLat, earthLon) = earthLatLonArgs args
  let (earthX, earthY, earthZ) = geodeticLLAToECEF (geodeticToGeocentricLat (degreesToRadians earthLat)) (degreesToRadians earthLon)
  let earthDist = sqrt (earthX**2 + earthY**2 + earthZ**2)
  let earthToSunDist = sqrt ((earthX - sunX)**2 + (earthY - sunY)**2 + (earthZ - sunZ)**2)
  let earthToMoonDist = sqrt ((earthX - moonX)**2 + (earthY - moonY)**2 + (earthZ - moonZ)**2)
  let sunlightAngle = acos ((earthDist**2 + earthToSunDist**2 - sunDist**2) / (2 * earthDist * earthToSunDist))
  let moonlightAngle = acos ((earthDist**2 + earthToMoonDist**2 - moonDist**2) / (2 * earthDist * earthToMoonDist))
  let moonToSunDist = sqrt ((moonX - sunX)**2 + (moonY - sunY)**2 + (moonZ - sunZ)**2)
  let i = acos ((moonDist**2 + moonToSunDist**2 - sunDist**2) / (2 * moonDist * moonToSunDist))
  let arcl = acos ((moonDist**2 + sunDist**2 - moonToSunDist**2)/ (2 * moonDist * sunDist))
  let ip = illuminationPercent i

  let (moonLat, moonLon, moonAlt) = geodeticECEFToLLA moonX moonY moonZ 0 20
  let (sunLat, sunLon, sunAlt) = geodeticECEFToLLA sunX sunY sunZ 0 20

  putStrLn ("{")
  putStrLn ("    \"moonIllumination\": " ++ show ip ++ ",")
  putStrLn ("    \"moonPhase\": " ++ show (radiansToDegrees (degreesToRadians (moonApparentLon - sunApparentLon))) ++ ",")
  putStrLn ("    \"sunAngle\": " ++ show (radiansToDegrees sunlightAngle) ++ ",")
  putStrLn ("    \"moonAngle\": " ++ show (radiansToDegrees moonlightAngle) ++ ",")
  putStrLn ("    \"sunGeoditicLocation\": {")
  putStrLn ("        \"latitude\": " ++ show (radiansToDegrees sunLat) ++ ",")
  putStrLn ("        \"longitude\": " ++ show (radiansToDegrees sunLon))
  putStrLn ("    },")
  putStrLn ("    \"moonGeoditicLocation\": {")
  putStrLn ("        \"latitude\": " ++ show (radiansToDegrees moonLat) ++ ",")
  putStrLn ("        \"longitude\": " ++ show (radiansToDegrees moonLon))
  putStrLn ("    },")
  putStrLn ("    \"earthGeoditicLocation\": {")
  putStrLn ("        \"latitude\": " ++ show earthLat ++ ",")
  putStrLn ("        \"longitude\": " ++ show earthLon)
  putStrLn ("    },")
  putStrLn ("    \"sunECEF\": {")
  putStrLn ("        \"x\": " ++ show sunX ++ ",")
  putStrLn ("        \"y\": " ++ show sunY ++ ",")
  putStrLn ("        \"z\": " ++ show sunZ)
  putStrLn ("    },")
  putStrLn ("    \"moonECEF\": {")
  putStrLn ("        \"x\": " ++ show moonX ++ ",")
  putStrLn ("        \"y\": " ++ show moonY ++ ",")
  putStrLn ("        \"z\": " ++ show moonZ)
  putStrLn ("    },")
  putStrLn ("    \"earthECEF\": {")
  putStrLn ("        \"x\": " ++ show earthX ++ ",")
  putStrLn ("        \"y\": " ++ show earthY ++ ",")
  putStrLn ("        \"z\": " ++ show earthZ)
  putStrLn ("    },")
  putStrLn ("    \"sunEarthPhase\": " ++ show (radiansToDegrees (degreesToRadians (earthLon - radiansToDegrees sunLon))) ++ ",")
  putStrLn ("    \"sunEclipticLongitude\": " ++ show sunApparentLon ++ ",")
  putStrLn ("    \"sunEarthMoonAngle\": " ++ show (radiansToDegrees arcl) ++ ",")
  putStrLn ("    \"time\": " ++ show time)
  putStrLn ("}")
