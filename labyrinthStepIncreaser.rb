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
        matched = event.lookForAll([:ControlVariable, :LabStepLimit, :Set, :Constant, nil])
        for insn in matched
          insn.parameters[4] *= 5
        end
        next !matched.empty?
      }
    }
  }
}