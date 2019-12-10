# I SPI some Peripherals

This is the repository for a final project in Computer Architecture at Olin College. Our project is based on SPI communication, and in this repository we provide the code to two SPI peripherals which we made in Verilog as well as test benches we used to validate them.

### Requirements
In order to run this code, you must have the following installed:

```
iverilog 10.3

```

And possibly

```
gtkwave 3.3.66

```

### Running the test benches

You can find the test benches in the base of the repository.

If you would like to run the test bench for the multiplier, you can type the following code into the terminal:

```
iverilog -Wall -o testbench1 smolmulti.t.v

./testbench1
```
If you would like to see the simulation in GTKwave, then you can type the following command:

```
gtkwave smolmulti.vcd
```

The same applies for the other two testbenches. For the memory peripheral, type the following commands:


```
iverilog -Wall -o testbench2 smolbaby.t.v

./testbench2

gtkwave bb.vcd
```
Finally, for the testbench that includes both modules together, type :

```
iverilog -Wall -o testbench3 smolboi.t.v

./testbench3

gtkwave smolboi.vcd
```
