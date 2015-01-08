#==============================================================================
# MBS - Aprender Habilidades com Equipamentos
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
($imported ||= {})[:mbs_equipment_skills] = true
#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  alias mbs_chngeqp change_equip
  alias mbs_inteqps init_equips
  #--------------------------------------------------------------------------
  # * Inicialização do equipamento
  #     equips : equipamentos iniciais
  #--------------------------------------------------------------------------
  def init_equips(equips)
    mbs_inteqps(equips)
    @equips.each {|i|
      equip_skills(i.object).each {|skill| learn_skill(skill)}
    }
  end
  #--------------------------------------------------------------------------
  # * Mudança de equipamentos
  #     slot_id : ID do slot
  #     item    : Armas/Amaduras (nil se vazio)
  #--------------------------------------------------------------------------
  def change_equip(slot_id, item)
    equip_skills(@equips[slot_id].object).each {|skill| forget_skill(skill) unless @perm_skills.include?(skill)}
    mbs_chngeqp(slot_id,item)
    equip_skills(item).each {|skill| learn_skill(skill)}
  end
  #--------------------------------------------------------------------------
  # * Aquisição das habilidades do equipamento
  #     item : o equipamento em questão
  #--------------------------------------------------------------------------
  def equip_skills(item)
    
    return [] if item.nil?
    
    s = ""
    skills = []
    
    item.note[/<Actor#{self.id}\s*LearnSkills:\s*(.+>)/im]
    unless $1.nil?
      $1.each_char {|char|
      
        next if char == " "
        if char == "," || char == ">"
          skills << s.to_i
          p skills
          s = ""
          next
        end
              
        s += char
      }
    end
    
    item.note[/<Actor#{self.id}\s*LearnPSkills:\s*(.+>)/im]
    @perm_skills ||= []
    
    return skills if $1.nil?
    
    $1.each_char {|char|
    
      next if char == " "
      if char == "," || char == ">"
        skills << s.to_i
        @perm_skills << s.to_i
        s = ""
        next
      end
            
      s += char
    }
    
    return skills
    
  end
end
