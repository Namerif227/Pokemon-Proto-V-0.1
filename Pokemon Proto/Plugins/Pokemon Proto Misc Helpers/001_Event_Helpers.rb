#===============================================================================
# Pokémon Proto Misc Helpers
# For Pokémon Essentials v21.1
#-------------------------------------------------------------------------------
# A collection of small reusable event helper methods for Pokémon Proto.
#===============================================================================

module PokemonProtoMisc
  #-----------------------------------------------------------------------------
  # Vending Machine
  #-----------------------------------------------------------------------------
  def self.vending_machine(items)
    valid_items = []

    items.each do |item_data|
      item_id = item_data[0]
      price   = item_data[1]

      next if !GameData::Item.exists?(item_id)
      valid_items.push([item_id, price])
    end

    if valid_items.empty?
      pbMessage(_INTL("The vending machine is empty."))
      return
    end

    loop do
      commands = []

      valid_items.each do |item_data|
        item_id = item_data[0]
        price   = item_data[1]

        item_name = GameData::Item.get(item_id).name
        commands.push(_INTL("{1} - ${2}", item_name, price))
      end

      commands.push(_INTL("Cancel"))

      choice = pbMessage(
        _INTL("It's a vending machine!\nWhat would you like to buy?"),
        commands,
        commands.length
      )

      break if choice < 0
      break if choice >= valid_items.length

      item_id = valid_items[choice][0]
      price   = valid_items[choice][1]
      item_name = GameData::Item.get(item_id).name

      if $player.money < price
        pbMessage(_INTL("You don't have enough money."))
        next
      end

      if !$bag.add(item_id, 1)
        pbMessage(_INTL("Your Bag is full."))
        next
      end

      $player.money -= price
      pbSEPlay("Mart buy item") rescue nil

      pbMessage(_INTL("Clang!\n{1} popped out of the vending machine!", item_name))
    end
  end
end

#===============================================================================
# Event shortcut
#-------------------------------------------------------------------------------
# This makes pbProtoVendingMachine usable directly inside RPG Maker XP event
# Script commands.
#===============================================================================
class Interpreter
  def pbProtoVendingMachine(items)
    PokemonProtoMisc.vending_machine(items)
  end
end