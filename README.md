# Wasm4 Binding for MoonBit

This is an opinionated binding for [Wasm4](https://wasm4.org) in MoonBit.

## Prerequisites

- MoonBit toolchain
- [Node.js](https://nodejs.org/en)

## Usage

- Add this package: `moon add moonbitlang/wasm4`
- Develop with this package as other packages
- Optionally export a function called `start` that will be executed once on
  initialization and export a function called `update` that will be executed at
  60Hz for the expected backend
- Import a memory with the module of `env` and name of `memory`
- Build with `moon build --target <wasm-gc or wasm>` with the respective backend
- Execute `npx wasm4 run <target>.wasm`. The target should be located in
  `target/wasm/release/build/<package path>/<package name>.wasm` for wasm
  backend, or `target/wasm-gc/release/build/<package path>/<package name>.wasm`
  for wasm-gc backend. The browser should open automatically and display the
  game. Enjoy

## Examples

The snake example (adapted from the Wasm4 documentation) demonstrates the usage. You may execute

```bash
moon build --source-dir example/snake --target wasm
npx wasm4 run example/snake/target/wasm/release/build/snake.wasm
```

and enjoy the game.

## References

- For more information about MoonBit, visit:
  [MoonBit official website](https://www.moonbitlang.com/docs/syntax)
- For more information about Wasm4 and how to play, visit:
  [WASM-4 Documentation](https://wasm4.org/docs/)
