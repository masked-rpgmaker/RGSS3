#==============================================================================
# MBS - Equipamento para os inimigos
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
# Para adicionar uma arma de ID X no inimigo, ponha nas notas dele:
# <Weapon X>
#
# Para adicionar uma armadura/escudo/acessório de ID X no inimigo, ponha 
# nas notas dele:
# <Armor X>
#
# Para definir o tipo de equipamento do inimigo como "Duas armas" ponha nas 
# notas dele:
# <Dual Weapon>
#==============================================================================
($imported ||= {})[:mbs_enemies_equips] = true
#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  
  alias mbs_intlsz initialize
  
  attr_accessor :equipments
  #--------------------------------------------------------------------------
  # * Inicialização do objeto
  #--------------------------------------------------------------------------
  def initialize(*args, &block)
    puts "Inimigo ID#{enemy_id}:"
    @enemy_id = args[1]
    @equips = []
    equips = []
    enemy.note.each_line {|line|
      if line =~ /<Weapon\s+(\d+)>/im
        if dual_wield?
          if equips[0]
            equips[1] = $1.to_i  
          else
            equips[0] = $1.to_i
          end
        else
          equips[0] = $1.to_i
        end
      elsif line =~ /<Armor\s+(\d+)>/im
        equips[0] ||= 0
        equips[1] ||= 0 if dual_wield?
        equips << $1.to_i
      end
    }
    mbs_intlsz(*args, &block)
    init_equips(equips)
    6.times {|i|
       puts param_plus(i)
    }
    apply_equips_params
  end
  #--------------------------------------------------------------------------
  # * Verificação de se o inimigo usa duas armas
  #--------------------------------------------------------------------------
  def dual_wield?
    return enemy.note =~ /<Dual Weapon>/i
  end
  #--------------------------------------------------------------------------
  # * Inicialização do equipamento
  #     equips : equipamentos iniciais
  #--------------------------------------------------------------------------
  def init_equips(equips)
    @equips = Array.new(equip_slots.size) { Game_BaseItem.new }
    equips.each_with_index do |item_id, i|
      etype_id = index_to_etype_id(i)
      slot_id = empty_slot(etype_id)
      @equips[slot_id].set_equip(etype_id == 0, item_id) if slot_id
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * ID tipo com o índice definido pelo editor
  #     index : índice
  #--------------------------------------------------------------------------
  def index_to_etype_id(index)
    index == 1 && dual_wield? ? 0 : index
  end
  #--------------------------------------------------------------------------
  # * Definição de lista de slots pelo tipo de equipamentos
  #     etype_id : tipo de equipamento
  #--------------------------------------------------------------------------
  def slot_list(etype_id)
    result = []
    equip_slots.each_with_index {|e, i| result.push(i) if e == etype_id }
    result
  end
  #--------------------------------------------------------------------------
  # * Definição de slot de equipamento vazio
  #     etype_id : tipo de equipamento
  #--------------------------------------------------------------------------
  def empty_slot(etype_id)
    list = slot_list(etype_id)
    list.find {|i| @equips[i].is_nil? } || list[0]
  end
  #--------------------------------------------------------------------------
  # * Aquisição da lista de slots de equipamentos
  #--------------------------------------------------------------------------
  def equip_slots
    return [0,0,2,3,4] if dual_wield?       # Duas armas
    return [0,1,2,3,4]                      # Normal
  end
  #--------------------------------------------------------------------------
  # * Aquisição da lista de armas
  #--------------------------------------------------------------------------
  def weapons
    @equips.select {|item| item.is_weapon? }.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * Aquisição da lista de armaduras
  #--------------------------------------------------------------------------
  def armors
    @equips.select {|item| item.is_armor? }.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * Aquisição da lista de equipamentos
  #--------------------------------------------------------------------------
  def equips
    @equips.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * Aquisição do valor adicional do parâmetro
  #     param_id : ID do parâmetro
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    equips.compact.inject(super) {|r, item| r += item.params[param_id] }
  end
  #--------------------------------------------------------------------------
  # * Aquisição da ID da animação de ataque normal
  #--------------------------------------------------------------------------
  def atk_animation_id1
    if dual_wield?
      return weapons[0].animation_id if weapons[0]
      return weapons[1] ? 0 : 1
    else
      return weapons[0] ? weapons[0].animation_id : 1
    end
  end
  #--------------------------------------------------------------------------
  # * Aquisição da ID da animação de ataque normal (Empunhando duas armas)
  #--------------------------------------------------------------------------
  def atk_animation_id2
    if dual_wield?
      return weapons[1] ? weapons[1].animation_id : 0
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de mudança de equipamento
  #     slot_id : ID do slot
  #--------------------------------------------------------------------------
  def equip_change_ok?(slot_id)
    return false if equip_type_fixed?(equip_slots[slot_id])
    return false if equip_type_sealed?(equip_slots[slot_id])
    return true
  end
  #--------------------------------------------------------------------------
  # * Mudança de equipamentos
  #     slot_id : ID do slot
  #     item    : Armas/Amaduras (nil se vazio)
  #--------------------------------------------------------------------------
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    return if item && equip_slots[slot_id] != item.etype_id
    @equips[slot_id].object = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Forçar mudança de equipamentos
  #     slot_id : ID do slot
  #     item    : Armas/Amaduras (nil se vazio)
  #--------------------------------------------------------------------------
  def force_change_equip(slot_id, item)
    @equips[slot_id].object = item
    release_unequippable_items(false)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Mudança de equipamentos (especificado pela ID)
  #     slot_id : ID do slot
  #     item_id : ID da Arma/Amadura
  #--------------------------------------------------------------------------
  def change_equip_by_id(slot_id, item_id)
    if equip_slots[slot_id] == 0
      change_equip(slot_id, $data_weapons[item_id])
    else
      change_equip(slot_id, $data_armors[item_id])
    end
  end
  #--------------------------------------------------------------------------
  # * Discartar equipamento
  #     item : Armas/Amaduras
  #--------------------------------------------------------------------------
  def discard_equip(item)
    slot_id = equips.index(item)
    @equips[slot_id].object = nil if slot_id
  end
  #--------------------------------------------------------------------------
  # * Remoção de equipamentos que não podem ser removidos
  #     item_gain : Voltar equipamento removido para o grupo
  #--------------------------------------------------------------------------
  def release_unequippable_items(item_gain = true)
    @equips.each_with_index do |item, i|
      if !equippable?(item.object) || item.object.etype_id != equip_slots[i]
        trade_item_with_party(nil, item.object) if item_gain
        item.object = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Remoção de todos os equipamentos
  #--------------------------------------------------------------------------
  def clear_equipments
    equip_slots.size.times do |i|
      change_equip(i, nil) if equip_change_ok?(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Equipar equipamentos mais fortes
  #--------------------------------------------------------------------------
  def optimize_equipments
    clear_equipments
    equip_slots.size.times do |i|
      next if !equip_change_ok?(i)
      items = $game_party.equip_items.select do |item|
        item.etype_id == equip_slots[i] &&
        equippable?(item) && item.performance >= 0
      end
      change_equip(i, items.max_by {|item| item.performance })
    end
  end
  #--------------------------------------------------------------------------
  # * Definição de tipo de arma equipada
  #     wtype_id : ID do tipo de arma
  #--------------------------------------------------------------------------
  def wtype_equipped?(wtype_id)
    weapons.any? {|weapon| weapon.wtype_id == wtype_id }
  end
  #--------------------------------------------------------------------------
  # * Aplicação das adições de parâmetros dos equipamentos
  #--------------------------------------------------------------------------
  def apply_equips_params
    equips.each {|equip|
    next unless equip
    system("cls")
    puts equip.params
      7.times {|i|
        add_param(i, equip.params[i])
        if enemy.params[i] > param_max(i)
          add_param(i, param_max(i) - enemy.params[i])
        end
      }
    }
  end
end
#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # * Exibição da animação do ataque 
  #    Se um herói estiver usando duas armas (arma da mão esquerda irá
  #    exibir uma animação invertida)
  #     targets : lista dos alvos
  #--------------------------------------------------------------------------
  def show_attack_animation(targets)
    if @subject.actor?
      show_normal_animation(targets, @subject.atk_animation_id1, false)
      show_normal_animation(targets, @subject.atk_animation_id2, true)
    else
      Sound.play_enemy_attack
      show_normal_animation(targets, @subject.atk_animation_id1, false)
      show_normal_animation(targets, @subject.atk_animation_id2, true)
      abs_wait_short
    end
  end
end
