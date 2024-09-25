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

/// (origin and not mask) or (value shift left and mask)
fn bitset(origin : UInt, value : UInt, offset : UInt, width : UInt) -> UInt {
  let mask = ((1 << width.reinterpret_as_int()) - 1) <<
    offset.reinterpret_as_int()
  (origin & mask.reinterpret_as_uint().lnot()) |
  ((value << offset.reinterpret_as_int()) & mask.reinterpret_as_uint())
}
