#==============================================================================
# MS - Change Character on Dash
#------------------------------------------------------------------------------
# por Masked
#------------------------------------------------------------------------------
# O script faz com que o personagem mude de gráfico ao correr, é possível usar
# gráficos normais ou spritesets compatíveis com o MBS - Spritesheet
#==============================================================================
module MS_DashChar_Config
#==============================================================================
# Configurações
#==============================================================================
 
# O sufixo que deve aparecer no final do nome do arquivo para ele ser usado na
# animação de corrida
DashSFX = "_dash"
 
# Se quiser que o gráfico a ser usado seja obtido a partir do
# MS - Spritesheet, deixe como true, se não, deixe como false
# Nesse caso, é necessário configurar um spriteset :default_dash
MSSprite_DashChar = true
 
# Se estiver usando o script MS - Movimento em 8 direções, e quiser que o
# gráfico de corrida na diagonal mude também, deixe como true, se não, deixe
# como false
# Lembre-se de que, se deixar este valor como true, você vai precisar
# configurar um spriteset :isometric_dash
Dash_Char = true
 
#==============================================================================
# Fim das configurações
#==============================================================================
end
#==============================================================================
# Game_Player
#==============================================================================
class Game_Player < Game_Character
  include MS_DashChar_Config
 
  alias ms_upd update
  #----------------------------------------------------------------------------
  # * Atualização do Processo
  #----------------------------------------------------------------------------
  def update
    ms_upd
    if dash? && Input.dir8 != 0
  if !MSSprite_DashChar
    @character_name = "#{@character_name.sub(DashSFX,"")}#{DashSFX}" if FileTest.file?("#{@character_name}#{DashSFX}")
  elsif Dash_Char
  if @pose == :isometric || @pose == :isometric_dash
  @pose = :isometric_dash
elsif @pose == :default
  @pose = :default_dash
else
  @pose = :default_dash
end
else
  @pose = :default_dash if @pose == :default or @pose == :default_dash
end
else
  @character_name = @character_name.sub(DashSFX,"") unless MSSprite_DashChar
  @pose = :default if @pose == :default or @pose == :default_dash if MSSprite_DashChar
  @pose = :isometric if @pose == :isometric or @pose == :isometric_dash if MSSprite_DashChar
end
end
end
