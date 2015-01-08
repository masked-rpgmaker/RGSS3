#==============================================================================
# Title com partículas:
#
# Configure abaixo como descrito:
#
#==============================================================================
module MBS_Menu_Config
#==============================================================================
# Configurações:
#==============================================================================
# Nome da imagem animada, ela deve estar na pasta Pictures
Image_Name = "a"
# Número de imagens que aparecem na tela 
Image_Number = 200
# Veloocidade com que a opacidade diminui
Opacity_Burn = 7
# Velocidade de movimento da imagem
Movement_Speed = 3
# Velocidade em que a imagem gira
Rotation = 0
end
#==============================================================================
# Fim das Configurações
#==============================================================================
class Scene_Title < Scene_Base
  include MBS_Menu_Config
  alias mbs_start start
  alias mbs_update update
def start
mbs_start
@images = []
@random = []
for i in 0...Image_Number
@images[i] = Sprite.new
@images[i].bitmap = Cache.picture(Image_Name)
@images[i].x = rand(544)
@images[i].y = rand(416)
end
end
def update
mbs_update
  for i in 0...@images.size
        @random[i] = rand(4) if @random[i] == nil
if @random[i] == 0
      @images[i].x += Movement_Speed
    elsif @random[i] == 1
      @images[i].x -= Movement_Speed
    elsif @random[i] == 2
      @images[i].y += Movement_Speed
    elsif @random[i] == 3
      @images[i].y -= Movement_Speed
    end
    @images[i].opacity -= rand(Opacity_Burn)
    if @images[i].opacity == 0
    @images[i].x = rand(544)
    @images[i].y = rand(416)
    @images[i].opacity = 255
  end
  @images[i].angle += Rotation
    end
  end
end
