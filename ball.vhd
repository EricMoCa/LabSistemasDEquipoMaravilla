library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.commonPak.all;

entity pelota is
	generic(
		numCollisionObjects: integer := 2;
		pelotaRadius : integer := 10;
		rgbColor : std_logic_vector(7 downto 0) := "111" & "111" & "11"
	);
	port(
		reset: in std_logic;
		clk: in std_logic;
		hCount: in integer range 0 to 1023;
		vCount: in integer range 0 to 1023;
		colObject: out type_collisionRect := init_type_collisionRect;
		colObjectArray: in type_collisionRectArray(0 to numCollisionObjects-1);
		
		drawElement: out type_drawElement := init_type_drawElement;
		
		score: out type_score := init_type_score
		
	);
end pelota;

architecture Behavioral of pelota is
	signal pelotaObj: type_collisionRect := init_type_collisionRect;
begin
	
	colObject <= pelotaObj;
	
	
	anim: process(clk) -- PROCESS PARA CONTROLAR LA ANIMACION DE LA PELOTA
		variable update_clk_count: integer := 0;
		variable update_clk_prescaler: integer := 833333; -- 50 Mhz / clk_prescaler = desired speed
		
		variable temp_pelotaObj: type_collisionRect := pelotaObj;
		variable temp_pelotaObj_bounds: type_bounds;
		
		variable currColObjectBounds: type_bounds;
		
		variable xColliding: boolean := false;
		variable yColliding: boolean := false;
		
		variable scoreReg: type_score := init_type_score;
		
	
		
	begin
		if rising_edge(clk) then
			if reset = '1' then --RESET PONE LA PELOTA EN MEDIO DE LA PANTALLA
				pelotaObj.pos.x <= SCREEN_RESX/2 - pelotaRadius;
				pelotaObj.pos.y <= SCREEN_RESY/2 - pelotaRadius;
				pelotaObj.width <= pelotaRadius * 2;
				pelotaObj.height <= pelotaRadius * 2;
				pelotaObj.velocity.x <= -3;
				pelotaObj.velocity.y <= 2;
				
				scoreReg := init_type_score;
			
				
				
				temp_pelotaObj := pelotaObj;
				temp_pelotaObj_bounds := createBounds(pelotaObj);
				
				xColliding := false;
				yColliding := false;
				
	
				
			else
				if update_clk_count >= update_clk_prescaler then
					
					
					
			
					temp_pelotaObj := pelotaObj;
					
		
						temp_pelotaObj.width := pelotaRadius * 2;
						temp_pelotaObj.height := pelotaRadius * 2;
					
					
			
					temp_pelotaObj_bounds := createBounds(pelotaObj);
					
					
					-- En caso de que la pelota entre a la pared izquierda
					-- Suma un valor de uno al marcador derecho
					if temp_pelotaObj_bounds.left < 0 then
						temp_pelotaObj.pos.x := SCREEN_RESX/2 - pelotaRadius;
						temp_pelotaObj.pos.y := SCREEN_RESY/2 - pelotaRadius;
						
						scoreReg.right := scoreReg.right + 1;
					
					-- En caso de que la pelota entre a la pared derecha
					-- Suma un valor de uno al marcador izquierdo
					elsif temp_pelotaObj_bounds.right > SCREEN_RESX-1 then
						temp_pelotaObj.pos.x := SCREEN_RESX/2 - pelotaRadius;
						temp_pelotaObj.pos.y := SCREEN_RESY/2 - pelotaRadius;
						
						scoreReg.left := scoreReg.left + 1;
					end if;
					
					
					score <= scoreReg;
					
					
					
				
					temp_pelotaObj_bounds := createBounds(pelotaObj);
					
					-- En caso de golpear la pared superior o la inferior
					if temp_pelotaObj_bounds.top < 0 or temp_pelotaObj_bounds.bottom > SCREEN_RESY-1 then
						-- REBOTA DE LA PARED
						temp_pelotaObj.velocity.y := temp_pelotaObj.velocity.y * (-1);
					end if;
					
					
					
				
					-- Actualiza posicion X
					temp_pelotaObj.pos.x := temp_pelotaObj.pos.x + temp_pelotaObj.velocity.x;
					
					for i in colObjectArray'range loop
						-- Esto se usa para crear los border de los objetos 
						-- Con los que rebota la pelota
						currColObjectBounds := createBounds(colObjectArray(i));
						
						-- Revisa contactos entre objetos
						xColliding := false;
						yColliding := false;
						xColliding := xColliding or CheckCollisionX(temp_pelotaObj, colObjectArray(i));
						yColliding := yColliding or CheckCollisionY(temp_pelotaObj, colObjectArray(i));
						
					
						-- En caso de que la pelota rebote en X con otro objeto
						if xColliding and yColliding then
							
							if temp_pelotaObj.velocity.x > 0 then
								temp_pelotaObj.pos.x := currColObjectBounds.left-temp_pelotaObj.width-1;
							else
								temp_pelotaObj.pos.x := currColObjectBounds.right+1;
							end if;
							
							-- Rebota del objeto
							temp_pelotaObj.velocity.x := temp_pelotaObj.velocity.x * (-1);
							
							
						end if;
					end loop;
				
				
				
					-- Actualiza posicion Y
					temp_pelotaObj.pos.y := temp_pelotaObj.pos.y + temp_pelotaObj.velocity.y;
					
					for i in colObjectArray'range loop
						-- Esto se usa para crear los border de los objetos 
						-- Con los que rebota la pelota
						currColObjectBounds := createBounds(colObjectArray(i));
					
						-- Revisa si hay contactos entre la pelota y objetos
						xColliding := false;
						yColliding := false;
						xColliding := xColliding or CheckCollisionX(temp_pelotaObj, colObjectArray(i));
						yColliding := yColliding or CheckCollisionY(temp_pelotaObj, colObjectArray(i));

				

						-- En caso de exista colision en Y
						if xColliding and yColliding then
							
							if temp_pelotaObj.velocity.y > 0 then
								temp_pelotaObj.pos.y := currColObjectBounds.top-temp_pelotaObj.height-1;
							else
								temp_pelotaObj.pos.y := currColObjectBounds.bottom+1;
							end if;
							
							
							-- Rebota del objeto
							temp_pelotaObj.velocity.y := (temp_pelotaObj.velocity.y * (-1)) + colObjectArray(i).velocity.y;
						end if;
					end loop;
				
					
				
					pelotaObj <= temp_pelotaObj;
					
					
					
					
					update_clk_count := 0;
				end if;
				
				update_clk_count := update_clk_count + 1;
			end if;
		end if;
	
	end process;


	drawing: process(clk) -- PROCESS PARA DIBUJAR LA PELOTA
		variable objectBounds: type_bounds;
		

	begin
		if rising_edge(clk) then
			if reset = '1' then
				drawElement.pixelOn <= false;
				drawElement.rgb <= (others => '0');
			else
				drawElement.rgb <= rgbColor;

				objectBounds := createBounds(pelotaObj);

				-- SI LA PELOTA ESTA DENTRO DE UNA COORDENADA VALIDA
				if hCount >= objectBounds.left and hCount <= objectBounds.right and vCount >= objectBounds.top and vCount <= objectBounds.bottom then
						
				drawElement.pixelOn <= true;
		
					
				else
					drawElement.pixelOn <= false;
				end if;
			end if;
		end if;
	end process;


end Behavioral;

