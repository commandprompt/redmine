require 'iconv'

module FixBrokenUtf8Params
  @@fix_utf8_iconv = Iconv.new('UTF-8//IGNORE', 'UTF-8')

  def self.included(base)
    base.class_eval do
      alias_method_chain :normalize_parameters, :utf8_fix
    end
  end

  def normalize_parameters_with_utf8_fix(value)
    case value
    when String
      @@fix_utf8_iconv.iconv(value)
    else
      normalize_parameters_without_utf8_fix(value)
    end
  end
end

ActionController::Request.send(:include, FixBrokenUtf8Params)
