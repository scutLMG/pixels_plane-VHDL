library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity action_logic is
    Port ( fire,rst,start : in std_logic;          
			plane_x,plane_y,plane_health,shoot_x,shoot_y,shoot_en:out integer;           
            enemy0_x,enemy1_x,enemy2_x,enemy3_x,enemy4_x,enemy0_y,enemy1_y,enemy2_y,enemy3_y,enemy4_y:out integer;  
            move_left,move_right:in std_logic;                         
			score_cnt:out integer;                                                     
            clk_al,clk:in std_logic);                          
end action_logic;

architecture behav of action_logic is

CONSTANT extent : INTEGER :=100;
CONSTANT plane_xini :INTEGER :=320;
CONSTANT plane_yini :INTEGER :=400;
CONSTANT e4_yini:INTEGER :=120;
signal p_xtmp,p_ytmp:integer range 0 to 1000;  --plane 
signal s_xtmp,s_ytmp:integer range 0 to 1000;  --shoot
signal e0_xtmp,e0_ytmp,e1_xtmp,e1_ytmp,e2_xtmp,e2_ytmp,e3_xtmp,e3_ytmp,e4_xtmp,e4_ytmp:integer range 0 to 1000; --,enemies temporary location
signal e_x0speed,e_y0speed,e_x4speed,e_y4speed,e_x2speed,e_y2speed,e_x3speed,e_y3speed,e_x1speed,e_y1speed:integer range -10 to 10; --speed
signal score_cnt_tmp:integer range 0 to 15:=0;
signal plane_health_tmp,shoot_en_tmp:integer range 0 to 1;
signal sjudge_e0,sjudge_e1,sjudge_e2,sjudge_e3,sjudge_e4 : boolean;
signal pjudge_e0,pjudge_e1,pjudge_e2,pjudge_e3,pjudge_e4 : boolean;
CONSTANT e0_xini:INTEGER :=320;
CONSTANT e0_yini:INTEGER :=40;
CONSTANT e1_xini:INTEGER :=370;
CONSTANT e1_yini:INTEGER :=60;
CONSTANT e2_xini:INTEGER :=400;
CONSTANT e2_yini:INTEGER :=70;
CONSTANT e3_xini:INTEGER :=200;
CONSTANT e3_yini:INTEGER :=100;
CONSTANT e4_xini:INTEGER :=600;


begin
 
random:process(clk,rst)
variable rand_num : std_logic_vector(7 downto 0):="11111111";
begin
    if(rst='0') then
        rand_num := "11111111";
	    elsif rising_edge(clk) then
	            rand_num(0) := rand_num(7);
	            rand_num(1) := rand_num(0);
	            rand_num(2) := rand_num(1);
	            rand_num(3) := rand_num(2);
	            rand_num(4) := rand_num(3) xor rand_num(7);
	            rand_num(5) := rand_num(4) xor rand_num(7);
	            rand_num(6) := rand_num(5) xor rand_num(7);
	            rand_num(7) := rand_num(6);
	    end if;
end process;


action_logic: process (clk_al,rst,start,plane_health_tmp,shoot_en_tmp)
begin
  if rst='0' then  --initialize
			p_xtmp <= plane_xini;
			p_ytmp <= plane_yini;
			e0_xtmp <= e0_xini;
			e0_ytmp <= e0_yini;
			e1_xtmp <= e1_xini;
			e1_ytmp <= e1_yini;
			e2_xtmp <= e2_xini;
			e2_ytmp <= e2_yini;
			e3_xtmp <= e3_xini;
			e3_ytmp <= e3_yini;
			e4_xtmp <= e4_xini;
			e4_ytmp <= e4_yini;

			e_x0speed<=2;
			e_y0speed<=3;
			e_x1speed<=4;
			e_y1speed<=3;
			e_x2speed<=3;
			e_y2speed<=3;
			e_x3speed<=5;
			e_y3speed<=2;
			e_x4speed<=1;
			e_y4speed<=4;

			shoot_en_tmp<=0;
			plane_health_tmp<=1;
			score_cnt_tmp<=0;
     
  else
		if  start='1'   then    --start 
			if (clk_al'event and clk_al='1') then
				if move_left='1' and move_right='0' and p_xtmp>=extent  then  --plane move left
					p_xtmp<=p_xtmp-5;
				elsif move_left='0' and move_right='1' and p_xtmp<=640-extent then --plane move right
					p_xtmp<=p_xtmp+5;
				end if;

			if plane_health_tmp/=0 then  --plane is alive

					if fire='1' then --fire!!!
						s_xtmp <= p_xtmp+8;
						s_ytmp <= p_ytmp;
						shoot_en_tmp<=1;
					else
						s_ytmp<=s_ytmp-6;
					end if;

					if e0_xtmp>640-extent then  --all below is abour emeny action logic depend on score
						e_x0speed<=-3-score_cnt_tmp;
					end if;
					if e0_xtmp<extent then
						e_x0speed<=2+score_cnt_tmp;
					end if;
					if e0_ytmp>400 then
						e_y0speed<=-1-score_cnt_tmp;
					end if;
					if e0_ytmp<30 then
						e_y0speed<=1+score_cnt_tmp;
					end if;

					if e1_xtmp>640-extent then
						e_x1speed<=-4-score_cnt_tmp;
					end if;
					if e1_xtmp<extent then
						e_x1speed<=2+score_cnt_tmp;
					end if;
					if e1_ytmp>400 then
						e_y1speed<=-3-score_cnt_tmp;
					end if;
					if e1_ytmp<30 then
						e_y1speed<=3+score_cnt_tmp;
					end if;

					if e2_xtmp>640-extent then
						e_x2speed<=-2-score_cnt_tmp;
					end if;
					if e2_xtmp<extent then
						e_x2speed<=2+score_cnt_tmp;
					end if;
					if e2_ytmp>400 then
						e_y2speed<=-2-score_cnt_tmp;
					end if;
					if e2_ytmp<30 then
						e_y2speed<=2+score_cnt_tmp;
					end if;

					if e3_xtmp>640-extent then
						e_x3speed<=-5-score_cnt_tmp;
					end if;
					if e3_xtmp<extent then
						e_x3speed<=1+score_cnt_tmp;
					end if;
					if e3_ytmp>400 then
						e_y3speed<=-3-score_cnt_tmp;
					end if;
					if e3_ytmp<30 then
						e_y3speed<=1+score_cnt_tmp;
					end if;

					if e4_xtmp>640-extent then
						e_x4speed<=-3-score_cnt_tmp;
					end if;
					if e4_xtmp<extent then
						e_x4speed<=2+score_cnt_tmp;
					end if;
					if e4_ytmp>400 then
						e_y4speed<=-4-score_cnt_tmp;
					end if;
					if e4_ytmp<30 then
						e_y4speed<=4+score_cnt_tmp;
					end if;

					e0_xtmp<=e0_xtmp+e_x0speed;
					e0_ytmp<=e0_ytmp+e_y0speed;
					e1_xtmp<=e1_xtmp+e_x1speed;
					e1_ytmp<=e1_ytmp+e_y1speed;
					e2_xtmp<=e2_xtmp+e_x2speed;
					e2_ytmp<=e2_ytmp+e_y2speed;
					e3_xtmp<=e3_xtmp+e_x3speed;
					e3_ytmp<=e3_ytmp+e_y3speed;
					e4_xtmp<=e4_xtmp+e_x4speed;
					e4_ytmp<=e4_ytmp+e_y4speed;
					sjudge_e0<=(s_xtmp>=(e0_xtmp-16) and s_xtmp<=(e0_xtmp+32) and s_ytmp>=(e0_ytmp-16) and s_ytmp<=(e0_ytmp+32));
					sjudge_e1<=(s_xtmp>=(e1_xtmp-16) and s_xtmp<=(e1_xtmp+32) and s_ytmp>=(e1_ytmp-16) and s_ytmp<=(e1_ytmp+32));
					sjudge_e2<=(s_xtmp>=(e2_xtmp-16) and s_xtmp<=(e2_xtmp+32) and s_ytmp>=(e2_ytmp-16) and s_ytmp<=(e2_ytmp+32));
					sjudge_e3<=(s_xtmp>=(e3_xtmp-16) and s_xtmp<=(e3_xtmp+32) and s_ytmp>=(e3_ytmp-16) and s_ytmp<=(e3_ytmp+32));
					sjudge_e4<=(s_xtmp>=(e4_xtmp-16) and s_xtmp<=(e4_xtmp+32) and s_ytmp>=(e4_ytmp-16) and s_ytmp<=(e4_ytmp+32));
					pjudge_e0<=(p_xtmp>=(e0_xtmp-32) and p_xtmp<=(e0_xtmp+32) and p_ytmp>=(e0_ytmp-32) and p_ytmp<=(e0_ytmp+32));
					pjudge_e1<=(p_xtmp>=(e1_xtmp-32) and p_xtmp<=(e1_xtmp+32) and p_ytmp>=(e1_ytmp-32) and p_ytmp<=(e1_ytmp+32));
					pjudge_e2<=(p_xtmp>=(e2_xtmp-32) and p_xtmp<=(e2_xtmp+32) and p_ytmp>=(e2_ytmp-32) and p_ytmp<=(e2_ytmp+32));
					pjudge_e3<=(p_xtmp>=(e3_xtmp-32) and p_xtmp<=(e3_xtmp+32) and p_ytmp>=(e3_ytmp-32) and p_ytmp<=(e3_ytmp+32));
					pjudge_e4<=(p_xtmp>=(e4_xtmp-32) and p_xtmp<=(e4_xtmp+32) and p_ytmp>=(e4_ytmp-32) and p_ytmp<=(e4_ytmp+32));
			end if;

--------judge logic
				if sjudge_e0 then
					shoot_en_tmp<=shoot_en_tmp-1;
					e0_xtmp<=e0_xini;
			   	e0_ytmp<=e0_yini;
					score_cnt_tmp<=score_cnt_tmp+1;
				end if;

				if sjudge_e1 then
					shoot_en_tmp<=shoot_en_tmp-1;
					e1_xtmp<=e1_xini;
					e1_ytmp<=e1_yini;
					score_cnt_tmp<=score_cnt_tmp+1;
				end if;

				if sjudge_e2 then
					shoot_en_tmp<=shoot_en_tmp-1;
					e2_xtmp<=e2_xini;
					e2_ytmp<=e2_yini;
					score_cnt_tmp<=score_cnt_tmp+1;
				end if;

				if sjudge_e3 then
					shoot_en_tmp<=shoot_en_tmp-1;
					e3_xtmp<=e3_xini;
					e3_ytmp<=e3_yini;
					score_cnt_tmp<=score_cnt_tmp+1;
				end if;

				if sjudge_e4 then
					shoot_en_tmp<=shoot_en_tmp-1;
					e4_xtmp<=e4_xini;
					e4_ytmp<=e4_yini;
					score_cnt_tmp<=score_cnt_tmp+1;
				end if;

				if (pjudge_e0 or pjudge_e1 or pjudge_e2 or pjudge_e3 or pjudge_e4) then
					plane_health_tmp<=0;
				end if;

			end if;
		end if;
   end if;
end process;

score_cnt<=score_cnt_tmp;               
shoot_en<=shoot_en_tmp;   
plane_health<=plane_health_tmp;     
plane_x<=p_xtmp;           
plane_y<=p_ytmp;           
enemy0_x<=e0_xtmp;           
enemy0_y<=e0_ytmp;           
enemy1_x<=e1_xtmp;         
enemy1_y<=e1_ytmp;
enemy2_x<=e2_xtmp;           
enemy2_y<=e2_ytmp;           
enemy3_x<=e3_xtmp;         
enemy3_y<=e3_ytmp;  
enemy4_x<=e4_xtmp;           
enemy4_y<=e4_ytmp;                    
shoot_x<=s_xtmp;         
shoot_y<=s_ytmp;         

end behav;
