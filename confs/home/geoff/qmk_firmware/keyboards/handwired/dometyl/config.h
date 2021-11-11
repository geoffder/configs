/* Copyright 2018-2020 ENDO Katsuhiro <ka2hiro@curlybracket.co.jp> David Philip Barr <@davidphilipbarr> Pierre Chevalier <pierrechevalier83@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

#include "config_common.h"

/* USB Device descriptor parameter */
#define VENDOR_ID       0xBEEF
#define MANUFACTURER    geoffder

/* key matrix size */
#define MATRIX_ROWS 8
#define MATRIX_COLS 5

/*
 * Keyboard Matrix Assignments
*/
#define DIRECT_PINS { \
    { C6, D1, B2, F6, F1 }, \
    { C7, D2, B3, F7, F4 }, \
    { D5, D3, B7, B6, F5 }, \
    { NO_PIN, NO_PIN, D7, B4, B5 } \
}

#define DIRECT_PINS_RIGHT  { \
    { B2, D1, F1, F6, B5 }, \
    { B3, D2, F4, F7, B4 }, \
    { B7, D3, F5, B6, D7 }, \
    { C6, C7, D5, NO_PIN, NO_PIN } \
}

#define UNUSED_PINS

#define DEBOUNCE 0  // no need for debounce (no contact switching)

/* Serial settings */
#define USE_SERIAL
#define SOFT_SERIAL_PIN D0

// Required for Teensy 2.0 unless modded
// https://beta.docs.qmk.fm/using-qmk/hardware-features/feature_split_keyboard#teensy-boards
#define SPLIT_USB_DETECT
