library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity tb_rom_example is
end tb_rom_example;

  -----------------------------------------------------------------------------
  -- DEZE TESTBANK MOET JE OP 10 PLAATSEN AANPASSEN AAN JE TE TESTEN ONTWERP
  -- DIT IS STEEDS AANGEGEVEN MET EEN COMMENTAARBLOK IN HOOFDLETTERS
  -- (ZOALS DIT)
  -----------------------------------------------------------------------------


architecture behavioural of tb_rom_example is

  -----------------------------------------------------------------------------
  -- DEZE SECTIE AANPASSEN (PLAATS 1 VAN 11):
  -- VUL HIER DE NAAM VAN JE  MEM-BESTAND IN
  -----------------------------------------------------------------------------
  constant memfile    : string := "display_encoder.mem";

  -----------------------------------------------------------------------------
  -- DEZE SECTIE AANPASSEN (PLAATS 2 VAN 11):
  -- CONFIGURATIE VAN DE TESTBANK
  -- 
  -- Voor COMBINATORISCHE modules:
  -- LAAT BEIDE CONSTANTEN HIERONDER OP '0' STAAN!!
  -- 
  -- Voor SEQUENTIËLE modules:
  -- ZET tb_uses_skips VOOR SKIPPEN VAN TESTPATRONEN 
  -- EERSTE BIT IN VECTORFILE IS DAN NOSKIP
  -- (NIET NODIG ALS JE ALLE PATRONEN WIL TESTEN)
  -- ZET tb_sequential HOOG VOOR SEQUENTIELE SYSTEMEN
  -- EERSTE BIT (EVT NA NOSKIP) IN VECTORFILE IS DAN RESET
  -----------------------------------------------------------------------------
 
  constant tb_sequential  : STD_LOGIC := '0';
  constant tb_uses_skips  : STD_LOGIC := '0';
  
  -----------------------------------------------------------------------------
  -- DEZE SECTIE ALTIJD AANPASSEN (PLAATS 3 VAN 11):
  -- SIGNALEN DIE WORDEN VERBONDEN MET 
  -- IN- EN UITGANGEN VAN HET TE TESTEN ONTWERP
  -- EN REFERENTIEWAARDEN VOOR DE UITGANGEN
  -----------------------------------------------------------------------------
  -- ingangen
  signal sw    : STD_LOGIC_VECTOR(7 downto 0);
  --signal dut_in0    : STD_LOGIC_VECTOR(2 downto 0);
  --signal dut_in1    : STD_LOGIC;
  
  -- uitgangen
  --signal dut_out     : STD_LOGIC;
  signal an : STD_LOGIC_VECTOR (3 downto 0);
  signal seg : STD_LOGIC_VECTOR (6 downto 0);

  -- gewenste (correcte) uitgangen
  signal an_gewenst : STD_LOGIC_VECTOR (3 downto 0);
  signal seg_gewenst : STD_LOGIC_VECTOR (6 downto 0);


  -----------------------------------------------------------------------------
  -- NIET WIJZIGEN: Vaste interne signalen voor de testbank
  -----------------------------------------------------------------------------

  file file_VECTORS   : TEXT;
  signal do_eval      : STD_LOGIC:='0';
  signal tb_init      : STD_LOGIC:='0';
  signal clk, reset   : STD_LOGIC;
  signal tb_done, run : STD_LOGIC := '0';
  signal num_errors   : integer := 0;
  signal num_tests    : integer := 0;
  
  -----------------------------------------------------------------------------
  -- NIET WIJZIGEN: Periode waarbinnen elke combinatorische berekening afgerond moet zijn
  -----------------------------------------------------------------------------
  constant periode: time := 10ns;
  
  
begin

-----------------------------------------------------------------------------
-- DEZE SECTIE AANPASSEN (PLAATS 4 VAN 11):
-- TE TESTEN MODULE (DUT = DEVICE UNDER TEST)
-----------------------------------------------------------------------------
 
DUT : entity work.display_encoder_board(Behavioral)
     port map (
        sw => sw,
        seg => seg,
        an => an
    );


-----------------------------------------------------------------------------
-- NIET WIJZIGEN: 
-- Hoofdproces: start en stop van testbank, openen en sluiten van testvectorbestand
-----------------------------------------------------------------------------
process
    variable s            : line;
    begin
        file_open(file_VECTORS, memfile,  read_mode);
        run <='0';
        wait for 100ns;
        run <= '1';
        wait until (tb_done = '1');
        run <= '0';
        wait for periode;
        file_close(file_VECTORS);
        wait for periode;
        -- wait;
        writeline(output,s);       
        write(s,num_tests);
        write(s,string'(" test patterns run, "));
        write(s,num_errors);
        write(s,string'(" error(s) detected"));
        writeline(output,s);       
        writeline(output,s);       
        assert FALSE report "This is not a failure: all tests completed" severity failure;
        wait;
end process;
 
 
----------------------------------------------------------------
-- NIET WIJZIGEN: klokgenerator                   
----------------------------------------------------------------

 process(run, clk)
 begin
    if run='0' then
        clk <= '0';
    else
        clk <= not clk after periode;
    end if;
 end process;
 
 
----------------------------------------------------------------
-- verificatieproces
----------------------------------------------------------------
process(clk)
    variable s            : line;
    variable match        : boolean;
begin
    if rising_edge(clk) then

        ----------------------------------------------------------------
        -- DEZE SECTIE AANPASSEN (PLAATS 5 VAN 11):
        -- PAS NAAM UIGANG AAN VOOR BEREKENING match 
        -- VOEG SIGNALEN TOE MET "and" VOOR MEERDERE UITGANGEN
        ----------------------------------------------------------------
        
        match := (an = an_gewenst and seg = seg_gewenst); 
        
        if ((tb_init='1')and not(match)) then
          if ( not(do_eval = '1')) then
            write(s,string'("Error for UNEVALUATED test input: "));
          else 
            write(s,string'("ERROR for test input: "));
            num_errors <= num_errors + 1;
          end if;
        else
          if do_eval = '1' then
            write(s,string'("Test OK for test input: "));
          end if;
        end if;
        
        if ((tb_init='1')and((do_eval = '1') or not(match))) then
        
          --------------------------------------------------------------
          -- DEZE SECTIE AANPASSEN (PLAATS 6 VAN 11):
          -- RAPPORTERING OVER INGANGEN VAN TE TESTEN ONTWERP
          -- 
          ----------------------------------------------------------------
          if (tb_sequential='1') then
            write(s,reset);
            write(s,string'(", "));
          end if;
          write(s,sw);
          write(s,string'(", "));
          --write(s,dut_out1);
          
          --------------------------------------------------------------
          -- DEZE SECTIE AANPASSEN (PLAATS 7 VAN 11):
          -- RAPPORTERING OVER UITGANGEN VAN TE TESTEN ONTWERP
          ----------------------------------------------------------------
          
          write(s,string' (" (output seg="));
          write(s,seg);
          write(s,string'(", desired output seg="));
          write(s,seg_gewenst);
          write(s,string'(")"));
          write(s,string' (" (output an="));
          write(s,an);
          write(s,string'(", desired output an="));
          write(s,an_gewenst);
          write(s,string'(")"));
          writeline(output,s);
        end if;      
    end if;
end process;


  ---------------------------------------------------------------------------
  -- Proces dat het bestand inleest en de gelezen data doorschrijft naar 
  -- de juiste signalen
  -- Merk op dat lijnen met een # commentaarlijnen zijn.
  -- deze worden genegeerd, maar wel uitgeschreven naar het scherm
  ---------------------------------------------------------------------------
  process(clk)
    variable v_ILINE     : line;
    variable NOSKIP    : std_logic;
    variable RST     : std_logic;
    variable v_SPACE : character;
    
    ---------------------------------------------------------
    -- DEZE SECTIE AANPASSEN (PLAATS 8 VAN 11):
    -- DECLAREER VARIABELEN VOOR INLEZEN VAN ELKE INGANG VAN HET TE TESTEN ONTWERP
    ---------------------------------------------------------
    variable INP_sw   : std_logic_vector(7 downto 0);
    
    ---------------------------------------------------------
    -- DEZE SECTIE AANPASSEN (PLAATS 9 VAN 11):
    -- DECLAREER VARIABELEN VOOR INLEZEN VAN ELKE UITGANG VAN HET TE TESTEN ONTWERP
    --------------------------------------------------------- 
    variable OUTP_seg      : std_logic_vector(6 downto 0);
    variable OUTP_an      : std_logic_vector(3 downto 0);
     
  begin
    if falling_edge(clk) then
        if endfile(file_VECTORS) then
            tb_done <= '1';
        else
            tb_done <= '0';
            tb_init <='1';
            
            -- lees een lijntje uit je vectorbestand
            readline(file_VECTORS, v_ILINE);
            while (v_ILINE(1) = '#') loop
                writeline(output,v_ILINE);
                readline(file_VECTORS, v_ILINE);
            end loop;

            ---------------------------------------------------------
            -- signalen inlezen uit lijntje
            ---------------------------------------------------------
            
            if tb_uses_skips='1' then
              read(v_ILINE, NOSKIP);
              do_eval <= NOSKIP;
              read(v_ILINE, v_SPACE);           -- read in the space character
            else
              do_eval <= '1';
            end if;
            
            if tb_sequential = '1' then
              read(v_ILINE, RST);
              reset <= RST;
              read(v_ILINE, v_SPACE);           -- read in the space character
            else
              reset <= '0';
            end if;            
            
          --------------------------------------------------------------
          -- DEZE SECTIE AANPASSEN (PLAATS 10 VAN 11):
          -- DUT-INGANGEN
          ---------------------------------------------------------
            
            read(v_ILINE, INP_sw);
            sw <= INP_sw;
            read(v_ILINE, v_SPACE);           -- read in the space character
            --read(v_ILINE, INP_IN1);
            --dut_in1 <= INP_IN1;
            --read(v_ILINE, v_SPACE);           -- read in the space character
            
           --------------------------------------------------------------
          -- DEZE SECTIE AANPASSEN (PLAATS 11 VAN 11):
          -- DUT-UITGANGEN
          ---------------------------------------------------------
            
            read(v_ILINE, OUTP_an);
            an_gewenst <= OUTP_an;
            read(v_ILINE, OUTP_seg);
            seg_gewenst <= OUTP_seg;
            
            
            num_tests <= num_tests + 1;
        end if;
    end if;
 
  end process;
end behavioural;
