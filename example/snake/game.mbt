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

let random : @random.RandomState = @random.init_state()

let fruit : @wasm4.Sprite = @wasm4.sprite(
  b"\x00\xa0\x02\x00\x0e\xf0\x36\x5c\xd6\x57\xd5\x57\x35\x5c\x0f\xf0",
)

pub struct Game {
  snake : Snake
  mut frame_count : UInt
  mut prev_gamepad : @wasm4.GamePad
  mut fruit : Point
}

pub fn Game::new() -> Game {
  {
    snake: Snake::new(),
    frame_count: 0,
    prev_gamepad: @wasm4.GamePad::default(),
    fruit: Point::{
      x: random.gen_int().abs() % 20,
      y: random.gen_int().abs() % 20,
    },
  }
}

pub fn update(self : Game) -> Unit {
  self.frame_count += 1
  self.input()
  if self.snake.is_dead() {
    @wasm4.trace("Game Over...Or not?")
    @wasm4.tone_note_mode(
      (@wasm4.Note::new(60, bend=0), None),
      @wasm4.ADSR::new(60),
      @wasm4.ADSRVolume::new(100),
      @wasm4.ToneFlag::new(),
    )
  }
  if self.frame_count % 15 == 0 {
    let dropped_pos = self.snake.update()
    if self.snake.body.front() == Some(self.fruit) {
      match dropped_pos {
        Some(pos) => self.snake.body.push_back(pos)
        None => ()
      }
      self.fruit = Point::{
        x: random.gen_int().abs() % 20,
        y: random.gen_int().abs() % 20,
      }
    }
  }
  self.snake.draw()
  @wasm4.set_draw_colors(0, index=1)
  @wasm4.set_draw_colors(2, index=2)
  @wasm4.set_draw_colors(3, index=3)
  @wasm4.set_draw_colors(4, index=4)
  fruit.blit(
    self.fruit.x * 8,
    self.fruit.y * 8,
    8,
    8,
    { one_bit_per_pixel: false, flip_x: false, flip_y: false, rotate: false },
  )
}

pub fn input(self : Game) -> Unit {
  let gamepad = @wasm4.get_gamepad()
  if gamepad != self.prev_gamepad {
    if gamepad.button_down {
      self.snake.down()
    }
    if gamepad.button_left {
      self.snake.left()
    }
    if gamepad.button_right {
      self.snake.right()
    }
    if gamepad.button_up {
      self.snake.up()
    }
  }
  self.prev_gamepad = gamepad
}
