// @ts-check

import fs from "node:fs";
import electron from "electron";

/**
 * Add the `compileOptions` parameter missing from TypeScript's WASM typings.
 * See: https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/JavaScript_interface/instantiate_static#syntax
 *
 * @type {(
 *     bytes: BufferSource,
 *     importObject?: WebAssembly.Imports,
 *     compileOptions?: {
 *         builtins?: ["js-string"];
 *         importedStringConstants?: string;
 *     },
 * ) => Promise<WebAssembly.WebAssemblyInstantiatedSource>}
 */
const WebAssembly_instantiate = WebAssembly.instantiate;

const wasm = fs.readFileSync("index.wasm");
const imports = Object.assign(globalThis, electron);
await WebAssembly_instantiate(wasm, Object(imports), { importedStringConstants: "" });
