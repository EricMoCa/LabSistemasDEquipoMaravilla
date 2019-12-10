library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



library work;
use work.commonPak.all;

entity pong is
	port(
		clk: in std_logic;
		sw: in std_logic; -- sw0 is reset
		btn: in std_logic_vector(3 downto 0);
		Led: out std_logic_vector(7 downto 0);
		
		hsync: out std_logic;
		vsync: out std_logic;
		Red: out std_logic;
		Green: out std_logic;
		Blue: out std_logic;
		
		seg: out std_logic_vector(6 downto 0);
		an: out std_logic_vector(3 downto 0)
	);
end pong;

-- PARA ESTE PROYECTO, USAMOS UNA LIBRERIA PROPORCIONADAS POR ERIC EASTWOOD
-- Estas librerias incluyen tipos de datos utiles para simplificar el movimiento
-- De las entidades y deteccion de obtsaculos



architecture Behavioral of pong is

	signal reset: std_logic := '0'; -- RESET ESTA ASIGNADO EN SW(0)

	-- Start out at the end of the display range, 
	-- so we give a sync pulse to kick things off
	signal hCount: integer range 0 to 1023 := 640;
	signal vCount: integer range 0 to 1023 := 480;
	
	signal nextHCount: integer range 0 to 1023 := 641;
	signal nextVCount: integer range 0 to 1023 := 480;

	constant NUM_DRAW_ELEMENTS: integer range 0 to 3 := 3;
	signal drawElementArray: type_drawElementArray(0 to NUM_DRAW_ELEMENTS-1) := (others => init_type_drawElement);
	-- DrawElementArray es un arreglo de DrawElement
	-- Draw Element es un tipo de dato que contiene 2 señales: 
	-- La primera señal es un booleano que tiene el objetivo 
	-- De convertirse en TRUE si los pixeles corresponden
	-- La segunda señal es un codigo RGB que determina
	-- El color que se le dara ese objeto
	
	constant NUM_PELOTA_COLLISION_ELEMENTS: integer range 0 to 2 := 2;
	-- # OBJETOS CON LOS QUE COLISIONA LA PELOTA
	signal pelota_collisionObjects: type_collisionRectArray(0 to NUM_PELOTA_COLLISION_ELEMENTS-1) := (others => init_type_collisionRect);
	-- CollisionRectArray es un arreglo de CollisionRectangle
	-- CollisionRect es un tipo de dato que contiene 4 datos:
	-- El primero y el ultimo, 
	-- RECTANGULO DE COLISION DE LA BOLA
	signal pelota_colRect: type_collisionRect := init_type_collisionRect;
	
	signal player1_btnControls: type_controls := (up => '0', down => '0');
	signal player2_btnControls: type_controls := (up => '0', down => '0');

	signal pongScore: type_score := init_type_score;
	
	component barra is -- DECLARACION DEL COMPONENTE DE LA BARRA
		generic(
			sidePos : type_side; -- En que lugar se encuenta la barra
			barraLength : integer := 80; -- Tamaño de la barra
			barraWidth : integer := 10; -- Ancho de la barra 
			rgbColor : std_logic_vector(7 downto 0) -- Colores en RGB de la barra
		);
		port(
			reset: in std_logic; -- Reset
			clk: in std_logic; -- clk
			hCount: in integer range 0 to 1023; -- Donde se encuentra el contador horizontal
			vCount: in integer range 0 to 1023; -- Donde se encuentra el contador vertical
			colObject: out type_collisionRect := init_type_collisionRect;
			
			controls: in type_controls;
			drawElement: out type_drawElement := init_type_drawElement
		);
	end component;
	
	component pelota is -- DECLARACION DEL COMPONENTE DE LA BOLA
	generic(
		numCollisionObjects: integer;
		pelotaRadius : integer;
		rgbColor : std_logic_vector(7 downto 0)
	);
	port(
		reset: in std_logic; -- Señal de reset de la pelota
		clk: in std_logic; -- Señal de reset del clk
		hCount: in integer range 0 to 1023; 
		vCount: in integer range 0 to 1023;
		colObject: out type_collisionRect := init_type_collisionRect;
		colObjectArray: in type_collisionRectArray(0 to numCollisionObjects-1);
		
		drawElement: out type_drawElement := init_type_drawElement;
		
		score: out type_score := init_type_score
		
	);
end component;
	
	
	
begin

	reset <= sw; -- boton reset se asigna en switch 0
	
	barraLeft: barra
	generic map(sidePos => left, rgbColor => "111" & "000" & "00")
	port map(reset, clk, nextHCount, nextVCount, pelota_collisionObjects(0), player1_btnControls, drawElementArray(0));
	
	barraRight: barra
	generic map(sidePos => right, rgbColor => "000" & "000" & "11")
	port map(reset, clk, nextHCount, nextVCount, pelota_collisionObjects(1), player2_btnControls, drawElementArray(1));
	
	pelotaModule: pelota
	generic map(numCollisionObjects => NUM_pelota_COLLISION_ELEMENTS, pelotaRadius => 5, rgbColor => "111" & "111" & "11")
	port map(reset, clk, nextHCount, nextVCount, pelota_colRect, pelota_collisionObjects, drawElementArray(2), PongScore);


	-- PROCESS PARA CONTROL DE BARRAS
	barras: process(clk)

	begin
		if rising_edge(clk) then -- ESTADO RESET
			if reset = '1' then
				player1_btnControls <= (up => '0', down => '0');
				player2_btnControls <= (up => '0', down => '0');
			else
				player1_btnControls <= (up => btn(3), down => btn(2)); -- ESTADO NORMAL
				player2_btnControls <= (up => btn(1), down => btn(0));
			end if;
		end if;
	end process;






	


	scoreToSevenSeg: process(clk)
		variable bcdLeft: std_logic_vector(7 downto 0) := (others => '0');
		variable bcdRight: std_logic_vector(7 downto 0) := (others => '0');
		
		variable currAn: integer range 0 to 3 := 0; -- ANODO ACTIVADO
		variable currBCD: std_logic_vector(3 downto 0)  := (others => '0'); -- BCD ACTIVADO
	
		variable update_clk_count: integer := 0;
		variable update_clk_prescaler: integer := 100000; -- 50 Mhz / clk_prescaler = desired speed
	begin
		if rising_edge(clk) then
			if reset = '1' then
				bcdLeft := (others => '0');
				bcdRight := (others => '0');
				
				currAn := 0;
				currBCD := (others => '0');
			else
				
				if update_clk_count >= update_clk_prescaler then
					
					-- Update the bcd
					bcdLeft := int_bcd2(pongScore.left);
					bcdRight := int_bcd2(pongScore.right);
					
					-- Set anode correctly
					case currAn is
						when 0 => 
							an <= "1110"; -- AN 0
							currBCD := bcdRight(3 downto 0); 
						when 1 => 
							an <= "1101"; -- AN 1
							currBCD := bcdRight(7 downto 4); 
						when 2 => 
							an <= "1011"; -- AN 2
							currBCD := bcdLeft(3 downto 0); 
						when 3 => 
							an <= "0111"; -- AN 3
							
							currBCD := bcdLeft(7 downto 4);
						
						when others => an <= "1111"; -- NINGUN ANODO ACTIVADO
					end case;
					
					-- DISPLAY SEGMENTO
					case currBCD is
						when "0000" => seg <= "1000000"; -- 0
						when "0001" => seg <= "1111001"; -- 1
						when "0010" => seg <= "0100100"; -- 2
						when "0011" => seg <= "0110000"; -- 3
						when "0100" => seg <= "0011001"; -- 4
						when "0101" => seg <= "0010010"; -- 5
						when "0110" => seg <= "0000011"; -- 6
						when "0111" => seg <= "1111000"; -- 7
						when "1000" => seg <= "0000000"; -- 8
						when "1001" => seg <= "0010000"; -- 9
						
						when others => seg <= "1111111"; 
					end case;
					
					-- Move to the next anode
					currAn := currAn + 1;
					
					update_clk_count := 0;
				end if;
				
				update_clk_count := update_clk_count + 1;
				
			end if;
		end if;
		
		
	end process;










	vgasignal: process(clk)
		variable divide_by_2 : std_logic := '0';  -- VARIABLE QUE SE USA PARA CREAR EL CLOCK DE 25 MHZ
		variable rgbDrawColor : std_logic_vector(7 downto 0) := (others => '0'); -- VARIABLES USADOS PARA EL RGB DE LA PANTALLA
	begin
		
		if rising_edge(clk) then
			if reset = '1' then
				hsync <= '1';
				vsync <= '1';
				
			
				hCount <= 640; -- Inicializacion 
				vCount <= 480;
				nextHCount <= 641;
				nextVCount <= 480;
				
				rgbDrawColor := (others => '0');
				
				divide_by_2 := '0';
			else
				
				-- Running at 25 Mhz (50 Mhz / 2)
				if divide_by_2 = '1' then
					
					if(hCount = 799) then
						hCount <= 0;
						
						if(vCount = 524) then
							vCount <= 0;
						else
							vCount <= vCount + 1;
						end if;
					else
						hCount <= hCount + 1;
					end if;
					
					
					-- RESETEO DEL CONTADOR VGA HORIZONTAL
					if (nextHCount = 799) then	
						nextHCount <= 0;
						
						-- RESETEO DEL CONTADOR VGA VERTICAL
						if (nextVCount = 524) then	
							nextVCount <= 0;
						else
							nextVCount <= vCount + 1;
						end if;
					else
						nextHCount <= hCount + 1;
					end if;
					
					
					
					if (vCount >= 490 and vCount < 492) then  -- Sincronizacion vertical
						vsync <= '0';
					else
						vsync <= '1';
					end if;
					
					if (hCount >= 656 and hCount < 752) then -- Sincronizacion horizontal
						hsync <= '0';
					else
						hsync <= '1';
					end if;
					
					
					-- DENTRO DEL RANGO DEL DISPLAY 
					if (hCount < 640 and vCount < 480) then
						
						
						
						-- Color default del rgb
						rgbDrawColor := "000" & "000" & "00";
						
						
						
						-- LINEA IZQUIERDA
						if hCount >= 0 and hCount < 2 then
							rgbDrawColor := "000" & "000" & "00";
						-- LINEA DERECHA
						elsif hCount <= 639 and hCount > 637 then
							rgbDrawColor := "000" & "000" & "00";
						end if;
						
						
						-- LINEA SUPERIOR
						if vCount >= 0 and vCount < 2 then
							rgbDrawColor := "111" & "111" & "00";
						-- LINEA INFERIOR
						elsif vCount <= 479 and vCount > 477 then
							rgbDrawColor := "111" & "111" & "00";
						end if;



						-- LINEA CENTRAL
						if hCount > (SCREEN_RESX/2)-5 and hCount < (SCREEN_RESX/2)+5 then
							rgbDrawColor := "111" & "111" & "00";
						end if;



						-- DIBUJA 
						-- Aqui se sintetizan 3 modulos que dibujan el objeto si los pixeles verticales y horizontales estan
						-- dentro de la posicion actual del objeto
						for i in drawElementArray'range loop
							if drawElementArray(i).pixelOn then
								rgbDrawColor := drawElementArray(i).rgb; 
							end if;
						end loop;
						
						
						
						
						-- Asigna el color en RGB que se usaran para transmitir color a los datos VGA
						Red <= rgbDrawColor(5);
						Green <= rgbDrawColor(2);
						Blue <= rgbDrawColor(0);
						
						
					else
						Red <= '0';
						Green <= '0';
						Blue <= '0';
					end if;
			
				end if;
				divide_by_2 := not divide_by_2;
			end if;
		end if;
	end process;


end Behavioral;

