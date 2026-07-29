# FIFO Designs in Verilog

[![Language: Verilog](https://img.shields.io/badge/language-Verilog-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![License](https://img.shields.io/badge/license-Not%20specified-lightgrey.svg)](#license)

A compact collection of synthesizable FIFO (First-In, First-Out) designs written in Verilog. The repository contains a single-clock synchronous FIFO and a dual-clock asynchronous FIFO, along with self-contained testbenches, RTL schematics, and simulation waveforms.

## Contents

| Design | Clocking | RTL entry point | Highlights |
| --- | --- | --- | --- |
| [Synchronous FIFO](synchronous_fifo/) | One shared clock | [`fifo_sync`](synchronous_fifo/rtl/fifo_sync.v) | Binary read/write pointers; full and empty flags |
| [Asynchronous FIFO](asynchronous_fifo/) | Independent read and write clocks | [`top`](asynchronous_fifo/rtl/top.v) | Gray-coded pointers, two-flop CDC synchronizers, dual-port memory |

## Repository layout

```text
.
├── synchronous_fifo/
│   ├── rtl/fifo_sync.v
│   ├── testbench_code/fifo_sync_tb.v
│   ├── schematic/
│   └── simulation/
├── asynchronous_fifo/
│   ├── rtl/
│   │   ├── top.v
│   │   ├── fifo_memory.v
│   │   ├── readptr_handler.v
│   │   ├── writeptr_handler.v
│   │   └── synchronizer.v
│   ├── testbench_code/fifo_async_tb.v
│   ├── schematic/
│   └── simulation/
└── docs/
```

## Quick start

The testbenches use standard Verilog. For example, with [Icarus Verilog](https://steveicarus.github.io/iverilog/):

```sh
# Synchronous FIFO
iverilog -g2012 -o sync_fifo_tb synchronous_fifo/rtl/fifo_sync.v synchronous_fifo/testbench_code/fifo_sync_tb.v
vvp sync_fifo_tb

# Asynchronous FIFO
iverilog -g2012 -o async_fifo_tb asynchronous_fifo/rtl/*.v asynchronous_fifo/testbench_code/fifo_async_tb.v
vvp async_fifo_tb
```

The supplied testbenches finish silently. Open the generated VCD only if you add waveform dumping (for example, `$dumpfile` and `$dumpvars`) to the testbench. Reference images are available in each design's `simulation/` directory.

## Design behavior

- A write is accepted only when `wr_en` (or `wr_en` with `cs` in the synchronous design) is asserted and `full` is low.
- A read is accepted only when `rd_en`/`r_en` is asserted and `empty` is low.
- Reads are registered: `data_out` updates on an accepted read clock edge; this is not a first-word-fall-through FIFO.
- The asynchronous FIFO uses independent active-low asynchronous resets: `wrst_n` for the write side and `rrst_n` for the read side.

See the detailed [architecture](docs/ARCHITECTURE.md), [module interface reference](docs/INTERFACES.md), and [verification guide](docs/VERIFICATION.md).

## Important implementation constraints

- The asynchronous FIFO depth must be a power of two (and at least 4 with the current full-flag expression). This is required by the Gray-pointer full detection.
- Although `fifo_sync` declares `DEPTH` and `DATA_WIDTH` parameters, its read/write pointer widths and memory index are currently fixed for an 8-entry FIFO. Use `DEPTH = 8` unless the RTL is updated as described in the architecture notes.
- The designs are educational RTL. Validate timing, reset sequencing, CDC constraints, and target-memory inference in the intended FPGA/ASIC flow before production use.

## Documentation

- [Architecture and design notes](docs/ARCHITECTURE.md)
- [Module interfaces](docs/INTERFACES.md)
- [Simulation and verification](docs/VERIFICATION.md)
- [Contributing guide](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## License

No license file is currently included. Add a `LICENSE` file before inviting reuse or distribution; until then, reuse terms are not explicit.

## Author

Rohit Kumar Panda
