# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      # Define mapping a generated twirp class and your controller
      module Twirp
        def twirp(service_class, controller:)
          service_class.rpcs.each do |_, rpcdef|
            path = [service_class.service_full_name, rpcdef[:rpc_method]].join('/')
            action = [controller, rpcdef[:ruby_method]].join('#')
            match path, to: action, via: :post
          end
        end
      end
    end
  end
end
