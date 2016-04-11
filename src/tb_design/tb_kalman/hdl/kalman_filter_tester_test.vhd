--
-- VHDL Architecture tb_kalman.kalman_filter_tester.test
--
-- Created:
--          by - Fernando.UNKNOWN (FERNANDO-LAPTOP)
--          at - 22:13:32 25/04/2015
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_textio.all;
USE ieee.numeric_std.all;
LIBRARY STD;
USE STD.textio.all;
------------------------------

ENTITY kalman_filter_tester IS
   GENERIC( 
      archivo_entrada : string := "T:\TFG2015\src\tb_design\tb_common\text\tb_entrada_kalman_filter.txt";
      archivo_salida  : string := "T:\TFG2015\src\tb_design\tb_common\text\tb_salida_kalman_filter.txt"
   );
   PORT(
      clk   	      : IN     std_logic;
      rst     	    : IN     std_logic;  
      q_addr       : IN     std_logic_vector (3 DOWNTO 0);
      xpo_data_out : IN     std_logic_vector (15 DOWNTO 0);	
      start		      : OUT    std_logic;
      imsr		       : OUT    std_logic_vector (15 DOWNTO 0);
      r			         : OUT    std_logic_vector (15 DOWNTO 0);
      q_data	      : OUT    std_logic_vector (15 DOWNTO 0)
   );

END kalman_filter_tester ;

--

ARCHITECTURE test OF kalman_filter_tester IS
    file stimulus: TEXT open read_mode is archivo_entrada;
    --signal auxiliar: std_logic_vector(48 downto 0);
BEGIN
p_read : process(clk, rst)
	variable l: line;
	variable s: std_logic_vector(48 downto 0);
	variable read_ok : boolean;
	begin
	if rising_edge(clk) then
		if(rst = '1')then
			report "estoy en el reset en read";
			start  <='0';               
			imsr   <= (others => '0');           
			r      <= (others => '0');
			q_data <= (others => '0');
		elsif not endfile(stimulus) then
			readline(stimulus,l);
			read(l,s,read_ok);
			assert read_ok
			report "joderrrrrrrrrr hay errrrrrrrrrrrrrrrror: " & l.all
			severity warning;
			--auxiliar<=s;
			start  <= s(48);              
			imsr   <= s(47 downto 32);           
			r      <= s(31 downto 16);
			q_data <= s(15 downto 0);          
		else
			start  <= '0';               
			imsr   <= (others => '0');           
			r      <= (others => '0');
			q_data <= (others => '0');
		end if;
	end if;
end process p_read;
	
	
p_write : process(clk)
	file matrixout : text open write_mode is archivo_salida;
  variable linea : line;
	variable acc: std_logic_vector(19 downto 0);
	begin
    if rising_edge(clk) then
    		if(rst = '1')then
    			report "estoy en el reset en write";
    			acc <= (others => '0');
    		else
    			acc (19 downto 16) <= q_addr;
    			acc (15 downto 0)  <= xpo_data_out;
    			write(linea, acc);
    			writeline(matrixout, linea);
    		end if;
    end if;
end process p_write;                                                                                    
    
END ARCHITECTURE test;
