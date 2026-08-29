---
layout: post
title:  "I parsed the Apollo 11 flight software and found the landing equation in its own comments"
date:   2026-08-29 12:00:00
categories: apollo
---

The Apollo 11 source has been on GitHub for years. I wanted to know what is
actually in it, so I wrote a parser instead of reading it.

<picture>
  <source srcset="/assets/img/apollo-agc.webp" type="image/webp">
  <img src="/assets/img/apollo-agc.jpg" alt="The AGC source analysis panel, mid-descent" width="1600" height="1228" loading="lazy">
</picture>

It turns 130,000 lines of AGC assembly into JSON: symbol table, call graph,
every alarm site with its octal code, every job the Executive schedules with its
priority, the erasable memory map, and the verb and noun tables the engineers
kept as comment blocks. References resolve at 100% on the lunar module build and
99.99% on the command module.

That 0.01% is the interesting part. Two symbols in Comanche 055 are referenced
and never defined. Not my bug — one of them, `ZEROEROR`, already has a note
about it in the file header from 2009. The parser found a transcription gap by
refusing to guess.

## The equation is in the comments

I expected to reconstruct the landing guidance from papers. I did not have to.
`LUNAR_LANDING_GUIDANCE_EQUATIONS.agc` states it, on listing page 808:

```
                 ___   __       ___   __
  ___   ___   6(VDG + VG)   12(RDG - RG)
  ACG = ADG + ----------- + ------------
                  TTF        (TTF)(TTF)
```

Time to go is negative. The reference trajectory is a polynomial in time
measured backwards from the target, and the signs only work that way. That cost
me an evening.

Ported it. The descent flies: high gate at 2,352 m against the real 2,286,
Armstrong's takeover point at 157 m, touchdown at 742 seconds with 5% of the
propellant left. Apollo 11 landed at about 720 seconds with about the same.

## Two bugs worth writing down

`CLEAR CLEAR` is two opcodes. I had a rule that a token matching a known label
beats an opcode name, and `CLEAR` is both — an interpretive opcode, and a label
in `PINBALL_GAME_BUTTONS_AND_LIGHTS`. Wrong rule. Outside the store class,
interpretive instructions take their operand on the following line, so the
second field is always an opcode.

The entry model peaked at 7.9 g. Apollo 11 pulled 6.56. I spent an hour on the
bank angle controller before working out that the controller was fine: my
atmosphere was an exponential fit anchored at sea level, which overstates
density at 60 km by more than three times, and 60 km is exactly where the
deceleration peak lives. Fixed the fit, got 6.52 g.

## What is real and what is not

Real: the parser, the DSKY layout and its 5-bit key codes — both documented in
the source itself — the descent guidance equation, and the vehicle constants.

Not real: the guidance target set, which was pad-loaded into erasable memory and
is not in the source, so I reconstructed it. The entry bank angle law, because
`REENTRY_CONTROL` is a much bigger piece of software than the landing equation
and porting it is still on the list. And the 1202 alarm, which is scripted
rather than falling out of a genuinely saturated job queue.

I tried to keep that line visible everywhere instead of letting it blur. A
simulation that quietly invents numbers is worth less than one that tells you
which numbers it invented.

Live: [ozergul.dev/apollo-agc](https://ozergul.dev/apollo-agc/)

Source: [github.com/ozergul/apollo-agc](https://github.com/ozergul/apollo-agc)
