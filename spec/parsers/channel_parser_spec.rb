require 'spec_helper'
require 'kiyohime/exceptions/unsupported_channel_name'
require 'kiyohime/parsers/channel_parser'

describe Kiyohime::Parsers::ChannelParser do
  let(:parser) { Kiyohime::Parsers::ChannelParser.new }

  it 'should be able to parse a simple Ruby type name to a channel name' do
    expect(parser.parse_type_to_channel_name(Kiyohime)).to eq('kiyohime')
  end

  it 'should be able to parse a simple Ruby type and method name to a channel name' do
    expect(parser.parse_type_and_method_to_channel_name(Kiyohime, :function)).to eq('kiyohime.function')
  end

  it 'should be able to parse a namespaced Ruby type name to a channel name' do
    expect(parser.parse_type_to_channel_name(Kiyohime::Parsers::ChannelParser)).to eq('kiyohime.parsers.channelparser')
  end

  it 'should be able to parse a namespaced Ruby type and method name to a channel name' do
    expect(parser.parse_type_and_method_to_channel_name(Kiyohime::Parsers::ChannelParser, :function)).to eq('kiyohime.parsers.channelparser.function')
  end

  it 'should not be able to parse a namespaced Ruby type name with a catch all expression to a channel name' do
    expect { parser.parse_type_to_channel_name('Kiyohime::Parsers::ChannelParser::*') }.to raise_error(Kiyohime::Exceptions::UnsupportedChannelName)
  end

  it 'should not be able to parse a nil Ruby type and method name to a channel name' do
    expect { parser.parse_type_and_method_to_channel_name(nil, :function) }.to raise_error(Kiyohime::Exceptions::UnsupportedChannelName)
  end

  it 'should raise an error for nil as a type name' do
    expect { parser.parse_type_to_channel_name(nil) }.to raise_error(Kiyohime::Exceptions::UnsupportedChannelName)
  end

  it 'should raise an error for nil as a method name' do
    expect { parser.parse_type_and_method_to_channel_name(Kiyohime, nil) }.to raise_error(Kiyohime::Exceptions::UnsupportedChannelName)
  end

  it 'should raise an error for an invalid Ruby type name as a channel name' do
    expect { parser.parse_type_to_channel_name('::') }.to raise_error(Kiyohime::Exceptions::UnsupportedChannelName)
  end
end
