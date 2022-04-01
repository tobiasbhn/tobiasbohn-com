module Spina
  module Parts
    class Tag < Base
      attr_json :tag_id, :integer

      def content
        Spina::Page.where(id: tag_id).live.first
      end
    end
  end
end
