#==============================================================================
# MBS - Press Start
#------------------------------------------------------------------------------
# por Masked
#------------------------------------------------------------------------------
# O script cria uma tela de 'Pressione Enter' antes da tela de título
#==============================================================================
module MBS_PS_Config
#==============================================================================
# Configurações
#==============================================================================
 
# Tecla que será pressionada para pular a cena, para isso, use a tabela:
 
#------------------------------------------------------------------------------
# Símbolo   |    Tecla
#           |
#   :C      | Z/Space/Enter
#   :B      |      X
#   :L      |      Q
#   :R      |      W
#   :X      |      A
#   :Y      |      S
#   :Z      |      D
#   :A      |    SHIFT
#------------------------------------------------------------------------------
# Para usar, mude o :C para o símbolo que quiser
#------------------------------------------------------------------------------
 
Button = :C
 
# Nome do arquivo com a imagem de fundo na pasta Pictures
 
BG_Filename = "Start_Background"
 
# Nome do arquivo com a imagem de "Pressione Start" na pasta Pictures
 
PS_Filename = "Start_Press"
 
# Posições Horizontal e Vertical do botão de 'Pressione Start'
 
PS_X = 0
PS_Y = 0
 
# Configurações do fade da imagem
 
Fade_Speed = 5
 
Fade_Max = 200
 
# Cena para que o script redireciona ao pressionar a tecla configurada, para ir
# para a tela de título, deixe como Scene_Title, para ir para o mapa, mude para
# Scene_Map, para mais cenas, veja nos scripts padrão do RPG Maker as classes
# com Scene_
 
Scene = Scene_Title
 
#==============================================================================
# Fim das configurações
#==============================================================================
end
#==============================================================================
# ** Scene_Start
#------------------------------------------------------------------------------
# Essa cena cria uma tela de 'Pressione Enter' antes da tela de título
#==============================================================================
class Scene_Start < Scene_Base
  include MBS_PS_Config
  #----------------------------------------------------------------------------
  # * Inicialização do processo
  #----------------------------------------------------------------------------
  def start
    super
    create_images
  end
  #----------------------------------------------------------------------------
  # * Criação das Imagens
  #----------------------------------------------------------------------------
  def create_images
  @background = Sprite.new
  @background.bitmap = Cache.picture(BG_Filename)
  @button = Sprite.new
  @button.x = PS_X
  @button.y = PS_Y
  @button.bitmap = Cache.picture(PS_Filename)
  end
  #----------------------------------------------------------------------------
  # * Atualização da tela
  #----------------------------------------------------------------------------
  def update
    super
    @button.opacity -= Fade_Speed unless @button.opacity <= 255-Fade_Max or @invert_fade
    if @button.opacity <= 255-Fade_Max
    @invert_fade = true
    elsif @button.opacity == 255
    @invert_fade = false
    end
    @button.opacity += Fade_Speed if @invert_fade
    DataManager.setup_new_game; SceneManager.call(Scene) if Input.trigger?(Button)
  end
  #----------------------------------------------------------------------------
  # * Finalização do processo
  #----------------------------------------------------------------------------
  def terminate
    super
    @background.dispose
    @button.dispose
  end
end
#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
# Nesse módulo será modificada a cena inicial
#==============================================================================
module SceneManager
  #--------------------------------------------------------------------------
  # * Cena da primeira classe
  #--------------------------------------------------------------------------
  def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Start
  end
end
