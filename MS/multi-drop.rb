($imported ||= {})[:ms_multi_drop] = true
#==============================================================================
# MS - Multi Drop
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# Instruções
#------------------------------------------------------------------------------
# Cole este script acima do main
#
# Para adicionar um drop ao inimigo, ponha nas notas dele a seguinte tag:
#
# <drop tipo x y%>
#
# Sendo o tipo 'weapon', 'armor' ou 'item' (sem aspas), x o ID do item no 
# database e y a porcentagem de chance que o item tem de ser dropado.
# Exemplo:
#
# <drop armor 10 45%>
#
# Com essa tag, o inimigo tem 45% de chance de dropar a armadura de ID 10 no
# database
#==============================================================================
#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  
  alias mbs_mkditm make_drop_items
  
  #--------------------------------------------------------------------------
  # * Lista de itens adicionais derrubados
  #--------------------------------------------------------------------------
  def mbs_make_drop_items
    d = []
    enemy.note.each_line do |line|
      next unless line =~ /<[ ]*drop([ ]+|_)(weapon|armor|item)[ ]+(\d+)[ ]+(\d+)%[ ]*>/i
      d << [$2, $3.to_i, 100.0 / $4.to_i]
    end
    a = d.inject([]) do |r, i|
      next unless i
      if rand * i[2] < drop_item_rate
        r << item_object(get_item_type(i[0]), i[1])
      else
        r
      end
    end
    return a
  end
  
  #--------------------------------------------------------------------------
  # * Lista de itens derrubados
  #--------------------------------------------------------------------------
  def make_drop_items
    mbs_mkditm + mbs_make_drop_items
  end
  
  #--------------------------------------------------------------------------
  # * Aquisição do número do tipo do item a partir do nome do tipo
  #--------------------------------------------------------------------------
  def get_item_type(t)
    case t[0]
      when 'i' || 'I'
        return 1
      when 'w' || 'W'
        return 2
      when 'a' || 'A'
        return 3      
    end
  end
end
