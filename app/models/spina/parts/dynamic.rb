module Spina
  module Parts
    class Dynamic < Base
      include Partable
      include AttrJson::NestedAttributes

      attr_json :target, :string
      attr_json :dynamic_part, AttrJson::Type::SpinaPartsModel.new
      attr_json_accepts_nested_attributes_for :dynamic_part

      def find_part(name)
        dynamic_part if dynamic_part&.name&.to_s == name.to_s
      end

      def content
        dynamic_part&.content
      end

      def dynamic_part=(val)
        if val.blank? || val&.key?("type")
          super val
        else
          super val&.values&.find {|x| x["name"] == target }
        end
      end
    end
  end
end
