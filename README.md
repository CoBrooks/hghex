# hghex

A small, bootstrapped hex digit interpreter used for bootstrapping the rest of
the Homegrown suite of programs (TODO).

## Bootstrapping

hghex can be bootstrapped from its `.hex` source using

```sh
./hghex-seed < hg.hex > hghex
chmod +x hghex
```

and can be verified with

```sh
diff hghex-seed hghex
```

## Assembling from Original Source

hghex uses the [Flat Assembler](https://flatassembler.net) for creating the
initial seed binary:

```sh
fasm hghex.s hghex-seed
```

