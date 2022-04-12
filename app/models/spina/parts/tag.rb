module Spina
  module Parts
    class Tag < Base
      attr_json :tag_id, :integer

      def content
        Spina::Page.where(id: tag_id).live.first
      end

      def present?
        tag_id.present?
      end
    end
  end
end
