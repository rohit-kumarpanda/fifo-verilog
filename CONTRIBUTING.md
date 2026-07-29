# Contributing

Contributions that improve RTL clarity, verification, portability, or documentation are welcome.

## Before opening a pull request

1. Keep changes focused on one concern.
2. Preserve the existing module interfaces unless the pull request clearly documents a breaking change.
3. Run the relevant testbench and include the simulator command and result in the pull-request description.
4. Add or update a test whenever behavior changes.
5. For asynchronous-FIFO changes, explain the CDC and reset implications.

## RTL guidelines

- Use non-blocking assignments in clocked logic.
- Parameterize widths consistently; do not leave fixed pointer or address slices in a depth-parameterized module.
- Keep read- and write-domain logic separate in CDC designs.
- Comment assumptions such as power-of-two depth, reset polarity, and read latency.
- Avoid silently changing memory read behavior, since FPGA/ASIC memory inference may differ.

## Suggested pull-request checklist

- [ ] RTL compiles with the documented command.
- [ ] Relevant testbench completes without errors.
- [ ] Documentation and waveform evidence are updated when behavior changes.
- [ ] Parameters and supported configurations are stated accurately.
- [ ] CDC-sensitive changes have been reviewed with the target flow's CDC tools.
