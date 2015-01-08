#==============================================================================
# MBS - Stat_Point - Processo principal
#
# by Masked
#
# O script pode ser configurados nas Configurações.
# O Battler do char é um gráfico na pasta pictures chamado Battler_ActorX, sendo
# o X o id do personagem sem 0 (1, 2, 3, ...)
#
#==============================================================================
#==============================================================================
# Configurações
#==============================================================================
module MBS_Stat_Point_Config
# Pontos ganhos a cada nível:
 Points_By_Level = 3
# Quantidade de HP aumentada com 1 ponto
  HP_Change = 15
# Quantidade de MP aumentada com 1 ponto  
  MP_Change = 15
# Quantos pontos são aumentados nos outros atributos a cada 1 ponto
  Basic_Change = 1
end
#==============================================================================
# Fim das configurações
#==============================================================================
class Scene_MBS_Stat_Point < Scene_Base
  include MBS_Stat_Point_Config
  def start
    super
    @actor_id = 0
    @already_added_points = false
    $mbs_actor_id = @actor_id
    $mbs_added_points = {'hp' => 0, 'mp' => 0, 'atk' => 0, 'def' => 0, 'mat' => 0, 'mdf' => 0, 'agi' => 0, 'luk' => 0}
    @window_help = Window_Base.new(0, 0, 544, 50)
    @window_help.contents.draw_text(544 / 2 - 70, 0, 544, 30, "Distribuição de Atributos")
    @window_actor_data1 = Window_Base.new(0, 50, 210, 416 - 200)
    @window_actor_data2 = Window_Selectable.new(210, 50, 544 - 210, 416)
    @window_actor_data2.contents.draw_text(100, -20, 100, 64, "Status:")
    @window_actor_data2.index = 2
    @window_instructions = Window_Base.new(0, 416 - 150, 210, 150)
    @window_instructions.contents.draw_text(5, -10, 190, 64, "Q ou W > Trocar Herói")
    @window_instructions.contents.draw_text(5, 14, 190, 64, "→ > Aumentar Status")
    @window_instructions.contents.draw_text(5, 38, 190, 64, "← > Diminuir Status")
    @window_instructions.contents.draw_text(5, 62, 190, 64, "Enter > Confirmar Mudanças")
    @battler = Sprite.new
    @hp_bar = HP_Bar.new
@mp_bar = MP_Bar.new
@df_bar = Def_Bar.new
@at_bar = Atk_Bar.new
@ma_bar = M_Atk_Bar.new
@md_bar = M_Def_Bar.new
@ag_bar = Agi_Bar.new
@lk_bar = Luk_Bar.new
    end
  def update
  super
  refresh if something_changed?
   if Input.trigger?(:B)
     unless @confirmed_add
      $game_party.members[@actor_id].points += $mbs_added_points['hp'] / HP_Change + $mbs_added_points['mp'] / MP_Change + ($mbs_added_points['atk'] + $mbs_added_points['def'] + $mbs_added_points['mat'] + $mbs_added_points['mdf'] + $mbs_added_points['agi'] + $mbs_added_points['luk']) / Basic_Change
       end
  SceneManager.return
end
confirm_add if Input.trigger?(:C)
  @window_actor_data2.index += 1 if Input.repeat?(:DOWN) and @window_actor_data2.index < 9
  @window_actor_data2.index -= 1 if Input.repeat?(:UP) and @window_actor_data2.index > 2
  if Input.trigger?(:R) and @actor_id < $game_party.members.size - 1
    @actor_id += 1
    $mbs_actor_id = @actor_id
    refresh
    end
  if Input.trigger?(:L) and @actor_id > 0
    @actor_id -= 1
    $mbs_actor_id = @actor_id
    refresh
  end
  if Input.repeat?(:RIGHT) and $game_party.members[@actor_id].points > 0
    add_point_to
end
  if Input.repeat?(:LEFT)
remove_point_of
    end
  end
  def add_point_to
    case @window_actor_data2.index
  when 2
    $mbs_added_points['hp'] += HP_Change
  when 3
    $mbs_added_points['mp'] += MP_Change
  when 4
    $mbs_added_points['atk'] += Basic_Change
  when 5
    $mbs_added_points['def'] += Basic_Change
  when 6
    $mbs_added_points['mat'] += Basic_Change
  when 7
    $mbs_added_points['mdf'] += Basic_Change
  when 8
    $mbs_added_points['agi'] += Basic_Change
  when 9
    $mbs_added_points['luk'] += Basic_Change
  end
  @already_added_points = true
  $game_party.members[@actor_id].points -= 1
  refresh
end
def confirm_add
  $game_party.members[@actor_id].add_param(0, $mbs_added_points['hp'])
  $game_party.members[@actor_id].add_param(1, $mbs_added_points['mp'])
  $game_party.members[@actor_id].add_param(2, $mbs_added_points['atk'])
  $game_party.members[@actor_id].add_param(3, $mbs_added_points['def'])
  $game_party.members[@actor_id].add_param(4, $mbs_added_points['mat'])
  $game_party.members[@actor_id].add_param(5, $mbs_added_points['mdf'])
  $game_party.members[@actor_id].add_param(6, $mbs_added_points['agi'])
  $game_party.members[@actor_id].add_param(7, $mbs_added_points['luk'])
  instance_variables.each {|varname|
  ivar = instance_variable_get(varname)
  ivar.dispose if ivar.is_a?(Window) or ivar.is_a?(Sprite)}
      
  @confirmed_add = true
    SceneManager.return
  end
def remove_point_of
      if @already_added_points
  case @window_actor_data2.index
  when 2
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['hp'] > 0
    $mbs_added_points['hp'] -= HP_Change if $mbs_added_points['hp'] > 0
  when 3
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['mp'] > 0
    $mbs_added_points['mp'] -= MP_Change if $mbs_added_points['mp'] > 0
  when 4
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['atk'] > 0
    $mbs_added_points['atk'] -= Basic_Change if $mbs_added_points['atk'] > 0
  when 5
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['def'] > 0
    $mbs_added_points['def'] -= Basic_Change if $mbs_added_points['def'] > 0
  when 6
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['mat'] > 0
    $mbs_added_points['mat'] -= Basic_Change if $mbs_added_points['mat'] > 0
  when 7
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['mdf'] > 0
    $mbs_added_points['mdf'] -= Basic_Change if $mbs_added_points['mdf'] > 0
  when 8
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['agi'] > 0
    $mbs_added_points['agi'] -= Basic_Change if $mbs_added_points['agi'] > 0
  when 9
        $game_party.members[@actor_id].points += 1 if $mbs_added_points['luk'] > 0
    $mbs_added_points['luk'] -= Basic_Change if $mbs_added_points['luk'] > 0
  end
  @already_added_points = false if $mbs_added_points == {'hp' => 0, 'mp' => 0, 'atk' => 0, 'def' => 0, 'mat' => 0, 'mdf' => 0, 'agi' => 0, 'luk' => 0}
  refresh
  end
end
def something_changed?
  return true if @actor_id != @old_actor_id
end
def refresh
  @old_actor_id = @actor_id
  @window_actor_data1.contents.clear
  @window_actor_data2.contents.clear
  @window_actor_data2.contents.draw_text(100, -20, 100, 64, "Status:")
  @window_actor_data2.contents.draw_text(10, 233, 100, 24, "Equips:")
  if $game_party.members[@actor_id].equips[0] != nil
  @window_actor_data2.contents.draw_text(100, 233, 200, 24, "Arma: #{$game_party.members[@actor_id].equips[0].name}")
else
@window_actor_data2.contents.draw_text(100, 233, 200, 24, "Arma:")
end
  if $game_party.members[@actor_id].equips[1] != nil
  @window_actor_data2.contents.draw_text(100, 257, 200,24, "Escudo: #{$game_party.members[@actor_id].equips[1].name}")
else
  @window_actor_data2.contents.draw_text(100, 257, 200, 24, "Escudo:")
  end
  if $game_party.members[@actor_id].equips[2] != nil
  @window_actor_data2.contents.draw_text(100, 281, 200, 24, "Cabeça: #{$game_party.members[@actor_id].equips[2].name}")
else
  @window_actor_data2.contents.draw_text(100, 281, 200, 24, "Cabeça:")
end
if $game_party.members[@actor_id].equips[3] != nil
  @window_actor_data2.contents.draw_text(100, 305, 200, 24, "Armadura: #{$game_party.members[@actor_id].equips[3].name}")
else
  @window_actor_data2.contents.draw_text(100, 305, 200, 24, "Armadura:")
  end
  if $game_party.members[@actor_id].equips[4] != nil
  @window_actor_data2.contents.draw_text(100, 329, 200, 24, "Acessório: #{$game_party.members[@actor_id].equips[4].name}")
else
  @window_actor_data2.contents.draw_text(100, 329, 200, 24, "Acessório:")
  end
  @window_actor_data1.draw_face($game_party.members[@actor_id].face_name, $game_party.members[@actor_id].face_index, 0, 0)
  @window_actor_data1.contents.draw_text(95, 0, 100, 64, $game_party.members[@actor_id].name)
  @window_actor_data1.contents.draw_text(95, 24, 100, 64, "Lv #{$game_party.members[@actor_id].level}")
  @window_actor_data1.contents.draw_text(95, 48, 90, 64, $game_party.members[@actor_id].class.name)
  @window_actor_data1.contents.draw_text(95, 72, 100, 64, "Exp: #{$game_party.members[@actor_id].exp}")
  @window_actor_data1.contents.draw_text(95, 96, 100, 64, "Pontos: #{$game_party.members[@actor_id].points}")

@hp_bar.dispose
@mp_bar.dispose
@at_bar.dispose
@df_bar.dispose
@ma_bar.dispose
@md_bar.dispose
@ag_bar.dispose
@lk_bar.dispose
@hp_bar = HP_Bar.new
@mp_bar = MP_Bar.new
@df_bar = Def_Bar.new
@at_bar = Atk_Bar.new
@ma_bar = M_Atk_Bar.new
@md_bar = M_Def_Bar.new
@ag_bar = Agi_Bar.new
@lk_bar = Luk_Bar.new

  @battler.bitmap = Cache.picture("Battler_Actor#{$game_party.members[@actor_id].id}")
  @battler.x = 544 - @battler.width
  @battler.y = 60
  @battler.z = 200
  end
def self.actor_id
  return @actor_id.to_i
end

def terminate
  super
  instance_variables.each {|varname|
  ivar = instance_variable_get(varname)
  ivar.dispose if ivar.is_a?(Window) or ivar.is_a?(Sprite)}
end
end
#==============================================================================
# MBS - Stat_Point - Barras
#
# by Masked
#
#==============================================================================
class HP_Bar < Sprite
def initialize
  super
@color = Color.new(50, 205, 50)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = ($game_party.members[$mbs_actor_id].mhp + $mbs_added_points['hp']) / 15
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 114, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 89, 50, 64, "HP:")
end
end
class MP_Bar < Sprite
def initialize
  super
@color = Color.new(0, 0, 255)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = ($game_party.members[$mbs_actor_id].mmp + $mbs_added_points['mp']) / 15
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 138, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 113, 50, 64, "MP:")
end
end
class Def_Bar < Sprite
def initialize
  super
@color = Color.new(0, 255, 0)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].def + $mbs_added_points['def']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 186, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 161, 50, 64, "Def:")
end
end
class Atk_Bar < Sprite
def initialize
  super
@color = Color.new(255, 0, 0)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].atk + $mbs_added_points['atk']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 162, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 137, 50, 64, "Atq:")
end
end
class M_Def_Bar < Sprite
def initialize
  super
@color = Color.new(255, 165, 0)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].mdf + $mbs_added_points['mdf']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 234, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 209, 50, 64, "Def.M:")
end
end
class M_Atk_Bar < Sprite
def initialize
  super
@color = Color.new(255, 0, 255)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].mat + $mbs_added_points['mat']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 210, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 185, 50, 64, "Atk.M:")
end
end
class Agi_Bar < Sprite
def initialize
  super
@color = Color.new(112, 128, 144)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].agi + $mbs_added_points['agi']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 258, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 233, 50, 64, "Agi:")
end
end
class Luk_Bar < Sprite
def initialize
  super
@color = Color.new(139, 69, 19)
@color2 = Color.new(255, 255, 255)
@back_color = Color.new(20, 20, 20)
@x_size = $game_party.members[$mbs_actor_id].luk + $mbs_added_points['luk']
self.bitmap = Bitmap.new(544, 416)
self.z = 200
self.bitmap.clear
self.bitmap.gradient_fill_rect(270, 282, @x_size, 15, @color, @color2)
self.bitmap.draw_text(220, 257, 50, 64, "Sorte:")
end
end
#==============================================================================
# Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  alias mbs_initialize initialize
  attr_accessor  :points
  def initialize(actor_id)
    mbs_initialize(actor_id)
    @points = 0 if @points == nil
  end
  def level_up
    @level += 1
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level == @level
    end
    @points += MBS_Stat_Point_Config::Points_By_Level
    end
  end
