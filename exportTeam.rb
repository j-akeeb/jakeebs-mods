# Credits
# _jakeeb
# wiresegal for a bunch of code and help
# pokemon showdown/smogon/pokepaste for the format itself
class PokemonScreen_Scene
  def pbChoosePokemon(switching=false,allow_party_switch=false,canswitch=0)
    for i in 0...6
      @sprites["pokemon#{i}"].preselected=(switching&&i==@activecmd)
      @sprites["pokemon#{i}"].switching=switching
    end
    pbRefresh
    loop do
      Graphics.update
      Input.update
      self.update
      oldsel=@activecmd
      key=-1
      key=Input::DOWN if Input.repeat?(Input::DOWN)
      key=Input::RIGHT if Input.repeat?(Input::RIGHT)
      key=Input::LEFT if Input.repeat?(Input::LEFT)
      key=Input::UP if Input.repeat?(Input::UP)
      if key>=0
        @activecmd=pbChangeSelection(key,@activecmd)
      end
      if @activecmd!=oldsel # Changing selection
        pbPlayCursorSE()
        numsprites=(@multiselect) ? 8 : 7
        for i in 0...numsprites
          @sprites["pokemon#{i}"].selected=(i==@activecmd)
        end
      end
      if allow_party_switch && canswitch==0 && Input.trigger?(Input::X)
        return [1,@activecmd]
      elsif allow_party_switch && Input.trigger?(Input::X) && canswitch==1
        return @activecmd
      end
      if Input.trigger?(Input::B)
        return -1
      end
      if Input.trigger?(Input::C)
        pbPlayDecisionSE()
        cancelsprite=(@multiselect) ? 7 : 6
        return (@activecmd==cancelsprite) ? -1 : @activecmd
      end
      if Input.triggerex?(:I)
        output = ""
        for mon in $Trainer.party
          output += exporter(mon) + "\n\n"
        end
        # copy to clipboard
        if Kernel.pbConfirmMessage("Would you like to copy your team to the clipboard?")
          Input.clipboard = output
          Kernel.pbMessage("Copied team to clipboard.")
        # export to text
        elsif Kernel.pbConfirmMessage("Would you like to export your team as a txt?")
          File.open("#{$Trainer.name}'s team.txt", "wb") { |f| # r = read, w = write, + = append, b = bytes (don't worry about this one)
            f.write(output)
          } 
          Kernel.pbMessage("Exported team as txt.")
        end
        
      end
    end
  end
  def exporter(mon)  
    formname = $cache.pkmn[mon.species].forms[mon.form] || "Normal Form"  
    if formname.include?("Form")  
      formname = formname.split("Form")[0].strip  
    end
    formname.gsub! 'Galarian', 'Galar'  
    formname.gsub! 'Alolan', 'Alola'  
    formname.gsub! 'Hisuian', 'Hisui'  
    formname.gsub! 'Paldean', 'Paldea'  
    formname.gsub! 'Aevian', 'Aevium'  
    speciesname = basespecies = getMonName(mon.species)  
    speciesname += "-#{formname}" unless formname == "Normal"  
    fullMon = mon.name && mon.name != basespecies ? "#{mon.name} (#{speciesname})" : speciesname  
    fullMon += " (M)" if mon.isMale?  
    fullMon += " (F)" if mon.isFemale?  
    fullMon += " @ #{getItemName(mon.item)}" if mon.item  
    fullMon += "\nAbility: #{getAbilityName(mon.ability)}"  
    fullMon += "\nLevel: #{mon.level}" if mon.level != 100  
    fullMon += "\nShiny: Yes" if mon.isShiny?  
    fullMon += "\nHappiness: #{mon.happiness}" if mon.happiness != 255    
    # hp  
    hiddenPower = nil  
    if mon.item == :INTERCEPTZ  
      hiddenPower = -1  
    else  
      for move in mon.moves  
        if move.move == :HIDDENPOWER  
          hiddenPower = -1  
          break  
        elsif move.move.start_with?("HIDDENPOWER")  
          hiddenPower = move.type  
          break  
        end  
      end  
    end  

    hiddenPower = pbHiddenPower(mon) if hiddenPower == -1  

    fullMon += "\nHidden Power: #{getTypeName(hiddenPower)}" if hiddenPower  
    statnames = ["HP", "Atk", "Def", "SpA", "SpD", "Spe"]  
    evs = mon.ev.each_with_index.select {  
      |ev, idx| ev != 0  
    }.map {  
      |ev, idx| "#{ev} #{statnames[idx]}"   
    }  

    ivs = mon.iv.each_with_index.select {  
      |iv, idx| iv != 31  
    }.map {  
      |iv, idx| "#{iv} #{statnames[idx]}"   
    }  
    fullMon += "\nEVs: #{evs.join(' / ')}" unless evs.empty?  
    fullMon += "\n#{getNatureName(mon.nature)} Nature"  
    fullMon += "\nIVs: #{ivs.join(' / ')}" unless ivs.empty?  
    for move in mon.moves  
      if move.move != :HIDDENPOWER && move.move.start_with?("HIDDENPOWER") && move.type != hiddenPower  
        fullMon += "\n- #{getMoveName(move.move)} #{getTypeName(move.type)}"  
      else  
        fullMon += "\n- #{getMoveName(move.move)}"  
      end  
    end  
    return fullMon  
  end  
end  