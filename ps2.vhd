LIBRARY ieee;
USE ieee.numeric_bit.all;

entity ps2_keyboard is

  generic ( clk_freq : INTEGER := 50_000_000; --system clock frequency in Hz
           debounce_counter_size : INTEGER := 8);         --set such that (2^size)/clk_freq = 5us (size = 8 for 50MHz)
  port( clk          : in  BIT;   --system clock
        ps2_clk      : in  BIT;   --clock signal from PS/2 keyboard
        ps2_data     : in  BIT;   --data signal from PS/2 keyboard
        ps2_code_new : out BIT;   --flag that new PS/2 code is available on ps2_code bus
        ps2_code     : out BIT_VECTOR(7 downto 0); --code received from PS/2
		  ps2_code_translated: out BIT_VECTOR(7 downto 0));
end ps2_keyboard;

architecture behave of ps2_keyboard is
  signal sync_ffs     : BIT_VECTOR(1 downto 0);  --synchronizer flip-flops for PS/2 signals
  signal ps2_clk_int  : BIT;  --debounced clock signal from PS/2 keyboard
  signal ps2_data_int : BIT;  --debounced data signal from PS/2 keyboard
  signal ps2_word     : BIT_VECTOR(10 downto 0);  --stores the ps2 data word
  signal error        : BIT;  --validate parity, start, and stop bits
  signal count_idle   : INTEGER range 0 to clk_freq/18_000; --counter to determine PS/2 is idle
  signal ps2_code_data: BIT_vector(7 downto 0);
  
  --declare debounce component for debouncing PS2 input signals
  component debounce is
    generic ( counter_size : INTEGER); --debounce period (in seconds) = 2^counter_size/(clk freq in Hz)
    port( clk    : in  BIT;  --input clock
          button : in  BIT;  --input signal to be debounced
          result : out BIT); --debounced signal
  end component;
  
begin

  --synchronizer flip-flops
  process(clk)
  begin
    if( clk'EVENT and clk = '1') then  --rising edge of system clock
      sync_ffs(0) <= ps2_clk;           --synchronize PS/2 clock signal
      sync_ffs(1) <= ps2_data;          --synchronize PS/2 data signal
    end if;
  end process;

  --debounce PS2 input signals
  debounce_ps2_clk: debounce
    generic map(counter_size => debounce_counter_size)
    port map(clk => clk, button => sync_ffs(0), result => ps2_clk_int);
    
  debounce_ps2_data: debounce
    generic map(counter_size => debounce_counter_size)
    port map(clk => clk, button => sync_ffs(1), result => ps2_data_int);

  --input PS2 data
  process(ps2_clk_int)
  begin
    if(ps2_clk_int'EVENT and ps2_clk_int = '0') then    --falling edge of PS2 clock
      ps2_word <= ps2_data_int & ps2_word(10 downto 1);   --shift in PS2 data bit
    end if;
  end process;
    
  --verify that parity, start, and stop bits are all correct
  error <= not (not ps2_word(0) and ps2_word(10) and (ps2_word(9) XOR ps2_word(8) XOR
        ps2_word(7) XOR ps2_word(6) XOR ps2_word(5) XOR ps2_word(4) XOR ps2_word(3) XOR 
        ps2_word(2) XOR ps2_word(1)));  

  --determine if PS2 port is idle (i.e. last transaction is finished) and output result
  process(clk)
  begin
    if(clk'EVENT and clk = '1') then  --rising edge of system clock
    
      if(ps2_clk_int = '0') then --low PS2 clock, PS/2 is active
        count_idle <= 0; --reset idle counter
      elsif(count_idle /= clk_freq/18_000) then  --PS2 clock has been high less than a half clock period (<55us)
          count_idle <= count_idle + 1;  --continue counting
      end if;
      
      if(count_idle = clk_freq/18_000 and error = '0') then  --idle threshold reached and no errors detected
        ps2_code_new <= '1'; --set flag that new PS/2 code is available
        ps2_code_data <= ps2_word(8 downto 1); --output new PS/2 code
      else --PS/2 port active or error detected
        ps2_code_new <= '0';  --set flag that PS/2 transaction is in progress
      end if;
      
    end if;
	 
	   case ps2_code_data IS            
                  WHEN x"1C" => ps2_code_translated <= x"41"; --A
                  WHEN x"32" => ps2_code_translated <= x"42"; --B
                  WHEN x"21" => ps2_code_translated <= x"43"; --C
                  WHEN x"23" => ps2_code_translated <= x"44"; --D
                  WHEN x"24" => ps2_code_translated <= x"45"; --E
                  WHEN x"2B" => ps2_code_translated <= x"46"; --F
                  WHEN x"34" => ps2_code_translated <= x"47"; --G
                  WHEN x"33" => ps2_code_translated <= x"48"; --H
                  WHEN x"43" => ps2_code_translated <= x"49"; --I
                  WHEN x"3B" => ps2_code_translated <= x"4A"; --J
                  WHEN x"42" => ps2_code_translated <= x"4B"; --K
                  WHEN x"4B" => ps2_code_translated <= x"4C"; --L
                  WHEN x"3A" => ps2_code_translated <= x"4D"; --M
                  WHEN x"31" => ps2_code_translated <= x"4E"; --N
                  WHEN x"44" => ps2_code_translated <= x"4F"; --O
                  WHEN x"4D" => ps2_code_translated <= x"50"; --P
                  WHEN x"15" => ps2_code_translated <= x"51"; --Q
                  WHEN x"2D" => ps2_code_translated <= x"52"; --R
                  WHEN x"1B" => ps2_code_translated <= x"53"; --S
                  WHEN x"2C" => ps2_code_translated <= x"54"; --T
                  WHEN x"3C" => ps2_code_translated <= x"55"; --U
                  WHEN x"2A" => ps2_code_translated <= x"56"; --V
                  WHEN x"1D" => ps2_code_translated <= x"57"; --W
                  WHEN x"22" => ps2_code_translated <= x"58"; --X
                  WHEN x"35" => ps2_code_translated <= x"59"; --Y
                  WHEN x"1A" => ps2_code_translated <= x"5A"; --Z
                  WHEN OTHERS => NULL;
                END CASE;
  end process;
  
  ps2_code <= ps2_code_data;
  
  
end behave;