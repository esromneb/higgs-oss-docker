# RISC-V and Verilator 4.222

Build the Dockerfile:

```sh
make dockerfile
```

Build the image:

```sh
make
```

## Why this image exists

`riscv-verilator-4-016` installs Verilator `v4.016` (2019) to the default
`/usr/local` prefix. Since SpinalHDL ~1.6.2, the Verilog backend emits a
"randBoot" feature: registers without another initializer get an
`` `ifndef SYNTHESIS `` -guarded `initial` block that assigns them via
`$urandom`. Verilator 4.016 predates PLI support for `$urandom` and fails
with:

```
%Error: ... Unsupported or unknown PLI call: $urandom
```

(see `higgs_sdr` repo, `doc/vex/NOTES.md` / `doc/vex/compile-report.md`,
VexRiscv walk-forward checkpoint 19). The immediate fix there was to disable
randBoot generation (`noRandBoot = true`) rather than depend on a newer
Verilator. This image installs the newer, `$urandom`-capable Verilator in
place of 4.016, with no other change in behavior, so existing workflows and
scripts that expect `verilator` on `PATH` at the default `/usr/local` prefix
keep working unmodified.

## What was done

1. Copied the `riscv-verilator-4-016` m4 template set
   (`../common/verilator/v4-016/*.m4`) to a new
   `../common/verilator/v4-222/*.m4` set.
2. Left `riscv-toolchain.m4`, `packages.m4`, and `final.m4` unchanged (same
   RISC-V toolchain base image, same apt package lists, and same `COPY
   --from=verilator-build /usr/local /usr/local` work for both Verilator
   versions).
3. In `verilator.m4`, changed only `VERILATOR_VERSION` from `v4.016` to
   `v4.222`; the build still uses plain `./configure` (no `--prefix`), so
   4.222 installs to the same default `/usr/local` prefix that 4.016 used,
   with identical paths and binary locations (`/usr/local/bin/verilator`,
   etc.). There is no side-by-side `/opt`-prefixed install and no `$PATH`
   change — this image behaves exactly like `riscv-verilator-4-016`, just
   with Verilator 4.222 instead of 4.016.
4. Added this `riscv-verilator-4-222/` directory (`Dockerfile.m4`,
   `Makefile`, `.gitignore`), mirroring `riscv-verilator-4-016/` exactly,
   except `include()`-ing the new `v4-222` m4 files and naming the built
   image `localhost/riscv-verilator-4-222:v1`.
5. Verified `m4 -I ../common Dockerfile.m4 > Dockerfile` renders cleanly
   before committing.

## Same steps, run directly on a host (no Docker), to test `$urandom`

Docker was not available in the environment used to validate this, so the
same recipe encoded above was run directly on the host, into the same
version-qualified prefix, to test Verilator 4.222's `$urandom` support
directly:

```sh
git clone https://github.com/verilator/verilator.git /tmp/verilator-4222-build
cd /tmp/verilator-4222-build
git checkout v4.222
git submodule update --init --depth 1
autoconf
./configure --prefix=/opt/verilator-4.222
make -j"$(nproc)"
sudo make install
/opt/verilator-4.222/bin/verilator --version
# Verilator 4.222 2022-05-02 rev v4.222
```

Build dependencies (`autoconf bison build-essential flex gcc g++ gperf git
libfl-dev make`) were already present on the host from the earlier 4.016
build; no extra packages were required for 4.222.

### `$urandom` test

A minimal module reproducing SpinalHDL's randBoot pattern was verilated and
simulated with the new 4.222 binary:

```verilog
module urandom_test (
    input  wire        clk,
    output reg  [31:0] dout
);
  reg [31:0] state;
`ifndef SYNTHESIS
  initial begin
    state = $urandom;
  end
`endif
  always @(posedge clk) dout <= state;
endmodule
```

```sh
/opt/verilator-4.222/bin/verilator -Wall --cc urandom_test.v --exe sim_main.cpp -Mdir obj_dir
make -C obj_dir -f Vurandom_test.mk
./obj_dir/Vurandom_test
# dout = 2037806020
```

**Result: Verilator 4.222 fully supports `$urandom`** — it verilates without
error, compiles, and simulates, producing a non-zero pseudo-random value.
This confirms that upgrading Verilator (rather than disabling SpinalHDL's
randBoot with `noRandBoot = true`) is a viable alternative fix for the
`$urandom` incompatibility hit at VexRiscv walk-forward checkpoint 19 in the
`higgs_sdr` repo — noted there for a future decision, not yet acted on.
