# frozen_string_literal: true

require 'kiyohime/exceptions/unsupported_channel_name'

module Kiyohime
  module Parsers
    # Microservices receive and send messages along channels, channel names can be derived
    # from the name of the type
    class ChannelParser
      # Convert a type name to a channel name. A type name can be a Ruby type or a string
      # representation of the type name
      def parse_type_to_channel_name(type_name)
        type_name = type_name.to_s.downcase.gsub(/::/, '.')
        if type_name.empty? || !type_name_valid?(type_name)
          raise Kiyohime::Exceptions::UnsupportedChannelName
        else
          type_name
        end
      end

      # Convert a type name and method name to a channel name. A type name can be a Ruby type or a string
      # representation of the type name. A method name can be a symbol or a string
      def parse_type_and_method_to_channel_name(type_name, method_name)
        type_name = type_name.to_s.downcase.gsub(/::/, '.')
        method_name = method_name.to_s.downcase
        if type_name.empty? || method_name.empty? ||
           !type_name_valid?(type_name) || !method_name_valid?(method_name)
          raise Kiyohime::Exceptions::UnsupportedChannelName
        else
          "#{type_name}.#{method_name}"
        end
      end

      private

      # Validate the type name to make sure we can convert it to a valid channel name
      def type_name_valid?(channel_name)
        (/^[a-z]+(\.[a-z]+)*(\.[a-z]+){0,1}$/ =~ channel_name).nil? ? false : true
      end

      # Validate the method name to make sure we can convert it to a valid channel name
      def method_name_valid?(method_name)
        (/^[a-z]+[_0-9a-zA-Z]*$/ =~ method_name).nil? ? false : true
      end
    end
  end
end
