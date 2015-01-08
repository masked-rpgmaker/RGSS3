#==============================================================================

# MS - Pixel Movement + Pixel Passability

#------------------------------------------------------------------------------

# por Masked

#==============================================================================

module MBS

  module Pixel_Movement

#==============================================================================

# * Configurações

#==============================================================================



    # O número de vezes que o tamanho do tile será dividido

    # O valor pode ser 2, 4 ou 8 (caso contrário o script não funciona)

    PIXEL_RATE = 2

   

    # Caso queira passabilidade por pixel deixe como true, se não,

    # deixe como false

    PIXEL_PASSABILITY = true

   

    # Deixe como true caso queira o movimento diagonal, se não, deixe

    # como false

    DIAGONAL = true

   

    # Velocidade de movimento do personagem, funciona como as velocidades

    # dos eventos (1 = Muito Lento...5 = Muito rápido) mas não tem limites.

    # Deixe como 0 para ajuste automático.

    MOVE_SPEED = 0

   

    # Caso queira que o script ajuste a fila do grupo deixe como true,

    # se não, deixe como false

    # OBS: Recomendo deixar como false por enquanto, precisa de ajustes

    ADJUST_CATERPILLAR = false

   

    # Caso queira que o script ajuste o movimento dos eventos deixe como

    # true, se não deixe como false

    ADJUST_EVENT_MOVEMENT = true

   

#==============================================================================

# * Fim das Configurações

#==============================================================================

  end

end

#==============================================================================

# ** Game_Map

#==============================================================================

class Game_Map

  alias mbspsble passable?

  def load_passability(filename)

    passability = Table.new(width, height)

    t = ''

    File.open("Data/" + filename + ".passability", 'rb') do |file|

      t = file.read.unpack("S*").pack("C*")

    end

   

    a = t.split('.')

    a.collect! do |n|

      if n =~ /F(.+)000(.+)000(.+)/

        b = [$1, $2, $3].collect {|c| eval("0x#{c}")}

      else

        b = [0,0,0]

      end

    end

    a.each do |b|

      passability[b[0], b[1]] = b[2]

    end

   

    return passability

  end

 

  def normal_passable?(x, y, d)

    bx = (x / MBS::Pixel_Movement::PIXEL_RATE).floor

    by = (y / MBS::Pixel_Movement::PIXEL_RATE).floor

    mbspsble(bx, by, d)

  end

 

  def passable?(x, y, d)

    y -= 1

    if MBS::Pixel_Movement::PIXEL_PASSABILITY

      unless FileTest.file?("Data/Map" + map_id.to_s + ".passability")

        return normal_passable?(x, y, d)

        #mbspsble((x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - rx(d, x, y), (y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - ry(d, x, y), d)

      else

        return (@passability ||= load_passability("Map" + map_id.to_s))[x, y] == 0

      end

    else

      return normal_passable?(x, y, d)

    end

  end

  #--------------------------------------------------------------------------

  # * Definição de passabilidade do barco

  #    x : coordenada X

  #    y : coordenada Y

  #--------------------------------------------------------------------------

  def boat_passable?(x, y)

    check_passage((x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - 1, (y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - (MBS::Pixel_Movement::PIXEL_RATE / 4.0).ceil, 0x0200)

  end

  #--------------------------------------------------------------------------

  # * Definição de passabilidade do navio

  #    x : coordenada X

  #    y : coordenada Y

  #--------------------------------------------------------------------------

  def ship_passable?(x, y)

    check_passage((x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - 1, (y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - MBS::Pixel_Movement::PIXEL_RATE / 4, 0x0400)

  end

  #--------------------------------------------------------------------------

  # * Definição de passabilidade da aeronave

  #    x : coordenada X

  #    y : coordenada Y

  #--------------------------------------------------------------------------

  def airship_land_ok?(x, y)

    check_passage((x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - 1, (y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil - MBS::Pixel_Movement::PIXEL_RATE / 4, 0x0800) && check_passage(x / MBS::Pixel_Movement::PIXEL_RATE, y / MBS::Pixel_Movement::PIXEL_RATE, 0x0f)

  end

  def width

    @map.width * MBS::Pixel_Movement::PIXEL_RATE

  end

  def height

    @map.height * MBS::Pixel_Movement::PIXEL_RATE

  end

  def set_display_pos(x, y)

    x = [0, [x, width - screen_tile_x].min].max unless loop_horizontal?

    y = [0, [y, height - screen_tile_y].min].max unless loop_vertical?

    @display_x = (x + width) % width

    @display_y = (y + height) % height

    @parallax_x = x

    @parallax_y = y

  end

  #--------------------------------------------------------------------------

  # * Aquisição do números de tiles horizontais na tela

  #--------------------------------------------------------------------------

  def screen_tile_x

    Graphics.width / 32 * MBS::Pixel_Movement::PIXEL_RATE

  end

  #--------------------------------------------------------------------------
  # * Aquisição do números de tiles verticais na tela
  #--------------------------------------------------------------------------

  def screen_tile_y

    Graphics.height / 32 * MBS::Pixel_Movement::PIXEL_RATE

  end

  #--------------------------------------------------------------------------
  # * Cálculo de ajuste da coordenada X padrão
  #    x : coordenada X
  #--------------------------------------------------------------------------

  def adjust_x(x)

    if loop_horizontal? && x < @display_x - (width - screen_tile_x) / 2

      x - @display_x + width

    else

      x - @display_x

    end

  end

  #--------------------------------------------------------------------------
  # * Cálculo de ajuste da coordenada Y padrão
  #    y : coordenada Y
  #--------------------------------------------------------------------------

  def adjust_y(y)

    if loop_vertical? && y < @display_y - (height - screen_tile_y) / 2

      y - @display_y + height

    else

      y - @display_y

    end

  end

end

class Integer

  def approx?(n, range)

    (self > n - range && self < n + range) || self == n

  end

end

class Game_CharacterBase

  alias mbsintlz234 initialize

  alias movtombs moveto

  def initialize

    mbsintlz234

  end

  def pos?(x, y)

    ax = (x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil

    bx = (@x / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil

    ay = (y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil

    by = (@y / MBS::Pixel_Movement::PIXEL_RATE.to_f).ceil

    ax.approx?(bx, (MBS::Pixel_Movement::PIXEL_RATE/8.0).round) && ay.approx?(by, (MBS::Pixel_Movement::PIXEL_RATE/8.0).round)

  end

  #--------------------------------------------------------------------------
  # * Definição de coordenada X na tela
  #--------------------------------------------------------------------------

  def screen_x
    $game_map.adjust_x(@real_x) * (32 / MBS::Pixel_Movement::PIXEL_RATE) + (32 / MBS::Pixel_Movement::PIXEL_RATE / 2)
  end

  #--------------------------------------------------------------------------
  # * Definição de coordenada Y na tela
  #--------------------------------------------------------------------------

  def screen_y

    $game_map.adjust_y(@real_y) * (32 / MBS::Pixel_Movement::PIXEL_RATE) + (32 / MBS::Pixel_Movement::PIXEL_RATE / 2) - shift_y - jump_height

  end

  def moveto(x, y)

    movtombs(x * MBS::Pixel_Movement::PIXEL_RATE + MBS::Pixel_Movement::PIXEL_RATE / 2, y * MBS::Pixel_Movement::PIXEL_RATE + MBS::Pixel_Movement::PIXEL_RATE )#/ 2)

  end

end

unless MBS::Pixel_Movement::PIXEL_RATE == 2 || MBS::Pixel_Movement::PIXEL_RATE == 4 || MBS::Pixel_Movement::PIXEL_RATE == 8 

  msgbox("O valor de MBS::Pixel_Movement::PIXEL_RATE deve ser 2, 4 ou 8")

  exit

end

class Game_Player < Game_Character

  #--------------------------------------------------------------------------
  # * Coordenada X do centro da tela
  #--------------------------------------------------------------------------

  def center_x

    (Graphics.width / (32 / MBS::Pixel_Movement::PIXEL_RATE) - 1) / 2.0 #* MBS::Pixel_Movement::PIXEL_RATE

  end

  #--------------------------------------------------------------------------
  # * Coordenada Y do centro da tela
  #--------------------------------------------------------------------------

  def center_y

    (Graphics.height / (32 / MBS::Pixel_Movement::PIXEL_RATE) - 1) / 2.0 #* MBS::Pixel_Movement::PIXEL_RATE

  end

  alias mvbiptmbs move_by_input

  #--------------------------------------------------------------------------
  # * Movimento diagonal
  #--------------------------------------------------------------------------

  def move_by_input

    return mvbiptmbs unless MBS::Pixel_Movement::DIAGONAL

    return if !movable? || $game_map.interpreter.running?

    case Input.dir8

      when 1; move_diagonal(4,2)

      when 2; move_straight(2)

      when 3; move_diagonal(6,2)

      when 4; move_straight(4)

      when 6; move_straight(6)

      when 7; move_diagonal(4,8)

      when 8; move_straight(8)

      when 9; move_diagonal(6,8)

      end

    end

  #--------------------------------------------------------------------------
  # * Aquisição da velocidade de movimento (considerando corrida)
  #--------------------------------------------------------------------------

  def real_move_speed

    if MBS::Pixel_Movement::MOVE_SPEED == 0

      r = 0

      case MBS::Pixel_Movement::PIXEL_RATE

        when 2

          r = 1

        when 4

          r = 2

        when 8

          r = 3

      end

      @move_speed + (dash? ? 1 : 0) + r

    else

      @move_speed = MBS::Pixel_Movement::MOVE_SPEED

      @move_speed + (dash? ? 1 : 0)

    end

  end

  #--------------------------------------------------------------------------
  # * Define a posição do mapa como centro da tela
  #    x : coordenada X
  #    y : coordenada Y
  #--------------------------------------------------------------------------

  def center(x, y)

    $game_map.set_display_pos(x * MBS::Pixel_Movement::PIXEL_RATE - center_x, y * MBS::Pixel_Movement::PIXEL_RATE - center_y)

  end

end

class Spriteset_Map

  #--------------------------------------------------------------------------
  # * Atualização do tilemap
  #--------------------------------------------------------------------------

  def update_tilemap

    @tilemap.map_data = $game_map.data

    @tilemap.ox = $game_map.display_x * 32 / MBS::Pixel_Movement::PIXEL_RATE

    @tilemap.oy = $game_map.display_y * 32 / MBS::Pixel_Movement::PIXEL_RATE

    @tilemap.update

  end

end

class Game_Follower < Game_Character

  #--------------------------------------------------------------------------
  # * Seguir personagem anterior
  #--------------------------------------------------------------------------

  alias mbschsprch chase_preceding_character

  def chase_preceding_character

    return mbschsprch unless MBS::Pixel_Movement::ADJUST_CATERPILLAR

    unless moving?

      sx = distance_x_from(@preceding_character.x)

      sy = distance_y_from(@preceding_character.y)

      d = $game_player.direction

      if d == 2

        if sx != 0 && sy != MBS::Pixel_Movement::PIXEL_RATE

          move_diagonal(sx > 0 ? 4 : 6, sy > MBS::Pixel_Movement::PIXEL_RATE ? 8 : 2)

        elsif !(@y <= (@preceding_character.y - MBS::Pixel_Movement::PIXEL_RATE))

          move_straight(8)

        elsif sx != 0

          move_straight(sx > 0 ? 4 : 6)

        elsif sy != MBS::Pixel_Movement::PIXEL_RATE

          move_straight(2)

        end

      elsif d == 8

        if sx != 0 && sy != MBS::Pixel_Movement::PIXEL_RATE

          move_diagonal(sx > 0 ? 4 : 6, sy > MBS::Pixel_Movement::PIXEL_RATE ? 8 : 2)

        elsif !(@y >= (@preceding_character.y + MBS::Pixel_Movement::PIXEL_RATE))

          move_straight(2)

        elsif sx != 0

          move_straight(sx > 0 ? 4 : 6)

        elsif sy != MBS::Pixel_Movement::PIXEL_RATE

          move_straight(8)

        end

      elsif d == 4

        if sx != MBS::Pixel_Movement::PIXEL_RATE && sy != 0

          move_diagonal(sx > MBS::Pixel_Movement::PIXEL_RATE ? 4 : 6, sy > 0 ? 8 : 2)

        elsif !(@x >= (@preceding_character.x + MBS::Pixel_Movement::PIXEL_RATE))

          move_straight(6)

        elsif sx != MBS::Pixel_Movement::PIXEL_RATE

          move_straight(4)

        elsif sy != 0

          move_straight(sy > 0 ? 8 : 2)

        end

      elsif d == 6

        #return unless @x <= (@preceding_character.x - MBS::Pixel_Movement::PIXEL_RATE)

        if sx != MBS::Pixel_Movement::PIXEL_RATE && sy != 0

          move_diagonal(sx > MBS::Pixel_Movement::PIXEL_RATE ? 4 : 6, sy > 0 ? 8 : 2)

        elsif !(@x <= (@preceding_character.x - MBS::Pixel_Movement::PIXEL_RATE))

          move_straight(4)

        elsif sx != MBS::Pixel_Movement::PIXEL_RATE

          move_straight(6)

        elsif sy != 0

          move_straight(2)

        end

      end

    end

  end

end

class Game_Vehicle < Game_Character

  #--------------------------------------------------------------------------
  # * Definir posição
  #    map_id : ID do mapa
  #    x      : coordenada X
  #    y      : coordenada Y
  #--------------------------------------------------------------------------

  def set_location(map_id, x, y)

    @map_id = map_id

    @x = x

    @y = x

    refresh

  end

  #--------------------------------------------------------------------------
  # * Sincronização com o jogador
  #--------------------------------------------------------------------------

  def sync_with_player

    @x = $game_player.x

    @y = $game_player.y

    @real_x = $game_player.real_x

    @real_y = $game_player.real_y

    @direction = $game_player.direction

    update_bush_depth

  end

end

class Game_Event < Game_Character

  #--------------------------------------------------------------------------
  # * Definição de coordenada X na tela
  #--------------------------------------------------------------------------

  def screen_x

    $game_map.adjust_x(@real_x - 1) / MBS::Pixel_Movement::PIXEL_RATE * 32 + 16

  end

  #--------------------------------------------------------------------------
  # * Definição de coordenada Y na tela
  #--------------------------------------------------------------------------

  def screen_y

    $game_map.adjust_y(@real_y) / MBS::Pixel_Movement::PIXEL_RATE * 32 - shift_y - jump_height

  end

  def pos?(x, y)

    (x == @x - 1 || x == @x) && (y == @y - 1 || y == @y)

  end

  #--------------------------------------------------------------------------
  # * Atualização de movimento
  #--------------------------------------------------------------------------

  def update_self_movement

    if near_the_screen? && @stop_count > stop_count_threshold

      (MBS::Pixel_Movement::ADJUST_EVENT_MOVEMENT ? MBS::Pixel_Movement::PIXEL_RATE : 1).times do

        case @move_type

        when 1;  move_type_random

        when 2;  move_type_toward_player

        when 3;  move_type_custom

        end

      end

    end

  end

end
