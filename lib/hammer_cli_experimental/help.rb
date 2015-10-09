require 'colorize'

module HammerCLIExperimental

  class CondensedBuilder < Clamp::Help::Builder

    def default_label_indent
      29
    end

    def add_list(heading, items)
      if is_option_list?(items)
        add_option_list(heading, items)
      else
        super
      end
    end

    def add_option_list(heading, items)
      items = items.map do |i|
        [i.help[0], i.help[1]]
      end
      items = squeeze_option_flags(items)
      items.sort! do |a, b|
        a[0] <=> b[0]
      end

      puts "\n#{heading}:"

      label_width = default_label_indent
      items.each do |item|
        label, description = item
        label_width = label.size if label.size > label_width
      end

      items.each do |item|
        label, description = item
        description.each_line do |line|
          puts " %-#{label_width}s %s" % [label, line]
          label = ''
        end
      end
    end

    SQUEEZABLE = [
      'subnet',
      'partition-table',
      'operatingsystem',
      'location',
      'organization',
      'owner',
      'medium',
      'environment',
      'hostgroup',
      'image',
      'model',
      'puppet-ca-proxy',
      'puppet-proxy',
      'domain',
      'compute-profile',
      'compute-resource',
      'architecture',
      'realm'
    ]

    private

    def squeeze_option_flags(items)
      new_items = SQUEEZABLE.map do |flag|
        squeeze_one(items, flag)
      end
      new_items += items.select do |i|
        !is_squeezable?(i)
      end
      new_items.compact
    end

    def squeeze_one(items, flag)
      # require 'pry'; binding.pry
      sel = items.select do |i|
        i[0] =~ /--#{flag}[ -]/
      end
      return nil if sel.empty?

      sel = sel.map do |i|
        i[0].split(' ')[0].gsub("--#{flag}", '')
      end
      sel = sel.select{ |i| !i.empty? }

      appendix = '[' + sel.join('|') + ']'
      # TODO: sizes get calculated wrong when the text is coloured
      appendix = appendix.yellow

      # TODO: translate the description
      ["--#{flag}#{appendix} #{flag.upcase}", '              '+flag]
    end

    def is_squeezable?(item)
      SQUEEZABLE.each do |flag|
        return true if item[0] =~ /--#{flag}[ -]/
      end
      false
    end

    def is_option_list?(items)
      (items.size > 0) && (items[0].is_a?(Clamp::Option::Definition))
    end
  end



end


class HammerCLI::AbstractCommand
  def help
    self.class.help(invocation_path, HammerCLIExperimental::CondensedBuilder.new)
  end
end
