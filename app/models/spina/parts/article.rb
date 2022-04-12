module Spina
  module Parts
    class Article < Base
      attr_json :article_id, :integer

      def content
        Spina::Page.where(id: article_id).live.first
      end

      def present?
        article_id.present?
      end
    end
  end
end
