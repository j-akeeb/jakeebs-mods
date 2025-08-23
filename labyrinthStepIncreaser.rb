$WIRE_LATE_LOAD = [] unless defined?($WIRE_LATE_LOAD)
$WIRE_LATE_LOAD << proc {
  {
    533 => 53, # Zorrialyn Labyrinth Ladder to Floor 2
    535 => 1, # Zorrialyn Labyrinth Entrance NPC
    536 => 83, # Zorrialyn Labyrinth Ladder to Floor 3
    541 => 75 # Zorrialyn Labyrinth Dive Floor step setter
  }.each { |k, v| 

    InjectionHelper.defineMapPatch(k, v) { |event|
      event.patch(:zorrialynlabyrinthstepcount) { |page|
        matched = page.lookForAll([:ControlVariable, :LabStepLimit, :Set, :Constant, nil])
        for insn in matched
          insn.parameters[4] *= 5
        end
        next !matched.empty?
      }
    }
  }
}
  module ShowLabyrinthSteps
    @@lastText = ''

    def self.ensureBox
      if !defined?(@@displaybox) || @@displaybox.contents.disposed?
        @@displaybox = Window_UnformattedTextPokemon.new() # Unformatted for speed\
        @@displaybox.setSkin("Graphics/Windowskins/choice 7")
        positionBox
        @@displaybox.z = 99999
      end

      @@displaybox.visible = [533, 536, 537, 541].include?($game_map.map_id)
    end

    def self.positionBox
      @@displaybox.resizeToFit(@@displaybox.text,Graphics.width)
      @@displaybox.x = 0
      @@displaybox.y = Graphics.height - @@displaybox.height
    end

    def self.update
      return if !$game_player || !$game_player
      ensureBox
      if @@displaybox.visible
        position = "Steps: #{$game_variables[:LabStepLimit]}"

        if @@lastText != position
          @@lastText = position
          @@displaybox.text=position
          positionBox
        end
      end 
    end
  end

  class Game_Screen
    alias :showlabsteps_old_update :update

    def update(*args, **kwargs)
      ShowLabyrinthSteps.update
      return showlabsteps_old_update(*args, **kwargs)
    end
  end
  