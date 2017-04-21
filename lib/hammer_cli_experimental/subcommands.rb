require 'hammer_cli/abstract'

module HammerCLIExperimental
  module Subcommands
    def find_subcommand(name)
      subcommand = super
      if subcommand.nil?
        case name
        when 'index'
          name = 'list'
        when 'show'
          name = 'info'
        when 'destroy'
          name = 'delete'
        end
        find_subcommand_starting_with(name)
      else
        subcommand
      end
    end

    def find_subcommand_starting_with(name)
      subcommands = recognised_subcommands.select { |sc| sc.names.any? { |n| n.start_with?(name) } }
      subcommands[0] if subcommands.length == 1
    end
  end
end

HammerCLI::AbstractCommand.extend(HammerCLIExperimental::Subcommands)
