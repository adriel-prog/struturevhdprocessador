library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processador is
  Port (
    clk    : in  STD_LOGIC;
    reset  : in  STD_LOGIC;

    -- Memória de instruções
    i_addr : out STD_LOGIC_VECTOR(7 downto 0);
    i_data : in  STD_LOGIC_VECTOR(7 downto 0);

    -- Memória de dados
    d_addr : out STD_LOGIC_VECTOR(7 downto 0);
    d_data : inout STD_LOGIC_VECTOR(7 downto 0);

    -- Registradores
    r0     : out STD_LOGIC_VECTOR(7 downto 0);
    r1     : out STD_LOGIC_VECTOR(7 downto 0);
    r2     : out STD_LOGIC_VECTOR(7 downto 0);
    r3     : out STD_LOGIC_VECTOR(7 downto 0)
  );
end processador;

architecture rtl of processador is

  -- Unidade de controle
  signal pc      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  signal ir      : STD_LOGIC_VECTOR(7 downto 0);
  signal alu_op  : STD_LOGIC_VECTOR(2 downto 0);
  signal alu_res : STD_LOGIC_VECTOR(7 downto 0);

  -- Unidade de lógica e aritmética
  signal a : STD_LOGIC_VECTOR(7 downto 0);
  signal b : STD_LOGIC_VECTOR(7 downto 0);

  -- Registradores
  signal reg0 : STD_LOGIC_VECTOR(7 downto 0);
  signal reg1 : STD_LOGIC_VECTOR(7 downto 0);
  signal reg2 : STD_LOGIC_VECTOR(7 downto 0);
  signal reg3 : STD_LOGIC_VECTOR(7 downto 0);

begin

  -- Geração do endereço da instrução
  i_addr <= pc;

  -- Fetch da instrução
  process(clk, reset)
  begin
    if reset = '1' then
      pc <= (others => '0');
    elsif rising_edge(clk) then
      pc <= i_data;
    end if;
  end process;

  -- Decodificação da instrução
  process(ir)
  begin
    alu_op <= ir(2 downto 0);
  end process;

  -- Execução da instrução
  process(clk)
  begin
    if rising_edge(clk) then
      case alu_op is
        when "000" => -- MOV
          reg0 <= i_data;
        when "001" => -- ADD
          a <= reg0;
          b <= i_data;
          alu_res <= a + b;
        when "010" => -- SUB
          a <= reg0;
          b <= i_data;
          alu_res <= a - b;
        when "011" => -- MUL
          a <= reg0;
          b <= i_data;
          alu_res <= a * b;
        when "100" => -- DIV
          a <= reg0;
          b <= i_data;
          if b /= (others => '0') then
            alu_res <= a / b;
          else
            alu_res <= (others => '0');
          end if;
        when "101" => -- AND
          a <= reg0;
          b <= i_data;
          alu_res <= a and b;
        when "110" => -- OR
          a <= reg0;
          b <= i_data;
          alu_res <= a or b;
        when "111" => -- NOT
          alu_res <= not reg0;
      end case;
    end if;
  end process;

  -- Escrita dos resultados
  process(clk)
  begin
    if rising_edge(clk) then
      r0 <= alu_res;
    end if;
  end process;

  -- Sinalizações
  d_addr <= pc;
  d_data <= alu_res;

end rtl;
