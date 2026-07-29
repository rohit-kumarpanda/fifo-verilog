# Module interface reference

## `fifo_sync`

Source: [`synchronous_fifo/rtl/fifo_sync.v`](../synchronous_fifo/rtl/fifo_sync.v)

| Name | Direction | Description |
| --- | --- | --- |
| `clk` | input | Shared clock for all FIFO operations. |
| `rst` | input | Active-high asynchronous reset. Clears pointers, output register, and memory. |
| `cs` | input | Chip select; must be asserted for a read or write to be accepted. |
| `wr_en` | input | Write request. Accepted when `cs` is high and `full` is low. |
| `rd_en` | input | Read request. Accepted when `cs` is high and `empty` is low. |
| `data_in[DATA_WIDTH-1:0]` | input | Data presented for an accepted write. |
| `data_out[DATA_WIDTH-1:0]` | output | Registered data from an accepted read. |
| `empty` | output | High when no readable entries are present. |
| `full` | output | High when no additional write is accepted. |

Parameters: `DATA_WIDTH` defaults to 16. `DEPTH` defaults to 8 and must remain 8 with the current pointer implementation.

## `top` (asynchronous FIFO)

Source: [`asynchronous_fifo/rtl/top.v`](../asynchronous_fifo/rtl/top.v)

| Name | Direction | Clock domain | Description |
| --- | --- | --- | --- |
| `data_in[DATA_WIDTH-1:0]` | input | write | Data presented for an accepted write. |
| `wr_en` | input | write | Write request; accepted when `full` is low. |
| `w_clk` | input | write | Write-domain clock. |
| `wrst_n` | input | write | Active-low asynchronous write-domain reset. |
| `r_en` | input | read | Read request; accepted when `empty` is low. |
| `r_clk` | input | read | Read-domain clock. |
| `rrst_n` | input | read | Active-low asynchronous read-domain reset. |
| `data_out[DATA_WIDTH-1:0]` | output | read | Registered data from an accepted read. |
| `empty` | output | read | Read-domain empty indication. |
| `full` | output | write | Write-domain full indication. |

Parameters: `DATA_WIDTH` defaults to 16; `FIFO_DEPTH` defaults to 8. `FIFO_DEPTH` must be a power of two and currently must be at least 4.

### Example instantiation

```verilog
top #(
    .DATA_WIDTH(32),
    .FIFO_DEPTH(16)
) u_async_fifo (
    .data_in (tx_data),
    .wr_en   (tx_valid),
    .w_clk   (tx_clk),
    .wrst_n  (tx_reset_n),
    .r_en    (rx_ready),
    .r_clk   (rx_clk),
    .rrst_n  (rx_reset_n),
    .data_out(rx_data),
    .empty   (rx_empty),
    .full    (tx_full)
);
```

Gate write requests with `!tx_full` and read requests with `!rx_empty` in surrounding control logic. The module also internally blocks invalid transfers.
