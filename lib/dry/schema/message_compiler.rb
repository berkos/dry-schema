require 'dry/schema/constants'
require 'dry/schema/message'
require 'dry/schema/message_set'
require 'dry/schema/message_compiler/visitor_opts'

module Dry
  module Schema
    class MessageCompiler
      attr_reader :messages, :options, :locale, :default_lookup_options

      EMPTY_OPTS = VisitorOpts.new
      LIST_SEPARATOR = ', '.freeze

      def initialize(messages, options = {})
        @messages = messages
        @options = options
        @full = @options.fetch(:full, false)
        @hints = @options.fetch(:hints, true)
        @locale = @options.fetch(:locale, messages.default_locale)
        @default_lookup_options = { locale: locale }
      end

      def full?
        @full
      end

      def hints?
        @hints
      end

      def with(new_options)
        return self if new_options.empty?
        self.class.new(messages, options.merge(new_options))
      end

      def call(ast)
        MessageSet[ast.map { |node| visit(node) }, failures: options.fetch(:failures, true)]
      end

      def visit(node, *args)
        __send__(:"visit_#{node[0]}", node[1], *args)
      end

      def visit_failure(node, opts = EMPTY_OPTS.dup)
        rule, other = node
        visit(other, opts.(rule: rule))
      end

      def visit_hint(node, opts = EMPTY_OPTS.dup)
        if hints?
          visit(node, opts.(message_type: :hint))
        end
      end

      def visit_each(node, opts = EMPTY_OPTS.dup)
        # TODO: we can still generate a hint for elements here!
        []
      end

      def visit_not(node, opts = EMPTY_OPTS.dup)
        visit(node, opts.(not: true))
      end

      def visit_check(node, opts = EMPTY_OPTS.dup)
        keys, other = node
        visit(other, opts.(path: keys.last, check: true))
      end

      def visit_rule(node, opts = EMPTY_OPTS.dup)
        name, other = node
        visit(other, opts.(rule: name))
      end

      def visit_schema(node, opts = EMPTY_OPTS.dup)
        node.rule_ast.map { |rule| visit(rule, opts) }
      end

      def visit_and(node, opts = EMPTY_OPTS.dup)
        left, right = node.map { |n| visit(n, opts) }

        if right
          [left, right]
        else
          left
        end
      end

      def visit_or(node, opts = EMPTY_OPTS.dup)
        left, right = node.map { |n| visit(n, opts) }

        if [left, right].flatten.map(&:path).uniq.size == 1
          Message::Or.new(left, right, -> k { messages[k, default_lookup_options] })
        elsif right.is_a?(Array)
          right
        else
          [left, right]
        end
      end

      def visit_predicate(node, base_opts = EMPTY_OPTS.dup)
        predicate, args = node

        *arg_vals, val = args.map(&:last)
        tokens = message_tokens(args)

        input = val != Undefined ? val : nil

        options = base_opts.update(lookup_options(arg_vals: arg_vals, input: input))
        msg_opts = options.update(tokens)

        rule = msg_opts[:rule]
        path = msg_opts[:path]

        template = messages[rule] || messages[predicate, msg_opts]

        unless template
          raise MissingMessageError, "message for #{predicate} was not found"
        end

        text = message_text(rule, template, tokens, options)

        message_class = options[:message_type] == :hint ? Hint : Message

        message_class[
          predicate, path, text,
          args: arg_vals,
          input: input,
          rule: rule || msg_opts[:name],
          check: base_opts[:check]
        ]
      end

      def visit_key(node, opts = EMPTY_OPTS.dup)
        name, other = node
        visit(other, opts.(path: name))
      end

      def visit_set(node, opts = EMPTY_OPTS.dup)
        node.map { |el| visit(el, opts) }
      end

      def visit_implication(node, *args)
        _, right = node
        visit(right, *args)
      end

      def visit_xor(node, opts = EMPTY_OPTS.dup)
        left, right = node
        [visit(left, opts), visit(right, opts)].uniq
      end

      def visit_type(node, opts = EMPTY_OPTS.dup)
        visit(node.rule.to_ast, opts)
      end

      def lookup_options(arg_vals: [], input: nil)
        default_lookup_options.merge(
          arg_type: arg_vals.size == 1 && arg_vals[0].class,
          val_type: input.class
        )
      end

      def message_text(rule, template, tokens, opts)
        text = template % tokens

        if full?
          rule_name = rule ? (messages.rule(rule, opts) || rule) : (opts[:name] || opts[:path].last)
          "#{rule_name} #{text}"
        else
          text
        end
      end

      def message_tokens(args)
        args.each_with_object({}) { |arg, hash|
          case arg[1]
          when Array
            hash[arg[0]] = arg[1].join(LIST_SEPARATOR)
          when Range
            hash["#{arg[0]}_left".to_sym] = arg[1].first
            hash["#{arg[0]}_right".to_sym] = arg[1].last
          else
            hash[arg[0]] = arg[1]
          end
        }
      end
    end
  end
end
