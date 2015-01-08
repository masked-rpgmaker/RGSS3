#==============================================================================
# MS - Idle Character
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MS_Idle_Character_Config
  # Sufixo do arquivo com o gráfico do personagem parado
  IDLE_SFX = "_idl"
  
  # Se estiver usando o script MBS - Spritesheet, deixe 
  # como true e configure uma pose :idle nas configurações
  # dele, caso contrário, deixe como false
  MBS_SPR = true

end
#==============================================================================
# Fim das Configurações
#==============================================================================
class Game_Player < Game_Character
  include MS_Idle_Character_Config
  alias mbs_mvbi move_by_input
  
  def move_by_input
    mbs_mvbi
    @pose = :idle if Input.dir8 == 0 && MBS_SPR
    @character_name = @character_name + IDLE_SFX unless @character_name =~ /#{IDLE_SFX}/ || !Input.dir8 == 0 || MBS_SPR || !FileTest.file?(@character_name+IDLE_SFX)
    @character_name = @character_name.sub(IDLE_SFX,"") unless Input.dir8 == 0 || MBS_SPR
  end
end
