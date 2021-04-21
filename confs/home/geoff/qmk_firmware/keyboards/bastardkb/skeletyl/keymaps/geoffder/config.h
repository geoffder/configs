#pragma once

// flash each side with `-bl dfu-split-{left,right}` to set handedness in memory
// e.g. qmk flash -bl dfu-split-left -kb bastardkb/skeletyl -km geoffder
#define EE_HANDS

#define MASTER_LEFT

// Configure the global tapping term (default: 200ms)
#define TAPPING_TERM 175

// Use get_tappihg_term in keymap.c to adjust terms for specific keys
#define TAPPING_TERM_PER_KEY

// Prevent normal rollover on alphas from accidentally triggering mods.
#define IGNORE_MOD_TAP_INTERRUPT

// Enable rapid switch from tap to hold, disables double tap hold auto-repeat.
#define TAPPING_FORCE_HOLD

// Apply the modifier on keys that are tapped during a short hold of a modtap
// NOTE: It seems like I roll over between keys a lot, so this leads to a lot
// of unintenional mod presses for me on the home row.
// #define PERMISSIVE_HOLD
