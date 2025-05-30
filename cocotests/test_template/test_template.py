import cocotb
from cocotb.clock import Clock
from cocotb.triggers import (
    RisingEdge, FallingEdge,
    Timer
)

async def write(dut):
    dut.w_rst_n.value = 0
    dut.w_en.value = 0
    dut.w_data.value = 0

    for i in range(3):
        await RisingEdge(dut.w_clk)

    dut.w_rst_n.value = 1

    for i in range(3):
        await RisingEdge(dut.w_clk)

    dut.w_en.value = 1
    for i in range(15):
        dut.w_data.value = i
        await RisingEdge(dut.w_clk)
        
    dut.w_en.value = 0

    for i in range(15):
        await RisingEdge(dut.w_clk)

    dut.w_en.value = 1
    for i in range(5):
        dut.w_data.value = i
        await RisingEdge(dut.w_clk)

    dut.w_en.value = 0

    pass

async def read(dut):
    dut.r_rst_n.value = 0
    dut.r_en.value = 0

    for i in range(2):
        await RisingEdge(dut.r_clk)

    dut.r_rst_n.value = 1

    for i in range(14):
        await RisingEdge(dut.r_clk)

    dut.r_en.value = 1
    await RisingEdge(dut.r_clk)
    dut.r_en.value = 0
    await RisingEdge(dut.r_clk)
    dut.r_en.value = 1

    pass

@cocotb.test()
async def template_test(dut):
    cocotb.start_soon(Clock(dut.r_clk, 20, units='ns').start())
    cocotb.start_soon(Clock(dut.w_clk, 12, units='ns').start())

    write_task = cocotb.start_soon(write(dut))
    read_task = cocotb.start_soon(read(dut))

    await write_task
    await read_task

    await Timer(500, units='ns')
