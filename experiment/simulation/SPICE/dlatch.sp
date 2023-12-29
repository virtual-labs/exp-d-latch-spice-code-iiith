*D_Latch*
.include PTM_45nm.txt

.PARAM supply=1.1
.PARAM Lmin=45nm
.PARAM Wmin=45nm
.PARAM Wp={2*Wmin}

vvdd vdd 0 supply
.global vdd gnd

.subckt inverter in out 
MP1 out in vdd vdd pmos w={Wmin} L={Lmin}
Mn1 out in 0 0 NMOS W={Wmin} L={Lmin}
.ends inverter

.subckt pass_transistor control in out
Xinv control not inverter
MP1 out not in vdd pmos w={Wp} L={Lmin}
MN1 out control in 0 nmos W={Wmin} L={Lmin}
.ends

.subckt mux a b s out
Xinvs s s_ inverter

Xpt1 s_ a out pass_transistor
Xpt2 s b out pass_transistor
.ends

.subckt d_latch clk in out
Xinv2 out neg inverter
Xinv1 temp out inverter
Xmux neg in clk temp mux
.ends

Xn a clk out d_latch

*USE '*' for commenting

.PARAM trfin=10p
.PARAM t1 = 10n
.PARAM t2 = 20n
.PARAM t3 = 30n
.PARAM t4 = 40n
.tran 6p 50n

V1 a 0 PWL (0 0 't1' 0 't2' 0 't2+trfin' 'supply' 't3' 'supply' 't4' 'supply')
V2 clk 0 PWL (0 0 't1' 0 't1+trfin' 'supply' 't2' 'supply' 't3' 'supply' 't3+trfin' 0 't4' 0 )


.control
run
*sets background color of plot, comment below line for black background
* set color0=white 
*plots input
plot v(a) v(clk)
*plots output
plot v(out) 

.endc
.end
    