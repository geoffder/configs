#pragma once
#include "config_common.h"
#define VENDOR_ID 0x2F8A
#define PRODUCT_ID 0x1828
#define DEVICE_VER 0x0001
#define MANUFACTURER HID Technologies
#define PRODUCT HID Technologies Skeletyl
#define DESCRIPTION A mini high-end split keyboard

#define MATRIX_ROWS 8
#define MATRIX_COLS 5

// dactyl manuform pins
#define DIODE_DIRECTION COL2ROW
#define MATRIX_COL_PINS { C6, D7, E6, B4, B5 }
#define MATRIX_ROW_PINS { F7, B1, B3, B2 }

// use an actual pin connecting D1 to GND on right hand side to indicate that it is right, no pin on the left controller makes it the master
/* #define SPLIT_HAND_PIN D1 */

#define USE_SERIAL
#define SOFT_SERIAL_PIN D0

#define DEBOUNCE 5
