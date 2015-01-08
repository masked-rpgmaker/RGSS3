#==============================================================================
# ** Sprite_Picture
#------------------------------------------------------------------------------
#  Este sprite é usado para exibir imagens. Ele observa uma instância
# da classe Game_Picture e automaticamente muda as condições do sprite.
#==============================================================================

class Sprite_Picture < Sprite
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     viewport : camada
  #     picture : imagem (Game_Picture)
  #--------------------------------------------------------------------------
  def initialize(viewport, picture)
    super(nil)
    @picture = picture
    update
  end
end
