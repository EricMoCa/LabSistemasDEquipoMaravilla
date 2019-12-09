entity ContMLCD is Port (
	MCLK : in bit ; -- RESET : in bit ;
	RSin : in bit ;
	Enter : in bit ;
	DataIn : in bit_vector(7 downto 0);
	RSstate : out bit ;
RS : out bit ;
RW : out bit ;
EN : out bit ;

DataOut : out bit_vector(7 downto 0);
LEDDataOut: out bit_vector(7 downto 0));
end ContMLCD;
-- DEBOUNCER entity Debouncer is
port (Q, clk: in bit;
Qout: out bit);
end Debouncer;
architecture Behavioral of Debouncer is signal Qb: bit;
begin
 process (clk) begin
if clk'event and clk = '1' then Qb <= Q;
Qout <= Qb; end if;
end process; end Behavioral;
-- DEBOUNCER -- SINGLE PULSE
entity SinglePulse is
port (Button, clk: in bit;
SP: out bit);
end SinglePulse;
architecture structural of SinglePulse is
signal syncpress: bit; signal nQ: bit;
component Debouncer is
port (Q, clk: in bit;
Qout: out bit);
end component;
begin
DB1 : Debouncer port map (Button, clk, syncpress);
process (clk) begin
if clk'event and clk = '1' then nQ <= not syncpress;
end if; end process;
SP <= nQ and syncpress;

 end structural;
-- SINGLE PULSE
architecture Behavioral of ContMLCD is
signal SPEN: bit;
SIGNAL CLK1KHz: bit;
signal DATA: bit_vector(7 downto 0);
SIGNAL CLK1KHz_cont : unsigned(15 DOWNTO 0):= (OTHERS => '0');
component SinglePulse is
port (Button, clk: in bit;
SP: out bit);
end component; begin
-- CODIGO PARA GENERAR UNA SEÑAL DE 1KHZ PROCESS (MCLK)
BEGIN
IF (RISING_EDGE(MCLK)) THEN
IF CLK1KHz_cont = 25_000 THEN CLK1KHz_cont <= (OTHERS => '0'); CLK1KHz <= NOT CLK1KHz;
ELSE
CLK1KHz_cont <= CLK1KHz_cont + 1;
END IF; ELSE NULL;
END IF; END PROCESS;
-- FIN CODIGO
SP1: SinglePulse port map(Enter, clk1khz, SPEN);
Data <= DataIn;
RS <= RSin;
RW <= '0'; LEDDataOut <= Data; DataOut <= DataIn;

EN <= SPEN; end Behavioral;