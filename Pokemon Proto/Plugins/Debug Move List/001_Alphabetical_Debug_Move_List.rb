#===============================================================================
# Alphabetical Debug Move List
# For Pokémon Essentials v21.1
#-------------------------------------------------------------------------------
# Makes the debug move picker sort moves alphabetically instead of by ID/order.
#===============================================================================

def pbChooseMoveList(default_move = nil)
  commands = []

  GameData::Move.each do |move|
    id_number = move.respond_to?(:id_number) ? move.id_number : commands.length + 1
    move_name = move.real_name || move.name
    commands.push([id_number, move_name, move.id])
  end

  # Sort alphabetically by displayed move name.
  # If two moves have the same name, sort by ID number as a fallback.
  commands.sort! do |a, b|
    name_compare = a[1].downcase <=> b[1].downcase
    name_compare == 0 ? a[0] <=> b[0] : name_compare
  end

  return pbChooseList(commands, default_move, default_move, -1)
end