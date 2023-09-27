-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

-- DATE "09/27/2023 21:48:50"

-- 
-- Device: Altera EP2C35F672C6 Package FBGA672
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

PACKAGE top_data_type IS

TYPE segment_a_6_0_type IS ARRAY (6 DOWNTO 0) OF std_logic;
TYPE segment_a_6_0_1_0_type IS ARRAY (1 DOWNTO 0) OF segment_a_6_0_type;
SUBTYPE segment_a_type IS segment_a_6_0_1_0_type;

TYPE segment_b_6_0_type IS ARRAY (6 DOWNTO 0) OF std_logic;
TYPE segment_b_6_0_1_0_type IS ARRAY (1 DOWNTO 0) OF segment_b_6_0_type;
SUBTYPE segment_b_type IS segment_b_6_0_1_0_type;

TYPE segment_result_6_0_type IS ARRAY (6 DOWNTO 0) OF std_logic;
TYPE segment_result_6_0_3_0_type IS ARRAY (3 DOWNTO 0) OF segment_result_6_0_type;
SUBTYPE segment_result_type IS segment_result_6_0_3_0_type;

END top_data_type;

LIBRARY CYCLONEII;
LIBRARY IEEE;
LIBRARY WORK;
USE CYCLONEII.CYCLONEII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.TOP_DATA_TYPE.ALL;

ENTITY 	top IS
    PORT (
	clk_50megahz : IN std_logic;
	sw_a : IN std_logic_vector(3 DOWNTO 0);
	sw_b : IN std_logic_vector(3 DOWNTO 0);
	sw_mode : IN std_logic_vector(1 DOWNTO 0);
	flag_n : IN std_logic;
	rst_n : IN std_logic;
	sw_a_led : OUT std_logic_vector(3 DOWNTO 0);
	sw_b_led : OUT std_logic_vector(3 DOWNTO 0);
	sw_mode_led : OUT std_logic_vector(1 DOWNTO 0);
	key_flag_n : OUT std_logic;
	key_rst_n : OUT std_logic;
	segment_a : OUT segment_a_type;
	segment_b : OUT segment_b_type;
	segment_result : OUT segment_result_type
	);
END top;

-- Design Ports Information
-- sw_a_led[0]	=>  Location: PIN_AF13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_a_led[1]	=>  Location: PIN_AE13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_a_led[2]	=>  Location: PIN_AE12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_a_led[3]	=>  Location: PIN_AD12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_b_led[0]	=>  Location: PIN_AA13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_b_led[1]	=>  Location: PIN_AC14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_b_led[2]	=>  Location: PIN_AD15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_b_led[3]	=>  Location: PIN_AE15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_mode_led[0]	=>  Location: PIN_AE23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_mode_led[1]	=>  Location: PIN_AF23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- key_flag_n	=>  Location: PIN_AE22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- key_rst_n	=>  Location: PIN_Y18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][0]	=>  Location: PIN_R2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][1]	=>  Location: PIN_P4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][2]	=>  Location: PIN_P3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][3]	=>  Location: PIN_M2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][4]	=>  Location: PIN_M3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][5]	=>  Location: PIN_M5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[0][6]	=>  Location: PIN_M4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][0]	=>  Location: PIN_L3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][1]	=>  Location: PIN_L2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][2]	=>  Location: PIN_L9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][3]	=>  Location: PIN_L6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][4]	=>  Location: PIN_L7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][5]	=>  Location: PIN_P9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_a[1][6]	=>  Location: PIN_N9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][0]	=>  Location: PIN_U9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][1]	=>  Location: PIN_U1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][2]	=>  Location: PIN_U2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][3]	=>  Location: PIN_T4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][4]	=>  Location: PIN_R7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][5]	=>  Location: PIN_R6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[0][6]	=>  Location: PIN_T3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][0]	=>  Location: PIN_T2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][1]	=>  Location: PIN_P6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][2]	=>  Location: PIN_P7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][3]	=>  Location: PIN_T9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][4]	=>  Location: PIN_R5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][5]	=>  Location: PIN_R4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_b[1][6]	=>  Location: PIN_R3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][0]	=>  Location: PIN_AF10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][1]	=>  Location: PIN_AB12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][2]	=>  Location: PIN_AC12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][3]	=>  Location: PIN_AD11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][4]	=>  Location: PIN_AE11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][5]	=>  Location: PIN_V14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[0][6]	=>  Location: PIN_V13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][0]	=>  Location: PIN_V20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][1]	=>  Location: PIN_V21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][2]	=>  Location: PIN_W21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][3]	=>  Location: PIN_Y22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][4]	=>  Location: PIN_AA24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][5]	=>  Location: PIN_AA23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[1][6]	=>  Location: PIN_AB24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][0]	=>  Location: PIN_AB23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][1]	=>  Location: PIN_V22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][2]	=>  Location: PIN_AC25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][3]	=>  Location: PIN_AC26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][4]	=>  Location: PIN_AB26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][5]	=>  Location: PIN_AB25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[2][6]	=>  Location: PIN_Y24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][0]	=>  Location: PIN_Y23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][1]	=>  Location: PIN_AA25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][2]	=>  Location: PIN_AA26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][3]	=>  Location: PIN_Y26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][4]	=>  Location: PIN_Y25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][5]	=>  Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- segment_result[3][6]	=>  Location: PIN_W24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
-- sw_a[0]	=>  Location: PIN_U3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_a[1]	=>  Location: PIN_U4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_a[2]	=>  Location: PIN_V1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_a[3]	=>  Location: PIN_V2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_b[0]	=>  Location: PIN_N1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_b[1]	=>  Location: PIN_P1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_b[2]	=>  Location: PIN_P2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_b[3]	=>  Location: PIN_T7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_mode[0]	=>  Location: PIN_N25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- sw_mode[1]	=>  Location: PIN_N26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- flag_n	=>  Location: PIN_G26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- rst_n	=>  Location: PIN_W26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- clk_50megahz	=>  Location: PIN_N2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF top IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk_50megahz : std_logic;
SIGNAL ww_sw_a : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_sw_b : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_sw_mode : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_flag_n : std_logic;
SIGNAL ww_rst_n : std_logic;
SIGNAL ww_sw_a_led : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_sw_b_led : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_sw_mode_led : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_key_flag_n : std_logic;
SIGNAL ww_key_rst_n : std_logic;
SIGNAL ww_segment_a : segment_a_type;
SIGNAL ww_segment_b : segment_b_type;
SIGNAL ww_segment_result : segment_result_type;
SIGNAL \clk_generator_0|clk_50hz~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk_50megahz~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \rst_n~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk_generator_0|clk_50hz_count[0]~32_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[0]~33\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[1]~34_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[1]~35\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[2]~36_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[2]~37\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[3]~38_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[3]~39\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[4]~40_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[4]~41\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[5]~42_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[5]~43\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[6]~44_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[6]~45\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[7]~46_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[7]~47\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[8]~48_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[8]~49\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[9]~50_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[9]~51\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[10]~52_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[10]~53\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[11]~54_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[11]~55\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[12]~56_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[12]~57\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[13]~58_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[13]~59\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[14]~60_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[14]~61\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[15]~62_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[15]~63\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[16]~64_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[16]~65\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[17]~66_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[17]~67\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[18]~68_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[18]~69\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[19]~70_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[19]~71\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[20]~72_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[20]~73\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[21]~74_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[21]~75\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[22]~76_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[22]~77\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[23]~78_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[23]~79\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[24]~80_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[24]~81\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[25]~82_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[25]~83\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[26]~84_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[26]~85\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[27]~86_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[27]~87\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[28]~88_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[28]~89\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[29]~90_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[29]~91\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[30]~92_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[30]~93\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count[31]~94_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz~regout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~0_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~1_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~2_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~3_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~4_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~5_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~6_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~7_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz~0_combout\ : std_logic;
SIGNAL \clk_generator_0|LessThan0~8_combout\ : std_logic;
SIGNAL \clk_50megahz~combout\ : std_logic;
SIGNAL \rst_n~clk_delay_ctrl_clkout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz~clkctrl_outclk\ : std_logic;
SIGNAL \clk_50megahz~clkctrl_outclk\ : std_logic;
SIGNAL \rst_n~clkctrl_outclk\ : std_logic;
SIGNAL \flag_n~combout\ : std_logic;
SIGNAL \rst_n~combout\ : std_logic;
SIGNAL \temp_reg_0|reg_a~3_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_a~1_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_a~0_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_a~2_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|WideOr5~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|WideOr2~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|WideOr1~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|WideOr0~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|num_segment[0]~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr5~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr3~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr2~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr1~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_1|WideOr0~0_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_b~0_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_b~1_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_b~2_combout\ : std_logic;
SIGNAL \temp_reg_0|reg_b~3_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|WideOr5~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|WideOr2~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|WideOr1~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|WideOr0~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|num_segment[0]~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr5~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr3~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr2~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr1~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_1|WideOr0~0_combout\ : std_logic;
SIGNAL \clk_generator_0|clk_50hz_count\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \temp_reg_0|reg_b\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \temp_reg_0|reg_a\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \sw_mode~combout\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \sw_b~combout\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \sw_a~combout\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_rst_n~clkctrl_outclk\ : std_logic;
SIGNAL \bcd2segment_b_0|ALT_INV_WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_b_0|ALT_INV_WideOr5~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|ALT_INV_WideOr4~0_combout\ : std_logic;
SIGNAL \bcd2segment_a_0|ALT_INV_WideOr5~0_combout\ : std_logic;

BEGIN

ww_clk_50megahz <= clk_50megahz;
ww_sw_a <= sw_a;
ww_sw_b <= sw_b;
ww_sw_mode <= sw_mode;
ww_flag_n <= flag_n;
ww_rst_n <= rst_n;
sw_a_led <= ww_sw_a_led;
sw_b_led <= ww_sw_b_led;
sw_mode_led <= ww_sw_mode_led;
key_flag_n <= ww_key_flag_n;
key_rst_n <= ww_key_rst_n;
segment_a <= ww_segment_a;
segment_b <= ww_segment_b;
segment_result <= ww_segment_result;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk_generator_0|clk_50hz~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clk_generator_0|clk_50hz~regout\);

\clk_50megahz~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \clk_50megahz~combout\);

\rst_n~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \rst_n~clk_delay_ctrl_clkout\);
\ALT_INV_rst_n~clkctrl_outclk\ <= NOT \rst_n~clkctrl_outclk\;
\bcd2segment_b_0|ALT_INV_WideOr4~0_combout\ <= NOT \bcd2segment_b_0|WideOr4~0_combout\;
\bcd2segment_b_0|ALT_INV_WideOr5~0_combout\ <= NOT \bcd2segment_b_0|WideOr5~0_combout\;
\bcd2segment_a_0|ALT_INV_WideOr4~0_combout\ <= NOT \bcd2segment_a_0|WideOr4~0_combout\;
\bcd2segment_a_0|ALT_INV_WideOr5~0_combout\ <= NOT \bcd2segment_a_0|WideOr5~0_combout\;

-- Location: LCFF_X24_Y2_N31
\clk_generator_0|clk_50hz_count[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[15]~62_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(15));

-- Location: LCFF_X24_Y2_N13
\clk_generator_0|clk_50hz_count[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[6]~44_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(6));

-- Location: LCFF_X24_Y2_N15
\clk_generator_0|clk_50hz_count[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[7]~46_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(7));

-- Location: LCFF_X24_Y2_N17
\clk_generator_0|clk_50hz_count[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[8]~48_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(8));

-- Location: LCFF_X24_Y2_N19
\clk_generator_0|clk_50hz_count[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[9]~50_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(9));

-- Location: LCFF_X24_Y2_N21
\clk_generator_0|clk_50hz_count[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[10]~52_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(10));

-- Location: LCFF_X24_Y2_N23
\clk_generator_0|clk_50hz_count[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[11]~54_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(11));

-- Location: LCFF_X24_Y2_N25
\clk_generator_0|clk_50hz_count[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[12]~56_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(12));

-- Location: LCFF_X24_Y2_N27
\clk_generator_0|clk_50hz_count[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[13]~58_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(13));

-- Location: LCFF_X24_Y2_N29
\clk_generator_0|clk_50hz_count[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[14]~60_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(14));

-- Location: LCFF_X24_Y1_N1
\clk_generator_0|clk_50hz_count[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[16]~64_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(16));

-- Location: LCFF_X24_Y1_N3
\clk_generator_0|clk_50hz_count[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[17]~66_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(17));

-- Location: LCFF_X24_Y1_N5
\clk_generator_0|clk_50hz_count[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[18]~68_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(18));

-- Location: LCFF_X24_Y1_N7
\clk_generator_0|clk_50hz_count[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[19]~70_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(19));

-- Location: LCFF_X24_Y1_N9
\clk_generator_0|clk_50hz_count[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[20]~72_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(20));

-- Location: LCFF_X24_Y1_N11
\clk_generator_0|clk_50hz_count[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[21]~74_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(21));

-- Location: LCFF_X24_Y1_N13
\clk_generator_0|clk_50hz_count[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[22]~76_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(22));

-- Location: LCFF_X24_Y1_N15
\clk_generator_0|clk_50hz_count[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[23]~78_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(23));

-- Location: LCFF_X24_Y1_N17
\clk_generator_0|clk_50hz_count[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[24]~80_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(24));

-- Location: LCFF_X24_Y1_N19
\clk_generator_0|clk_50hz_count[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[25]~82_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(25));

-- Location: LCFF_X24_Y1_N21
\clk_generator_0|clk_50hz_count[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[26]~84_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(26));

-- Location: LCFF_X24_Y1_N23
\clk_generator_0|clk_50hz_count[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[27]~86_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(27));

-- Location: LCFF_X24_Y1_N25
\clk_generator_0|clk_50hz_count[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[28]~88_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(28));

-- Location: LCFF_X24_Y1_N27
\clk_generator_0|clk_50hz_count[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[29]~90_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(29));

-- Location: LCFF_X24_Y1_N29
\clk_generator_0|clk_50hz_count[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[30]~92_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(30));

-- Location: LCFF_X24_Y1_N31
\clk_generator_0|clk_50hz_count[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[31]~94_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(31));

-- Location: LCFF_X24_Y2_N11
\clk_generator_0|clk_50hz_count[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[5]~42_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(5));

-- Location: LCFF_X24_Y2_N9
\clk_generator_0|clk_50hz_count[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[4]~40_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(4));

-- Location: LCFF_X24_Y2_N7
\clk_generator_0|clk_50hz_count[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[3]~38_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(3));

-- Location: LCFF_X24_Y2_N5
\clk_generator_0|clk_50hz_count[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[2]~36_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(2));

-- Location: LCFF_X24_Y2_N3
\clk_generator_0|clk_50hz_count[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[1]~34_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(1));

-- Location: LCFF_X24_Y2_N1
\clk_generator_0|clk_50hz_count[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz_count[0]~32_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	sclr => \clk_generator_0|LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz_count\(0));

-- Location: LCCOMB_X24_Y2_N0
\clk_generator_0|clk_50hz_count[0]~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[0]~32_combout\ = \clk_generator_0|clk_50hz_count\(0) $ (VCC)
-- \clk_generator_0|clk_50hz_count[0]~33\ = CARRY(\clk_generator_0|clk_50hz_count\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(0),
	datad => VCC,
	combout => \clk_generator_0|clk_50hz_count[0]~32_combout\,
	cout => \clk_generator_0|clk_50hz_count[0]~33\);

-- Location: LCCOMB_X24_Y2_N2
\clk_generator_0|clk_50hz_count[1]~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[1]~34_combout\ = (\clk_generator_0|clk_50hz_count\(1) & (!\clk_generator_0|clk_50hz_count[0]~33\)) # (!\clk_generator_0|clk_50hz_count\(1) & ((\clk_generator_0|clk_50hz_count[0]~33\) # (GND)))
-- \clk_generator_0|clk_50hz_count[1]~35\ = CARRY((!\clk_generator_0|clk_50hz_count[0]~33\) # (!\clk_generator_0|clk_50hz_count\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(1),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[0]~33\,
	combout => \clk_generator_0|clk_50hz_count[1]~34_combout\,
	cout => \clk_generator_0|clk_50hz_count[1]~35\);

-- Location: LCCOMB_X24_Y2_N4
\clk_generator_0|clk_50hz_count[2]~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[2]~36_combout\ = (\clk_generator_0|clk_50hz_count\(2) & (\clk_generator_0|clk_50hz_count[1]~35\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(2) & (!\clk_generator_0|clk_50hz_count[1]~35\ & VCC))
-- \clk_generator_0|clk_50hz_count[2]~37\ = CARRY((\clk_generator_0|clk_50hz_count\(2) & !\clk_generator_0|clk_50hz_count[1]~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(2),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[1]~35\,
	combout => \clk_generator_0|clk_50hz_count[2]~36_combout\,
	cout => \clk_generator_0|clk_50hz_count[2]~37\);

-- Location: LCCOMB_X24_Y2_N6
\clk_generator_0|clk_50hz_count[3]~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[3]~38_combout\ = (\clk_generator_0|clk_50hz_count\(3) & (!\clk_generator_0|clk_50hz_count[2]~37\)) # (!\clk_generator_0|clk_50hz_count\(3) & ((\clk_generator_0|clk_50hz_count[2]~37\) # (GND)))
-- \clk_generator_0|clk_50hz_count[3]~39\ = CARRY((!\clk_generator_0|clk_50hz_count[2]~37\) # (!\clk_generator_0|clk_50hz_count\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(3),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[2]~37\,
	combout => \clk_generator_0|clk_50hz_count[3]~38_combout\,
	cout => \clk_generator_0|clk_50hz_count[3]~39\);

-- Location: LCCOMB_X24_Y2_N8
\clk_generator_0|clk_50hz_count[4]~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[4]~40_combout\ = (\clk_generator_0|clk_50hz_count\(4) & (\clk_generator_0|clk_50hz_count[3]~39\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(4) & (!\clk_generator_0|clk_50hz_count[3]~39\ & VCC))
-- \clk_generator_0|clk_50hz_count[4]~41\ = CARRY((\clk_generator_0|clk_50hz_count\(4) & !\clk_generator_0|clk_50hz_count[3]~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(4),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[3]~39\,
	combout => \clk_generator_0|clk_50hz_count[4]~40_combout\,
	cout => \clk_generator_0|clk_50hz_count[4]~41\);

-- Location: LCCOMB_X24_Y2_N10
\clk_generator_0|clk_50hz_count[5]~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[5]~42_combout\ = (\clk_generator_0|clk_50hz_count\(5) & (!\clk_generator_0|clk_50hz_count[4]~41\)) # (!\clk_generator_0|clk_50hz_count\(5) & ((\clk_generator_0|clk_50hz_count[4]~41\) # (GND)))
-- \clk_generator_0|clk_50hz_count[5]~43\ = CARRY((!\clk_generator_0|clk_50hz_count[4]~41\) # (!\clk_generator_0|clk_50hz_count\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(5),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[4]~41\,
	combout => \clk_generator_0|clk_50hz_count[5]~42_combout\,
	cout => \clk_generator_0|clk_50hz_count[5]~43\);

-- Location: LCCOMB_X24_Y2_N12
\clk_generator_0|clk_50hz_count[6]~44\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[6]~44_combout\ = (\clk_generator_0|clk_50hz_count\(6) & (\clk_generator_0|clk_50hz_count[5]~43\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(6) & (!\clk_generator_0|clk_50hz_count[5]~43\ & VCC))
-- \clk_generator_0|clk_50hz_count[6]~45\ = CARRY((\clk_generator_0|clk_50hz_count\(6) & !\clk_generator_0|clk_50hz_count[5]~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(6),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[5]~43\,
	combout => \clk_generator_0|clk_50hz_count[6]~44_combout\,
	cout => \clk_generator_0|clk_50hz_count[6]~45\);

-- Location: LCCOMB_X24_Y2_N14
\clk_generator_0|clk_50hz_count[7]~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[7]~46_combout\ = (\clk_generator_0|clk_50hz_count\(7) & (!\clk_generator_0|clk_50hz_count[6]~45\)) # (!\clk_generator_0|clk_50hz_count\(7) & ((\clk_generator_0|clk_50hz_count[6]~45\) # (GND)))
-- \clk_generator_0|clk_50hz_count[7]~47\ = CARRY((!\clk_generator_0|clk_50hz_count[6]~45\) # (!\clk_generator_0|clk_50hz_count\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(7),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[6]~45\,
	combout => \clk_generator_0|clk_50hz_count[7]~46_combout\,
	cout => \clk_generator_0|clk_50hz_count[7]~47\);

-- Location: LCCOMB_X24_Y2_N16
\clk_generator_0|clk_50hz_count[8]~48\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[8]~48_combout\ = (\clk_generator_0|clk_50hz_count\(8) & (\clk_generator_0|clk_50hz_count[7]~47\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(8) & (!\clk_generator_0|clk_50hz_count[7]~47\ & VCC))
-- \clk_generator_0|clk_50hz_count[8]~49\ = CARRY((\clk_generator_0|clk_50hz_count\(8) & !\clk_generator_0|clk_50hz_count[7]~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(8),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[7]~47\,
	combout => \clk_generator_0|clk_50hz_count[8]~48_combout\,
	cout => \clk_generator_0|clk_50hz_count[8]~49\);

-- Location: LCCOMB_X24_Y2_N18
\clk_generator_0|clk_50hz_count[9]~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[9]~50_combout\ = (\clk_generator_0|clk_50hz_count\(9) & (!\clk_generator_0|clk_50hz_count[8]~49\)) # (!\clk_generator_0|clk_50hz_count\(9) & ((\clk_generator_0|clk_50hz_count[8]~49\) # (GND)))
-- \clk_generator_0|clk_50hz_count[9]~51\ = CARRY((!\clk_generator_0|clk_50hz_count[8]~49\) # (!\clk_generator_0|clk_50hz_count\(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(9),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[8]~49\,
	combout => \clk_generator_0|clk_50hz_count[9]~50_combout\,
	cout => \clk_generator_0|clk_50hz_count[9]~51\);

-- Location: LCCOMB_X24_Y2_N20
\clk_generator_0|clk_50hz_count[10]~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[10]~52_combout\ = (\clk_generator_0|clk_50hz_count\(10) & (\clk_generator_0|clk_50hz_count[9]~51\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(10) & (!\clk_generator_0|clk_50hz_count[9]~51\ & VCC))
-- \clk_generator_0|clk_50hz_count[10]~53\ = CARRY((\clk_generator_0|clk_50hz_count\(10) & !\clk_generator_0|clk_50hz_count[9]~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(10),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[9]~51\,
	combout => \clk_generator_0|clk_50hz_count[10]~52_combout\,
	cout => \clk_generator_0|clk_50hz_count[10]~53\);

-- Location: LCCOMB_X24_Y2_N22
\clk_generator_0|clk_50hz_count[11]~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[11]~54_combout\ = (\clk_generator_0|clk_50hz_count\(11) & (!\clk_generator_0|clk_50hz_count[10]~53\)) # (!\clk_generator_0|clk_50hz_count\(11) & ((\clk_generator_0|clk_50hz_count[10]~53\) # (GND)))
-- \clk_generator_0|clk_50hz_count[11]~55\ = CARRY((!\clk_generator_0|clk_50hz_count[10]~53\) # (!\clk_generator_0|clk_50hz_count\(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(11),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[10]~53\,
	combout => \clk_generator_0|clk_50hz_count[11]~54_combout\,
	cout => \clk_generator_0|clk_50hz_count[11]~55\);

-- Location: LCCOMB_X24_Y2_N24
\clk_generator_0|clk_50hz_count[12]~56\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[12]~56_combout\ = (\clk_generator_0|clk_50hz_count\(12) & (\clk_generator_0|clk_50hz_count[11]~55\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(12) & (!\clk_generator_0|clk_50hz_count[11]~55\ & VCC))
-- \clk_generator_0|clk_50hz_count[12]~57\ = CARRY((\clk_generator_0|clk_50hz_count\(12) & !\clk_generator_0|clk_50hz_count[11]~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(12),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[11]~55\,
	combout => \clk_generator_0|clk_50hz_count[12]~56_combout\,
	cout => \clk_generator_0|clk_50hz_count[12]~57\);

-- Location: LCCOMB_X24_Y2_N26
\clk_generator_0|clk_50hz_count[13]~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[13]~58_combout\ = (\clk_generator_0|clk_50hz_count\(13) & (!\clk_generator_0|clk_50hz_count[12]~57\)) # (!\clk_generator_0|clk_50hz_count\(13) & ((\clk_generator_0|clk_50hz_count[12]~57\) # (GND)))
-- \clk_generator_0|clk_50hz_count[13]~59\ = CARRY((!\clk_generator_0|clk_50hz_count[12]~57\) # (!\clk_generator_0|clk_50hz_count\(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(13),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[12]~57\,
	combout => \clk_generator_0|clk_50hz_count[13]~58_combout\,
	cout => \clk_generator_0|clk_50hz_count[13]~59\);

-- Location: LCCOMB_X24_Y2_N28
\clk_generator_0|clk_50hz_count[14]~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[14]~60_combout\ = (\clk_generator_0|clk_50hz_count\(14) & (\clk_generator_0|clk_50hz_count[13]~59\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(14) & (!\clk_generator_0|clk_50hz_count[13]~59\ & VCC))
-- \clk_generator_0|clk_50hz_count[14]~61\ = CARRY((\clk_generator_0|clk_50hz_count\(14) & !\clk_generator_0|clk_50hz_count[13]~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(14),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[13]~59\,
	combout => \clk_generator_0|clk_50hz_count[14]~60_combout\,
	cout => \clk_generator_0|clk_50hz_count[14]~61\);

-- Location: LCCOMB_X24_Y2_N30
\clk_generator_0|clk_50hz_count[15]~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[15]~62_combout\ = (\clk_generator_0|clk_50hz_count\(15) & (!\clk_generator_0|clk_50hz_count[14]~61\)) # (!\clk_generator_0|clk_50hz_count\(15) & ((\clk_generator_0|clk_50hz_count[14]~61\) # (GND)))
-- \clk_generator_0|clk_50hz_count[15]~63\ = CARRY((!\clk_generator_0|clk_50hz_count[14]~61\) # (!\clk_generator_0|clk_50hz_count\(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(15),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[14]~61\,
	combout => \clk_generator_0|clk_50hz_count[15]~62_combout\,
	cout => \clk_generator_0|clk_50hz_count[15]~63\);

-- Location: LCCOMB_X24_Y1_N0
\clk_generator_0|clk_50hz_count[16]~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[16]~64_combout\ = (\clk_generator_0|clk_50hz_count\(16) & (\clk_generator_0|clk_50hz_count[15]~63\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(16) & (!\clk_generator_0|clk_50hz_count[15]~63\ & VCC))
-- \clk_generator_0|clk_50hz_count[16]~65\ = CARRY((\clk_generator_0|clk_50hz_count\(16) & !\clk_generator_0|clk_50hz_count[15]~63\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(16),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[15]~63\,
	combout => \clk_generator_0|clk_50hz_count[16]~64_combout\,
	cout => \clk_generator_0|clk_50hz_count[16]~65\);

-- Location: LCCOMB_X24_Y1_N2
\clk_generator_0|clk_50hz_count[17]~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[17]~66_combout\ = (\clk_generator_0|clk_50hz_count\(17) & (!\clk_generator_0|clk_50hz_count[16]~65\)) # (!\clk_generator_0|clk_50hz_count\(17) & ((\clk_generator_0|clk_50hz_count[16]~65\) # (GND)))
-- \clk_generator_0|clk_50hz_count[17]~67\ = CARRY((!\clk_generator_0|clk_50hz_count[16]~65\) # (!\clk_generator_0|clk_50hz_count\(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(17),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[16]~65\,
	combout => \clk_generator_0|clk_50hz_count[17]~66_combout\,
	cout => \clk_generator_0|clk_50hz_count[17]~67\);

-- Location: LCCOMB_X24_Y1_N4
\clk_generator_0|clk_50hz_count[18]~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[18]~68_combout\ = (\clk_generator_0|clk_50hz_count\(18) & (\clk_generator_0|clk_50hz_count[17]~67\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(18) & (!\clk_generator_0|clk_50hz_count[17]~67\ & VCC))
-- \clk_generator_0|clk_50hz_count[18]~69\ = CARRY((\clk_generator_0|clk_50hz_count\(18) & !\clk_generator_0|clk_50hz_count[17]~67\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(18),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[17]~67\,
	combout => \clk_generator_0|clk_50hz_count[18]~68_combout\,
	cout => \clk_generator_0|clk_50hz_count[18]~69\);

-- Location: LCCOMB_X24_Y1_N6
\clk_generator_0|clk_50hz_count[19]~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[19]~70_combout\ = (\clk_generator_0|clk_50hz_count\(19) & (!\clk_generator_0|clk_50hz_count[18]~69\)) # (!\clk_generator_0|clk_50hz_count\(19) & ((\clk_generator_0|clk_50hz_count[18]~69\) # (GND)))
-- \clk_generator_0|clk_50hz_count[19]~71\ = CARRY((!\clk_generator_0|clk_50hz_count[18]~69\) # (!\clk_generator_0|clk_50hz_count\(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(19),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[18]~69\,
	combout => \clk_generator_0|clk_50hz_count[19]~70_combout\,
	cout => \clk_generator_0|clk_50hz_count[19]~71\);

-- Location: LCCOMB_X24_Y1_N8
\clk_generator_0|clk_50hz_count[20]~72\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[20]~72_combout\ = (\clk_generator_0|clk_50hz_count\(20) & (\clk_generator_0|clk_50hz_count[19]~71\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(20) & (!\clk_generator_0|clk_50hz_count[19]~71\ & VCC))
-- \clk_generator_0|clk_50hz_count[20]~73\ = CARRY((\clk_generator_0|clk_50hz_count\(20) & !\clk_generator_0|clk_50hz_count[19]~71\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(20),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[19]~71\,
	combout => \clk_generator_0|clk_50hz_count[20]~72_combout\,
	cout => \clk_generator_0|clk_50hz_count[20]~73\);

-- Location: LCCOMB_X24_Y1_N10
\clk_generator_0|clk_50hz_count[21]~74\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[21]~74_combout\ = (\clk_generator_0|clk_50hz_count\(21) & (!\clk_generator_0|clk_50hz_count[20]~73\)) # (!\clk_generator_0|clk_50hz_count\(21) & ((\clk_generator_0|clk_50hz_count[20]~73\) # (GND)))
-- \clk_generator_0|clk_50hz_count[21]~75\ = CARRY((!\clk_generator_0|clk_50hz_count[20]~73\) # (!\clk_generator_0|clk_50hz_count\(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(21),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[20]~73\,
	combout => \clk_generator_0|clk_50hz_count[21]~74_combout\,
	cout => \clk_generator_0|clk_50hz_count[21]~75\);

-- Location: LCCOMB_X24_Y1_N12
\clk_generator_0|clk_50hz_count[22]~76\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[22]~76_combout\ = (\clk_generator_0|clk_50hz_count\(22) & (\clk_generator_0|clk_50hz_count[21]~75\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(22) & (!\clk_generator_0|clk_50hz_count[21]~75\ & VCC))
-- \clk_generator_0|clk_50hz_count[22]~77\ = CARRY((\clk_generator_0|clk_50hz_count\(22) & !\clk_generator_0|clk_50hz_count[21]~75\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(22),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[21]~75\,
	combout => \clk_generator_0|clk_50hz_count[22]~76_combout\,
	cout => \clk_generator_0|clk_50hz_count[22]~77\);

-- Location: LCCOMB_X24_Y1_N14
\clk_generator_0|clk_50hz_count[23]~78\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[23]~78_combout\ = (\clk_generator_0|clk_50hz_count\(23) & (!\clk_generator_0|clk_50hz_count[22]~77\)) # (!\clk_generator_0|clk_50hz_count\(23) & ((\clk_generator_0|clk_50hz_count[22]~77\) # (GND)))
-- \clk_generator_0|clk_50hz_count[23]~79\ = CARRY((!\clk_generator_0|clk_50hz_count[22]~77\) # (!\clk_generator_0|clk_50hz_count\(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(23),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[22]~77\,
	combout => \clk_generator_0|clk_50hz_count[23]~78_combout\,
	cout => \clk_generator_0|clk_50hz_count[23]~79\);

-- Location: LCCOMB_X24_Y1_N16
\clk_generator_0|clk_50hz_count[24]~80\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[24]~80_combout\ = (\clk_generator_0|clk_50hz_count\(24) & (\clk_generator_0|clk_50hz_count[23]~79\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(24) & (!\clk_generator_0|clk_50hz_count[23]~79\ & VCC))
-- \clk_generator_0|clk_50hz_count[24]~81\ = CARRY((\clk_generator_0|clk_50hz_count\(24) & !\clk_generator_0|clk_50hz_count[23]~79\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(24),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[23]~79\,
	combout => \clk_generator_0|clk_50hz_count[24]~80_combout\,
	cout => \clk_generator_0|clk_50hz_count[24]~81\);

-- Location: LCCOMB_X24_Y1_N18
\clk_generator_0|clk_50hz_count[25]~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[25]~82_combout\ = (\clk_generator_0|clk_50hz_count\(25) & (!\clk_generator_0|clk_50hz_count[24]~81\)) # (!\clk_generator_0|clk_50hz_count\(25) & ((\clk_generator_0|clk_50hz_count[24]~81\) # (GND)))
-- \clk_generator_0|clk_50hz_count[25]~83\ = CARRY((!\clk_generator_0|clk_50hz_count[24]~81\) # (!\clk_generator_0|clk_50hz_count\(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(25),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[24]~81\,
	combout => \clk_generator_0|clk_50hz_count[25]~82_combout\,
	cout => \clk_generator_0|clk_50hz_count[25]~83\);

-- Location: LCCOMB_X24_Y1_N20
\clk_generator_0|clk_50hz_count[26]~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[26]~84_combout\ = (\clk_generator_0|clk_50hz_count\(26) & (\clk_generator_0|clk_50hz_count[25]~83\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(26) & (!\clk_generator_0|clk_50hz_count[25]~83\ & VCC))
-- \clk_generator_0|clk_50hz_count[26]~85\ = CARRY((\clk_generator_0|clk_50hz_count\(26) & !\clk_generator_0|clk_50hz_count[25]~83\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(26),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[25]~83\,
	combout => \clk_generator_0|clk_50hz_count[26]~84_combout\,
	cout => \clk_generator_0|clk_50hz_count[26]~85\);

-- Location: LCCOMB_X24_Y1_N22
\clk_generator_0|clk_50hz_count[27]~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[27]~86_combout\ = (\clk_generator_0|clk_50hz_count\(27) & (!\clk_generator_0|clk_50hz_count[26]~85\)) # (!\clk_generator_0|clk_50hz_count\(27) & ((\clk_generator_0|clk_50hz_count[26]~85\) # (GND)))
-- \clk_generator_0|clk_50hz_count[27]~87\ = CARRY((!\clk_generator_0|clk_50hz_count[26]~85\) # (!\clk_generator_0|clk_50hz_count\(27)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(27),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[26]~85\,
	combout => \clk_generator_0|clk_50hz_count[27]~86_combout\,
	cout => \clk_generator_0|clk_50hz_count[27]~87\);

-- Location: LCCOMB_X24_Y1_N24
\clk_generator_0|clk_50hz_count[28]~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[28]~88_combout\ = (\clk_generator_0|clk_50hz_count\(28) & (\clk_generator_0|clk_50hz_count[27]~87\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(28) & (!\clk_generator_0|clk_50hz_count[27]~87\ & VCC))
-- \clk_generator_0|clk_50hz_count[28]~89\ = CARRY((\clk_generator_0|clk_50hz_count\(28) & !\clk_generator_0|clk_50hz_count[27]~87\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(28),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[27]~87\,
	combout => \clk_generator_0|clk_50hz_count[28]~88_combout\,
	cout => \clk_generator_0|clk_50hz_count[28]~89\);

-- Location: LCCOMB_X24_Y1_N26
\clk_generator_0|clk_50hz_count[29]~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[29]~90_combout\ = (\clk_generator_0|clk_50hz_count\(29) & (!\clk_generator_0|clk_50hz_count[28]~89\)) # (!\clk_generator_0|clk_50hz_count\(29) & ((\clk_generator_0|clk_50hz_count[28]~89\) # (GND)))
-- \clk_generator_0|clk_50hz_count[29]~91\ = CARRY((!\clk_generator_0|clk_50hz_count[28]~89\) # (!\clk_generator_0|clk_50hz_count\(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(29),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[28]~89\,
	combout => \clk_generator_0|clk_50hz_count[29]~90_combout\,
	cout => \clk_generator_0|clk_50hz_count[29]~91\);

-- Location: LCCOMB_X24_Y1_N28
\clk_generator_0|clk_50hz_count[30]~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[30]~92_combout\ = (\clk_generator_0|clk_50hz_count\(30) & (\clk_generator_0|clk_50hz_count[29]~91\ $ (GND))) # (!\clk_generator_0|clk_50hz_count\(30) & (!\clk_generator_0|clk_50hz_count[29]~91\ & VCC))
-- \clk_generator_0|clk_50hz_count[30]~93\ = CARRY((\clk_generator_0|clk_50hz_count\(30) & !\clk_generator_0|clk_50hz_count[29]~91\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(30),
	datad => VCC,
	cin => \clk_generator_0|clk_50hz_count[29]~91\,
	combout => \clk_generator_0|clk_50hz_count[30]~92_combout\,
	cout => \clk_generator_0|clk_50hz_count[30]~93\);

-- Location: LCCOMB_X24_Y1_N30
\clk_generator_0|clk_50hz_count[31]~94\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz_count[31]~94_combout\ = \clk_generator_0|clk_50hz_count[30]~93\ $ (\clk_generator_0|clk_50hz_count\(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \clk_generator_0|clk_50hz_count\(31),
	cin => \clk_generator_0|clk_50hz_count[30]~93\,
	combout => \clk_generator_0|clk_50hz_count[31]~94_combout\);

-- Location: LCFF_X29_Y2_N23
\clk_generator_0|clk_50hz\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_50megahz~clkctrl_outclk\,
	datain => \clk_generator_0|clk_50hz~0_combout\,
	aclr => \ALT_INV_rst_n~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \clk_generator_0|clk_50hz~regout\);

-- Location: LCCOMB_X25_Y2_N12
\clk_generator_0|LessThan0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~0_combout\ = (!\clk_generator_0|clk_50hz_count\(7) & (!\clk_generator_0|clk_50hz_count\(9) & (!\clk_generator_0|clk_50hz_count\(8) & !\clk_generator_0|clk_50hz_count\(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(7),
	datab => \clk_generator_0|clk_50hz_count\(9),
	datac => \clk_generator_0|clk_50hz_count\(8),
	datad => \clk_generator_0|clk_50hz_count\(6),
	combout => \clk_generator_0|LessThan0~0_combout\);

-- Location: LCCOMB_X25_Y2_N14
\clk_generator_0|LessThan0~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~1_combout\ = ((!\clk_generator_0|clk_50hz_count\(11)) # (!\clk_generator_0|clk_50hz_count\(10))) # (!\clk_generator_0|clk_50hz_count\(12))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \clk_generator_0|clk_50hz_count\(12),
	datac => \clk_generator_0|clk_50hz_count\(10),
	datad => \clk_generator_0|clk_50hz_count\(11),
	combout => \clk_generator_0|LessThan0~1_combout\);

-- Location: LCCOMB_X25_Y2_N16
\clk_generator_0|LessThan0~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~2_combout\ = (!\clk_generator_0|clk_50hz_count\(14) & (!\clk_generator_0|clk_50hz_count\(13) & ((\clk_generator_0|LessThan0~1_combout\) # (\clk_generator_0|LessThan0~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000100010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(14),
	datab => \clk_generator_0|clk_50hz_count\(13),
	datac => \clk_generator_0|LessThan0~1_combout\,
	datad => \clk_generator_0|LessThan0~0_combout\,
	combout => \clk_generator_0|LessThan0~2_combout\);

-- Location: LCCOMB_X25_Y1_N20
\clk_generator_0|LessThan0~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~3_combout\ = (!\clk_generator_0|clk_50hz_count\(16) & (!\clk_generator_0|clk_50hz_count\(19) & (!\clk_generator_0|clk_50hz_count\(18) & !\clk_generator_0|clk_50hz_count\(17))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(16),
	datab => \clk_generator_0|clk_50hz_count\(19),
	datac => \clk_generator_0|clk_50hz_count\(18),
	datad => \clk_generator_0|clk_50hz_count\(17),
	combout => \clk_generator_0|LessThan0~3_combout\);

-- Location: LCCOMB_X25_Y1_N2
\clk_generator_0|LessThan0~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~4_combout\ = (!\clk_generator_0|clk_50hz_count\(23) & (!\clk_generator_0|clk_50hz_count\(20) & (!\clk_generator_0|clk_50hz_count\(21) & !\clk_generator_0|clk_50hz_count\(22))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(23),
	datab => \clk_generator_0|clk_50hz_count\(20),
	datac => \clk_generator_0|clk_50hz_count\(21),
	datad => \clk_generator_0|clk_50hz_count\(22),
	combout => \clk_generator_0|LessThan0~4_combout\);

-- Location: LCCOMB_X25_Y1_N0
\clk_generator_0|LessThan0~5\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~5_combout\ = (!\clk_generator_0|clk_50hz_count\(26) & (!\clk_generator_0|clk_50hz_count\(24) & (!\clk_generator_0|clk_50hz_count\(27) & !\clk_generator_0|clk_50hz_count\(25))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(26),
	datab => \clk_generator_0|clk_50hz_count\(24),
	datac => \clk_generator_0|clk_50hz_count\(27),
	datad => \clk_generator_0|clk_50hz_count\(25),
	combout => \clk_generator_0|LessThan0~5_combout\);

-- Location: LCCOMB_X25_Y1_N22
\clk_generator_0|LessThan0~6\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~6_combout\ = (!\clk_generator_0|clk_50hz_count\(31) & (!\clk_generator_0|clk_50hz_count\(29) & (!\clk_generator_0|clk_50hz_count\(28) & !\clk_generator_0|clk_50hz_count\(30))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(31),
	datab => \clk_generator_0|clk_50hz_count\(29),
	datac => \clk_generator_0|clk_50hz_count\(28),
	datad => \clk_generator_0|clk_50hz_count\(30),
	combout => \clk_generator_0|LessThan0~6_combout\);

-- Location: LCCOMB_X25_Y2_N10
\clk_generator_0|LessThan0~7\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~7_combout\ = (\clk_generator_0|LessThan0~3_combout\ & (\clk_generator_0|LessThan0~6_combout\ & (\clk_generator_0|LessThan0~4_combout\ & \clk_generator_0|LessThan0~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|LessThan0~3_combout\,
	datab => \clk_generator_0|LessThan0~6_combout\,
	datac => \clk_generator_0|LessThan0~4_combout\,
	datad => \clk_generator_0|LessThan0~5_combout\,
	combout => \clk_generator_0|LessThan0~7_combout\);

-- Location: LCCOMB_X29_Y2_N22
\clk_generator_0|clk_50hz~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|clk_50hz~0_combout\ = \clk_generator_0|clk_50hz~regout\ $ ((((\clk_generator_0|clk_50hz_count\(15) & !\clk_generator_0|LessThan0~2_combout\)) # (!\clk_generator_0|LessThan0~7_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101001000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(15),
	datab => \clk_generator_0|LessThan0~2_combout\,
	datac => \clk_generator_0|clk_50hz~regout\,
	datad => \clk_generator_0|LessThan0~7_combout\,
	combout => \clk_generator_0|clk_50hz~0_combout\);

-- Location: LCCOMB_X25_Y2_N20
\clk_generator_0|LessThan0~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \clk_generator_0|LessThan0~8_combout\ = ((\clk_generator_0|clk_50hz_count\(15) & !\clk_generator_0|LessThan0~2_combout\)) # (!\clk_generator_0|LessThan0~7_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \clk_generator_0|clk_50hz_count\(15),
	datac => \clk_generator_0|LessThan0~2_combout\,
	datad => \clk_generator_0|LessThan0~7_combout\,
	combout => \clk_generator_0|LessThan0~8_combout\);

-- Location: PIN_N2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clk_50megahz~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_clk_50megahz,
	combout => \clk_50megahz~combout\);

-- Location: CLKDELAYCTRL_G7
\rst_n~clk_delay_ctrl\ : cycloneii_clk_delay_ctrl
-- pragma translate_off
GENERIC MAP (
	delay_chain_mode => "none",
	use_new_style_dq_detection => "false")
-- pragma translate_on
PORT MAP (
	clk => \rst_n~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	clkout => \rst_n~clk_delay_ctrl_clkout\);

-- Location: CLKCTRL_G14
\clk_generator_0|clk_50hz~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk_generator_0|clk_50hz~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk_generator_0|clk_50hz~clkctrl_outclk\);

-- Location: CLKCTRL_G2
\clk_50megahz~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk_50megahz~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk_50megahz~clkctrl_outclk\);

-- Location: CLKCTRL_G7
\rst_n~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \rst_n~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \rst_n~clkctrl_outclk\);

-- Location: PIN_U3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_a[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_a(0),
	combout => \sw_a~combout\(0));

-- Location: PIN_U4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_a[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_a(1),
	combout => \sw_a~combout\(1));

-- Location: PIN_V1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_a[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_a(2),
	combout => \sw_a~combout\(2));

-- Location: PIN_V2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_a[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_a(3),
	combout => \sw_a~combout\(3));

-- Location: PIN_N1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_b[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_b(0),
	combout => \sw_b~combout\(0));

-- Location: PIN_P1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_b[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_b(1),
	combout => \sw_b~combout\(1));

-- Location: PIN_P2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_b[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_b(2),
	combout => \sw_b~combout\(2));

-- Location: PIN_T7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_b[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_b(3),
	combout => \sw_b~combout\(3));

-- Location: PIN_N25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_mode[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_mode(0),
	combout => \sw_mode~combout\(0));

-- Location: PIN_N26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\sw_mode[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_sw_mode(1),
	combout => \sw_mode~combout\(1));

-- Location: PIN_G26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\flag_n~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_flag_n,
	combout => \flag_n~combout\);

-- Location: PIN_W26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\rst_n~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_rst_n,
	combout => \rst_n~combout\);

-- Location: LCCOMB_X1_Y24_N6
\temp_reg_0|reg_a~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_a~3_combout\ = (\sw_a~combout\(0) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sw_a~combout\(0),
	datad => \rst_n~combout\,
	combout => \temp_reg_0|reg_a~3_combout\);

-- Location: LCFF_X1_Y24_N7
\temp_reg_0|reg_a[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_a~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_a\(0));

-- Location: LCCOMB_X1_Y24_N26
\temp_reg_0|reg_a~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_a~1_combout\ = (\sw_a~combout\(2) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \sw_a~combout\(2),
	datad => \rst_n~combout\,
	combout => \temp_reg_0|reg_a~1_combout\);

-- Location: LCFF_X1_Y24_N27
\temp_reg_0|reg_a[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_a~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_a\(2));

-- Location: LCCOMB_X1_Y24_N4
\temp_reg_0|reg_a~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_a~0_combout\ = (\sw_a~combout\(1) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sw_a~combout\(1),
	datad => \rst_n~combout\,
	combout => \temp_reg_0|reg_a~0_combout\);

-- Location: LCFF_X1_Y24_N5
\temp_reg_0|reg_a[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_a~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_a\(1));

-- Location: LCCOMB_X1_Y24_N12
\temp_reg_0|reg_a~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_a~2_combout\ = (\sw_a~combout\(3) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sw_a~combout\(3),
	datad => \rst_n~combout\,
	combout => \temp_reg_0|reg_a~2_combout\);

-- Location: LCFF_X1_Y24_N13
\temp_reg_0|reg_a[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_a~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_a\(3));

-- Location: LCCOMB_X1_Y24_N20
\bcd2segment_a_0|WideOr5~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_0|WideOr5~0_combout\ = (\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2) & (!\temp_reg_0|reg_a\(1))) # (!\temp_reg_0|reg_a\(2) & ((!\temp_reg_0|reg_a\(3)))))) # (!\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2) & ((\temp_reg_0|reg_a\(1)) # 
-- (\temp_reg_0|reg_a\(3)))) # (!\temp_reg_0|reg_a\(2) & (!\temp_reg_0|reg_a\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100110101101011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_0|WideOr5~0_combout\);

-- Location: LCCOMB_X1_Y24_N18
\bcd2segment_a_0|WideOr4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_0|WideOr4~0_combout\ = (\temp_reg_0|reg_a\(0) $ (\temp_reg_0|reg_a\(2))) # (!\temp_reg_0|reg_a\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110111101101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	combout => \bcd2segment_a_0|WideOr4~0_combout\);

-- Location: LCCOMB_X1_Y24_N24
\bcd2segment_a_0|WideOr2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_0|WideOr2~0_combout\ = (\temp_reg_0|reg_a\(0) & (!\temp_reg_0|reg_a\(2) & ((!\temp_reg_0|reg_a\(3))))) # (!\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(1) & (\temp_reg_0|reg_a\(2))) # (!\temp_reg_0|reg_a\(1) & ((\temp_reg_0|reg_a\(3))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010101100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_0|WideOr2~0_combout\);

-- Location: LCCOMB_X1_Y24_N22
\bcd2segment_a_0|WideOr1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_0|WideOr1~0_combout\ = (\temp_reg_0|reg_a\(0) & (!\temp_reg_0|reg_a\(2) & (\temp_reg_0|reg_a\(1) & !\temp_reg_0|reg_a\(3)))) # (!\temp_reg_0|reg_a\(0) & (((!\temp_reg_0|reg_a\(1) & \temp_reg_0|reg_a\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_0|WideOr1~0_combout\);

-- Location: LCCOMB_X1_Y24_N16
\bcd2segment_a_0|WideOr0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_0|WideOr0~0_combout\ = (!\temp_reg_0|reg_a\(1) & ((\temp_reg_0|reg_a\(0) & (\temp_reg_0|reg_a\(2))) # (!\temp_reg_0|reg_a\(0) & (!\temp_reg_0|reg_a\(2) & !\temp_reg_0|reg_a\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_0|WideOr0~0_combout\);

-- Location: LCCOMB_X1_Y24_N14
\bcd2segment_a_1|num_segment[0]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|num_segment[0]~0_combout\ = (\temp_reg_0|reg_a\(2) & (!\temp_reg_0|reg_a\(1) & (\temp_reg_0|reg_a\(0) $ (\temp_reg_0|reg_a\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|num_segment[0]~0_combout\);

-- Location: LCCOMB_X1_Y24_N28
\bcd2segment_a_1|WideOr5~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr5~0_combout\ = (\temp_reg_0|reg_a\(1) & (\temp_reg_0|reg_a\(0) $ ((!\temp_reg_0|reg_a\(2))))) # (!\temp_reg_0|reg_a\(1) & (!\temp_reg_0|reg_a\(0) & (\temp_reg_0|reg_a\(2) & !\temp_reg_0|reg_a\(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000010010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr5~0_combout\);

-- Location: LCCOMB_X1_Y24_N30
\bcd2segment_a_1|WideOr4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr4~0_combout\ = (\temp_reg_0|reg_a\(1) & ((\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2)) # (!\temp_reg_0|reg_a\(3)))) # (!\temp_reg_0|reg_a\(0) & (!\temp_reg_0|reg_a\(2)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr4~0_combout\);

-- Location: LCCOMB_X1_Y24_N8
\bcd2segment_a_1|WideOr3~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr3~0_combout\ = (\temp_reg_0|reg_a\(0) & (\temp_reg_0|reg_a\(2) $ (((!\temp_reg_0|reg_a\(1) & \temp_reg_0|reg_a\(3)))))) # (!\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2) & (!\temp_reg_0|reg_a\(1) & \temp_reg_0|reg_a\(3))) # 
-- (!\temp_reg_0|reg_a\(2) & (\temp_reg_0|reg_a\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr3~0_combout\);

-- Location: LCCOMB_X1_Y24_N2
\bcd2segment_a_1|WideOr2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr2~0_combout\ = (\temp_reg_0|reg_a\(3) & ((\temp_reg_0|reg_a\(0) & (!\temp_reg_0|reg_a\(2))) # (!\temp_reg_0|reg_a\(0) & ((!\temp_reg_0|reg_a\(1)))))) # (!\temp_reg_0|reg_a\(3) & (\temp_reg_0|reg_a\(2) & (\temp_reg_0|reg_a\(0) $ 
-- (\temp_reg_0|reg_a\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010011101001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr2~0_combout\);

-- Location: LCCOMB_X1_Y24_N0
\bcd2segment_a_1|WideOr1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr1~0_combout\ = (\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2) & (!\temp_reg_0|reg_a\(1) & !\temp_reg_0|reg_a\(3))) # (!\temp_reg_0|reg_a\(2) & (\temp_reg_0|reg_a\(1))))) # (!\temp_reg_0|reg_a\(0) & (((!\temp_reg_0|reg_a\(1) & 
-- \temp_reg_0|reg_a\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010010100101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr1~0_combout\);

-- Location: LCCOMB_X1_Y24_N10
\bcd2segment_a_1|WideOr0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_a_1|WideOr0~0_combout\ = (!\temp_reg_0|reg_a\(1) & ((\temp_reg_0|reg_a\(0) & ((\temp_reg_0|reg_a\(2)) # (\temp_reg_0|reg_a\(3)))) # (!\temp_reg_0|reg_a\(0) & (\temp_reg_0|reg_a\(2) $ (!\temp_reg_0|reg_a\(3))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_a\(0),
	datab => \temp_reg_0|reg_a\(2),
	datac => \temp_reg_0|reg_a\(1),
	datad => \temp_reg_0|reg_a\(3),
	combout => \bcd2segment_a_1|WideOr0~0_combout\);

-- Location: LCCOMB_X1_Y15_N24
\temp_reg_0|reg_b~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_b~0_combout\ = (\sw_b~combout\(1) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \sw_b~combout\(1),
	datac => \rst_n~combout\,
	combout => \temp_reg_0|reg_b~0_combout\);

-- Location: LCFF_X1_Y15_N25
\temp_reg_0|reg_b[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_b~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_b\(1));

-- Location: LCCOMB_X1_Y15_N26
\temp_reg_0|reg_b~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_b~1_combout\ = (\rst_n~combout\ & \sw_b~combout\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \rst_n~combout\,
	datac => \sw_b~combout\(2),
	combout => \temp_reg_0|reg_b~1_combout\);

-- Location: LCFF_X1_Y15_N27
\temp_reg_0|reg_b[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_b~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_b\(2));

-- Location: LCCOMB_X1_Y15_N8
\temp_reg_0|reg_b~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_b~2_combout\ = (\sw_b~combout\(3) & \rst_n~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \sw_b~combout\(3),
	datac => \rst_n~combout\,
	combout => \temp_reg_0|reg_b~2_combout\);

-- Location: LCFF_X1_Y15_N9
\temp_reg_0|reg_b[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_b~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_b\(3));

-- Location: LCCOMB_X1_Y15_N18
\temp_reg_0|reg_b~3\ : cycloneii_lcell_comb
-- Equation(s):
-- \temp_reg_0|reg_b~3_combout\ = (\rst_n~combout\ & \sw_b~combout\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \rst_n~combout\,
	datac => \sw_b~combout\(0),
	combout => \temp_reg_0|reg_b~3_combout\);

-- Location: LCFF_X1_Y15_N19
\temp_reg_0|reg_b[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \clk_generator_0|clk_50hz~clkctrl_outclk\,
	datain => \temp_reg_0|reg_b~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \temp_reg_0|reg_b\(0));

-- Location: LCCOMB_X1_Y15_N20
\bcd2segment_b_0|WideOr5~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_0|WideOr5~0_combout\ = (\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(1) & ((!\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(3)) # (\temp_reg_0|reg_b\(0)))))) # (!\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(0) & 
-- ((!\temp_reg_0|reg_b\(3)))) # (!\temp_reg_0|reg_b\(0) & (!\temp_reg_0|reg_b\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100011111011001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_0|WideOr5~0_combout\);

-- Location: LCCOMB_X1_Y15_N6
\bcd2segment_b_0|WideOr4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_0|WideOr4~0_combout\ = (\temp_reg_0|reg_b\(2) $ (\temp_reg_0|reg_b\(0))) # (!\temp_reg_0|reg_b\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(1),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_0|WideOr4~0_combout\);

-- Location: LCCOMB_X1_Y15_N16
\bcd2segment_b_0|WideOr2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_0|WideOr2~0_combout\ = (\temp_reg_0|reg_b\(0) & (((!\temp_reg_0|reg_b\(2) & !\temp_reg_0|reg_b\(3))))) # (!\temp_reg_0|reg_b\(0) & ((\temp_reg_0|reg_b\(1) & (\temp_reg_0|reg_b\(2))) # (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(3))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001111011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_0|WideOr2~0_combout\);

-- Location: LCCOMB_X1_Y15_N22
\bcd2segment_b_0|WideOr1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_0|WideOr1~0_combout\ = (\temp_reg_0|reg_b\(1) & (!\temp_reg_0|reg_b\(2) & (!\temp_reg_0|reg_b\(3) & \temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(1) & (((\temp_reg_0|reg_b\(3) & !\temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_0|WideOr1~0_combout\);

-- Location: LCCOMB_X1_Y15_N28
\bcd2segment_b_0|WideOr0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_0|WideOr0~0_combout\ = (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(2) & (!\temp_reg_0|reg_b\(3) & !\temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_0|WideOr0~0_combout\);

-- Location: LCCOMB_X1_Y15_N30
\bcd2segment_b_1|num_segment[0]~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|num_segment[0]~0_combout\ = (!\temp_reg_0|reg_b\(1) & (\temp_reg_0|reg_b\(2) & (\temp_reg_0|reg_b\(3) $ (\temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|num_segment[0]~0_combout\);

-- Location: LCCOMB_X1_Y15_N12
\bcd2segment_b_1|WideOr5~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr5~0_combout\ = (\temp_reg_0|reg_b\(1) & (\temp_reg_0|reg_b\(2) $ (((!\temp_reg_0|reg_b\(0)))))) # (!\temp_reg_0|reg_b\(1) & (\temp_reg_0|reg_b\(2) & (!\temp_reg_0|reg_b\(3) & !\temp_reg_0|reg_b\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr5~0_combout\);

-- Location: LCCOMB_X1_Y15_N14
\bcd2segment_b_1|WideOr4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr4~0_combout\ = (\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(2) & ((!\temp_reg_0|reg_b\(0)) # (!\temp_reg_0|reg_b\(3))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000101000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr4~0_combout\);

-- Location: LCCOMB_X1_Y15_N0
\bcd2segment_b_1|WideOr3~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr3~0_combout\ = (\temp_reg_0|reg_b\(1) & (\temp_reg_0|reg_b\(2) $ (((!\temp_reg_0|reg_b\(0)))))) # (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(2) & (\temp_reg_0|reg_b\(3) $ (\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(2) & 
-- (\temp_reg_0|reg_b\(3) & \temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001110001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr3~0_combout\);

-- Location: LCCOMB_X1_Y15_N2
\bcd2segment_b_1|WideOr2~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr2~0_combout\ = (\temp_reg_0|reg_b\(3) & ((\temp_reg_0|reg_b\(0) & ((!\temp_reg_0|reg_b\(2)))) # (!\temp_reg_0|reg_b\(0) & (!\temp_reg_0|reg_b\(1))))) # (!\temp_reg_0|reg_b\(3) & (\temp_reg_0|reg_b\(2) & (\temp_reg_0|reg_b\(1) $ 
-- (\temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011010001011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr2~0_combout\);

-- Location: LCCOMB_X1_Y15_N4
\bcd2segment_b_1|WideOr1~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr1~0_combout\ = (\temp_reg_0|reg_b\(1) & (!\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(0))))) # (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(3) & ((!\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(3) & (\temp_reg_0|reg_b\(2) & 
-- \temp_reg_0|reg_b\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010011001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr1~0_combout\);

-- Location: LCCOMB_X1_Y15_N10
\bcd2segment_b_1|WideOr0~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \bcd2segment_b_1|WideOr0~0_combout\ = (!\temp_reg_0|reg_b\(1) & ((\temp_reg_0|reg_b\(2) & ((\temp_reg_0|reg_b\(3)) # (\temp_reg_0|reg_b\(0)))) # (!\temp_reg_0|reg_b\(2) & (\temp_reg_0|reg_b\(3) $ (!\temp_reg_0|reg_b\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \temp_reg_0|reg_b\(1),
	datab => \temp_reg_0|reg_b\(2),
	datac => \temp_reg_0|reg_b\(3),
	datad => \temp_reg_0|reg_b\(0),
	combout => \bcd2segment_b_1|WideOr0~0_combout\);

-- Location: PIN_AF13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_a_led[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_a~combout\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_a_led(0));

-- Location: PIN_AE13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_a_led[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_a~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_a_led(1));

-- Location: PIN_AE12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_a_led[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_a~combout\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_a_led(2));

-- Location: PIN_AD12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_a_led[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_a~combout\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_a_led(3));

-- Location: PIN_AA13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_b_led[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_b~combout\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_b_led(0));

-- Location: PIN_AC14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_b_led[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_b~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_b_led(1));

-- Location: PIN_AD15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_b_led[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_b~combout\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_b_led(2));

-- Location: PIN_AE15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_b_led[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_b~combout\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_b_led(3));

-- Location: PIN_AE23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_mode_led[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_mode~combout\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_mode_led(0));

-- Location: PIN_AF23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\sw_mode_led[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \sw_mode~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_sw_mode_led(1));

-- Location: PIN_AE22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\key_flag_n~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \flag_n~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_key_flag_n);

-- Location: PIN_Y18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\key_rst_n~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \rst_n~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_key_rst_n);

-- Location: PIN_R2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(0));

-- Location: PIN_P4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|ALT_INV_WideOr5~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(1));

-- Location: PIN_P3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|ALT_INV_WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(2));

-- Location: PIN_M2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|ALT_INV_WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(3));

-- Location: PIN_M3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|WideOr2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(4));

-- Location: PIN_M5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|WideOr1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(5));

-- Location: PIN_M4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[0][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_0|WideOr0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(0)(6));

-- Location: PIN_L3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|num_segment[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(0));

-- Location: PIN_L2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr5~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(1));

-- Location: PIN_L9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(2));

-- Location: PIN_L6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr3~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(3));

-- Location: PIN_L7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(4));

-- Location: PIN_P9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(5));

-- Location: PIN_N9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_a[1][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_a_1|WideOr0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_a(1)(6));

-- Location: PIN_U9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(0));

-- Location: PIN_U1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|ALT_INV_WideOr5~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(1));

-- Location: PIN_U2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|ALT_INV_WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(2));

-- Location: PIN_T4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|ALT_INV_WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(3));

-- Location: PIN_R7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|WideOr2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(4));

-- Location: PIN_R6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|WideOr1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(5));

-- Location: PIN_T3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[0][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_0|WideOr0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(0)(6));

-- Location: PIN_T2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|num_segment[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(0));

-- Location: PIN_P6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr5~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(1));

-- Location: PIN_P7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(2));

-- Location: PIN_T9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr3~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(3));

-- Location: PIN_R5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(4));

-- Location: PIN_R4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(5));

-- Location: PIN_R3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_b[1][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \bcd2segment_b_1|WideOr0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_b(1)(6));

-- Location: PIN_AF10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(0));

-- Location: PIN_AB12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(1));

-- Location: PIN_AC12,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(2));

-- Location: PIN_AD11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(3));

-- Location: PIN_AE11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(4));

-- Location: PIN_V14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(5));

-- Location: PIN_V13,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[0][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(0)(6));

-- Location: PIN_V20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(0));

-- Location: PIN_V21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(1));

-- Location: PIN_W21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(2));

-- Location: PIN_Y22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(3));

-- Location: PIN_AA24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(4));

-- Location: PIN_AA23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(5));

-- Location: PIN_AB24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[1][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(1)(6));

-- Location: PIN_AB23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(0));

-- Location: PIN_V22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(1));

-- Location: PIN_AC25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(2));

-- Location: PIN_AC26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(3));

-- Location: PIN_AB26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(4));

-- Location: PIN_AB25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(5));

-- Location: PIN_Y24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[2][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(2)(6));

-- Location: PIN_Y23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(0));

-- Location: PIN_AA25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(1));

-- Location: PIN_AA26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(2));

-- Location: PIN_Y26,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(3));

-- Location: PIN_Y25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(4));

-- Location: PIN_U22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(5));

-- Location: PIN_W24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 24mA
\segment_result[3][6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_segment_result(3)(6));
END structure;


