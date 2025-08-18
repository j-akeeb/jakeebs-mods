# CREDITS
# Rejuvenation Team for the game
# Wiresegal for helping me code this and creating the framework

# DEPENDENCIES
# 0000.textures.rb

alias :trainerrefight_old_pbPrepareBattle :pbPrepareBattle

def pbPrepareBattle(battle)
  battle.disableExpGain=true if TrainerRefightSelection.noexp
  trainerrefight_old_pbPrepareBattle(battle)
end

TextureOverrides.registerTextureOverrides({
  'Graphics/Pictures/CharPosterSansXW' => TextureOverrides::MODBASE + "__SansX/CharPosterW",
  'Graphics/Pictures/CharPosterSansX' => TextureOverrides::MODBASE + "__SansX/CharPoster",
  'Graphics/Pictures/ShopBGSpattersSansX' => TextureOverrides::MODBASE + "__SansX/Spatters"
})

class Game_Screen
  attr_writer :weather_type
end

module TrainerRefightSelection
  @@noexp = false
  def self.noexp=(value); @@noexp = value; end
  def self.noexp; @@noexp; end

  class BossFight
    attr_reader :name

    def initialize(name, cap, field, species, level, partner: nil, music: nil)
      @name = name
      @cap = cap
      @field = field
      @species = species
      @level = level
      @partner = partner
      @music = music
    end

    def battle
      prev = TrainerRefightSelection.applyField(@field)

      pbRegisterPartner(*@partner) if @partner
      $PokemonGlobal.nextBattleBGM = RPG::AudioFile.new(*@music) if @music
      playermoney = $Trainer.money
      TrainerRefightSelection.noexp = true
      ret = TrainerRefightSelection.fightWithCap(@cap) { pbWildBattle(@species, @level, Variables[:BattleResult], false, true) }
      TrainerRefightSelection.noexp = false
      $Trainer.money = playermoney
      pbDeregisterPartner if @partner

      TrainerRefightSelection.resetField(prev)
      return ret
    end
  end

  class TrainerFight
    attr_reader :name

    def initialize(name, cap, field, opponent, partner: nil, opponent2: nil, doublebattle: false, music: nil)
      @name = name
      @cap = cap
      @field = field
      @opponent = opponent
      @partner = partner
      @opponent2 = opponent2
      @doublebattle = partner || opponent2 || doublebattle
      @music = music
    end

    def battle
      prev = TrainerRefightSelection.applyField(@field)

      pbRegisterPartner(*@partner) if @partner
      $PokemonGlobal.nextBattleBGM = RPG::AudioFile.new(*@music) if @music
      playermoney = $Trainer.money
      ttype, tname, tid = @opponent
      if @opponent2
        ttype2, tname2, tid2 = @opponent2
        ret = TrainerRefightSelection.fightWithCap(@cap) { pbDoubleTrainerBattle(ttype, tname, tid, "", ttype2, tname2, tid2, "", true, noexp: true) }
      else
        ret = TrainerRefightSelection.fightWithCap(@cap) { pbTrainerBattle(ttype, tname, "", @doublebattle, tid, true, noexp: true) }
      end
      $Trainer.money = playermoney
      pbDeregisterPartner if @partner

      TrainerRefightSelection.resetField(prev)
      return ret
    end
  end

  class Gauntlet
    attr_reader :name
    def initialize(name, cap, fights, healtype: nil, music: nil)
      @name = name
      @cap = cap
      @fights = fights
      @healtype = healtype
      @music = music
    end

    def battle
      if @music
        $game_switches[1404] = true # Don't stop the music
        $game_system.bgm_memorize
        pbBGMPlay(*@music)
      end
      failedAny = false
      TrainerRefightSelection.fightWithCap(@cap) { 
        for fight in @fights
          if !fight.battle
            failedAny = true
            break
          end
          case @healtype
          when :Partial then pbPartialHeal
          when :Full then pbHealAll
          end
        end
      }
      if @music
        $game_switches[1404] = false
        $game_system.bgm_restore
      end

      return failedAny
    end
  end

  class Category 
    attr_reader :name
    attr_reader :members
    def initialize(name, members)
      @name = name
      @members = members
    end
  end

  SELECTION = Category.new(nil, [
    Category.new("By Chapter", [
      Category.new("Chapter 1", [
        :renLab, :novaeChrisola, :rorimChrisola, :garbageMenace, 
        :mercury, :renLibrary, :venamGym, :mars, 
        :meliaGoldenleaf, :misfortunate1, :zettaGoldenleaf, :riftGyarados1
        
      ]),
      Category.new("Chapter 2", [
        :jenkelFactory, :riftGalvantula, :nimAmethyst, :ketaGym, 
        :rorimNovae, :cueBalls, :madelisKeta, :riftVolcanion,
        :sheridanGothitelle
      ]),
      Category.new("Chapter 3", [
        :spiritKeta, :marianetteGym
      ]),
      Category.new("Chapter 4", [
        :narcissaGym
      ]),
      Category.new("Chapter 5", [
        :nevedBlacksteeple, :valarieGym
      ]),
      Category.new("Chapter 6", [
        :crawliGym
      ]),
      Category.new("Chapter 7", [
        :angieGym
      ]),
      Category.new("Chapter 8", [
        :zettaGearaValor, :amberGym #INCLUDE TEXEN LATER
      ]),
      Category.new("Chapter 9", [
      :spectorDay, :spectorNight, :spiritJenner, :erickGym
      ]),
      Category.new("Chapter 10", [
        :floraGym, :florinGym
      ]),
      Category.new("Chapter 11", [
        :puppetGym
      ]),
      Category.new("Chapter 12", [
        :soutaGym
      ]),
      Category.new("Chapter 13", [
        :adamGym
      ]),
      Category.new("Chapter 14", [
        :rylandGym
      ]),
      Category.new("Chapter 15", [
        :sakiGym, :dufaux
      ]),
      Category.new(".KF Paragon", [
        :spiritXaraJean, :inevitableGrief, :talonPara, :hagsPara
      ]),
      Category.new(".KF Renegade", [
      ]),
    ]),
    Category.new("By Category", [
      Category.new("Gym Leaders", [
        :venamGym, :ketaGym, :marianetteGym, :narcissaGym, 
        :valarieGym, :crawliGym, :angieGym, :amberGym, 
        :spectorDay, :spectorNight, :erickGym, :floraGym, 
        :florinGym, :puppetGym, :soutaGym, :adamGym,
        :rylandGym, :sakiGym, :talonPara # INCLUDE TEXEN LATER
      
      ]),
      Category.new("\"Rival\" Fights", [
        :renLab, :renLibrary, :novaeChrisola, :meliaGoldenleaf, 
        :rorimNovae, :inevitableGrief
      ]),
      Category.new("Team Xen", [
        :misfortunate1, :zettaGoldenleaf, :madelisKeta, :nevedBlacksteeple,
        :zettaGearaValor
      ]),
      Category.new("Boss Pokemon", [
        :garbageMenace, :riftGyarados1, :riftGalvantula, :riftVolcanion, 
        :dufaux, :hagsPara
      ]),
      Category.new("Spirit Battles", [
        :spiritKeta, :spiritJenner, :spiritXaraJean
      ]),
      Category.new("Other", [
        :rorimChrisola, :mercury, :mars, :jenkelFactory, 
        :nimAmethyst, :rorimNovae, :cueBalls, :sheridanGothitelle
      ])
    ])
  ])

  BATTLES = {
    # Rivals
    renLab: TrainerFight.new("Lab Ren", 5, "Indoor", [:TRAINER_REN, "Ren", 0]),
    novaeChrisola: TrainerFight.new("Chrisola Novae", LEVELCAPS[0], "City", [:WANDERER, "Novae", 0]),
    renLibrary: TrainerFight.new("Library Ren", LEVELCAPS[0], "Indoor", [:TRAINER_REN, "Ren", 15]),
    meliaGoldenleaf: TrainerFight.new("Silent Grove Melia", LEVELCAPS[1], "Forest", [:TRAINER_MELIA1, "Melia", 0]),
    rorimNovae: TrainerFight.new("Rorim B. & Novae", LEVELCAPS[1], "Forest", [:WANDERER, "Novae", 1], opponent2: [:DISCOTEEN, "Rorim B.",  2], music: ['Battle - Rorrim B.', 100, 100]),
    inevitableGrief: Gauntlet.new("Inevitable Grief", LEVELCAPS[15], [
      TrainerFight.new("Rv", nil, "Zeight3", [:TREAT_01,"01010010 01110110",0], doublebattle: true, music: ['Battle - Lonely Moon', 100, 110]),
      TrainerFight.new("AE", nil, "Zeight3", [:TREAT_02,"01000001 01000101",0], doublebattle: true, music: ['Battle - Lonely Moon', 100, 110]),
      TrainerFight.new("M", nil, "Zeight3", [:TREAT_03,"01001101",0], doublebattle: true, music: ['Battle - Lonely Moon', 100, 110])
    ], healtype: :Partial, music: ['Battle - Lonely Moon', 100, 110]),
    # Gyms/Extra
    venamGym: TrainerFight.new("Venam Gym", LEVELCAPS[0], "Concert2", [:LEADER_VENAM, "Venam", 0]),
    ketaGym: TrainerFight.new("Keta Gym", LEVELCAPS[1], "Forest", [:LEADER_KETA, "Keta", 0], doublebattle: true),
    marianetteGym: TrainerFight.new("Marianette Gym", LEVELCAPS[2], "Ruin2", [:LEADER_MARIANETTE, "Marianette", 0]),
    narcissaGym: TrainerFight.new("Narcissa Gym", LEVELCAPS[3], "Haunted2", [:LEADER_NARCISSA, "Narcissa", 0]),
    valarieGym: TrainerFight.new("Valarie Gym", LEVELCAPS[4], "Beach", [:LEADER_VALARIE, "Valarie", 0]),
    crawliGym: TrainerFight.new("Crawli Gym", LEVELCAPS[5], "Swamp", [:LEADER_CRAWLI, "Crawli", 0], doublebattle: true),
    angieGym: TrainerFight.new("Angie Gym", LEVELCAPS[6], "Angie", [:LEADER_ANGIE, "Angie", 0], doublebattle: true),
    amberGym: TrainerFight.new("Amber Gym", LEVELCAPS[7], "Concert2", [:LEADER_AMBER, "Amber", 0]),
    erickGym: TrainerFight.new("Erick Gym", LEVELCAPS[8], :MURKWATERSURFACE, [:LEADER_ERICK, "Erick", 0], doublebattle: true),
    spectorDay: TrainerFight.new("Spector Day", LEVELCAPS[7], {basefield: "Haunted2", time: :Day}, [:LEADER_SPECTOR, "Spector", 0], doublebattle: true),
    spectorNight: TrainerFight.new("Spector Night", LEVELCAPS[7], {basefield: "Haunted2", time: :Night}, [:LEADER_SPECTOR2, "Spector", 0], doublebattle: true),
    floraGym: TrainerFight.new("Flora Gym", LEVELCAPS[9], {basefield: "Darchlight", weather: :Rain}, [:LEADER_FLORA, "Flora", 0]),
    florinGym: TrainerFight.new("Florin Gym", LEVELCAPS[9], {basefield: "Darchlight", weather: :Rain}, [:LEADER_FLORIN, "Florin", 0], doublebattle: true),
    puppetGym: TrainerFight.new("Puppet Master Gym", LEVELCAPS[10], "Psychic_2", [:LEADER_PUPPET1, "Magenta", 0], opponent2: [:LEADER_PUPPET2, "Neon", 0], music: ['Battle - Nightmare_1', 100, 100]),
    soutaGym: TrainerFight.new("Souta Gym", LEVELCAPS[11], {basefield: "GoldenArena", weather: :BlowingLeaves, time: :Day}, [:LEADER_SOUTA, "Souta", 0]),
    adamGym: TrainerFight.new("Adam Gym", LEVELCAPS[12], :INVERSE, [:LEADER_ADAM, "Adam", 0]),
    rylandGym: TrainerFight.new("Ryland Gym", LEVELCAPS[13], {basefield: "Desert3", weather: :Sandstorm}, [:LEADER_RYLAND, "Flora", 0]),
    sakiGym: TrainerFight.new("Saki Gym", LEVELCAPS[14], "Factory", [:LEADER_SAKI2, "Saki", 0]),
    talonPara: TrainerFight.new("Talon Paragon", LEVELCAPS[15], {basefield: "GoldenArena", weather: :SwirlingLeaves, time: :Night}, [:LEADER_TALON, "Talon", 0], music: ['Battle - Gyms', 100, 100]),
    # Bosses
    garbageMenace: BossFight.new("Garbage Menace", LEVELCAPS[0], "Sewers", :BOSSGARBODOR, 12, partner: [:TRAINER_REN, "Ren", 3], music: ["Battle - Mini Boss", 100, 100]),
    riftGyarados1: BossFight.new("Rift Gyarados 1", LEVELCAPS[1], "Dimensional", :RIFTGYARADOS1, 20, music: ["Battle - Dimensional Rift", 100, 100]),
    riftGalvantula: BossFight.new("Rift Galvaantula", LEVELCAPS[1], "Dimensional", :RIFTGALVANTULA, 25, partner: [:LEADER_VENAM, "Venam", 1], music: ["Battle - Dimensional Rift", 100, 100]),
    riftVolcanion: BossFight.new("Rift Volcanion", LEVELCAPS[1], "Dimensional", :RIFTVOLCANION, 28, music: ["Battle - Dimensional Rift", 100, 100]),
    dufaux: BossFight.new("Dufaux", LEVELCAPS[15], "Darchlight", :DUFAUX, 90, partner: [:LEADER_NARCISSA,"Narcissa",1], music: ['Battle - Conclusive', 100, 100] ),
    hagsPara: Gauntlet.new("Paragon Space Hags", LEVELCAPS[15], [
      BossFight.new("Tiempa (Paragon)", nil, "Zeight4", :TIEMPAGOOD, 90, music: ['Battle - Space and Time', 100, 100]),
      BossFight.new("Spacea (Paragon)", nil, "Zeight4", :SPACEAGOOD, 90, music: ['Battle - Space and Time', 100, 100])
    ], healtype: :Full, music: ['Battle - Space and Time', 100, 100]),
    # Team Xen
    misfortunate1: TrainerFight.new("Eli & Sharon 1", LEVELCAPS[1], "Forest", [:MISFORTUNATEDUO, "Eli and Sharon", 0], partner: [:TRAINER_MELIA1, "Melia", 1]),
    zettaGoldenleaf: TrainerFight.new("Goldenleaf Zetta", LEVELCAPS[1], "Forest", [:XENEXECUTIVE_1, "Zetta", 1]),
    madelisKeta: TrainerFight.new("Carotos Madelis", LEVELCAPS[1], "XenInterior", [:XENEXECUTIVE_2, "Madelis", 0], partner: [:LEADER_KETA, "Keta", 0]),
    nevedBlacksteeple: TrainerFight.new("Blacksteeple Neved", LEVELCAPS[4], "BlacksteepleIndoor", [:XENEXECUTIVE_4,"Neved",0], partner: [:STUDENT,"Aelita",10], music: ['Battle - Conclusive', 100, 100]),
    zettaGearaValor: TrainerFight.new("Zetta and Geara", LEVELCAPS[7], "Voltop", [:XENEXECUTIVE_1,"Zetta",8], opponent2: [:XENEXECUTIVE_3,"Geara",2], partner: [:ENIGMA,"Melia",5], music: ['Battle - Conclusive_1', 100, 100]),
    #Spirits
    spiritKeta: TrainerFight.new("Spirit Keta", LEVELCAPS[5], "Ruin3", [:LEADER_KETA2, "Keta", 0]),
    spiritJenner: TrainerFight.new("Spirit Jenner", LEVELCAPS[8], "Concert3", [:SPIRITJENNER, "Jenner", 0]),
    spiritXaraJean: TrainerFight.new("Spirit Xara/Jean", LEVELCAPS[16], "GDCScholarDistrict", [:SPIRITXARA,"Xara",0], opponent2: [:SPIRITJEAN,"Jean",0], music: ['Battle - Soul', 100, 100]),
    # Other
    rorimChrisola: TrainerFight.new("Chrisola Rorim B.", LEVELCAPS[0], "Indoor", [:DISCOTEEN, "Rorim B.", 0]),
    mercury: TrainerFight.new("Mercury", nil, "Indoor", [:CHALLENGER, "Mercury", 0]),
    mars: TrainerFight.new("Mars", LEVELCAPS[1], "Cave", [:CHALLENGER, "Mars", 0]),
    jenkelFactory: TrainerFight.new("Factory Jenkel", LEVELCAPS[1], "Factory", [:MADSCIENTIST, "Dr. Jenkel", 0], partner: [:LEADER_VENAM, "Venam", 7]),
    nimAmethyst: TrainerFight.new("Altered Dimension Nim", LEVELCAPS[1], "Psychic", [:APPRENTICE, "Nim", 0]),
    cueBalls: TrainerFight.new("Stolen Cargo Cueballs", LEVELCAPS[1], "Factory", [:CUEBALL, "Samwell", 0], opponent2: [:CUEBALL, "Jacksin", 0], partner: [:LEADER_VENAM, "Venam", 1], music: ['Battle - Trainers', 100, 100] ),
    sheridanGothitelle: BossFight.new("Gothitelle", LEVELCAPS[2], "Indoor", :BOSSGOTHITELLE_SHERIDAN, 35, music: ["Battle - Insanity", 100, 100]),
  }

  def self.fightWithCap(cap)
    return yield unless cap

    $FREE_RESTOCKING = true if defined?($FREE_RESTOCKING)
    trainermons = []
    pokemonexp = []
    pokemonlevels = []
    pokemonitems = []
    for i in 0...$Trainer.party.length
      pkmn = $Trainer.party[i]
      next if pkmn.nil?
      unless pkmn.isEgg?
        trainermons.push(pkmn)
        pokemonexp.push(pkmn.exp)
        pokemonlevels.push(pkmn.level)
        pokemonitems.push(pkmn.item)
        pkmn.level = cap
        pkmn.exp = PBExp.startExperience(cap,pkmn.growthrate)
        pkmn.calcStats
      end
    end

    ret = yield

    for i in 0...trainermons.length
      pkmn = trainermons[i]
      pkmn.exp = pokemonexp[i]
      pkmn.level = pokemonlevels[i]
      pkmn.item = pokemonitems[i]
      pkmn.calcStats
    end
    $FREE_RESTOCKING = false if defined?($FREE_RESTOCKING)

    return ret
  end

  def self.applyField(field)
    prevweather = $game_screen.weather_type

    return prevweather if field.nil?

    field = { basefield: field } if field.is_a?(String)
    field = { effect: field } if field.is_a?(Symbol)

    forcetime = $game_switches[:Forced_Time_of_Day]
    forceday = $game_switches[:Forced_Daytime]
    forceevening = $game_switches[:Forced_Evening]
    forcenight = $game_switches[:Forced_Night]

    $game_variables[:Forced_Field_Effect] = field[:effect] if field[:effect]
    $game_variables[:Forced_BaseField] = field[:basefield] if field[:basefield]
    $game_screen.weather_type = field[:weather] if field[:weather]
    case field[:time]
    when :Day then turnToDay
    when :Evening then turnToEvening
    when :Night then turnToNight
    end
    return { weather: prevweather, time: [forcetime, forceday, forceevening, forcenight] }
  end

  def self.resetField(prev)
    $game_variables[:Forced_Field_Effect] = 0
    $game_variables[:Forced_BaseField] = 0
    $game_screen.weather_type = prev[:weather]
    forcetime, forceday, forceevening, forcenight = prev[:time]
    $game_switches[:Forced_Time_of_Day] = forcetime
    $game_switches[:Forced_Daytime] = forceday
    $game_switches[:Forced_Evening] = forceevening
    $game_switches[:Forced_Night] = forcenight
  end

  def self.selectFight


    pbWait(10)
    $game_screen.pictures[4].show('CharPosterSansXW', 0, -150, 0, 100, 100, 0, 0)
    $game_screen.pictures[4].move(10, 0, -100, 0, 100, 100, 255, 0)
    pbWait(8)

    $game_screen.pictures[1].show('BlurOverlay', 0, 0, 0, 100, 100, 0, 0)
    $game_screen.pictures[1].move(20, 0, 0, 0, 100, 100, 140, 0)

    pbWait(8)
    $game_screen.pictures[2].show('DreamPixels', 0, 0, 0, 100, 100, 0, 0)
    $game_screen.pictures[2].move(6, 0, 0, 0, 100, 100, 255, 0)
    pbSEPlay('SFX - Stamp', 80, 100)
    $game_screen.pictures[3].show('ShopBGSpattersSansX', 0, -160, 0, 110, 110, 0, 0)
    $game_screen.pictures[3].move(6, 0, 0, 0, 100, 100, 255, 0)
    pbWait(6)
    $game_screen.pictures[5].show('CharPosterSansX', 0, -150, 0, 100, 100, 0, 0)
    $game_screen.pictures[5].move(4, 0, -100, 0, 100, 100, 255, 0)
    $game_screen.pictures[3].move(2, 0, 0, 0, 102, 102, 255, 0)
    pbWait(6)
    $game_screen.pictures[4].move(10, 0, -85, 0, 100, 100, 255, 0)
    $game_screen.pictures[3].move(2, 0, 0, 0, 100, 100, 255, 0)
    pbWait(6)

    categorystack = []
    category = SELECTION

    selectedFight = nil

    loop do
      options = []
      fights = []
      for fight in category.members
        next if fight.is_a?(Category) && fight.members.empty?
        fight = BATTLES[fight] if fight.is_a?(Symbol)
        options.push(fight.name)
        fights.push(fight)
      end

      choice = Kernel.pbMessage(_INTL("MADAME XANS: Who would you like to fight?"), options, -1)
      if choice == -1
        break if categorystack.empty?
        category = categorystack.pop
      elsif fights[choice].is_a?(Category)
        categorystack.push(category)
        category = fights[choice]
      else
        selectedFight = fights[choice]
        break
      end
    end

    if selectedFight
      $game_screen.pictures[5].move(12, 0, -100, 0, 100, 100, 0, 0)
      $game_screen.pictures[4].move(12, 0, -100, 0, 100, 100, 0, 0)
      $game_screen.pictures[3].move(20, 0, 0, 0, 100, 100, 0, 0)
      $game_screen.pictures[2].move(20, 0, 0, 0, 100, 100, 0, 0)
      $game_screen.pictures[1].move(20, 0, 0, 0, 100, 100, 0, 0)
      selectedFight.battle
    else
      $game_screen.pictures[5].move(6, 0, -100, 0, 100, 100, 0, 0)
      $game_screen.pictures[4].move(6, 0, -100, 0, 100, 100, 0, 0)
      $game_screen.pictures[3].move(10, 0, 0, 0, 100, 100, 0, 0)
      $game_screen.pictures[2].move(10, 0, 0, 0, 100, 100, 0, 0)
      $game_screen.pictures[1].move(10, 0, 0, 0, 100, 100, 0, 0)
      pbWait(10)
    end

    $game_screen.pictures[1].erase
    $game_screen.pictures[2].erase
    $game_screen.pictures[3].erase
    $game_screen.pictures[4].erase
    $game_screen.pictures[5].erase

  end
end
    