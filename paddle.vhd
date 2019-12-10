library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library work;
use work.commonPak.all;


entity barra is
	generic(
		sidePos : type_side := left;
		barraLength : integer := 60;
		barraWidth : integer := 10;
		rgbColor : std_logic_vector(7 downto 0) := "111" & "111" & "11"
	);
	port(
		reset: in std_logic;
		clk: in std_logic;
		hCount: in integer range 0 to 1023;
		vCount: in integer range 0 to 1023;
		colObject: out type_collisionRect := init_type_collisionRect;
		
		controls: in type_controls;
		drawElement: out type_drawElement := init_type_drawElement
	);
end barra;

architecture Behavioral of barra is
	signal barraObj: type_collisionRect := init_type_collisionRect;
begin

	colObject <= barraObj;

	anim: process(clk)
		variable update_clk_count: integer := 0;
		variable update_clk_prescaler: integer := 833333; -- 50 Mhz / clk_prescaler = desired speed
		
		variable barraBounds: type_bounds;
		
		variable spaceFromWall: integer := 20;
		
	begin
		if rising_edge(clk) then
			if reset = '1' then

				case sidePos is
					-- Pone la posicion de la barra en la izquierda
					when left => 
						barraObj.pos.x <= spaceFromWall;
						barraObj.pos.y <= (SCREEN_RESY/2)-1 - (barraLength/2);
						
						barraObj.width <= barraWidth;
						barraObj.height <= barraLength;
						
					-- Crea la entidad de la barra en la derecha
					when right => 
						barraObj.pos.x <= SCREEN_RESX - barraWidth - spaceFromWall;
						barraObj.pos.y <= (SCREEN_RESY/2)-1 - (barraLength/2);
						
						barraObj.width <= barraWidth;
						barraObj.height <= barraLength;
						
					when others =>
						null;
						
				end case;
				
				barraObj.velocity.x <= 0;
				barraObj.velocity.y <= 0;
				
				
			else
				if update_clk_count >= update_clk_prescaler then
					-- VETE ARRIBA
					if controls.down = '1' then
						barraObj.velocity.y <= barraObj.velocity.y + 1;
					end if;
					-- VETE ABAJO
					if controls.up = '1' then
						barraObj.velocity.y <= barraObj.velocity.y - 1;
					end if;

					-- NO HAZ NADA
					if controls.up = '0' and controls.down = '0' then
						barraObj.velocity.y <= 0;
					end if;
					
					
					-- Crea las coordenadas donde se encuentran los limites del objeto barra
					barraBounds := createBounds(barraObj);
					
					-- Permite el movimiento en caso de que no este en los limites
					if barraBounds.top + barraObj.velocity.y >= 0 and barraBounds.bottom + barraObj.velocity.y <= SCREEN_RESY-1 then
						barraObj.pos.y <= barraObj.pos.y + barraObj.velocity.y;				
					else
						-- En caso de que este en los limites
						
						if barraBounds.top + barraObj.velocity.y < 0 then
							barraObj.pos.y <= 0;
						--Posiciona la barra arriba	
						elsif barraBounds.bottom + barraObj.velocity.y > SCREEN_RESY-1 then
							barraObj.pos.y <= SCREEN_RESY - barraLength;
						end if;
						-- Posiciona la barra abajo
						-- Le quita el movimiento a la barra
						barraObj.velocity.y <= 0;
					end if;
					
					
					update_clk_count := 0;
				end if;

				update_clk_count := update_clk_count + 1;
			end if;
		end if;
	
	end process;


	drawing: process(clk)
		variable objectBounds: type_bounds;
	begin
		if rising_edge(clk) then
			if reset = '1' then
				drawElement.pixelOn <= false;
				drawElement.rgb <= (others => '0');
			else
				drawElement.rgb <= rgbColor;

				objectBounds := createBounds(barraObj);

				--Si los contadores horizontales y verticales estan dentro 
				--de los margenes de la entidad del objeto.
				if hCount >= objectBounds.left and hCount <= objectBounds.right and vCount >= objectBounds.top and vCount <= objectBounds.bottom then
					drawElement.pixelOn <= true;
				else
					drawElement.pixelOn <= false;
				end if;
				
			end if;
		end if;
	end process;


end Behavioral;

