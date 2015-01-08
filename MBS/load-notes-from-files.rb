#==============================================================================
# MBS - Load Notes from file
#------------------------------------------------------------------------------
# por Masked
#==============================================================================
#==============================================================================
# ** DataManager
#==============================================================================
module DataManager
  class << self
    alias mbs_ldbtbs load_database
  end
  #--------------------------------------------------------------------------
  # * Carregamento do banco de dados
  #--------------------------------------------------------------------------
  def self.load_database
    mbs_ldbtbs
    load_notes
  end
  #--------------------------------------------------------------------------
  # * Carregamento das notas
  #--------------------------------------------------------------------------
  def self.load_notes
    
    n = FileTest.file?("Notes.rvdata2")
    
    File.open("Notes.rvdata2","wb") {|file| file.write(" ")} unless n
    
    if FileTest.file?("notes.txt")
      File.open("notes.txt","rb") {|file|
        File.open("Notes.rvdata2","w+") {|file2|
          Marshal.dump(file.read.unpack("C*"),file2)
        }
      }
    end
       
    contents = load_data("Notes.rvdata2").pack("U*")
    return if contents.nil?
    notedata = {}
    notedata[:actors] = contents[/\[actors\].+\[\/actors\]/im]
    notedata[:items] = contents[/\[items\].+\[\/items\]/im]
    notedata[:armors] = contents[/\[armors\].+\[\/armors\]/im]
    notedata[:weapons] = contents[/\[weapons\].+\[\/weapons\]/im]
    notedata[:enemies] = contents[/\[enemies\].+\[\/enemies\]/im]
    notedata[:classes] = contents[/\[classes\].+\[\/classes\]/im]
    notedata[:skills] = contents[/\[skills\].+\[\/skills\]/im]
    notedata[:states] = contents[/\[states\].+\[\/states\]/im]
    notedata[:tilesets] = contents[/\[tilesets\].+\[\/tilesets\]/im]
   
    $data_actors.each {|actor|
      break unless notedata[:actors]
      next unless actor
      notedata[:actors][/<ID\s*[0]*#{actor.id}\s*=\s*(.+)>/im]
      actor.note = $1.to_s
    }
    $data_items.each {|item|
    break unless notedata[:items]
      next unless item
      notedata[:items][/<ID\s*[0]*#{item.id}\s*=\s*(.+)\>/im]
      item.note = $1.to_s
    }
    $data_armors.each {|item|
    break unless notedata[:armors]
      next unless item
      notedata[:armors][/<ID\s*[0]*#{item.id}\s*=\s*(.+)\>/im]
      item.note = $1.to_s
    }
    $data_weapons.each {|item|
    break unless notedata[:weapons]
      next unless item
      notedata[:weapons][/<ID\s*[0]*#{item.id}\s*=\s*(.+)>/im]
      item.note = $1.to_s
    }
    $data_enemies.each {|enemy|
    break unless notedata[:enemies]
      next unless enemy
      notedata[:enemies][/<ID\s*[0]*#{enemy.id}\s*=\s*(.+)>/im]
      enemy.note = $1.to_s
    }
    $data_classes.each {|klass|
    break unless notedata[:classes]
      next unless klass
      notedata[:classes][/<ID\s*[0]*#{klass.id}\s*=\s*(.+)>/im]
      klass.note = $1.to_s
    }
    $data_skills.each {|skill|
    break unless notedata[:skills]
      next unless skill
      notedata[:skills][/<ID\s*[0]*#{skill.id}\s*=\s*(.+)>/im]
      skill.note = $1.to_s
    }
    $data_states.each {|state|
    break unless notedata[:states]
      next unless state
      cnotedata[:states][/<ID\s*[0]*#{state.id}\s*=\s*(.+)>/im]
      state.note = $1.to_s
    }
    $data_tilesets.each {|tileset|
    break unless notedata[:tilesets]
      next unless tileset
      notedata[:tilesets][/<ID\s*[0]*#{tileset.id}\s*=\s*(.+)>/im]
      tileset.note = $1.to_s
    }
  end
end
