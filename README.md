# pixels_plane-VHDL
a simple game, pixels plane , written in vhdl

seg_con.vhd and vga.vhd : control Segment Displays and the vga output.

div.vhd : a 2Hz divider.

p_enemy.vhd and pixel_plane : use 01 array to discribe enemies and your plane with buttle.

action_logic.vhd: to discribe how the enemy run and how your plane responses you.

display.vhd: to output vga signal,so that your screen can display all the blocks.

pixel_airwar.vhd : connet all modules.

