#==============================================================================
# ** MS - Visual Equipment
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Instruções:
#------------------------------------------------------------------------------
# Para definir um gráfico para o equipamento, escreva nas notas dele:
# <Graphic = Nome_do_arquivo>
# O arquivo "Nome_do_arquivo" deve estar na pasta Graphics/Characters do seu
# projeto
#
# Para definir mais de um frame, para o caso de um script de extra frame,
# escreva isso nas notas do equipamento:
# <Frames = x>
# Sendo o 'x' o número de frames
#
# Para definir os gráficos para um evento, é preciso criar um comentário nele
# com o seguinte conteúdo:
# <Equips: x,y,z>
# Sendo x, y e z os IDs dos equipamentos, se x for A1, a armadura de id 1 será
# atribuída ao evento, se y for W3, a arma de id 3 será atribuída a ele,
# você pode colocar quantos IDs quiser na lista
#==============================================================================
($imported ||= {})[:ms_visual_equip] = true
#==============================================================================
# ** Sprite_Character
#==============================================================================
class Sprite_Character < Sprite_Base
  alias ms_initlz initialize
  alias ms_updt update
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #     viewport  : camada
  #     character : personagem (Game_Character)
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    @equip_sprite = Sprite.new
    @equip_sprite.bitmap = Bitmap.new(96,128)
    @equip_sprite.oy = 4
    ms_initlz(viewport,character)
  end
  #--------------------------------------------------------------------------
  # * Atualização da tela
  #--------------------------------------------------------------------------
  def update
    ms_updt
    update_equipment
  end
  #-------------------------------------------------------------------------
  # * Atualização do gráfico de equipamento
  #-------------------------------------------------------------------------
  def update_equipment
   
    pattern = @character.pattern < 3 ? @character.pattern : 1
    frames = 3
    @equip_sprite.bitmap.clear
    bitmap = Bitmap.new(32,32)
   
     pr = ->(equip) {
      next if equip.nil?
        equip.note.each_line {|line|
        bitmap = Cache.character($1) if line =~ /<Graphic\s*=\s*([[:ascii:]]+)>/i
        frames = $1.to_i if line =~ /<Frames\s*=\s*(\d+)>/i
        }
        rect = Rect.new(pattern*(bitmap.width/frames),(@character.direction/2-1)*(bitmap.height/4),bitmap.width/frames,bitmap.height/4)
        @equip_sprite.bitmap.blt((frames/3-1)*4,0,bitmap,rect)
    }
   
    if @character.is_a?(Game_Player) || @character.is_a?(Game_Follower)
     
      if @character.is_a?(Game_Player)
     
      $game_party.members[0].equips.each {|equip|
        pr[equip]
      }
     
      else
      return unless $game_party.members[@character.member_index]
      $game_party.members[@character.member_index].equips.each {|equip|
        pr[equip]
      }
       
      end
     
    elsif @character.is_a?(Game_Event)
      @equipments = []
      @character.list.each {|command|
        if command.code == 108
          command.parameters[0][/<Equips\s*:\s*([AW0-9,]+)>/im]
          $1.scan(/-*\w+/).collect{|n|n}.each {|equip|
            if equip[0] == "A"
              @equipments << $data_armors[equip[/\d+/].to_i]
            elsif equip[0] == "W"
              @equipments << $data_weapons[equip[/\d+/].to_i]
            end
          }
        end
      }
      @equipments.each {|equip|
        pr[equip]
      }
     
    end
     
      @equip_sprite.x = @character.screen_x - 16
      @equip_sprite.y = @character.screen_y - bitmap.height/4 + @character.shift_y + @character.jump_height
      @equip_sprite.z = @character.screen_z
    end
    
    alias mbsdisps dispose
    
    def dispose
      mbsdisps
      @equip_sprite.dispose
    end
end
#==============================================================================
# ** Game_Follower
#==============================================================================
class Game_Follower < Game_Character
  attr_reader :member_index
end
