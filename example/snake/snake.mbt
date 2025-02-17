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
pub(all) struct Point {
  x : Int
  y : Int
} derive(Eq)

///|
pub(all) struct Snake {
  body : @deque.T[Point]
  mut direction : Point
}

///|
pub fn Snake::new() -> Snake {
  {
    body: @deque.of([
      Point::{ x: 2, y: 0 },
      Point::{ x: 1, y: 0 },
      Point::{ x: 0, y: 0 },
    ]),
    direction: Point::{ x: 1, y: 0 },
  }
}

///|
pub fn draw(self : Snake) -> Unit {
  @wasm4.set_draw_colors(4, index=2)
  @wasm4.set_draw_colors(3)
  self.body.iter().each(fn { { x, y } => @wasm4.rect(x * 8, y * 8, 8, 8) })
  @wasm4.set_draw_colors(4)
  self.body.front().map(fn { { x, y } => @wasm4.rect(x * 8, y * 8, 8, 8) })
  |> ignore
}

///|
pub fn Snake::update(self : Snake) -> Point? {
  let head = self.body.front().unwrap()
  self.body.push_front(Point::{
    x: (head.x + self.direction.x + 20) % 20,
    y: (head.y + self.direction.y + 20) % 20,
  })
  self.body.pop_back()
}

///|
pub fn up(self : Snake) -> Unit {
  if self.direction.y == 0 {
    self.direction = Point::{ x: 0, y: -1 }
  }
}

///|
pub fn down(self : Snake) -> Unit {
  if self.direction.y == 0 {
    self.direction = Point::{ x: 0, y: 1 }
  }
}

///|
pub fn left(self : Snake) -> Unit {
  if self.direction.x == 0 {
    self.direction = Point::{ x: -1, y: 0 }
  }
}

///|
pub fn right(self : Snake) -> Unit {
  if self.direction.x == 0 {
    self.direction = Point::{ x: 1, y: 0 }
  }
}

///|
pub fn is_dead(self : Snake) -> Bool {
  self.body
  .iter()
  .drop(1)
  .find_first(fn { point => point == self.body.front().unwrap() })
  .is_empty()
  |> not()
}
