Events.onStepTaken+=proc {
  $game_variables[:LabStepLimit] = 100000 if $game_variables[:LabStepLimit] > 0
}