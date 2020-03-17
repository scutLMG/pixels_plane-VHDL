--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

--entity seg_con is
--port(seg_in: in integer;                 
--     seg_out:out integer);
--end seg_con;
--architecture behav of seg_con is

--begin
--seg_out<=seg_in-seg_in;	
--end behav;

--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------
entity seg_con is
  port( clk,reset  :  in std_logic;                               
        plane_health,score_cnt:  in integer;
        ledag      :  out  std_logic_vector(6 downto 0);
        sel        :  out  std_logic_vector(4 downto 0)    
       );      
end seg_con;
--------------------------------------------------------------------
architecture behave of seg_con is
  signal cq              :  std_logic_vector(3 downto 0);--计数
  constant led_num: integer := 4;--使用的数码管数量
 begin
 
--process(clk,reset) 
--      variable  cqi :  std_logic_vector(3 downto 0);
      
--      begin
--        if  reset='0' then  cqi:=(others =>'0');-- 计数器异步复位
--          elsif  clk'event  and  clk='1' then--检测时钟上升沿
--                if  enemy_health='0' and cqi<9  then cqi:=cqi+1;
--              else  cqi:=(others =>'0');
--              end if;
--            --end  if;
--        end if;
--        cq<=cqi;--计数值向端口输出
--     end  process;

process(cq,clk,reset,plane_health)--数码管显示 
      variable var_bit: integer range 0 to led_num+1:=0;--变量，用于选位，0代表初始化
      begin
      if  reset='0' then 
      cq <=(others =>'0');
      sel<="11111";
      elsif (rising_edge(clk)) then
      if  plane_health = 0  then
          var_bit := var_bit + 1;
          if(var_bit=5) then
            var_bit := 1;
          end if;
            case var_bit is
                when 0=> 
                    sel <="01111";
                    ledag <="0000110";
                when 1=> 
                    sel <="01111";
                    ledag <="0000110";
                when 2=> 
                    sel <="10111";
                    ledag <="0010010";
                when 3=> 
                    sel <="11011";
                    ledag <="1000000";
                when 4=> 
                    sel <="11101";
                    ledag <="1000111";
        when 5=>
          sel <="11101";
                    ledag <="0000110";
              end case;
       else
        cq <= conv_std_logic_vector(score_cnt,4);
        sel<="11101";
      case  cq  is
          when  "0000" => ledag <="1000000";
          when  "0001" => ledag <="1111001";
          when  "0010" => ledag <="0100100";
          when  "0011" => ledag <="0110000";
          when  "0100" => ledag <="0011001";
          when  "0101" => ledag <="0010010";
          when  "0110" => ledag <="0000010";
          when  "0111" => ledag <="1111000";
          when  "1000" => ledag <="0000000";
          when  "1001" => ledag <="0010000";
          when  others => null;
     end  case;
     end if;
     end if;
     end process;

  end  behave;
