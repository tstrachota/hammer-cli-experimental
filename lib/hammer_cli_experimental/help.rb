require 'colorize'

module HammerCLIExperimental

  class CondensedBuilder < HammerCLI::Help::Builder

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
      collect_squeezable_names(items)

      items = squeeze_option_flags(items)
      items.sort! do |a, b|
        a[0] <=> b[0]
      end

      puts
      heading(heading)

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

    private

    def collect_squeezable_names(items)
      @squeezable_names = items.map { |i| i.referenced_resource }.compact.uniq
    end

    attr_reader :squeezable_names

    def squeeze_option_flags(items)
      help_items = items.map do |i|
        [i.help[0], i.help[1]] if !is_squeezable?(i)
      end.compact
      help_items += squeezable_names.map do |resoruce_name|
        squeezed_help(select_options_for_resource(resoruce_name, items))
      end
      help_items
    end

    def select_options_for_resource(resoruce_name, options)
      options.select { |opt| opt.referenced_resource == resoruce_name }
    end

    def squeezed_help(options)
      prefix = common_prefix(options.map { |opt| opt.switches[0] })

      appendix_items = options.map do |opt|
        opt.switches[0][prefix.length, opt.switches[0].length]
      end
      appendix_items = appendix_items.select { |i| !i.empty? }

      if !appendix_items.empty?
        appendix = ('[' + appendix_items.join('|') + ']').yellow
        padding = ' ' * 14
      end

      resource_name = options[0].referenced_resource

      # TODO: translate the description
      ["#{prefix}#{appendix} #{resource_name.upcase}", "#{padding}#{resource_name.gsub('_', ' ').capitalize}"]
    end

    def common_prefix(items)
      shortest_length = items.map(&:length).min
      i = 0
      while (i < shortest_length) && chars_equal(i, items)
        i += 1
      end
      items[0][0, i]
    end

    def chars_equal(index, items)
      items.map {|i| i[index] }.uniq.length == 1
    end

    def is_squeezable?(item)
      !item.referenced_resource.nil?
    end

    def is_option_list?(items)
      (items.size > 0) && (items[0].is_a?(Clamp::Option::Definition))
    end
  end
end


class HammerCLI::AbstractCommand
  def help
    self.class.help(invocation_path, HammerCLIExperimental::CondensedBuilder.new(context[:is_tty?]))
  end
end
