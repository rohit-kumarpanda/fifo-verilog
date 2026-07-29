# Simulation and verification

## Included testbenches

| Testbench | DUT | Clocking | Scenarios exercised |
| --- | --- | --- | --- |
| `synchronous_fifo/testbench_code/fifo_sync_tb.v` | `fifo_sync` | One 10 ns-period clock | Reset, writes, reads, full, empty, blocked overflow/underflow |
| `asynchronous_fifo/testbench_code/fifo_async_tb.v` | `top` | 26 ns write clock and 58 ns read clock | Independent clocks, reset, writes, reads, full, empty, blocked overflow/underflow |

## Run with Icarus Verilog

Run commands from the repository root:

```sh
iverilog -g2012 -o sync_fifo_tb synchronous_fifo/rtl/fifo_sync.v synchronous_fifo/testbench_code/fifo_sync_tb.v
vvp sync_fifo_tb

iverilog -g2012 -o async_fifo_tb asynchronous_fifo/rtl/*.v asynchronous_fifo/testbench_code/fifo_async_tb.v
vvp async_fifo_tb
```

The supplied tests use `$finish` and do not print a pass/fail summary. A simulator run that completes without compile/runtime errors confirms only that the directed test ran; it is not a proof of complete functional or CDC correctness.

## Waveform capture

To inspect signals in GTKWave or another viewer, add this near the start of the relevant testbench `initial` block:

```verilog
$dumpfile("fifo.vcd");
$dumpvars(0, fifo_sync_tb); // use fifo_async_tb for the asynchronous testbench
```

Then run the simulation and open `fifo.vcd`:

```sh
gtkwave fifo.vcd
```

Existing reference waveforms are stored in `synchronous_fifo/simulation/` and `asynchronous_fifo/simulation/`.

## Recommended verification additions

- Add a scoreboard queue that compares every accepted read against the oldest accepted write.
- Check the full and empty flags after each transfer, including simultaneous read/write cases for the synchronous FIFO.
- Randomize read/write request timing and data.
- For the asynchronous FIFO, randomize unrelated clock periods and reset assertion/deassertion timing.
- Add assertions that prevent pointer movement on blocked operations and verify FIFO ordering.
- Run CDC analysis in the target implementation flow; simulation alone cannot establish metastability safety.

## Expected properties

1. Data ordering: each accepted read returns the oldest unread accepted write.
2. Overflow protection: writes do not advance the write pointer while `full` is high.
3. Underflow protection: reads do not advance the read pointer while `empty` is high.
4. Reset: pointers return to zero when their applicable reset is asserted.
5. Asynchronous FIFO only: the pointer signal entering each foreign clock domain passes through the corresponding two-flop synchronizer.
