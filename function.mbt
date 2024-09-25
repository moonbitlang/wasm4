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

type Sprite Bytes

pub fn sprite(bytes : Bytes) -> Sprite {
  Sprite(bytes)
}

/// one_bit_per_pixel: Sprite pixel format: 1BPP or 2BPP
/// flip_x: flip the sprite horizontally
/// flip_y: flip the sprite vertically
/// rotate: rotate the sprite anti-clockwise 90 degrees, applied after any flipping
pub struct BlitFlag {
  one_bit_per_pixel : Bool
  flip_x : Bool
  flip_y : Bool
  rotate : Bool
}

fn to_int(self : BlitFlag) -> Int {
  (if self.one_bit_per_pixel { 0 } else { 1 }) |
  (if self.flip_x { 2 } else { 0 }) |
  (if self.flip_y { 4 } else { 0 }) |
  (if self.rotate { 8 } else { 0 })
}

/// Copies pixels to the framebuffer.
/// 
/// @param spritePtr raw pixel data stored in either 1BPP or 2BPP format.
/// @param x X position in the destination framebuffer.
/// @param y Y position in the destination framebuffer.
/// @param width Width of the sprite.
/// @param height Height of the sprite.
/// @param flags Flags that modify behavior.
pub fn blit(
  self : Sprite,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  flags : BlitFlag
) -> Unit {
  blit_ffi(get_addr(self._), x, y, width, height, flags.to_int())
  ignore(self)
}

/// Copies a subregion within a larger sprite atlas to the framebuffer. Same as blit, but with 3 additional parameters.
/// 
/// @param srcX Source X position of the sprite region.
/// @param srcY Source Y position of the sprite region.
/// @param stride Total width of the overall sprite atlas. This is typically larger than width.
/// For info on other parameters, see blit().
pub fn blit_sub(
  self : Sprite,
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  src_x : Int,
  src_y : Int,
  stride : Int,
  flags : BlitFlag
) -> Unit {
  blit_sub_ffi(
    get_addr(self._),
    x,
    y,
    width,
    height,
    src_x,
    src_y,
    stride,
    flags.to_int(),
  )
  ignore(self)
}

/// Draws a line between two points
/// 
/// `DRAW_COLORS` color 1 is used as the line color
pub fn line(x1 : Int, y1 : Int, x2 : Int, y2 : Int) = "env" "line"

/// Draws a horizontal line between `(x, y)` and `(x + len - 1, y)`
/// 
/// `DRAW_COLORS` color 1 is used as the line color
pub fn hline(x : Int, y : Int, len : Int) = "env" "hline"

/// Draws a vertical line between `(x, y)` and `(x, y + len - 1)`
/// 
/// `DRAW_COLORS` color 1 is used as the line color
pub fn vline(x : Int, y : Int, len : Int) = "env" "vline"

/// Draws an oval (or circle).
/// 
/// `DRAW_COLORS` color 1 is used as the fill color, `DRAW_COLORS` color 2 is used as the outline color.
pub fn oval(x : Int, y : Int, width : Int, height : Int) = "env" "oval"

/// Draws a rectangle.
/// 
/// `DRAW_COLORS` color 1 is used as the fill color, `DRAW_COLORS` color 2 is used as the outline color.
pub fn rect(x : Int, y : Int, width : Int, height : Int) = "env" "rect"

/// Draws text using the built-in system font. The string may contain new-line (`\n`) characters.
/// 
/// The font is 8x8 pixels per character  
/// `DRAW_COLORS` color 1 is used as the text color, `DRAW_COLORS` color 2 is used as the background color.
pub fn text(s : String, x : Int, y : Int) -> Unit {
  let bytes = Bytes::new(s.length() * 4 + 1)
  let mut offset = 0
  s.iter().each(fn { ch => offset += bytes.set_utf8_char(offset, ch) })
  text_ffi(get_addr(bytes), x, y)
  ignore(bytes)
}

/// An ADSR volume envelop
/// 
/// The envelope starts at zero volume, 
/// then raises to the peak volume over the attack time, 
/// lowers to the sustain volume during the decay time, 
/// remains at the sustain volume during the sustain time, 
/// and finally fades to zero volume during the release time.  
/// Duration of each phase is specified in frames (1/60th of a second).
pub(readonly) struct ADSR {
  sustain : UInt
  release : UInt
  decay : UInt
  attack : UInt
}

/// An ADSR volume envelop
/// 
/// The envelope starts at zero volume, 
/// then raises to the peak volume over the attack time, 
/// lowers to the sustain volume during the decay time, 
/// remains at the sustain volume during the sustain time, 
/// and finally fades to zero volume during the release time.  
/// Duration of each phase is specified in frames (1/60th of a second).
pub fn ADSR::new(
  sustain : UInt,
  ~release : UInt = 0,
  ~decay : UInt = 0,
  ~attack : UInt = 0
) -> ADSR {
  { sustain, release, decay, attack }
}

/// The volume of an ADSR envelope
/// 
/// The volume used for the sustain duration, and the peak volume (default to 100 if zero) reached by the attack duration.
pub(readonly) struct ADSRVolume {
  sustain : UInt
  peak : UInt
}

/// The volume of an ADSR envelope
/// 
/// The volume used for the sustain duration, and the peak volume (default to 100 if zero) reached by the attack duration.
pub fn ADSRVolume::new(sustain : UInt, ~peak : UInt = 100) -> ADSRVolume {
  { sustain, peak }
}

/// Notes with pitch bend
/// 
/// @param note Specified in MIDI note format, e.g. 60 = C4, 69 = A4.  
/// @param bend Bend note upwards. 0 = Nothing, 255 = One 256th away from the next note above
pub(readonly) struct Note {
  note : UInt
  bend : UInt
}

/// Notes with pitch bend
/// 
/// @param note Specified in MIDI note format, e.g. 60 = C4, 69 = A4.  
/// @param bend Bend note upwards. 0 = Nothing, 255 = One 256th away from the next note above
pub fn Note::new(note : UInt, ~bend : UInt = 0) -> Note {
  { note, bend }
}

/// Flags that modify behavior of `tone`
pub(readonly) struct ToneFlag {
  channel : ToneChannel
  mode : ToneMode
  pan : TonePan
}

/// Flags that modify behavior of `tone`
pub fn ToneFlag::new(
  ~channel : ToneChannel = Pulse1,
  ~mode : ToneMode = Duty_1_8,
  ~pan : TonePan = Center
) -> ToneFlag {
  { channel, mode, pan }
}

pub enum ToneChannel {
  Pulse1
  Pulse2
  Triangle
  Noise
}

pub enum ToneMode {
  Duty_1_8
  Duty_1_4
  Duty_1_2
  Duty_3_4
}

pub enum TonePan {
  Center
  Left
  Right
}

/// Plays a sound tone
/// 
/// @param frequency Start frequency and optional end frequency presented in hertz  
/// @param duration Duration of the tone in frames (1/60th of a second), up to 255 frames for each phase  
/// @param volume Volume of the sustain and attack durations, between 0 and 100  
/// @param flags Flags that modify behavior
pub fn tone(
  frequency : (UInt, UInt),
  duration : ADSR,
  volume : ADSRVolume,
  flags : ToneFlag
) -> Unit {
  let frequency = frequency.0 | (frequency.1 << 16)
  let duration = (duration.attack << 24) |
    (duration.decay << 16) |
    (duration.release << 8) |
    duration.sustain
  let volume = (volume.peak << 8) | volume.sustain
  let flags = {
    let pan = match flags.pan {
      Center => 0U
      Left => 1
      Right => 2
    }
    let mode = match flags.mode {
      Duty_1_8 => 0U
      Duty_1_4 => 1
      Duty_1_2 => 2
      Duty_3_4 => 3
    }
    let channel = match flags.channel {
      Pulse1 => 0U
      Pulse2 => 1
      Triangle => 2
      Noise => 3
    }
    (pan << 4) | (mode << 2) | channel
  }
  tone_ffi(frequency, duration, volume, flags)
}

/// Plays a sound tone in note mode
/// 
/// @param frequency Start frequency and optional end frequency presented in MIDI note  
/// @param duration Duration of the tone in frames (1/60th of a second), up to 255 frames for each phase  
/// @param volume Volume of the sustain and attack durations, between 0 and 100  
/// @param flags Flags that modify behavior
pub fn tone_note_mode(
  frequency : (Note, Note?),
  duration : ADSR,
  volume : ADSRVolume,
  flags : ToneFlag
) -> Unit {
  let higher_note = frequency.1.or({ note: 0, bend: 0 })
  let frequency = frequency.0.note |
    (frequency.0.bend << 8) |
    ((higher_note.note | (higher_note.bend << 8)) << 16)
  let duration = (duration.attack << 24) |
    (duration.decay << 16) |
    (duration.release << 8) |
    duration.sustain
  let volume = (volume.peak << 8) | volume.sustain
  let flags = {
    let pan = match flags.pan {
      Center => 0U
      Left => 1
      Right => 2
    }
    let mode = match flags.mode {
      Duty_1_8 => 0U
      Duty_1_4 => 1
      Duty_1_2 => 2
      Duty_3_4 => 3
    }
    let channel = match flags.channel {
      Pulse1 => 0U
      Pulse2 => 1
      Triangle => 2
      Noise => 3
    }
    (pan << 4) | (mode << 2) | channel | 0b1000000
  }
  tone_ffi(frequency, duration, volume, flags)
}

/// Writes up to `size` bytes from `bytes` into persistent storage.
///
/// Any previously saved data on the disk is replaced.
/// @return the number of bytes written, which may be less than `size`.
pub fn disk_write(bytes : Bytes, size : UInt) -> Int {
  if size > 1024 {
    trace("Disk write size exceeds 1024 bytes")
    panic()
  }
  diskw_ffi(get_addr(bytes), size.reinterpret_as_int())
}

/// Reads up to `size` bytes from persistent storage into `bytes`.
/// 
/// @return the number of bytes read, which may be less than `size`
pub fn disk_read(bytes : Bytes, size : UInt) -> Int {
  if size > 1024 {
    trace("Disk write size exceeds 1024 bytes")
    panic()
  }
  diskr_ffi(get_addr(bytes), size.reinterpret_as_int())
}

/// Prints a message to the debug console
pub fn trace(s : String) -> Unit {
  let bytes = Bytes::new(s.length() * 4 + 1)
  let mut offset = 0
  s.iter().each(fn { ch => offset += bytes.set_utf8_char(offset, ch) })
  trace_ffi(get_addr(bytes))
  ignore(bytes)
}
