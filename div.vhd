LIBRARY ieee;
 USE ieee.std_logic_1164.all;
 USE ieee.std_logic_arith.all; 
 USE ieee.std_logic_unsigned.all;
 
 ENTITY div IS
   PORT(clk_in: IN STD_LOGIC ;
        clk_out:OUT STD_LOGIC);
 END ENTITY;
  
ARCHITECTURE reg OF div IS
SIGNAL ten_hz:  STD_LOGIC;--10Hz
BEGIN
  PROCESS(clk_in)
   VARIABLE cout:INTEGER:=0;
    BEGIN
      IF clk_in'EVENT AND clk_in='1' THEN
         cout:=cout+1;
         IF cout<=2500000 THEN ten_hz<='0';
         ELSIF cout<5000000 THEN ten_hz<='1';
         ELSE cout:=0;
         END IF;
      clk_out<=ten_hz;
      END IF;
  END PROCESS;
END reg;