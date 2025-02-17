//  Copyright 2024 Bruno Garcia
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

///|
pub fn start() -> Unit {
  @wasm4.set_palette(1, @wasm4.rgb(0xfbf7f3))
  @wasm4.set_palette(2, @wasm4.rgb(0xe5b083))
  @wasm4.set_palette(3, @wasm4.rgb(0x426e5d))
  @wasm4.set_palette(4, @wasm4.rgb(0x20283d))
}

///|
let game : Game = Game::new()

///|
pub fn upd() -> Unit {
  game.update()
}
