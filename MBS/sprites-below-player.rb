#==============================================================================
# MBS - Imagens debaixo do player
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  Este sprite é usado para mostrar personagens. Ele observa uma instância
# da classe Game_Character e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     viewport  : camada
  #     character : personagem (Game_Character)
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(nil)
    @character = character
    @balloon_duration = 0
    update
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  
  alias mbs_upd update
  
  def update
    mbs_upd
    self.z = 10
  end
end
