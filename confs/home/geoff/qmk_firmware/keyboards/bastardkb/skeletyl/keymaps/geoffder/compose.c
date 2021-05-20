uint16_t COMPOSE_TIMEOUT = 800;

static uint16_t codes[3] = {KC_NO, KC_NO, KC_NO};
static int next_code = 0;
static bool composing = false;
static uint16_t compose_timer;

void reset_compose(void) {
  for (int i = 0; i < 3; ++i) {
    codes[i] = KC_NO;
  }
  next_code = 0;
  composing = false;
}

bool code_matches(uint16_t m1, uint16_t m2, uint16_t m3, bool flex) {
  return
    ((codes[0] == m1 && codes[1] == m2) ||
     (flex && ((codes[1] == m1 && codes[0] == m2))))
    && codes[2] == m3;
}

bool circum_match(uint16_t keycode, bool flex) {
  return code_matches(KC_CIRC, keycode, KC_NO, flex)
    || code_matches(KC_GT, keycode, KC_NO, flex);
}


void send_compose(void) {
  if (code_matches(KC_GRV, KC_A, KC_NO, true)) {
    send_unicode_hex_string("0x0e0"); // à
  } else if (code_matches(KC_GRV, LSFT(KC_A), KC_NO, true)) {
    send_unicode_hex_string("0x0c0"); // À
  } else if (circum_match(KC_A, true)) {
    send_unicode_hex_string("0x0e2"); // â
  } else if (circum_match(LSFT(KC_A), true)) {
    send_unicode_hex_string("0x0c2"); // Â
  } else if (code_matches(KC_GRV, KC_E, KC_NO, true)) {
    send_unicode_hex_string("0x0e8"); // è
  } else if (code_matches(KC_GRV, LSFT(KC_E), KC_NO, true)) {
    send_unicode_hex_string("0x0c8"); // È
  } else if (code_matches(KC_QUOT, KC_E, KC_NO, true)) {
    send_unicode_hex_string("0x0e9"); // é
  } else if (code_matches(KC_QUOT, LSFT(KC_E), KC_NO, true)) {
    send_unicode_hex_string("0x0c9"); // É
  } else if (circum_match(KC_E, true)) {
    send_unicode_hex_string("0x0ea"); // ê
  } else if (circum_match(LSFT(KC_E), true)) {
    send_unicode_hex_string("0x0ca"); // Ê
  } else if (code_matches(KC_DQUO, KC_E, KC_NO, true)) {
    send_unicode_hex_string("0x0eb"); // ë
  } else if (code_matches(KC_DQUO, LSFT(KC_E), KC_NO, true)) {
    send_unicode_hex_string("0x0cb"); // Ë
  } else if (circum_match(KC_I, true)) {
    send_unicode_hex_string("0x0ee"); // î
  } else if (circum_match(LSFT(KC_I), true)) {
    send_unicode_hex_string("0x0ce"); // Î
  } else if (code_matches(KC_DQUO, KC_I, KC_NO, true)) {
    send_unicode_hex_string("0x0ef"); // ï
  } else if (code_matches(KC_DQUO, LSFT(KC_I), KC_NO, true)) {
    send_unicode_hex_string("0x0cf"); // Ï
  } else if (circum_match(KC_O, true)) {
    send_unicode_hex_string("0x0f4"); // ô
  } else if (circum_match(LSFT(KC_O), true)) {
    send_unicode_hex_string("0x0d4"); // Ô
  } else if (code_matches(KC_GRV, KC_U, KC_NO, true)) {
    send_unicode_hex_string("0x0f9"); // ù
  } else if (code_matches(KC_GRV, LSFT(KC_U), KC_NO, true)) {
    send_unicode_hex_string("0x0d9"); // Ù
  } else if (circum_match(KC_U, true)) {
    send_unicode_hex_string("0x0fb"); // û
  } else if (circum_match(LSFT(KC_U), true)) {
    send_unicode_hex_string("0x0fb"); // Û
  } else if (code_matches(KC_DQUO, KC_U, KC_NO, true)) {
    send_unicode_hex_string("0x0fc"); // ü
  } else if (code_matches(KC_DQUO, LSFT(KC_U), KC_NO, true)) {
    send_unicode_hex_string("0x0dc"); // Ü
  } else if (code_matches(KC_DQUO, KC_Y, KC_NO, true)) {
    send_unicode_hex_string("0x0ff"); // ÿ
  } else if (code_matches(KC_DQUO, LSFT(KC_Y), KC_NO, true)) {
    send_unicode_hex_string("0x178"); // Ÿ
  } else if (code_matches(KC_COMM, KC_C, KC_NO, true)) {
    send_unicode_hex_string("0x0e7"); // ç
  } else if (code_matches(KC_COMM, LSFT(KC_C), KC_NO, true)) {
    send_unicode_hex_string("0x0c7"); // Ç
  } else if (code_matches(KC_O, KC_E, KC_NO, false)) {
    send_unicode_hex_string("0x153"); // œ
  } else if (code_matches(LSFT(KC_O), LSFT(KC_E), KC_NO, false)) {
    send_unicode_hex_string("0x152"); // Œ
  }

  reset_compose();
}

bool compose(uint16_t keycode, keyrecord_t *record) {
  // Get the base keycode of a mod or layer tap key
  if ((QK_MOD_TAP <= keycode && keycode <= QK_MOD_TAP_MAX)
    || (QK_LAYER_TAP <= keycode && keycode <= QK_LAYER_TAP_MAX)) {
    // Earlier return if this has not been considered tapped yet
    if (record->tap.count == 0) {
        return true;
    }
    keycode = keycode & 0xFF;
  }
  // let through anything above normal keyboard keycode or a mod
  if ((keycode < KC_A || keycode > KC_CAPSLOCK) && (keycode < QK_MODS || keycode > QK_MODS_MAX)) {
    return true;
  }

  if (keycode == KC_ENT) {
    send_compose();
  } else {
    codes[next_code] = get_mods() & MOD_MASK_SHIFT ? LSFT(keycode) : keycode;
    next_code++;

    if (next_code < 3) {
      compose_timer = timer_read();
    } else {
      send_compose();
    }
  }
  return false;
}
