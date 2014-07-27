Please see the code for the full details of the implementation, but in summary:

* SPI Slave code with clock domain crossing
* Requires 2 clocks - one SPI clock from the sender, and a 'user mode' clock to run the logic
* Estimated speed is estimated by (3*tUSER + 2*tSU)/7.5 ns, invert for frequency 
        (and please check my math - no warranties implied)
* 2 Flip-Flop synchronization stage for clock domain crossing
* Single byte FIFO for passing SPI byte to user logic

License is MIT
