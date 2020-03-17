library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is
    Port ( clk : in std_logic;
	        hcnt,vcnt : in integer; 
	        plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en:in integer;   
	        enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y:in integer;                                           
			pic_rgb:out std_logic_vector(2 downto 0));
end display;

architecture behav of display is
----------------------------------------------------------------------
signal midx_p,midy_p,midx_e0,midy_e0,midx_e1,midy_e1,midx_e2,midy_e2,midx_e3,midy_e3,midx_e4,midy_e4,midx_s,midy_s:std_logic_vector(10 downto 0);
signal data_s,data_p,data_e0,data_e1,data_e2,data_e3,data_e4:std_logic;
signal plane_rgb,enemy0_rgb,enemy1_rgb,enemy2_rgb,enemy3_rgb,enemy4_rgb,shoot_rgb:std_logic_vector(2 downto 0);

component pixel_plane is
	port (
		x_p,y_p: in std_logic_vector(5 downto 0); --the xy for the plane
        x_s,y_s:in std_logic_vector(3 downto 0); --for shooting
        d_p,d_s: out std_logic
	);
end component pixel_plane;


component p_enemy is
    port(
	x_e,y_e: in std_logic_vector(5 downto 0); --the xy for the plane and the enemy 
    d_e: out std_logic 
    );
end component ;


begin
--generate plane
midx_p<=conv_std_logic_vector(hcnt-plane_x,11);
midy_p<=conv_std_logic_vector(vcnt-plane_y,11);

midx_s<=conv_std_logic_vector(hcnt-shoot_x,11);
midy_s<=conv_std_logic_vector(vcnt-shoot_y,11);

--generate enemies
midx_e0<=conv_std_logic_vector(hcnt-enemy0_x,11);
midy_e0<=conv_std_logic_vector(vcnt-enemy0_y,11);
midx_e1<=conv_std_logic_vector(hcnt-enemy1_x,11);
midy_e1<=conv_std_logic_vector(vcnt-enemy1_y,11);
midx_e2<=conv_std_logic_vector(hcnt-enemy2_x,11);
midy_e2<=conv_std_logic_vector(vcnt-enemy2_y,11);
midx_e3<=conv_std_logic_vector(hcnt-enemy3_x,11);
midy_e3<=conv_std_logic_vector(vcnt-enemy3_y,11);
midx_e4<=conv_std_logic_vector(hcnt-enemy4_x,11);
midy_e4<=conv_std_logic_vector(vcnt-enemy4_y,11);

plane:pixel_plane  port map
			(midx_p(5 downto 0),
			 midy_p(5 downto 0),
			 midx_s(3 downto 0),
			 midy_s(3 downto 0),
			 data_p,
			 data_s);


enemy_0:p_enemy  port map
			(midx_e0(5 downto 0),
			 midy_e0(5 downto 0),
			 data_e0);
			 
enemy_1:p_enemy  port map
			(midx_e1(5 downto 0),
			 midy_e1(5 downto 0),
			 data_e1);


enemy_2:p_enemy  port map
			(midx_e2(5 downto 0),
			 midy_e2(5 downto 0),
			 data_e2);


enemy_3:p_enemy  port map
			(midx_e3(5 downto 0),
			 midy_e3(5 downto 0),
			 data_e3);


enemy_4:p_enemy  port map
			(midx_e4(5 downto 0),
			 midy_e4(5 downto 0),
			 data_e4);
			 


draw: process (clk)
begin
	if clk'event and clk='1' then
		if plane_health/=0 then
			if ((hcnt>=plane_x)) and (hcnt<=(plane_x+32)) and (vcnt>=(plane_y)) and (vcnt<=(plane_y+32)) then
				plane_rgb <= "00"&data_p;
			else
				plane_rgb <= "000";
			end if;

			if shoot_en/=0 then
				if ((hcnt>=shoot_x)) and (hcnt<=(shoot_x+16)) and (vcnt>=(shoot_y)) and (vcnt<=(shoot_y+16)) then
					shoot_rgb <= "00"&data_s;
				else
					shoot_rgb <= "000";
				end if;
			end if;


				if ((hcnt>=enemy0_x)) and (hcnt<=(enemy0_x+32)) and (vcnt>=(enemy0_y)) and (vcnt<=(enemy0_y+32)) then
					enemy0_rgb <= data_e0&"00";
				else
					enemy0_rgb <= "000";
				end if;

				if ((hcnt>=enemy1_x)) and (hcnt<=(enemy1_x+32)) and (vcnt>=(enemy1_y)) and (vcnt<=(enemy1_y+32)) then
					enemy1_rgb <= '0'&data_e1&'0';
				else
					enemy1_rgb <= "000";
				end if;
				if ((hcnt>=enemy2_x)) and (hcnt<=(enemy2_x+32)) and (vcnt>=(enemy2_y)) and (vcnt<=(enemy2_y+32)) then
					enemy2_rgb <= data_e2&"00" or '0'&data_e2&'0';
				else
					enemy2_rgb <= "000";
				end if;

				if ((hcnt>=enemy3_x)) and (hcnt<=(enemy3_x+32)) and (vcnt>=(enemy3_y)) and (vcnt<=(enemy3_y+32)) then
					enemy3_rgb <= '0'&data_e3&'0' or "00"&data_e3;
				else
					enemy3_rgb <= "000";
				end if;				

				if ((hcnt>=enemy4_x)) and (hcnt<=(enemy4_x+32)) and (vcnt>=(enemy4_y)) and (vcnt<=(enemy4_y+32)) then
					enemy4_rgb <= data_e4&"00" or "00"&data_e4;
				else
					enemy4_rgb <= "000";
				end if;

		end if;
	end if;
end process;
pic_rgb<=enemy0_rgb or enemy1_rgb or enemy2_rgb or enemy3_rgb or enemy4_rgb or plane_rgb or shoot_rgb; 

end behav;

