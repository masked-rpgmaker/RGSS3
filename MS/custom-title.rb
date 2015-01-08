#==============================================================================
# MS - Tela de Título Customizável
#
# por Masked
#
#==============================================================================

module MS_Title_Config

  Background_Effects_Config = [] # Não mecha  
  
#==============================================================================
# Configurações:
#
# ● Logo: deixe como true para ativar a opção de iniciar com logos e como false 
# para desativar
#
# ● Logo_Music: Aqui você põe o nome da BGM da tla de logo, não se esqueça de 
# especificar a extensão do arquivo.
#
# ● Logo_Config: Aqui você configura as partes da cena de Logo, usando o modelo
# a seguir:
# 
# ["Nome da imagem na pasta System", tempo de permanência, velocidade de fade]
#
# Sempre que quiser adicionar uma opção, use o modelo e ponha depois disso:
#
# Logo_Config = [
# 
# E antes disso:
#
# ]
#
# Lembre-se de que os logos aparecerão na ordem em que estão nessa área, 
# sempre que adicionar uma opção, certifique-se de adicionar uma vírgula no fim
# da opção anterior. Também é preciso tirar a vírgula depois da última 
# configuração de logo.
#
# ● Mode: Deixe como 'Window'para usar janelas e como 'Image' para usar imagens
#
# ● Cursor: Deixe como true para ativar imagens para os cursores que ficam na 
# opção selecionada e como false para não usar nada.
#
# ● Cursor_Images: Aqui você configura as imagens usadas como cursores, ponha 
# os nomes das imagens na pasta System entre parêntesis e separados por vírgula
# um do outro, lembrando que eles devem estar entre os colchetes. No primeiro
# lugar, coloque o nome da imagem do cursor esquerdo e no segundo o do cursor
# direito. Caso apenas um cursor seja definido, ele será usado para os dois 
# lados (se Both_Side_Cursor for true). Os dois cursores devem apontar para o 
# mesmo lado (direita se for apontar para o opção e esquerda se for apontar 
# para o outro lado).
#
# ● Cursor_Animation: Deixe como true para atviar as animações de movimento no
# evento e como false para desativar
#
# ● Cursor_Animation_Config: Configure cada item dentro dessa opção:
#
# - 'amplitude': é a distância que o cursor vai percorrer na animação
#
# - 'speed': a velocidade com que o cursor faz o percurso
#
# - 'rotation_speed': a velocidade com que o cursor gira na percurso, deixe
# como 0 para desativar
#
# - 'rotation_correction_x': Correção no eixo de rotação horizontal, mude para
# a posição em píxels de onde fica o eixo.
#
# - 'rotatioin_correction_y': igual ao item anterior, porém ajusta o eixo de
# rotação vertical
#
# - 'fade': Até quanto a opacidade do cursor diminui
#
# - 'fade_speed': Velocidade com que a opacidade do cursor diminui
#
# ● Both_Side_Cursor: Deixe como true para ativar os cursores nos dois lados e
# como false para usar em apenas um.
#
# ● Default_Cursor_Side: Deixe como 0 para deixar o cursor na esquerda e 1 para
# deixá-lo na direita, só funciona de Both_Side_Cursor for false.
#
# ● Background_Effects: Deixe como true para ativar a animação de fundo e false
# para desativá-la.
#
# ● Background_Images: Uma lista das imagens de fundo, os nomes das imagens na 
# pasta System devem estar separados por vírgulas enter si e devem estar dentro
# dos colchetes, a ordem em que forem escritas é a mesma que serão posicionadas
# (quanto antes escrita, mais em baixo ficará a imagem) 
#
# ● Background_Effects_Config[X]: Configuração dos efeitos da imagem de fundo 
# X ( a contagem começa do 0, e é baseada na imagem na posição X no 
# Background_Images):
#
# 'effects': uma lista de efeitos, eles podem ser 'Wave', para efeito de 
# ondulação, 'Fade' para aumentar e diminuir a transparência e 'Move' para 
# movimentar as imagens.
# 
# 'wave_amplitude': a amplitude em píxels das ondas do efeito de ondulação.
#
# 'wave_speed': velocidade com que a onda avança.
#
# 'fade_max': máximo que a transparência do background aumenta.
#
# 'fade_speed': velocidade com que a transparência do fundo aumenta / diminui
#
# 'move_amplitude': a quantidade de píxels que as imagens de fundo se move em 
# cada direção
#
# 'move_speed': a velocidade com que as imagens de fundo se movem
#
# 'rotation_speed': a velocidade com que as imagens de fundo giram.
#
# 'rotation_correction_x': correção na posição do eixo de rotação horizontal da
# imagem, coloque a posição em píxels do eixo de rotação na imagem.
#
# 'rotation_correction_y': correção na posição do eixo de rotação vertical da
# imagem, coloque a posição em píxels do eixo de rotação na imagem.
#
# ● Name: deixe como true para ativar o uso da imagem com o nome do jogo e como 
# false para desativar
#
# ● Name_Image: Ponha o nome da imagem na pasta System
#
# ● Name_Positions: O primeiro número é a posição horizontal do nome do jogo e
# o segundo é a posição vertical do mesmo.
# 
# ● Name_Effects: Deixe como true para ativar a animação na imagem de nome e 
# como false para desativá-la.
#
# ● Name_Effects_Config: Aqui se configura as opções dos efeitos no nome do 
# jogo, seguindo a lista:
#
# 'effects': configure quais efeitos acontecerão no nome, eles podem ser 'Wave'
# para ondular a imagem / texto, 'Fade', para aumentar e diminuir a 
# transparência do nome, e 'Move', para mover o nome.
#
# 'wave_amplitude': mude o número para o tamanho que terão as ondas no nome.
#
# 'wave_speed': velocidade com que as ondas se movem
#
# 'fade_max': o máximo de opacidade que o nome pode perder
#
# 'fade_speed': a velocidade com que o ome perde opacidade
#
# 'move_x_amplitude': a quantidade de píxels que o nome avança na horizontal
#
# 'move_y_amplitude': a quantidade de píxels que o nome avança na vertical
#
# 'move_speed': a velocidade com que o nome se move
#
# ● Name_Mode: Configure se quer que o nome seja uma imagem ou um texto, 
# respectivamente ficaria: "Image" ou "Write"
#
# ● Name_Font: Só funciona se Name_Mode for "Write", ponha entre as aspas o 
# nome da fonte com que se escreverá o nome
#
# ● Name_Font_Size: Tamanho da fonte usada na hora de se escrever o nome (só 
# funciona se Name_Mode for "Write")
#
# ● Options: Aqui é onde se configuram as opções que estarão no menu, para isso
# usa-se este modelo:
#
# ["Nome da Opção", "Nome da imagem", "Nome da imagem quando selecionada"]
#
# ● Window_Config: Configuração da posição da janela (Caso Mode seja "Window"),
# o primeiro número é a posição horizontal e o segundo é a posição vertical.
#
# Options_Positions: Só funciona se Mode for "Image"
#
# 'Nome da opção': Deve estar igual ao primeiro item de Options, dentro dessa,
# configure o primeiro item dentro dos colchetes como a posição horizontal da
# imagem da opção e o segundo como a posição vertical.
# 
#==============================================================================

  Logo = false
  
  Logo_Music = "Airship.ogg"
  
  Logo_Config = [
  ["logo1", 1, 5],
  ["logo2", 1, 4],
  ["logo3", 1, 3]
  ]
    
  Mode = 'Window'
    
  Cursor = true
  
  Cursor_Images = ["Title_CursorLeft", "Title_CursorRight"]
  
  Cursor_Animation = true
  
  Cursor_Animation_Config = {
  'amplitude' => 50,
  'speed' => 1,
  'rotation_speed' => 0,
  'rotation_correction_x' => 30,
  'rotation_correction_y' => 0,
  'fade' => 50,
  'fade_speed' => 1
  
  }
  
  Both_Side_Cursor = true
  
  Default_Cursor_Side = 0
  
  Background_Effects = true
  
  Background_Images = ["Title_Background", "Title_Background2"]
    
  Background_Effects_Config[0] = {

  'effects' => [""],
  'wave_amplitude' => 0,
  'wave_speed' => 0,
  'fade_max' => 0,
  'fade_speed' => 0,
  'move_x_amplitude' => 0,
  'move_y_amplitude' => 0,
  'move_speed' => 0
  }
  
  Name = true
  
  Name_Image = "Title_GameName"
  
  Name_Positions = [172, 10]
  
  Name_Effects = true
  
  Name_Effects_Config = {
  'effects' => [""],
  'wave_amplitude' => 0,
  'wave_speed' => 0,
  'fade_max' => 0,
  'fade_speed' => 0,
  'move_x_amplitude' => 0,
  'move_y_amplitude' => 0,
  'move_speed' => 0
  
  }
  
  Name_Mode = "Write"
  
  Name_Font = "Times New Roman"
  
  Name_Font_Size = 42
    
  Options = [
  ['Novo Jogo',"Title_NewGame","Title_NewGame_Selected"], 
  ['Continuar',"Title_Continue","Title_Continue_Selected"],
  ['Sair',"Title_Exit","Title_Exit_Selected"]
  ]
  
  Window_Config = [180, 123, 150, 100, "Window"]  
  
  Options_Positions = {
  'Novo Jogo' => [200, 200],
  'Continuar' => [185, 250], 
  'Sair' => [200, 300]
  }
  
end

#==============================================================================
# Fim das configurações
#
# Não altere nada abaixo a não ser que saiba o que está fazendo. 
#==============================================================================

#==============================================================================
# ▼ Scene_Title
#
# Aqui são feitas as alterações na tela de título, que inclui:
#
# - os métodos de criação de imagens, cursores, janela e nome do jogo.
#
# - os métodos de atualização de cada umdos itens criados nos métodos citados
# acima
#
# - alterações nos métodos 'start', 'update' e 'terminate'
#
#==============================================================================

class Scene_Title < Scene_Base
  
  include MS_Title_Config # Incluindo o módulo de configuração

#==============================================================================
# ● start:
#==============================================================================
  def start
    super
    Audio.bgm_play("Audio/BGM/#{Logo_Music}")        
    create_logo if Logo
    
    play_title_music
    create_background
    create_name if Name
  if Mode == 'Window'
    create_window
    
  else
    create_images

  end
    @index = 0
    create_cursor if Cursor
    
    @continue_enabled = true if !Dir.glob('Save*.rvdata2').empty?
  end

#==============================================================================
# ● update:
#==============================================================================

  
  def update
  super
if Input.repeat?(:DOWN) and @index < Options.size - 1
  @index += 1 
  
  @cursor_1.opacity = 255 if Cursor
  @cursor_2.opacity = 255 if Cursor and Both_Side_Cursor
  @cursor_1.x = @cursor_1_original_x if Cursor
  @cursor_2.x = @cursor_2_original_x if Cursor and Both_Side_Cursor
  
 if Mode == "Image" 
if Cursor
       if Default_Cursor_Side == 0 
         
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5 
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5
    
  elsif Default_Cursor_Side == 1
  case @index
  when 0
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
when 1
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_1.ox
when 2
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_1.ox
  end
  end

if Both_Side_Cursor 
  
      if Default_Cursor_Side == 0 
        
        case @index
  when 0
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
when 1
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_2.ox
when 2
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_2.ox
end

  elsif Default_Cursor_Side == 1

  @cursor_2.x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox

end

end
end
end
  Sound.play_cursor
  
elsif Input.repeat?(:UP) and @index > 0
  @index -= 1
 
  @cursor_1.opacity = 255 if Cursor
  @cursor_2.opacity = 255 if Cursor and Both_Side_Cursor
  @cursor_1.x = @cursor_1_original_x if Cursor
  @cursor_2.x = @cursor_2_original_x if Cursor and Both_Side_Cursor
if Mode == "Image"
if Cursor
       if Default_Cursor_Side == 0 
         
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5 
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5
  
  elsif Default_Cursor_Side == 1
  case @index
  when 0
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
when 1
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_1.ox
when 2
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_1.ox
  end
  end

if Both_Side_Cursor 
  
      if Default_Cursor_Side == 0 
        
        case @index
  when 0
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
when 1
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @continue.width + 5 + @cursor_2.ox
when 2
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @exit.width + 5 + @cursor_2.ox
end

  elsif Default_Cursor_Side == 1

  @cursor_2.x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox

end

end
end
end

  Sound.play_cursor
  
elsif Input.trigger?(:C)
  
  case @index
  
  when 0
      Sound.play_ok
    DataManager.setup_new_game
    fadeout_all
    $game_map.autoplay
    SceneManager.goto(Scene_Map)
    
  when 1
    if @continue_enabled
      Sound.play_ok
    SceneManager.call(Scene_Load)
  else
    Sound.play_buzzer
  end
  
  when 2
      Sound.play_ok
    SceneManager.exit
    
end    
    
end

@name_effects = []

@background_effects = []

if Name_Effects
  
  for effect in Name_Effects_Config['effects']
    
    @name_effects.push(effect)
      
  end
  
refresh_name_effects 

end

if Background_Effects  
  for i in 0...Background_Effects_Config.size
  
    bg_config = Background_Effects_Config[i]
    
  for effect in bg_config['effects']
    
    @background_effects[i] = [] if @background_effects[i].nil?
    @background_effects[i].push(effect)
      
  end
  end
  refresh_background_effects
   
 end

   refresh_window unless @refreshed_window or Mode == "Image"

   refresh_images if Mode == "Image"

   refresh_cursor if Cursor
  
  end

#==============================================================================
# ● create_background:
#==============================================================================
  
  def create_background
    @background = []
  for i in 0...Background_Images.size
    @background[i] = Sprite.new
    @background[i].bitmap = Cache.system(Background_Images[i])
  end
  
end

#==============================================================================
# ● create_logo:
#==============================================================================
  def create_logo
  @logo = Sprite.new
  @logo.opacity = 0  
  times = 0
  for logo in Logo_Config
@logo.bitmap = Cache.system(logo[0])
until @logo.opacity >= 255
@logo.opacity += logo[2]
Graphics.update
end
until times >= logo[1] * 9999990
times += 1
end
until @logo.opacity <= 0
@logo.opacity -= logo[2]
Graphics.update
end
times = 0
  end
  
  end

#==============================================================================
# ● create_window:
#==============================================================================
  
  def create_window
  
  @window = Window_Selectable.new(Window_Config[0], Window_Config[1], Window_Config[2], Window_Config[3])
  
  @window.windowskin = Cache.system(Window_Config[4])
  @window.contents.draw_text(5, 0, Window_Config[2], 24, Options[0][0])
  @window.change_color(Color.new(255, 255, 255), false) unless @continue_enabled
  @window.change_color(Color.new(255, 255, 255)) if @continue_enabled
  @window.contents.draw_text(5, 24, Window_Config[2], 24, Options[1][0])
  @window.change_color(Color.new(255, 255, 255)) unless @continue_enabled
  @window.contents.draw_text(5, 48, Window_Config[2], 24, Options[2][0])
  
  end

#==============================================================================
# ● refresh_window:
#==============================================================================
  
  def refresh_window
  
  @refreshed_window = true  
    
  @window.contents.clear  
    
  @window = Window_Selectable.new(Window_Config[0], Window_Config[1], Window_Config[2], Window_Config[3])
  
  @window.windowskin = Cache.system(Window_Config[4])
  @window.change_color(Color.new(255, 255, 255))
  @window.contents.draw_text(5, 0, Window_Config[2], 24, Options[0][0])
  @window.change_color(Color.new(255, 255, 255), false) unless @continue_enabled
  @window.contents.draw_text(5, 24, Window_Config[2], 24, Options[1][0])
  @window.change_color(Color.new(255, 255, 255)) unless @continue_enabled
  @window.contents.draw_text(5, 48, Window_Config[2], 24, Options[2][0])
    
  end

#==============================================================================
# ● create_name:
#==============================================================================
  
  def create_name
  
    @name = Sprite.new
    @name_original_x = Name_Positions[0]
    @name_original_y = Name_Positions[1]
    
    if Name_Mode == "Image"
    
    @name.bitmap = Cache.system(Name_Image)
    @name.x = Name_Positions[0]
    @name.y = Name_Positions[1]
    
  else
    
    bitmap = Bitmap.new(544, 416)
    bitmap.font.size = Name_Font_Size
    bitmap.font.name = [Name_Font, "Verdana", "Arial"]
    @name.bitmap = bitmap
    @name.bitmap.draw_text(Name_Positions[0], Name_Positions[1], 544 - Name_Positions[0] - 50, 60, $data_system.game_title)
    
    end
    
  end

#==============================================================================
# ● create_images:
#==============================================================================
  
  def create_images
    
@new_game = Sprite.new
@new_game.x = Options_Positions[Options[0][0]][0]
@new_game.y = Options_Positions[Options[0][0]][1]
@new_game.bitmap = Cache.system(Options[0][1])

@continue = Sprite.new
@continue.x = Options_Positions[Options[1][0]][0]
@continue.y = Options_Positions[Options[1][0]][1]
@continue.bitmap = Cache.system(Options[1][1])

@exit = Sprite.new
@exit.x = Options_Positions[Options[2][0]][0]
@exit.y = Options_Positions[Options[2][0]][1]
@exit.bitmap = Cache.system(Options[2][1])
    
  end

#==============================================================================
# ● create_cursor:
#==============================================================================
  
  def create_cursor
  
  @cursor_1 = Sprite.new
  @cursor_1.ox = Cursor_Animation_Config['rotation_correction_x']
  @cursor_1.oy = Cursor_Animation_Config['rotation_correction_y']
  @cursor_2 = Sprite.new if Both_Side_Cursor
  @cursor_2.ox = Cursor_Animation_Config['rotation_correction_x'] if Both_Side_Cursor
  @cursor_2.oy = Cursor_Animation_Config['rotation_correction_y'] if Both_Side_Cursor
  @cursor_1.bitmap = Cache.system(Cursor_Images[0])
  @cursor_2.bitmap = Cache.system(Cursor_Images[1]) if Both_Side_Cursor
  @cursor_2.mirror = true if Both_Side_Cursor
  
   if Mode == "Window"
    
    if Default_Cursor_Side == 0 
  @cursor_1.x = Window_Config[0] - @cursor_1.width - 5 + @cursor_1.ox
  @cursor_1_original_x = Window_Config[0] - @cursor_1.width - 5 + @cursor_1.ox
elsif Default_Cursor_Side == 1
  @cursor_1.x = Window_Config[0] + Window_Config[2] + 5 + @cursor_1.ox
  @cursor_1_original_x = Window_Config[0] + Window_Config[2] + 5 + @cursor_1.ox
end

if Both_Side_Cursor 
  
    if Default_Cursor_Side == 0 
  @cursor_2.x = Window_Config[0] + Window_Config[2] + 5 + @cursor_2.ox
  @cursor_2_original_x = Window_Config[0] + Window_Config[2] + 5 + @cursor_2.ox
elsif Default_Cursor_Side == 1
  @cursor_2.x = Window_Config[0] - @cursor_2.width - 5 + @cursor_2.ox
  @cursor_2_original_x = Window_Config[0] - @cursor_2.width - 5 + @cursor_2.ox
end

@cursor_2.y = Window_Config[1] - 12 + @cursor_2.oy
end

@cursor_1.y = Window_Config[1] - 12 + @cursor_1.oy

elsif Mode == "Image"
  
      if Default_Cursor_Side == 0 
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5 
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @cursor_1.ox - @cursor_1.width - 5
elsif Default_Cursor_Side == 1
  @cursor_1.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
  @cursor_1_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_1.ox
end

if Both_Side_Cursor 
  
      if Default_Cursor_Side == 0 
  @cursor_2.x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] + @new_game.width + 5 + @cursor_2.ox
elsif Default_Cursor_Side == 1
  @cursor_2.x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox 
  @cursor_2_original_x = Options_Positions[Options[@index][0]][0] - @cursor_2.width - 5 + @cursor_2.ox 
end

end
  
end
  end
  
#==============================================================================
# ● refresh_images:
#============================================================================== 
  
  def refresh_images
  
  case @index
  
  when 0
    @new_game.bitmap = Cache.system(Options[0][2])
    @continue.bitmap = Cache.system(Options[1][1])
    @exit.bitmap = Cache.system(Options[2][1])
    
  when 1
    @new_game.bitmap = Cache.system(Options[0][1])
    @continue.bitmap = Cache.system(Options[1][2])
    @exit.bitmap = Cache.system(Options[2][1])
    
  when 2
    @new_game.bitmap = Cache.system(Options[0][1])
    @continue.bitmap = Cache.system(Options[1][1])
    @exit.bitmap = Cache.system(Options[2][2])   
  end
  
  end
  
#==============================================================================
# ● refresh_cursor:
#==============================================================================

def refresh_cursor
  
@window.index = @index if Mode == "Window"

if Cursor_Animation

 unless @cursor_1.x <= @cursor_1_original_x - Cursor_Animation_Config['amplitude'] or @invert_move
@cursor_1.x -= Cursor_Animation_Config['speed']

else
  
@invert_move = true
@cursor_1.x += Cursor_Animation_Config['speed']
@invert_move = false if @cursor_1.x >= @cursor_1_original_x

end

@cursor_1.angle += Cursor_Animation_Config['rotation_speed'].to_f

unless @cursor_1.opacity <= 255 - Cursor_Animation_Config['fade'] or @invert_anim
@cursor_1.opacity -= Cursor_Animation_Config['fade_speed']
else
@invert_anim = true
@cursor_1.opacity += Cursor_Animation_Config['fade_speed']
@invert_anim = false if @cursor_1.opacity >= 255

end

 unless @cursor_2.x >= @cursor_2_original_x + Cursor_Animation_Config['amplitude'] or @invert_move
@cursor_2.x += Cursor_Animation_Config['speed']

else
  
@invert_move = true
@cursor_2.x -= Cursor_Animation_Config['speed']
@invert_move = false if @cursor_2.x <= @cursor_2_original_x

end

@cursor_2.angle -= Cursor_Animation_Config['rotation_speed'].to_f

unless @cursor_2.opacity <= 255 - Cursor_Animation_Config['fade'] or @invert_anim
@cursor_2.opacity -= Cursor_Animation_Config['fade_speed']
else
@invert_anim = true
@cursor_2.opacity += Cursor_Animation_Config['fade_speed']
@invert_anim = false if @cursor_2.opacity >= 255

end

end

if Mode == 'Image'

case @index

when 0
  
 @cursor_1.y = Options_Positions[Options[0][0]][1] - @new_game.height / 2
 @cursor_2.y = Options_Positions[Options[0][0]][1] - @new_game.height / 2 if Both_Side_Cursor
  
when 1

 @cursor_1.y = Options_Positions[Options[1][0]][1] - @continue.height / 2
 @cursor_2.y = Options_Positions[Options[1][0]][1] - @continue.height / 2if Both_Side_Cursor
   
when 2
  
@cursor_1.y = Options_Positions[Options[2][0]][1] - @exit.height / 2
@cursor_2.y = Options_Positions[Options[2][0]][1] - @exit.height / 2 if Both_Side_Cursor 
  
end

else

case @index

when 0
  
  @cursor_1.y = Window_Config[1] - 12 + @cursor_1.oy
  @cursor_2.y = Window_Config[1] - 12 + @cursor_2.oy if Both_Side_Cursor
  
when 1
  
  @cursor_1.y = Window_Config[1] + 12 + @cursor_1.oy
  @cursor_2.y = Window_Config[1] + 12 + @cursor_2.oy if Both_Side_Cursor
  
when 2
  
  @cursor_1.y = Window_Config[1] + 36 + @cursor_1.oy
  @cursor_2.y = Window_Config[1] + 36 + @cursor_2.oy if Both_Side_Cursor
  
end  
  
end

end

#==============================================================================
# ● refresh_name_effects:
#==============================================================================

def refresh_name_effects
  
  if @name_effects.include?("Wave")

    @name.wave_amp = Name_Effects_Config['wave_amplitude']
    @name.wave_phase += Name_Effects_Config['wave_speed']
    
  end
  
  if @name_effects.include?("Fade")

    @invert_name_fade = false unless @invert_name_fade
    
    unless @invert_name_fade
      @name.opacity -= Name_Effects_Config['fade_speed']
   
      @invert_name_fade = true if @name.opacity <= 255 - Name_Effects_Config['fade_max']
      
    else
      
    @invert_name_fade = true
    @name.opacity += Name_Effects_Config['fade_speed']

    @invert_name_fade = false if @name.opacity >= 255
  end
  end
    
 if @name_effects.include?("Move")
  
  @invert_name_x_move = false unless @invert_name_x_move
  
  @invert_name_y_move = false unless @invert_name_y_move
  
  unless @name.x >= Name_Effects_Config['move_x_amplitude'] or @invert_name_x_move
    
  @name.x += Name_Effects_Config['move_speed']
  
else
  
  @invert_name_x_move = true
  @name.x -= Name_Effects_Config['move_speed']
  @invert_name_x_move = false if @name.x <= @name_original_x - Name_Effects_Config['move_x_amplitude'] * 2
  
  end
  
unless @name.y >= Name_Effects_Config['move_y_amplitude'] or @invert_name_y_move
    
  @name.y += Name_Effects_Config['move_speed']
  
else
  
  @invert_name_y_move = true
  @name.y -= Name_Effects_Config['move_speed']
  @invert_name_y_move = false if @name.y <= @name_original_y - Name_Effects_Config['move_y_amplitude'] * 2
  
end

end
end

#==============================================================================
# ● refresh_background_effects:
#==============================================================================

def refresh_background_effects

  for i in 0...Background_Effects_Config.size
  
  if @background_effects[i].include?("Wave")

    for i in 0...Background_Effects_Config.size
      
      bg_image = @background[i]
    
    bg_image.wave_amp = Background_Effects_Config[i]['wave_amplitude']
    bg_image.wave_phase += Background_Effects_Config[i]['wave_speed']
    
    end
    
  end
  
  if @background_effects[i].include?("Fade")

    for i in 0...Background_Effects_Config.size
      
      bg_image = @background[i]
      
    @invert_background_fade = false unless @invert_background_fade
    
    unless @invert_background_fade
      @background[i].opacity -= Background_Effects_Config[i]['fade_speed']
   
     @invert_background_fade = true if @background[i].opacity <= 255 - Background_Effects_Config[i]['fade_max']
      
    else
      
    @invert_background_fade = true
    @background[i].opacity += Background_Effects_Config[i]['fade_speed']
    @invert_background_fade = false if @background[i].opacity >= 255
    
  end
      
    end
    
  end
    
  if @background_effects[i].include?("Move")
    
    for i in 0...Background_Effects_Config.size
      
      bg_image = @background[i]
      
      @invert_background_x_move = false unless @invert_background_x_move
  
  @invert_background_y_move = false unless @invert_background_y_move
  
unless @background[i].x >= Background_Effects_Config[i]['move_x_amplitude'] or @invert_background_x_move
    
  @background[i].x += Background_Effects_Config[i]['move_speed']
  
else
  
  @invert_background_x_move = true
  @background[i].x -= Background_Effects_Config[i]['move_speed']
  @invert_background_x_move = false if @background[i].x <= 0 - Background_Effects_Config[i]['move_x_amplitude'] * 2
  
end
  
unless @background[i].y >= Background_Effects_Config[i]['move_y_amplitude'] or @invert_background_y_move
    
  @background[i].y += Background_Effects_Config[i]['move_speed']
  
else
  
  @invert_background_y_move = true
  @background[i].y -= Background_Effects_Config[i]['move_speed']
  @invert_background_y_move = false if @background[i].y <= 0 - Background_Effects_Config[i]['move_y_amplitude'] * 2
  
end

      
    end
    
  end  
    
end

end

#==============================================================================
# ● terminate:
#==============================================================================

  def terminate
  super
  @cursor_1.dispose if Cursor
  @cursor_2.dispose if Cursor and Both_Side_Cursor
  
  if Mode == 'Image'
  @new_game.dispose
  @continue.dispose
  @exit.dispose
end

end

#==============================================================================
# Fim do Script
#==============================================================================

end
