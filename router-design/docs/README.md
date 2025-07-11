# Router Design Implementation

This project implements a router in Verilog with the following components:
- FIFO buffer
- Finite State Machine (FSM)
- Register module
- Synchronizer module
- Top-level integration

## Block Diagram
![Block Diagram](docs/block_diagram.png)

## Modules
1. **router_fifo**: FIFO buffer implementation
2. **router_fsm**: Finite State Machine controlling packet routing
3. **router_register**: Register module for packet handling
4. **router_synchronizer**: Synchronization module
5. **router_top**: Top-level integration

## Simulation
Each module has its own testbench:
- `router_fifo_tb.v`
- `router_fsm_tb.v`
- `router_register_tb.v`
- `router_synchronizer_tb.v`
- `router_top_tb.v`

## Usage
Simulate using your preferred Verilog simulator (Icarus Verilog, ModelSim, etc.)

```bash
iverilog -o sim router_top_tb.v rtl/*.v
vvp sim