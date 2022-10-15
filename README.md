# **Syzygy**

Haskell program that accurately calculates the 3D position in space of the Sun, Moon, and a latitude/longitude location on Earth for a given time

## Description:
Syzygy is a program that accurately calculates the 3D positions of the Sun, Earth, and specified latitude/longitude on Earth for a given time.  This allows the user to track things like moon illumination, sunset, sunrise, equinoxes, moon phases, solar eclipses, and lunar eclipses.

The algorithms used to calculate this data comes from "Astronomical Algorithms, 2nd Edition" by Jean Meeus.

## Build Platforms:
- \*BSD
- Linux
- macOS

## Build Dependencies:
- **ghc-static**

## Build:
In the root directory of this repository (the directory this README.md file is in), run the following command.

```sh
make
```

The executable will be at `build/bin/syzygy` in the repository.

## Clean Build Environment:
If you used `make` to build syzygy, you can run the following command to clean up the build environment.
```sh
make clean
```

## Usage:
There are 4 ways to use syzygy, which are as follows

```sh
syzygy
```

```sh
syzygy <unix_timestamp>
```

```
syzygy <lat> <lon>
```

```
syzygy <lat> <lon> <unix_timestamp>
```

- **\<lat\>** is the latitude value on Earth you want to track from -90 to 90
- **\<lon\>** is the longitude value on Earth you want to track from -180 to 180
- **\<unix_timestamp\>** is the amount of seconds since January 1st, 1970 (excluding leap seconds)

In cases where **\<unix_timestamp\>** is not specified, syzygy will use the current unix timestamp.

In cases where **\<lat\>** and **\<lon\>** are not specified, syzygy will use 0 for the latitude and longitude.

## Example Usage
```sh
syzygy 1665348963                 
```

The above command will provide the following output

```
{
    "moonIllumination": 0.99957407644572,
    "moonPhase": 179.99993919134036,
    "sunAngle": 43.17075597516776,
    "moonAngle": 135.46725402375057,
    "sunGeoditicLocation": {
        "latitude": -6.50423175818878,
        "longitude": -137.22468181349913
    },
    "moonGeoditicLocation": {
        "latitude": 4.314456208445099,
        "longitude": 43.6876813984543
    },
    "earthGeoditicLocation": {
        "latitude": 0.0,
        "longitude": 0.0
    },
    "sunECEF": {
        "x": -1.0896891034553605e8,
        "y": -1.0081915852153297e8,
        "z": -1.6925351152715765e7
    },
    "moonECEF": {
        "x": 273630.25533367856,
        "y": 261374.21953694063,
        "z": 28545.184657886857
    },
    "earthECEF": {
        "x": 6378.137,
        "y": 0.0,
        "z": 0.0
    },
    "sunEarthPhase": 137.22468181349916,
    "sunEclipticLongitude": 196.54377250238426,
    "sunEarthMoonAngle": 177.62889612776624,
    "time": 1.665348963e9
}
```

## LICENSE
```
Copyright (C) 2022, Vi Grey
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS \`\`AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
```