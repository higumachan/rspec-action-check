module RSpec
  module ActionCheck
    module Helpers
      module ClassMethods
        def create_from_dag(node)
          Proc.new do ||
            node[:forwards].each do |next_node_name|
            next_node = __action_dags[next_node_name]
            context next_node[:action][:description] do
              before(&next_node[:action][:block])
              next_node[:examples].each do |example_info|
                example("check:#{example_info[:description]}", &example_info[:block])
              end
              context_proc = create_from_dag(next_node)
              self.module_exec(&context_proc) if context_proc
            end
          end
          end
        end

        def actions(description, &actions_block)
          context description do
            self.define_singleton_method(:__action_dags) do ||
              {}
            end
          self.define_singleton_method(:__branch_tail_actions) do ||
            []
          end
            _update_before_action_names([:root])
            before_action_name = __before_action_names[0]
            self.module_exec(&actions_block)
            if __action_dags.empty?
              pending 'actions is empty'
              return
            end
            node = __action_dags[before_action_name]

            self.module_exec(&create_from_dag(node))
          end
        end

        def branch(description, &branch_block)
          name = "#{description.gsub(/ /, "_")}_#{__action_dags.size}".to_sym
          before_action_names = __before_action_names

          _update_action_dags(name, description, before_action_names, Proc.new{}, 'branch')

          tail_before_action_names = nil
          context do
            _update_before_action_names([name])
            self.define_singleton_method(:__branch_tail_actions) do ||
              []
            end
            self.module_exec(&branch_block)
            tail_before_action_names = __before_action_names
          end
          _update_before_action_names(__before_action_names)
          t = __branch_tail_actions
          self.define_singleton_method(:__branch_tail_actions) do ||
            t + tail_before_action_names
          end
        end

        def action(description, &action_block)
          p __branch_tail_actions
          before_action_names = (not __branch_tail_actions.empty?) ? __branch_tail_actions : __before_action_names
          name = "#{description.gsub(/ /, "_")}_#{__action_dags.size}".to_sym

          _update_before_action_names([name])

          _update_action_dags(name, description, before_action_names, action_block)
          self.define_singleton_method(:__branch_tail_actions) do ||
            []
          end
        end

        def check(description, &action_block)
          p __branch_tail_actions
          check_action_names = (not __branch_tail_actions.empty?) ? __branch_tail_actions : __before_action_names
          p __branch_tail_actions

          check_action_names.each do |check_action_name|
            _action_dags = __action_dags
            _action_dags[check_action_name][:examples] << {
              description: description,
              block: action_block,
            }
            define_singleton_method(:__action_dags) do ||
              _action_dags
            end
          end
        end

        def _update_action_dags(name, action_description, before_action_names, action_block, prefix='action')

          _action_dags = __action_dags
          _action_dags[name] = {
            forwards: [],
            backwards: [],
            examples: [],
          } if _action_dags[name].nil?

          before_action_names.each do |before_action_name|
            _action_dags[before_action_name] = {
              forwards: [],
              backwards: [],
              examples: [],
            } if _action_dags[before_action_name].nil?
            _action_dags[name].merge!({
              forwards: _action_dags[name][:forwards],
              backwards: _action_dags[name][:backwards] | [before_action_name],
              action: {description: "#{prefix}:#{action_description}", block: action_block},
            })
            _action_dags[before_action_name].merge!({
              forwards: _action_dags[before_action_name][:forwards] | [name],
              backwards: _action_dags[before_action_name][:backwards],
            })
            self.define_singleton_method(:__action_dags) do ||
              _action_dags
            end
          end
        end

        def _update_before_action_names(names)
          define_singleton_method(:__before_action_names) do ||
            names
          end
        end
      end
    end
  end
end
