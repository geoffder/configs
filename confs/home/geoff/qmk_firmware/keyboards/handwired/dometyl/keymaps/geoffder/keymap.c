#include QMK_KEYBOARD_H
#include "compose.c"

#define _COLEMAKDHM 0
#define _LOWER 1
#define _RAISE 2
#define _ADJUST 3

#define KC_MS_U KC_MS_UP
#define KC_MS_D KC_MS_DOWN
#define KC_MS_L KC_MS_LEFT
#define KC_MS_R KC_MS_RIGHT
#define KC_MW_U KC_MS_WH_UP
#define KC_MW_D KC_MS_WH_DOWN
#define KC_MW_L KC_MS_WH_LEFT
#define KC_MW_R KC_MS_WH_RIGHT
#define KC_MSB1 KC_MS_BTN1
#define KC_MSB2 KC_MS_BTN2
#define KC_MSB3 KC_MS_BTN3

// Left-hand home row mods
#define HOME_A LGUI_T(KC_A)
#define HOME_R LALT_T(KC_R)
#define HOME_S LSFT_T(KC_S)
#define HOME_T LCTL_T(KC_T)

// Right-hand home row mods
#define HOME_N RCTL_T(KC_N)
#define HOME_E RSFT_T(KC_E)
#define HOME_I LALT_T(KC_I)
#define HOME_O RGUI_T(KC_O)

// Left-thumb later taps
#define ESC_ADJ LT(_ADJUST, KC_ESC)
/* #define TAB_LOW LT(_LOWER, KC_TAB) */
/* #define SPC_RSE LT(_RAISE, KC_SPC) */
#define TAB_RSE LT(_RAISE, KC_TAB)
#define SPC_LOW LT(_LOWER, KC_SPC)

// Right-thumb layer taps
#define BS_RSE LT(_RAISE, KC_BSPC)
#define ENT_LOW LT(_LOWER, KC_ENT)
/* #define ENT_RSE LT(_RAISE, KC_ENT) */
/* #define BS_LOW LT(_LOWER, KC_BSPC) */
#define DEL_ADJ LT(_ADJUST, KC_DEL)

#define UC_INPT LSFT(LCTL(KC_U))

enum custom_keycodes {
  COLEMAKDHM = SAFE_RANGE,
  LOWER,
  RAISE,
  ADJUST,
  COMPOSE,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

  [_COLEMAKDHM] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┐             ┌────────┬────────┬────────┬────────┬────────┐
     KC_Q,    KC_W,    KC_F,    KC_P,    KC_B,                  KC_J,    KC_L,    KC_U,    KC_Y,    KC_QUOT,
  //├────────┼────────┼────────┼────────┼────────┐             ├────────┼────────┼────────┼────────┼────────┼
     HOME_A,  HOME_R,  HOME_S,  HOME_T,  KC_G,                  KC_M,    HOME_N,  HOME_E,  HOME_I,  HOME_O,
  //├────────┼────────┼────────┼────────┼────────┐             ┼────────┼────────┼────────┼────────┼────────┼
     KC_Z,    KC_X,    KC_C,    KC_D,    KC_V,                  KC_K,    KC_H,    KC_COMM, KC_DOT,  KC_SLSH,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┐    ┌────┴───┬────┴───┬────┴───┬────┴────────┴────────┘
                           ESC_ADJ, SPC_LOW, TAB_RSE,      ENT_LOW, BS_RSE,  DEL_ADJ
                       // └────────┴────────┴────────┘    └────────┴────────┴────────┘
  ),

  [_LOWER] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┐             ┌────────┬────────┬────────┬────────┬────────┐
     KC_LBRC, KC_7,    KC_8,    KC_9,    KC_RBRC,               KC_AGIN, KC_PSTE, KC_COPY, KC_CUT,  KC_UNDO,
  //├────────┼────────┼────────┼────────┼────────┐             ├────────┼────────┼────────┼────────┼────────┼
     KC_SCLN, KC_4,    KC_5,    KC_6,    KC_EQL,                KC_CAPS, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT,
  //├────────┼────────┼────────┼────────┼────────┐             ┼────────┼────────┼────────┼────────┼────────┼
     KC_GRV,  KC_1,    KC_2,    KC_3,    KC_BSLS,               KC_INS,  KC_HOME, KC_PGDN, KC_PGUP, KC_END,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┐    ┌────┴───┬────┴───┬────┴───┬────┴────────┴────────┘
                           KC_DOT,  KC_0,    KC_MINS,      KC_ENT,  KC_BSPC, KC_DEL
                       // └────────┴────────┴────────┘    └────────┴────────┴────────┘
  ),

  [_RAISE] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┐             ┌────────┬────────┬────────┬────────┬────────┐
     KC_LCBR, KC_AMPR, KC_ASTR, KC_LPRN, KC_RCBR,               _______, _______, _______, _______, _______,
  //├────────┼────────┼────────┼────────┼────────┐             ├────────┼────────┼────────┼────────┼────────┼
     KC_COLN, KC_DLR,  KC_PERC, KC_CIRC, KC_PLUS,               _______, KC_MS_L, KC_MS_D, KC_MS_U, KC_MS_R,
  //├────────┼────────┼────────┼────────┼────────┐             ┼────────┼────────┼────────┼────────┼────────┼
     KC_TILD, KC_EXLM, KC_AT,   KC_HASH, KC_PIPE,               _______, KC_MW_L, KC_MW_D, KC_MW_U, KC_MW_R,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┐    ┌────┴───┬────┴───┬────┴───┬────┴────────┴────────┘
                           KC_LPRN, KC_RPRN, KC_UNDS,      KC_MSB1, KC_MSB3,  KC_MSB2
                       // └────────┴────────┴────────┘    └────────┴────────┴────────┘
  ),

  [_ADJUST] = LAYOUT(
  //┌────────┬────────┬────────┬────────┬────────┐             ┌────────┬────────┬────────┬────────┬────────┐
     KC_F12,  KC_F7,   KC_F8,   KC_F9,   KC_PSCR,               _______, UC_INPT, COMPOSE, _______, _______,
  //├────────┼────────┼────────┼────────┼────────┐             ├────────┼────────┼────────┼────────┼────────┼
     KC_F11,  KC_F4,   KC_F5,   KC_F6,   KC_SLCK,               _______, KC_MPRV, KC_VOLU, KC_VOLD, KC_MNXT,
  //├────────┼────────┼────────┼────────┼────────┐             ┼────────┼────────┼────────┼────────┼────────┼
     KC_F10,  KC_F1,   KC_F2,   KC_F3,   KC_BRK,                RESET,   _______, _______, _______, _______,
  //└────────┴────────┴────────┴───┬────┴───┬────┴───┐    ┌────┴───┬────┴───┬────┴───┬────┴────────┴────────┘
                           KC_MENU, KC_SPC,  KC_TAB,       KC_MSTP, KC_MPLY, KC_MUTE
                       // └────────┴────────┴────────┘    └────────┴────────┴────────┘
  )
};


void matrix_scan_user(void) {
    if (composing && (timer_elapsed(compose_timer) > COMPOSE_TIMEOUT)) {
      send_compose();
    }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case COLEMAKDHM:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_COLEMAKDHM);
      }
      return false;
      break;
    case LOWER:
      if (record->event.pressed) {
        layer_on(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_LOWER);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case RAISE:
      if (record->event.pressed) {
        layer_on(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      } else {
        layer_off(_RAISE);
        update_tri_layer(_LOWER, _RAISE, _ADJUST);
      }
      return false;
      break;
    case ADJUST:
      if (record->event.pressed) {
        layer_on(_ADJUST);
      } else {
        layer_off(_ADJUST);
      }
      return false;
      break;
    case COMPOSE:
      if (record->event.pressed) {
        composing = true;
        compose_timer = timer_read();
      }
      return false;
      break;
    default:
      if (composing && record->event.pressed) {
        return compose(keycode, record);
      }
      break;
  }
  return true;
}

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case HOME_A:
          return TAPPING_TERM + 125;
        case HOME_R:
          return TAPPING_TERM + 125;
        case HOME_S:
          return TAPPING_TERM;
        case HOME_T:
          return TAPPING_TERM + 75;
        case HOME_N:
          return TAPPING_TERM + 75;
        case HOME_E:
          return TAPPING_TERM;
        case HOME_I:
          return TAPPING_TERM + 125;
        case HOME_O:
          return TAPPING_TERM + 125;
        case SPC_LOW:
          return TAPPING_TERM + 75;
        case BS_RSE:
          return TAPPING_TERM + 75;
        default:
          return TAPPING_TERM;
    }
}
