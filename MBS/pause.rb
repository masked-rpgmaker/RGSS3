#==============================================================================
# MBS - Pause
#
# by Masked
#
#==============================================================================
module MBS_Pause_Config
#==============================================================================
# Configurações:
#==============================================================================
 
# Tecla que será pressionada para pausar/voltar o jogo, para isso, use a tabela:
 
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
 
Button = :X
 
# Texto mostrado na cena de pause
 
Text = "Pausado"
 
# Switch que ativa o sistema
 
Switch = 1

# Tom da tela na cena, para configurar use o modelo:
# Tone.new(tom de vermelho, verde, azul, cinza)
# os tons podem ser negativos, Tone.new(0,0,0,0) não muda nada

Screen_Tone = Tone.new(0,0,0,255)

# Cor da barra central, use o modelo:
# Color.new(vermelho,verde,azul,opacidade)
# lembrando que as cores não podem ser negativas e Color.new(0,0,0) é preto
# total
Center_Bar_Color = Color.new(0,0,0,200)
 
#==============================================================================
# Fim das configurações
#==============================================================================
end
#==============================================================================
# ** Scene_Pause
#------------------------------------------------------------------------------
# Esta é a cena usada para quando o jogo fica pausado
#==============================================================================
class Scene_Pause < Scene_Base
  include MBS_Pause_Config
  def start
    super
    create_background
    create_center_bar
  end
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.tone.set(Screen_Tone)
  end
  def create_center_bar
    @center_bar = Sprite.new
    @center_bar.bitmap = Bitmap.new(544,416)
    @center_bar.bitmap.fill_rect(0, 416/2 - 50, 544, 100, Center_Bar_Color)
    @center_bar.bitmap.font.size = 42
    @center_bar.bitmap.draw_text(0, 416/2 - 50, 544, 100, Text, 1)
  end
  def update
    super
    SceneManager.return if Input.trigger?(Button)
  end
end
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
# Nessa classe serão feitas as alterações para que ao pressionar a tecla
# configurada a tela de pause seja chamada
#==============================================================================
class Scene_Map
  alias mbs_upd update
  def update
    mbs_upd
if $game_switches[MBS_Pause_Config::Switch]
  SceneManager.call(Scene_Pause) if Input.trigger?(MBS_Pause_Config::Button)
end
  end
end
