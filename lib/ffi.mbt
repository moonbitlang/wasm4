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

// Addresses: https://wasm4.org/docs/reference/memory#memory-map
let address_PALETTE = 0x4

let address_DRAW_COLORS = 0x14

let address_GAMEPADS = 0x16

let address_MOUSE_X = 0x1a

let address_MOUSE_Y = 0x1c

let address_MOUSE_BUTTONS = 0x1e

let address_SYSTEM_FLAGS = 0x1f

let address_NETPLAY = 0x20

let address_FRAMEBUFFER = 0xa0

extern "wasm" fn load_byte(offset : Int) -> Byte =
  #|(func (param i32) (result i32) (i32.load8_u (local.get 0)))

extern "wasm" fn store_byte(offset : Int, byte : Byte) =
  #|(func (param i32) (param i32) (i32.store8 (local.get 0) (local.get 1)))

extern "wasm" fn load_s16(offset : Int) -> Int =
  #|(func (param i32) (result i32) (i32.load16_s (local.get 0)))

extern "wasm" fn load_u16(offset : Int) -> UInt =
  #|(func (param i32) (result i32) (i32.load16_u (local.get 0)))

extern "wasm" fn store_i16(offset : Int, value : Int) =
  #|(func (param i32) (param i32) (i32.store16 (local.get 0) (local.get 1)))

extern "wasm" fn load_s32(offset : Int) -> Int =
  #|(func (param i32) (result i32) (i32.load (local.get 0)))

extern "wasm" fn store_i32(offset : Int, value : Int) =
  #|(func (param i32) (param i32) (i32.store (local.get 0) (local.get 1)))

fn blit_ffi(
  spritePtr : Int,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  flags : Int
) = "env" "blit"

fn blit_sub_ffi(
  spritePtr : Int,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  src_x : Int,
  src_y : Int,
  stride : Int,
  flags : Int
) = "env" "blitSub"

fn text_ffi(str : Int, x : Int, y : Int) = "env" "text"

fn tone_ffi(frequency : UInt, duration : UInt, volume : UInt, flags : UInt) = "env" "tone"

fn trace_ffi(offset : Int) = "env" "trace"

fn diskr_ffi(ptr : Int, size : Int) -> Int = "env" "diskr"

fn diskw_ffi(ptr : Int, size : Int) -> Int = "env" "diskw"
