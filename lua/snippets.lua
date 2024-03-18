local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

ls.add_snippets("all", {
  s("ter", {
    i(1), t' ? ', i(2), t' : ', i(3)
  }),
})

ls.add_snippets("javascript", {
  -- Arrow functions.
  s("af", {
    t'(', i(1), t{ ') => {', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),
  s("aaf", {
    t'async (', i(1), t{ ') => {', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),

  -- Await.
  s("aw", {
    t'await ', i(1)
  }),

  -- const
  s("c", {
    t'const ', i(1), t' = ', i(2),
  }),
  s("caw", {
    t'const ', i(1), t' = await ', i(2),
  }),
  s("caf", {
    t'const ', i(1), t' = (', i(2), t{ ') => {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("caaf", {
    t'const ', i(1), t' = async (', i(2), t{ ') => {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("cii", {
    t'const ', i(1), t' = ((', i(2), t{ ') => {', '' },
    t'    ', i(3),
    t{ '', '})()' }
  }),
  s("cm", {
    t'const ', i(1, 'newArray'), t' = ', i(2, 'items'), t'.map((', i(3, 'item'), t{ ') => {', '' },
    t'    return ', i(4), t{ '', '' },
    t'})'
  }),
  s("cr", {
    t'const ', i(1, 'result'), t' = ', i(2, 'items'), t'.reduce((', i(3, 'acc'), t', ', i(4, 'item'), t{ ') => {', '' },
    t'    return ', i(5, 'acc + item'), t{ '', '' },
    t'}, ', i(6, 'initial'), t')'
  }),
  s("cn", {
    t'const ', i(1, 'foo'), t' = new ', i(2, 'Foo'), t'(', i(3), t')'
  }),

  -- console
  s("cl", {
    t'console.log(', i(1), t')'
  }),
  s("cll", {
    t'console.log("---------- ', i(1), t':", ', i(2), t')'
  }),
  s("ce", {
    t'console.error("Error:", ', i(1), t')'
  }),

  -- class
  s("cla", {
    t'class ', i(1, 'Foo'), t{ ' {', '' },
    t'    ', i(2),
    t{ '', '}'}
  }),
  s("clac", {
    t'constructor (', i(1), t{ ') {', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),
  s("clacs", {
    t'constructor (', i(1), t{ ') {', '' },
    t{ '    super()', '', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),
  s("clae", {
    t'class ', i(1, 'Foo'), t' extends ', i(2, 'Bar'), t{ ' {', '' },
    t'    ', i(3),
    t{ '', '}'}
  }),
  s("clai", {
    t'class ', i(1, 'Foo'), t' implements ', i(2, 'Bar'), t{ ' {', '' },
    t'    ', i(3),
    t{ '', '}'}
  }),

  -- Class methods.
  s({
    trig = "claam",
    dscr = "A class async method."
  }, {
    t'async ', i(1), t'(', i(2), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("clam", {
    i(1), t'(', i(2), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s({
    trig = "clapam",
    dscr = "A class private async method."
  }, {
    t'private async ', i(1), t'(', i(2), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("clapm", {
    t'private ', i(1), t'(', i(2), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),

  -- Debug.
  s("deb", {
    t{ '', 'debugger', '' },
  }),

  -- Errors.
  s("ne", {
    t'Error("', i(1, 'My message'), t'.")'
  }),
  s("tne", {
    t'throw Error("', i(1, 'My message'), t'.")'
  }),

  -- export
  s("ex", {
    t'export { ', i(1), t' }'
  }),
  s("exl", {
    t'export let ', i(1),
  }),
  s("ext", {
    t'export type { ', i(1), t' }'
  }),

  -- if
  s("if", {
    t'if (', i(1, 'condition'), t{ ') {', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),
  s("ife", {
    t'if (', i(1, 'condition'), t{ ') {', '' },
    t'    ', i(2), t{ '', '' },
    t'} else {', t{ '', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),

  -- import
  s("im", {
    t'import { ', i(1), t' } from "', i(2), t'"'
  }),
  s("imt", {
    t'import type { ', i(1), t' } from "', i(2), t'"'
  }),

  -- let
  s("l", {
    t'let ', i(1), t' = ', i(2),
  }),
  s("law", {
    t'let ', i(1), t' = await ', i(2),
  }),

  -- Loops.
  s("do", {
    t{ 'do {', '' },
    t'    ', i(1), t{ '', '' },
    t'} while (', i(2, 'condition'), t')'
  }),
  s("for", {
    t'for (let i = ', i(1, '0'), t'; i < ', i(2, 'array'), t{ '.length; i += 1) {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("fore", {
    i(1, 'items'), t'.forEach((', i(2, 'item'), t{ ') => {', '' },
    t'    ', i(3),
    t{ '', '})' }
  }),
  s("fori", {
    t'for (const ', i(1, 'key'), t' in ', i(2, 'object'), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("foro", {
    t'for (const ', i(1, 'entry'), t' of ', i(2, 'arrayOrMapOrSet'), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("w", {
    t'while (', i(1, 'condition'), t{ ') {', '' },
    t'    ', i(2), t{ '', '' },
    t'}'
  }),

  -- Promises.
  s("np", {
    t{ 'new Promise((resolve, reject) => {', '' },
    t'    ', i(1), t{ '', '' },
    t'})'
  }),

  -- return
  s("r", {
    t'return ', i(1)
  }),

  -- switch
  s("sw", {
    t'switch (', i(1, 'expr'), t{') {', '' },
    t'    case ', i(2, '"A"'), t{ ':', '' },
    t'        ', i(3, 'console.log("A")'), t{ ';', '' },
    t{ '        break;', '' },
    t'    case ', i(4, '"B"'), t{ ':', '' },
    t'    case ', i(5, '"C"'), t{ ':', '' },
    t'        ', i(6, 'console.log("B or C")'), t{ ';', '' },
    t{ '        break;', '' },
    t{ '    default:', '' },
    t'        ', i(7, 'console.log("Neither")'), t{ ';', '' },
    t'}'
  }),

  -- this
  s("t", {
    t'this.', i(1)
  }),
  s("tt", {
    t'this.', i(1), t' = ', i(2),
  }),

  -- try
  s("try", {
    t{ 'try {', '' },
    t'    ', i(1), t{ '', '' },
    t'} catch (', i(2, 'error'), t{ ') {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
})

ls.filetype_extend("typescript", { "javascript" })
ls.add_snippets("typescript", {
  -- Arrow functions.
  s("af", {
    t'(', i(1), t'): ', i(2, 'void'), t{ ' => {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),
  s("aaf", {
    t'async (', i(1), t'): Promise<', i(2, 'void'), t{ '> => {', '' },
    t'    ', i(3), t{ '', '' },
    t'}'
  }),

  -- const
  s("caaf", {
    t'const ', i(1), t' = async (', i(2), t'): Promise<', i(3, 'void'), t{ '> => {', '' },
    t'    ', i(4), t{ '', '' },
    t'}'
  }),

  -- Class methods.
  s({
    trig = "claam",
    dscr = "A class async method."
  }, {
    t'async ', i(1), t'(', i(2), t'): Promise<', i(3, 'void'), t{ '> {', '' },
    t'    ', i(4), t{ '', '' },
    t'}'
  }),
  s({
    trig = "clapam",
    dscr = "A class private async method."
  }, {
    t'private async ', i(1), t'(', i(2), t'): Promise<', i(3, 'void'), t{ '> {', '' },
    t'    ', i(4), t{ '', '' },
    t'}'
  }),

  -- interface
  s("in", {
    t'interface ', i(1, 'Bar'), t{ ' {', '' },
    t'    ', i(2),
    t{ '', '}'}
  }),
})

ls.filetype_extend("svelte", { "typescript", "javascript" })
ls.add_snippets("svelte", {
  s("cs", {
    t'class="', i(1), t{ '"' },
  }),
  s("sc", {
    t'{@const ', i(1), t' = ', i(2), t{ '}' },
  }),
  s("sif", {
    t'{#if ', i(1, 'condition'), t{ '}', '' },
    i(2),
    t{ '', '{/if}' }
  }),
  s("sife", {
    t'{#if ', i(1, 'condition'), t{ '}', '' },
    i(2),
    t{ '', '{:else}', '' },
    i(3),
    t{ '', '{/if}' }
  }),
  s("se", {
    t'{#each ', i(1, 'items'), t' as ', i(2, 'item'), t{ '}', '' },
    i(3),
    t{ '', '{/each}' }
  }),
  s("sei", {
    t'{#each ', i(1, 'items'), t' as ', i(2, 'item'), t{ ', i}', '' },
    i(3),
    t{ '', '{/each}' }
  }),
  s("ssc", {
    t{ '<script lang="ts">', '' },
    i(1),
    t{ '', '</script>' }
  }),
  s("sscm", {
    t{ '<script context="module" lang="ts">', '' },
    i(1),
    t{ '', '</script>' }
  }),
  s("sst", {
    t{ '<style>', '' },
    i(1),
    t{ '', '</style>' }
  }),
})
