def bettermissy_patchForm(species, form=nil, **values)
  if form.nil?
    for key, value in values
      $cache.pkmn[species].set_instance_variable("@#{key}".to_sym, value)
    end
  else
    $cache.pkmn[species].formData[form].merge! values
  end
end # expandable if i feel like it
bettermissy_patchForm(:MISMAGIUS, BaseStats: [75,105,90,60,60,105], Abilities: [:MAGICBOUNCE, :TECHNICIAN, :TANGLINGHAIR])
