# jakeeb's mods

## Instructions

Create `__jakeebloader.rb` in `Data/Mods`with the following contents:

```ruby
Dir[File.join(__dir__, "DevUtilities/*.rb")].each {|file| load File.expand_path(file) }
```

Create a new folder in `Data/Mods` titled `jakeebs-mods` and place the other mods inside.
**CERTAIN MODS MAY HAVE DEPENDENCIES FROM WIRE'S REJUVENATION MODPACK. YOU CAN DOWNLOAD THEM [HERE](https://github.com/yrsegal/rejuvenation-modpack)**

## Contents

- rebattleHQ.rb (depends on 0000.injection.rb, 0000.textures.rb, trainerRebattler.rb, 0000.music.rb, requires rebattleInfo folder)
  adds an NPC in Gearen Labs and the GDC Central Building that takes you to an area to rebattle NPCs with their exact teams, fields, etc. and putting you at the level cap.
- trainerRebattler.rb (depends on 0000.textures, requires rebattleInfo folder)
  adds a framework for rebattling trainers alongside every major battle themselves. (WIP)
- exportTeam.rb
  allows you to export your team as a txt or copy it to the clipboard by pressing I in the party screen.
- labyrinthStepIncreaser.rb
  makes the maximum steps in Zorrailyn Labyrinth 100,000. (because who wants to take multiple trips)
- darkGardevoir.rb (requires darkGardevoir folder)
  adds a Dark Gardevoir form as well as a Mega Evolution accessible by using a Dusk Stone on a female Kirlia. Uses the regular Gardevoirite. (mega back sprite made by The 11th Dimension on RebornEvo!)
