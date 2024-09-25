//  Copyright 2024 International Digital Economy Academy
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//      http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

type Color UInt

pub fn rgb(color : UInt) -> Color {
  color
}

/// Sets the color of the palette at the given index.
/// 
/// @param index the index of the palette to set, from 1 to 4 (inclusive)  
/// @param color the color to set
pub fn set_palette(index : UInt, color : Color) -> Unit {
  if index == 0 || index > 4 {
    trace("Palette index out of range")
    panic()
  }
  store_i32(
    address_PALETTE + (index.reinterpret_as_int() - 1) * 4,
    color._.reinterpret_as_int(),
  )
}

/// Gets the color of the palette at the given index.
/// 
/// @param index the index of the palette to get, from 1 to 4 (inclusive)  
/// @return the color at the given index
pub fn get_palette(index : UInt) -> Color {
  if index == 0 || index > 4 {
    trace("Palette index out of range")
    panic()
  }
  load_s32(address_PALETTE + (index.reinterpret_as_int() - 1) * 4).reinterpret_as_uint()
}

/// Sets the draw color at the given index.
/// 
/// @param index the index of the draw color to set, from 1 to 4 (inclusive)  
/// @param palette the index of the palette to set the draw color to, from 1 to 4 (inclusive), or 0 for transparent
pub fn set_draw_colors(palette : UInt, ~index : UInt = 1) -> Unit {
  if index == 0 || index > 4 || palette > 4 {
    trace("Draw color index or palette index out of range")
    panic()
  }
  let current_color = get_draw_colors(index)
  let updated_color = bitset(current_color, palette, (index - 1U) * 4U, 4U)
  store_i16(address_DRAW_COLORS, updated_color.reinterpret_as_int())
}

/// Gets the draw color at the given index.
/// 
/// @param index the index of the draw color to get, from 1 to 4 (inclusive)  
/// @return the index of the palette that the draw color is set to
pub fn get_draw_colors(index : UInt) -> UInt {
  if index == 0 || index > 4 {
    trace("Draw color index out of range")
    panic()
  }
  load_u16(address_DRAW_COLORS)
}

pub(readonly) struct GamePad {
  button_1 : Bool
  button_2 : Bool
  button_left : Bool
  button_right : Bool
  button_up : Bool
  button_down : Bool
} derive(Eq, Default)

/// Gets the state of the gamepads.
/// 
/// @param index the index of the gamepad to get, from 1 to 4 (inclusive)  
/// @return the state of the gamepads
pub fn get_gamepad(~index : UInt = 1) -> GamePad {
  if index.reinterpret_as_int() > 4 {
    trace("Gamepad index out of range")
    panic()
  }
  let state = load_byte(address_GAMEPADS + index.reinterpret_as_int() - 1).to_int()
  GamePad::{
    button_1: (state & 1) == 1,
    button_2: (state & 2) == 2,
    button_left: (state & 16) == 16,
    button_right: (state & 32) == 32,
    button_up: (state & 64) == 64,
    button_down: (state & 128) == 128,
  }
}

pub(readonly) struct Mouse {
  x : Int
  y : Int
  left : Bool
  middle : Bool
  right : Bool
} derive(Eq, Default)

/// Gets the state of the mouse.
/// 
/// @return the state of the mouse
pub fn get_mouse() -> Mouse {
  let buttons = load_byte(address_MOUSE_BUTTONS).to_int().reinterpret_as_uint()
  Mouse::{
    x: load_s16(address_MOUSE_X),
    y: load_s16(address_MOUSE_Y),
    left: (buttons & 1U) == 1U,
    middle: (buttons & 2U) == 2U,
    right: (buttons & 4U) == 4U,
  }
}

/// Manipulate the framebuffer directly.
/// 
/// @param index the index of the pixel to set, from 0 to 160 * 160 (exclusive)  
/// @param palette the index of the palette to set the pixel to, from 1 to 4 (inclusive)
pub fn set_frame_buffer(index : UInt, palette : UInt) -> Unit {
  if index >= 160U * 160U || palette == 0 || palette > 4 {
    trace("Frame buffer index or palette index out of range")
    panic()
  }
  let byte = load_byte(address_FRAMEBUFFER + index.reinterpret_as_int() / 4)
  let new_byte = bitset(
    byte.to_int().reinterpret_as_uint(),
    palette - 1,
    index % 4U * 2U,
    2U,
  )
  store_byte(
    address_FRAMEBUFFER + index.reinterpret_as_int() / 4,
    new_byte.reinterpret_as_int().to_byte(),
  )
}

/// Status of netplay
/// 
/// The index is from 1 to 4 (inclusive)
pub(readonly) struct Netplay {
  index : UInt
  active : Bool
}

/// Gets the state of the netplay.
/// 
/// @return the state of the netplay
pub fn get_netplay() -> Netplay {
  let flags = load_byte(address_NETPLAY).to_int().reinterpret_as_uint()
  Netplay::{ index: (flags & 0b11U) + 1, active: (flags & 4U) == 4U }
}

pub fn set_system_preserve_framebuffer(b : Bool) -> Unit {
  let flags = load_byte(address_SYSTEM_FLAGS)
  let new_flags = bitset(
    flags.to_int().reinterpret_as_uint(),
    if b {
      1
    } else {
      0
    },
    0U,
    1U,
  )
  store_byte(address_SYSTEM_FLAGS, new_flags.reinterpret_as_int().to_byte())
}

pub fn get_system_preserve_framebuffer() -> Bool {
  let flags = load_byte(address_SYSTEM_FLAGS)
  (flags.to_int() & 1) == 1
}

pub fn set_system_hide_gamepad_overlay(b : Bool) -> Unit {
  let flags = load_byte(address_SYSTEM_FLAGS)
  let new_flags = bitset(
    flags.to_int().reinterpret_as_uint(),
    if b {
      1
    } else {
      0
    },
    1U,
    1U,
  )
  store_byte(address_SYSTEM_FLAGS, new_flags.reinterpret_as_int().to_byte())
}

pub fn get_system_hide_gamepad_overlay() -> Bool {
  let flags = load_byte(address_SYSTEM_FLAGS)
  (flags.to_int() & 2) == 2
}
