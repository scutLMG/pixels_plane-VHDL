library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pixel_airwar is
    Port (  clk: in std_logic;                        
            rst,start:in std_logic;                                                      
            fire,right,left: in std_logic;                
            hs,vs: out std_logic;                           
            pic_rgb: out std_logic_vector(2 downto 0);
            seg_num : out  std_logic_vector(6 downto 0);
        	sel : out  std_logic_vector(4 downto 0));     
end pixel_airwar;


architecture behav of pixel_airwar is
signal clk_t,clk_al,clk_out: std_logic;
signal hcnt,vcnt,score_cnt:integer;
signal plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en,enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y:integer;
---------------------------------------------------------------------------------     

component div is
	port (clk_in: IN STD_LOGIC ;
        clk_out: OUT STD_LOGIC	
	);
end component div;

component vga is
	port (
	clk: in std_logic;         
    reset:in std_logic;        
    hs,vs:out std_logic;       
    hcnt,vcnt: buffer integer
	);
end component vga;

component seg_con is
	port (
		clk,reset  :  in std_logic;                               
        plane_health,score_cnt:  in integer;
        ledag      :  out  std_logic_vector(6 downto 0); 
        sel        :  out  std_logic_vector(4 downto 0)      
	);
end component seg_con;

component display is
 	port (
 		clk : in std_logic;
	    hcnt,vcnt : in integer; 
	    plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en:in integer;   
	    enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y:in integer;                                           
		pic_rgb:out std_logic_vector(2 downto 0)
 	);
end component display; 
 
component action_logic is
 	port (
 		fire,rst,start : in std_logic;          
		plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en:out integer;           
        enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y:out integer;  
        move_left,move_right:in std_logic;                         
		score_cnt:out integer;                                                     
        clk_al,clk:in std_logic
 	);
end component action_logic;
  
begin

  process (rst,clk)
    begin
    if rst ='0' then
       clk_t<='0';
    elsif clk'event and clk='1' then 
        clk_t<=not clk_t;
    end if;
 end process;


divi: div port map
    (clk,clk_out);


vgac: vga port map
    (clk_t,rst,hs,vs,hcnt,vcnt);


displayc: display port map
    ( clk_t,hcnt,vcnt, plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en,enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y,pic_rgb);

action: action_logic port map
	(fire,rst,start,plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en,enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y,left,right,score_cnt,clk_out,clk);

segc:seg_con port map
	(clk_out,rst,plane_health,score_cnt,seg_num,sel); 		  
          
end behav;