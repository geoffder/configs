/* Copyright 2015-2017 Jack Humbert
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H
#include "keymap_steno.h"

enum preonic_layers {
  _PLOVER,
};

enum preonic_keycodes {
  PLOVER = SAFE_RANGE
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/* Plover layer (http://opensteno.org) (example from planck)
 * ,-----------------------------------------------------------------------------------.
 * |   #  |   #  |   #  |   #  |   #  |   #  |   #  |   #  |   #  |   #  |   #  |   #  |
 * |------+------+------+------+------+-------------+------+------+------+------+------|
 * |  FN  |   S  |   T  |   P  |   H  |   *  |   *  |   F  |   P  |   L  |   T  |   D  |
 * |------+------+------+------+------+------|------+------+------+------+------+------|
 * |      |   S  |   K  |   W  |   R  |   *  |   *  |   R  |   B  |   G  |   S  |   Z  |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Exit |      |      |   A  |   O  |             |   E  |   U  |  PWR | RES1 | RES2 |
 * `-----------------------------------------------------------------------------------'
 */

[_PLOVER] = LAYOUT_preonic_grid(
  XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
  XXXXXXX, STN_TL,  STN_PL,  STN_HL,  STN_ST1, XXXXXXX, STN_ST3, STN_FR,  STN_PR,  STN_LR,  XXXXXXX, XXXXXXX,
  STN_S1,  STN_KL,  STN_WL,  STN_RL,  STN_ST2, XXXXXXX, STN_ST4, STN_RR,  STN_BR,  STN_GR,  STN_TR,  STN_DR ,
  STN_S2,  XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, STN_SR,  STN_ZR ,
  XXXXXXX, XXXXXXX, STN_A,   STN_O,   STN_N1,  XXXXXXX, STN_N2,  STN_E,   STN_U,   XXXXXXX, XXXXXXX, XXXXXXX
),

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  return true;
};

void matrix_init_user() {
  steno_set_mode(STENO_MODE_GEMINI); // or STENO_MODE_BOLT
}
